--- PolyZones + prompt inferior + dominação (pulse, E, HUD).

local function drawRedWall(p1, p2, minZ, maxZ, a)
  local bottomLeft = vector3(p1.x, p1.y, minZ)
  local topLeft = vector3(p1.x, p1.y, maxZ)
  local bottomRight = vector3(p2.x, p2.y, minZ)
  local topRight = vector3(p2.x, p2.y, maxZ)
  local r, g, b = 255, 30, 30
  DrawPoly(bottomLeft, topLeft, bottomRight, r, g, b, a)
  DrawPoly(topLeft, topRight, bottomRight, r, g, b, a)
  DrawPoly(bottomRight, topRight, topLeft, r, g, b, a)
  DrawPoly(bottomRight, topLeft, bottomLeft, r, g, b, a)
end

local function drawTerritoryRedOutline(zone)
  if not zone or zone.destroyed or not zone.points or #zone.points < 2 then
    return
  end
  local minZ = zone.minZ
  local maxZ = zone.maxZ
  if not minZ or not maxZ then
    return
  end
  local down = tonumber(Config.TerritoryVisualExtendDown) or 80.0
  local up = tonumber(Config.TerritoryVisualExtendUp) or 520.0
  local visMinZ = minZ - down
  local visMaxZ = maxZ + up
  local pts = zone.points
  local a = 48
  for i = 1, #pts - 1 do
    drawRedWall(pts[i], pts[i + 1], visMinZ, visMaxZ, a)
  end
  if #pts > 2 then
    drawRedWall(pts[#pts], pts[1], visMinZ, visMaxZ, a)
  end
end

local RES = GetCurrentResourceName()
local ZONE_RELOAD_EVENT = RES .. ":reloadDominationZones"

local zoneRegistry = {}
local activeTerritoryId = nil

--- Territórios com sessão ativa no servidor (sincronizado por eventos).
VD_DominationServerSessions = {}

local function hidePrompt()
  activeTerritoryId = nil
  SendReactMessage("setDominationPrompt", { visible = false })
end

local function sendPrompt(play)
  if not play or not play.id then
    hidePrompt()
    return
  end
  if play.domination_active then
    VD_DominationServerSessions[play.id] = true
  end
  SendReactMessage("setDominationPrompt", {
    visible = true,
    id = play.id,
    name = play.name,
    image_url = play.image_url or "",
    owner_group = play.owner_group,
    owner_label = play.owner_label,
    cooldown_ends = play.cooldown_ends,
    domination_active = play.domination_active == true,
  })
end

local function refreshPlayState(id)
  if not id then
    return
  end
  local row = vSERVER.DominacaoGetTerritoryPlayState(id)
  if row and row.id then
    sendPrompt(row)
  else
    hidePrompt()
  end
end

local function findTerritoryIdAtPosition(pos)
  for _, entry in ipairs(zoneRegistry) do
    local z = entry.zone
    if z and not z.destroyed and z:isPointInside(pos) then
      return entry.id
    end
  end
  return nil
end

local function destroyZones()
  for _, entry in ipairs(zoneRegistry) do
    local z = entry.zone
    if z and z.destroy then
      z:destroy()
    end
  end
  zoneRegistry = {}
end

local function buildZonesFromSync(list)
  destroyZones()
  if type(list) ~= "table" then
    return
  end

  for _, t in ipairs(list) do
    local id = tonumber(t.id)
    local pts = t.points
    if id and type(pts) == "table" and #pts >= 3 then
      local vec = {}
      for i = 1, #pts do
        local p = pts[i]
        if p and p.x and p.y then
          vec[#vec + 1] = vector2(p.x + 0.0, p.y + 0.0)
        end
      end
      if #vec >= 3 then
        local minZ = tonumber(t.min_z) or -90.0
        local maxZ = tonumber(t.max_z) or 900.0
        local zone = PolyZone:Create(vec, {
          name = ("vd_dom_territory_%s"):format(id),
          useGrid = false,
          minZ = minZ,
          maxZ = maxZ,
          -- debugPoly do PolyZone desenha em branco; o contorno vermelho é desenhado abaixo.
          debugPoly = false,
        })
        zone:onPlayerInOut(function(isInside)
          if isInside then
            activeTerritoryId = id
            refreshPlayState(id)
          else
            if activeTerritoryId == id then
              local pos = PolyZone.getPlayerPosition()
              local still = findTerritoryIdAtPosition(pos)
              activeTerritoryId = still
              if still then
                refreshPlayState(still)
              else
                SendReactMessage("setDominationHud", { visible = false, territory_id = id })
                hidePrompt()
              end
            end
          end
        end, 400)
        zoneRegistry[#zoneRegistry + 1] = { id = id, zone = zone }
      end
    end
  end

  local pos = PolyZone.getPlayerPosition()
  local inside = findTerritoryIdAtPosition(pos)
  if inside then
    activeTerritoryId = inside
    refreshPlayState(inside)
  else
    hidePrompt()
  end
end

local function loadZones()
  local ok, list = pcall(function()
    return vSERVER.DominacaoSyncClientZones()
  end)
  if ok and type(list) == "table" then
    buildZonesFromSync(list)
  end
end

RegisterNetEvent(ZONE_RELOAD_EVENT, function()
  loadZones()
end)

RegisterNetEvent(RES .. ":dominationStarted", function(data)
  local id = tonumber(data and data.territory_id)
  if id then
    VD_DominationServerSessions[id] = true
    if activeTerritoryId == id then
      refreshPlayState(id)
    end
  end
end)

RegisterNetEvent(RES .. ":dominationEnded", function(data)
  local id = tonumber(data and data.territory_id)
  if id then
    VD_DominationServerSessions[id] = nil
  end
  SendReactMessage("setDominationHud", { visible = false, territory_id = id })
  if id and activeTerritoryId == id then
    refreshPlayState(id)
  end
end)

RegisterNetEvent(RES .. ":dominationHud", function(payload)
  if type(payload) == "table" then
    SendReactMessage("setDominationHud", payload)
  end
end)

RegisterNetEvent(RES .. ":dominationToast", function(kind, msg, durationMs)
  local ms = tonumber(durationMs) or 7000
  TriggerEvent("Notify", kind or "amarelo", tostring(msg or ""), ms)
end)

CreateThread(function()
  Wait(1500)
  loadZones()
end)

CreateThread(function()
  while true do
    if activeTerritoryId and activeTerritoryId > 0 then
      refreshPlayState(activeTerritoryId)
      Wait(2000)
    else
      Wait(4000)
    end
  end
end)

CreateThread(function()
  while true do
    local tid = activeTerritoryId
    if tid and VD_DominationServerSessions[tid] and not VD_PolyEditorFlowActive then
      local st = LocalPlayer.state
      local alive = not (st and st.Death)
      vSERVER.DominacaoPresencePulse({ territory_id = tid, alive = alive })
      Wait(750)
    else
      Wait(400)
    end
  end
end)

CreateThread(function()
  while true do
    if not activeTerritoryId then
      Wait(300)
    elseif VD_PolyEditorFlowActive then
      Wait(150)
    elseif IsNuiFocused() then
      Wait(150)
    elseif IsControlJustPressed(0, 38) then
      local id = activeTerritoryId
      if id and not VD_DominationServerSessions[id] then
        local r = vSERVER.DominacaoRequestStart(id)
        if type(r) == "table" and r.ok then
          VD_DominationServerSessions[id] = true
          refreshPlayState(id)
        elseif type(r) == "table" and r.error then
          TriggerEvent("Notify", "vermelho", tostring(r.error), 6500)
        end
      end
      Wait(450)
    else
      Wait(0)
    end
  end
end)

CreateThread(function()
  while true do
    if Config.TerritoryDebugRed == false then
      Wait(2000)
    else
      local ped = PlayerPedId()
      local pos = GetEntityCoords(ped)
      for _, entry in ipairs(zoneRegistry) do
        local z = entry.zone
        if z and not z.destroyed and z.center then
          local dx = pos.x - z.center.x
          local dy = pos.y - z.center.y
          if (dx * dx + dy * dy) < (200.0 * 200.0) then
            drawTerritoryRedOutline(z)
          end
        elseif z and not z.destroyed then
          drawTerritoryRedOutline(z)
        end
      end
      Wait(0)
    end
  end
end)
