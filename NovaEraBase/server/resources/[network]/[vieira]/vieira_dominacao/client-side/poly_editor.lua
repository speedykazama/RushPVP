--- Editor apenas polyzone (PolyZone) — sem passo de centro.
--- O centro persistido no banco é calculado no servidor (centroide XY + Z médio da altura).
--- E = adicionar vértice | Enter (191/201) = finalizar (mín. 3) | Backspace (177/178) = desfazer | ESC (322) = cancelar

--- Usado por `zone_runtime.lua` para não interceptar E / UI de dominação durante criação/edição de poly.
VD_PolyEditorFlowActive = false

local previewZone = nil

local function destroyPreview()
  if previewZone then
    previewZone:destroy()
    previewZone = nil
  end
end

local function refreshPreview(points, minZ, maxZ)
  destroyPreview()
  if #points < 2 then
    return
  end
  previewZone = PolyZone:Create(points, {
    name = "vd_dom_preview",
    useGrid = false,
    minZ = minZ,
    maxZ = maxZ,
    debugPoly = true,
  })
end

local function sendPolyUi(pointCount)
  SendReactMessage("setPolyEditor", {
    visible = true,
    phase = "poly",
    pointCount = pointCount or 0,
  })
end

local function hidePolyUi()
  SendReactMessage("setPolyEditor", { visible = false })
  SendReactMessage("setEscapeBlock", { block = false })
end

local function reopenAdminTerritory(id)
  SetNuiFocus(true, true)
  SendReactMessage("setNuiState", {
    visible = true,
    mode = "admin",
    section = "territory",
  })
  SendReactMessage("openTerritoryDetail", { id = id })
end

local function reopenAdminDominations()
  SetNuiFocus(true, true)
  SendReactMessage("setNuiState", {
    visible = true,
    mode = "admin",
    section = "dominations",
  })
end

local function recomputeZ(points)
  if #points == 0 then
    return 0.0, 0.0
  end
  local mn, mx = points[1].zStore, points[1].zStore
  for i = 2, #points do
    local z = points[i].zStore
    if z < mn then
      mn = z
    end
    if z > mx then
      mx = z
    end
  end
  return mn, mx
end

--- Editar poly existente: recebe pontos {x,y} e min/max Z do banco; zStore = média da altura.
---@param territoryId number
---@param existingPoints {x:number,y:number}[]
---@param baseMinZ number
---@param baseMaxZ number
---@param onDone fun(payload: { minZ: number, maxZ: number, points: {x:number,y:number}[] })
---@param onAbort fun()|nil
function VD_StartDominationPolyEditFlow(territoryId, existingPoints, baseMinZ, baseMaxZ, onDone, onAbort)
  CreateThread(function()
    VD_PolyEditorFlowActive = true
    SendReactMessage("setEscapeBlock", { block = true })
    SetNuiFocus(false, false)

    local zmid = ((tonumber(baseMinZ) or 0.0) + (tonumber(baseMaxZ) or 0.0)) / 2.0
    local points = {}
    if type(existingPoints) == "table" then
      for i = 1, #existingPoints do
        local p = existingPoints[i]
        if p and p.x and p.y then
          points[#points + 1] = { x = p.x + 0.0, y = p.y + 0.0, zStore = zmid }
        end
      end
    end

    local minZ, maxZ = recomputeZ(points)
    local vecPts0 = {}
    for i = 1, #points do
      vecPts0[i] = vector2(points[i].x, points[i].y)
    end
    refreshPreview(vecPts0, minZ, maxZ)
    sendPolyUi(#points)

    TriggerEvent(
      "Notify",
      "amarelo",
      "Editando poly: ~g~E~w~ vértice | ~b~Backspace~w~ desfaz | ~g~Enter~w~ salvar (mín. 3). ~r~ESC~w~ cancela.",
      12000
    )

    local cancelled = false
    local done = false

    while not done and not cancelled do
      if IsControlJustPressed(0, 322) then
        cancelled = true
        break
      end

      if IsControlJustPressed(0, 38) then
        local p = GetEntityCoords(PlayerPedId())
        points[#points + 1] = { x = p.x, y = p.y, zStore = p.z }
        minZ, maxZ = recomputeZ(points)
        local vecPts = {}
        for i = 1, #points do
          vecPts[i] = vector2(points[i].x, points[i].y)
        end
        refreshPreview(vecPts, minZ, maxZ)
        sendPolyUi(#points)
      end

      if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 178) then
        if #points > 0 then
          points[#points] = nil
          minZ, maxZ = recomputeZ(points)
          local vecPts = {}
          for i = 1, #points do
            vecPts[i] = vector2(points[i].x, points[i].y)
          end
          refreshPreview(vecPts, minZ, maxZ)
          sendPolyUi(#points)
        end
      end

      local enter = IsControlJustPressed(0, 191) or IsControlJustPressed(0, 201)
      if enter then
        if #points >= 3 then
          done = true
        else
          TriggerEvent("Notify", "vermelho", "Mínimo 3 vértices.", 3500)
        end
      end

      Wait(0)
    end

    destroyPreview()
    hidePolyUi()
    VD_PolyEditorFlowActive = false

    if cancelled then
      reopenAdminTerritory(territoryId)
      if onAbort then
        onAbort()
      end
      TriggerEvent("Notify", "vermelho", "Edição de poly cancelada.", 4000)
      return
    end

    local outPts = {}
    for i = 1, #points do
      outPts[i] = { x = points[i].x + 0.0, y = points[i].y + 0.0 }
    end

    if onDone then
      onDone({
        minZ = minZ + 0.0,
        maxZ = maxZ + 0.0,
        points = outPts,
      })
    end
  end)
end

---@param onDone fun(payload: { minZ: number, maxZ: number, points: {x:number,y:number}[] })
---@param onAbort fun()|nil
function VD_StartDominationCreateFlow(onDone, onAbort)
  CreateThread(function()
    VD_PolyEditorFlowActive = true
    SendReactMessage("setEscapeBlock", { block = true })
    SetNuiFocus(false, false)
    sendPolyUi(0)

    TriggerEvent(
      "Notify",
      "amarelo",
      "Polyzone: ~g~E~w~ adiciona vértice | ~b~Backspace~w~ desfaz | ~g~Enter~w~ finaliza (mín. 3). ~r~ESC~w~ cancela.",
      12000
    )

    local points = {}
    local minZ, maxZ = 0.0, 0.0
    local cancelled = false
    local done = false

    while not done and not cancelled do
      if IsControlJustPressed(0, 322) then
        cancelled = true
        break
      end

      if IsControlJustPressed(0, 38) then
        local p = GetEntityCoords(PlayerPedId())
        points[#points + 1] = { x = p.x, y = p.y, zStore = p.z }
        minZ, maxZ = recomputeZ(points)
        local vecPts = {}
        for i = 1, #points do
          vecPts[i] = vector2(points[i].x, points[i].y)
        end
        refreshPreview(vecPts, minZ, maxZ)
        sendPolyUi(#points)
      end

      if IsControlJustPressed(0, 177) or IsControlJustPressed(0, 178) then
        if #points > 0 then
          points[#points] = nil
          minZ, maxZ = recomputeZ(points)
          local vecPts = {}
          for i = 1, #points do
            vecPts[i] = vector2(points[i].x, points[i].y)
          end
          refreshPreview(vecPts, minZ, maxZ)
          sendPolyUi(#points)
        end
      end

      local enter = IsControlJustPressed(0, 191) or IsControlJustPressed(0, 201)
      if enter then
        if #points >= 3 then
          done = true
        else
          TriggerEvent("Notify", "vermelho", "Adicione pelo menos 3 vértices.", 3500)
        end
      end

      Wait(0)
    end

    destroyPreview()
    hidePolyUi()
    VD_PolyEditorFlowActive = false

    if cancelled then
      reopenAdminDominations()
      if onAbort then
        onAbort()
      end
      TriggerEvent("Notify", "vermelho", "Criação de dominação cancelada.", 4000)
      return
    end

    local outPts = {}
    for i = 1, #points do
      outPts[i] = { x = points[i].x + 0.0, y = points[i].y + 0.0 }
    end

    if onDone then
      onDone({
        minZ = minZ + 0.0,
        maxZ = maxZ + 0.0,
        points = outPts,
      })
    end
  end)
end
