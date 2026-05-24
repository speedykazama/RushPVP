--- Sessões de dominação: presença por pulse, progresso por maioria, vitória e cooldown.

local RES = GetCurrentResourceName()

---@type table<number, { started: number, territory_name: string, progress: table<string, number>, last_presence: number }>
local Sessions = {}

---@type table<number, table<number, { group: string, label: string, src: number, last: number, alive: boolean }>>
local Presence = {}

local PULSE_STALE = 10
local SESSION_IDLE_SEC = 95
local MAX_GAIN_PER_TICK = 3.8

local function nowSec()
  return os.time()
end

local function cooldownActive(row)
  if not row or row.cooldown_ends == nil then
    return false
  end
  local ce = tonumber(row.cooldown_ends)
  if not ce or ce <= 0 then
    return false
  end
  local t = nowSec()
  if ce > 1e12 then
    return (ce / 1000) > t
  end
  return ce > t
end

local function getDominationGroup(passport)
  local list = Config.AllowedGroups or {}
  for i = 1, #list do
    local e = list[i]
    local g = e and e.group
    if g and vRP.HasGroup(passport, g) then
      return g, tostring(e.label or g)
    end
  end
  return nil, nil
end

local function labelForAllowedGroupKey(key)
  if not key or key == "" then
    return "Facção"
  end
  for _, e in ipairs(Config.AllowedGroups or {}) do
    if e.group == key then
      return tostring(e.label or key)
    end
  end
  return tostring(key)
end

local function getTerritoryRow(id)
  local rows = vRP.Query("vieira_dominacao/get_by_id", { id = id }) or {}
  return rows[1]
end

function VD_DominationSessionActive(territoryId)
  territoryId = tonumber(territoryId)
  if not territoryId then
    return false
  end
  return Sessions[territoryId] ~= nil
end

local function broadcastToast(targets, msg, kind, durationMs)
  kind = kind or "verde"
  durationMs = tonumber(durationMs) or 7000
  for src, _ in pairs(targets) do
    TriggerClientEvent(RES .. ":dominationToast", src, kind, msg, durationMs)
  end
end

local function subscribersFor(territoryId)
  local out = {}
  local pmap = Presence[territoryId]
  if not pmap then
    return out
  end
  for _, e in pairs(pmap) do
    if e.src then
      out[e.src] = true
    end
  end
  return out
end

local function pushHud(territoryId)
  local session = Sessions[territoryId]
  if not session then
    return
  end

  local pmap = Presence[territoryId] or {}
  local t = nowSec()
  local counts = {}

  for passport, e in pairs(pmap) do
    if e and (t - (e.last or 0)) <= PULSE_STALE and e.alive then
      local g = e.group
      if g then
        counts[g] = (counts[g] or 0) + 1
      end
    end
  end

  local list = {}
  for g, c in pairs(counts) do
    local label = g
    for _, e in pairs(pmap) do
      if e.group == g and e.label then
        label = e.label
        break
      end
    end
    list[#list + 1] = {
      key = g,
      label = label,
      count = c,
      progress = math.min(100.0, (session.progress[g] or 0.0) + 0.0),
    }
  end

  table.sort(list, function(a, b)
    if a.count ~= b.count then
      return a.count > b.count
    end
    return tostring(a.label) < tostring(b.label)
  end)

  if #list == 0 then
    local subsEmpty = subscribersFor(territoryId)
    for src, _ in pairs(subsEmpty) do
      TriggerClientEvent(
        RES .. ":dominationHud",
        src,
        { visible = false, territory_id = territoryId }
      )
    end
    return
  end

  local c1 = list[1] and list[1].count or 0
  local c2 = list[2] and list[2].count or 0
  local contesting = #list > 1
  local stalemate = contesting and c1 == c2

  local subs = subscribersFor(territoryId)
  for src, _ in pairs(subs) do
    local pass = vRP.Passport(src)
    local gk = pass and select(1, getDominationGroup(pass))
    local payload = {
      visible = true,
      territory_id = territoryId,
      territory_name = session.territory_name,
      groups = list,
      contesting = contesting,
      stalemate = stalemate,
      leader_count = c1,
      runner_count = c2,
      my_group = gk,
    }
    TriggerClientEvent(RES .. ":dominationHud", src, payload)
  end
end

local function clearSession(territoryId, reason)
  Sessions[territoryId] = nil
  Presence[territoryId] = nil
  TriggerClientEvent(RES .. ":dominationEnded", -1, { territory_id = territoryId, reason = reason or "cleared" })
end

local function finishWin(territoryId, groupKey, territoryName)
  local session = Sessions[territoryId]
  if not session then
    return
  end

  local pmap = Presence[territoryId] or {}
  local targets = {}
  for _, e in pairs(pmap) do
    if e.group == groupKey and e.src then
      targets[e.src] = true
    end
  end

  vRP.Query("vieira_dominacao/update_owner", {
    id = territoryId,
    owner_group = groupKey,
  })
  local hours = tonumber(Config.Cooldown) or 24
  local ends = nowSec() + math.floor(hours * 3600)
  vRP.Query("vieira_dominacao/update_cooldown", {
    id = territoryId,
    cooldown_ends = ends,
  })

  local label = labelForAllowedGroupKey(groupKey)
  local area = territoryName or "a área"
  local msg = ("Sucesso! %s dominou %s. A área agora é sua."):format(label, area)
  broadcastToast(targets, msg, "verde", 14000)

  clearSession(territoryId, "won")
  TriggerClientEvent(RES .. ":reloadDominationZones", -1)
end

function VD_DominationRequestStart(src, territoryId)
  territoryId = tonumber(territoryId)
  if not territoryId then
    return { ok = false, error = "Área inválida." }
  end

  local passport = vRP.Passport(src)
  if not passport then
    return { ok = false, error = "Personagem indisponível." }
  end

  local g, label = getDominationGroup(passport)
  if not g then
    return { ok = false, error = "Seu grupo não pode dominar áreas." }
  end

  local row = getTerritoryRow(territoryId)
  if not row then
    return { ok = false, error = "Território não encontrado." }
  end

  if cooldownActive(row) then
    return { ok = false, error = "Área em cooldown." }
  end

  if Sessions[territoryId] then
    TriggerClientEvent(RES .. ":dominationStarted", src, { territory_id = territoryId })
    return { ok = true, already = true }
  end

  Sessions[territoryId] = {
    started = nowSec(),
    territory_name = tostring(row.name or "Dominação"),
    progress = {},
    last_presence = nowSec(),
  }
  Presence[territoryId] = Presence[territoryId] or {}

  TriggerClientEvent(RES .. ":dominationStarted", -1, { territory_id = territoryId })
  return { ok = true }
end

function VD_DominationPresencePulse(src, data)
  if type(data) ~= "table" then
    return
  end
  local territoryId = tonumber(data.territory_id)
  if not territoryId or not Sessions[territoryId] then
    return
  end

  local passport = vRP.Passport(src)
  if not passport then
    return
  end

  local g, label = getDominationGroup(passport)
  if not g then
    return
  end

  local alive = data.alive ~= false
  local pmap = Presence[territoryId]
  if not pmap then
    pmap = {}
    Presence[territoryId] = pmap
  end

  pmap[passport] = {
    group = g,
    label = label,
    src = src,
    last = nowSec(),
    alive = alive,
  }
  Sessions[territoryId].last_presence = nowSec()
end

function VD_DominationOnPlayerDeath(src)
  for terrId, pmap in pairs(Presence) do
    for passport, e in pairs(pmap) do
      if e and e.src == src then
        e.alive = false
        e.last = nowSec()
      end
    end
  end
end

local function computeTickGain(c1, c2, numGroups)
  local base = tonumber(Config.DominationBaseRate) or 0.72
  local pm = tonumber(Config.DominationPeopleMult) or 0.11
  if numGroups <= 1 then
    local solo = math.max(1, c1)
    return base * (0.55 + pm * (solo - 1))
  end
  if c1 == c2 then
    return 0.0
  end
  local adv = c1 - c2
  return base * adv * (1.0 + pm * math.max(0, c1 - 1))
end

function VD_DominationTick()
  local t = nowSec()
  local ids = {}
  for tid, _ in pairs(Sessions) do
    ids[#ids + 1] = tid
  end

  for _, territoryId in ipairs(ids) do
    local session = Sessions[territoryId]
    if session then
      local pmap = Presence[territoryId] or {}
      local counts = {}

      for passport, e in pairs(pmap) do
        if e and (t - (e.last or 0)) > PULSE_STALE * 3 then
          pmap[passport] = nil
        end
      end

      for _, e in pairs(pmap) do
        if e and (t - (e.last or 0)) <= PULSE_STALE and e.alive then
          local g = e.group
          if g then
            counts[g] = (counts[g] or 0) + 1
          end
        end
      end

      local sorted = {}
      for g, c in pairs(counts) do
        sorted[#sorted + 1] = { g = g, c = c }
      end
      table.sort(sorted, function(a, b)
        if a.c ~= b.c then
          return a.c > b.c
        end
        return a.g < b.g
      end)

      local c1 = sorted[1] and sorted[1].c or 0
      local c2 = sorted[2] and sorted[2].c or 0
      local numGroups = 0
      local seenG = {}
      for _, e in pairs(pmap) do
        if e and e.group and (t - (e.last or 0)) <= PULSE_STALE and e.alive then
          if not seenG[e.group] then
            seenG[e.group] = true
            numGroups = numGroups + 1
          end
        end
      end

      local won = false
      if c1 == 0 then
        if t - (session.last_presence or 0) > SESSION_IDLE_SEC then
          clearSession(territoryId, "idle")
        end
      else
        if numGroups <= 1 and sorted[1] then
          local gain = computeTickGain(c1, 0, 1)
          local onlyG = sorted[1].g
          session.progress[onlyG] = math.min(
            100.0,
            (session.progress[onlyG] or 0.0) + math.min(MAX_GAIN_PER_TICK, gain)
          )
          if session.progress[onlyG] >= 100.0 then
            finishWin(territoryId, onlyG, session.territory_name)
            won = true
          end
        elseif c1 > c2 and sorted[1] then
          local leaderG = sorted[1].g
          local gain = computeTickGain(c1, c2, numGroups)
          session.progress[leaderG] = math.min(
            100.0,
            (session.progress[leaderG] or 0.0) + math.min(MAX_GAIN_PER_TICK, gain)
          )
          if session.progress[leaderG] >= 100.0 then
            finishWin(territoryId, leaderG, session.territory_name)
            won = true
          end
        end
      end

      if not won and Sessions[territoryId] then
        pushHud(territoryId)
      end
    end
  end
end

CreateThread(function()
  while true do
    Wait(tonumber(Config.DominationTickMs) or 1000)
    VD_DominationTick()
  end
end)

AddEventHandler("player:Death", function()
  VD_DominationOnPlayerDeath(source)
end)
