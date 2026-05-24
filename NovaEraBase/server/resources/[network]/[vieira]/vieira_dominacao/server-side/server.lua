local function isAdmin(src)
  local Passport = vRP.Passport(src)
  if not Passport then
    return false
  end
  local g = Config.AdminGroup or "Admin"
  return vRP.HasGroup(Passport, g) and true or false
end

--- Label amigável para `owner_group` salvo no banco (chave vRP), se existir em `Config.AllowedGroups`.
local function labelForDominationOwnerGroup(groupKey)
  if groupKey == nil then
    return nil
  end
  local g = tostring(groupKey):gsub("^%s+", ""):gsub("%s+$", "")
  if g == "" then
    return nil
  end
  for _, e in ipairs(Config.AllowedGroups or {}) do
    if e.group == g then
      return tostring(e.label or g)
    end
  end
  return g
end

local function centerFromPolygon(points, min_z, max_z)
  local n = #points
  if n < 1 then
    return 0.0, 0.0, 0.0
  end
  local sx, sy = 0.0, 0.0
  for _, p in ipairs(points) do
    sx = sx + (tonumber(p.x) or 0.0)
    sy = sy + (tonumber(p.y) or 0.0)
  end
  local zmid = 0.0
  if min_z and max_z then
    zmid = ((tonumber(min_z) or 0.0) + (tonumber(max_z) or 0.0)) / 2.0
  end
  return sx / n, sy / n, zmid
end

local function decodePointsFromRow(r)
  local pts = {}
  if r.points_json and r.points_json ~= "" then
    local ok, decoded = pcall(json.decode, r.points_json)
    if ok and type(decoded) == "table" then
      pts = decoded
    end
  end
  return pts
end

local function broadcastClientZonesChanged()
  TriggerClientEvent(GetCurrentResourceName() .. ":reloadDominationZones", -1)
end

local function rowToDetail(r)
  if not r then
    return nil
  end
  local pts = decodePointsFromRow(r)
  return {
    id = r.id,
    name = r.name,
    image_url = r.image_url or "",
    center = { x = r.center_x + 0.0, y = r.center_y + 0.0, z = r.center_z + 0.0 },
    min_z = r.min_z,
    max_z = r.max_z,
    points = pts,
    point_count = #pts,
    owner_group = r.owner_group,
    owner_label = labelForDominationOwnerGroup(r.owner_group),
    cooldown_ends = r.cooldown_ends,
    created_at = r.created_at and tostring(r.created_at) or nil,
    updated_at = r.updated_at and tostring(r.updated_at) or nil,
  }
end

function RegisterTunnel.DominacaoAdminAuth()
  return isAdmin(source)
end

function RegisterTunnel.DominacaoListForAdmin()
  local src = source
  if not isAdmin(src) then
    return {}
  end
  local rows = vRP.Query("vieira_dominacao/list_all", {}) or {}
  local out = {}
  for i = 1, #rows do
    local d = rowToDetail(rows[i])
    if d then
      d.points = nil
      out[#out + 1] = d
    end
  end
  return out
end

function RegisterTunnel.DominacaoGetTerritory(id)
  local src = source
  if not isAdmin(src) then
    return nil
  end
  id = tonumber(id)
  if not id then
    return nil
  end
  local rows = vRP.Query("vieira_dominacao/get_by_id", { id = id }) or {}
  return rowToDetail(rows[1])
end

--- Polígonos + metadado para o cliente montar PolyZones (qualquer jogador).
function RegisterTunnel.DominacaoSyncClientZones()
  local rows = vRP.Query("vieira_dominacao/list_all", {}) or {}
  local out = {}
  for i = 1, #rows do
    local r = rows[i]
    local pts = decodePointsFromRow(r)
    out[#out + 1] = {
      id = r.id,
      name = r.name,
      image_url = r.image_url or "",
      owner_group = r.owner_group,
      cooldown_ends = r.cooldown_ends,
      min_z = r.min_z,
      max_z = r.max_z,
      points = pts,
    }
  end
  return out
end

--- Atualização leve (cooldown, nome, dono) enquanto o jogador está na área.
function RegisterTunnel.DominacaoGetTerritoryPlayState(id)
  id = tonumber(id)
  if not id then
    return nil
  end
  local rows = vRP.Query("vieira_dominacao/get_by_id", { id = id }) or {}
  local r = rows[1]
  if not r then
    return nil
  end
  return {
    id = r.id,
    name = r.name,
    image_url = r.image_url or "",
    owner_group = r.owner_group,
    owner_label = labelForDominationOwnerGroup(r.owner_group),
    cooldown_ends = r.cooldown_ends,
    domination_active = VD_DominationSessionActive(id),
  }
end

function RegisterTunnel.DominacaoRequestStart(territoryId)
  return VD_DominationRequestStart(source, territoryId)
end

function RegisterTunnel.DominacaoPresencePulse(data)
  VD_DominationPresencePulse(source, data)
end

function RegisterTunnel.DominacaoCreateTerritory(data)
  local src = source
  if not isAdmin(src) then
    return { ok = false, error = "Sem permissão." }
  end
  if type(data) ~= "table" then
    return { ok = false, error = "Payload inválido." }
  end

  local name = tostring(data.name or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" or #name > 128 then
    return { ok = false, error = "Nome inválido." }
  end

  local image_url = tostring(data.image_url or "")
  if #image_url > 512 then
    return { ok = false, error = "URL muito longa." }
  end

  local points = data.points
  if type(points) ~= "table" or #points < 3 then
    return { ok = false, error = "Polígono precisa de pelo menos 3 pontos." }
  end

  for _, p in ipairs(points) do
    if type(p) ~= "table" or not p.x or not p.y then
      return { ok = false, error = "Ponto inválido na poly." }
    end
  end

  local min_z = tonumber(data.min_z)
  local max_z = tonumber(data.max_z)
  local cx, cy, cz = centerFromPolygon(points, min_z, max_z)

  local enc = json.encode(points)
  if not enc then
    return { ok = false, error = "Erro ao serializar pontos." }
  end

  vRP.Query("vieira_dominacao/insert", {
    name = name,
    image_url = image_url,
    center_x = cx,
    center_y = cy,
    center_z = cz,
    min_z = min_z,
    max_z = max_z,
    points_json = enc,
  })

  broadcastClientZonesChanged()
  return { ok = true }
end

function RegisterTunnel.DominacaoUpdateTerritoryMeta(data)
  local src = source
  if not isAdmin(src) or type(data) ~= "table" then
    return { ok = false, error = "Sem permissão." }
  end
  local id = tonumber(data.id)
  local name = tostring(data.name or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if not id or name == "" or #name > 128 then
    return { ok = false, error = "Dados inválidos." }
  end
  local image_url = tostring(data.image_url or "")
  if #image_url > 512 then
    return { ok = false, error = "URL muito longa." }
  end
  vRP.Query("vieira_dominacao/update_meta", {
    id = id,
    name = name,
    image_url = image_url,
  })
  return { ok = true }
end

function RegisterTunnel.DominacaoUpdateTerritoryGeometry(data)
  local src = source
  if not isAdmin(src) or type(data) ~= "table" then
    return { ok = false, error = "Sem permissão." }
  end
  local id = tonumber(data.id)
  local points = data.points
  if not id or type(points) ~= "table" or #points < 3 then
    return { ok = false, error = "Polígono inválido." }
  end
  for _, p in ipairs(points) do
    if type(p) ~= "table" or not p.x or not p.y then
      return { ok = false, error = "Ponto inválido." }
    end
  end
  local min_z = tonumber(data.min_z)
  local max_z = tonumber(data.max_z)
  local cx, cy, cz = centerFromPolygon(points, min_z, max_z)
  local enc = json.encode(points)
  if not enc then
    return { ok = false, error = "Serialização falhou." }
  end
  vRP.Query("vieira_dominacao/update_geometry", {
    id = id,
    center_x = cx,
    center_y = cy,
    center_z = cz,
    min_z = min_z,
    max_z = max_z,
    points_json = enc,
  })
  broadcastClientZonesChanged()
  return { ok = true }
end

function RegisterTunnel.DominacaoSetTerritoryOwner(data)
  local src = source
  if not isAdmin(src) or type(data) ~= "table" then
    return { ok = false, error = "Sem permissão." }
  end
  local id = tonumber(data.id)
  if not id then
    return { ok = false, error = "ID inválido." }
  end
  local og = tostring(data.owner_group or ""):gsub("^%s+", ""):gsub("%s+$", "")
  vRP.Query("vieira_dominacao/update_owner", { id = id, owner_group = og })
  return { ok = true }
end

--- @param data { id, cooldown_ends: number|nil } — nil ou 0 limpa
function RegisterTunnel.DominacaoSetTerritoryCooldown(data)
  local src = source
  if not isAdmin(src) or type(data) ~= "table" then
    return { ok = false, error = "Sem permissão." }
  end
  local id = tonumber(data.id)
  if not id then
    return { ok = false, error = "ID inválido." }
  end
  local ce = data.cooldown_ends
  if data.clear == true or ce == nil or ce == false then
    vRP.Query("vieira_dominacao/clear_cooldown", { id = id })
  else
    vRP.Query("vieira_dominacao/update_cooldown", {
      id = id,
      cooldown_ends = tonumber(ce),
    })
  end
  return { ok = true }
end

function RegisterTunnel.DominacaoDeleteTerritory(id)
  local src = source
  if not isAdmin(src) then
    return { ok = false, error = "Sem permissão." }
  end
  id = tonumber(id)
  if not id then
    return { ok = false, error = "ID inválido." }
  end
  vRP.Query("vieira_dominacao/delete", { id = id })
  broadcastClientZonesChanged()
  return { ok = true }
end
