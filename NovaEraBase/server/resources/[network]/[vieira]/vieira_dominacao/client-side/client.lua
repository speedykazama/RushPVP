local function openAdminDashboard(section)
  SetNuiFocus(true, true)
  SendReactMessage('setNuiState', {
    visible = true,
    mode = 'admin',
    section = section or 'dominations',
  })
end

local function closeNui()
  SetNuiFocus(false, false)
  SendReactMessage('setNuiState', { visible = false })
end

RegisterCommand(Config.AdminCommand or 'admdominacao', function()
  local allowed = vSERVER.DominacaoAdminAuth()
  if not allowed then
    TriggerEvent('Notify', 'vermelho', 'Sem permissão para o painel de dominação.', 5000)
    return
  end
  openAdminDashboard('dominations')
end)

RegisterNUICallback('hideFrame', function(_, cb)
  closeNui()
  cb({})
end)

RegisterNUICallback('getTerritories', function(_, cb)
  local list = vSERVER.DominacaoListForAdmin()
  cb(list or {})
end)

RegisterNUICallback('getTerritoryDetail', function(data, cb)
  local id = tonumber(data and data.id)
  if not id then
    cb(nil)
    return
  end
  local row = vSERVER.DominacaoGetTerritory(id)
  cb(row)
end)

RegisterNUICallback('teleportToTerritory', function(data, cb)
  local id = tonumber(data and data.id)
  if not id then
    cb({ ok = false })
    return
  end
  local row = vSERVER.DominacaoGetTerritory(id)
  if not row or not row.center then
    TriggerEvent('Notify', 'vermelho', 'Território não encontrado.', 4000)
    cb({ ok = false })
    return
  end
  local c = row.center
  local ped = PlayerPedId()
  SetEntityCoords(ped, c.x + 0.0, c.y + 0.0, c.z + 0.0, false, false, false, false)
  TriggerEvent('Notify', 'verde', 'Teleportado para o centro da área.', 4000)
  cb({ ok = true })
end)

RegisterNUICallback('updateTerritoryMeta', function(data, cb)
  local r = vSERVER.DominacaoUpdateTerritoryMeta(data)
  if type(r) == 'table' and r.ok then
    TriggerEvent('Notify', 'verde', 'Dados atualizados.', 4000)
    SendReactMessage('territoryDetailRefresh', { id = tonumber(data.id) })
    cb({ ok = true })
  else
    local err = (type(r) == 'table' and r.error) or 'Erro ao salvar.'
    TriggerEvent('Notify', 'vermelho', err, 6000)
    cb({ ok = false, error = err })
  end
end)

RegisterNUICallback('setTerritoryOwner', function(data, cb)
  local r = vSERVER.DominacaoSetTerritoryOwner(data)
  if type(r) == 'table' and r.ok then
    TriggerEvent('Notify', 'verde', 'Dono da área atualizado.', 4000)
    SendReactMessage('territoryDetailRefresh', { id = tonumber(data.id) })
    cb({ ok = true })
  else
    local err = (type(r) == 'table' and r.error) or 'Erro.'
    TriggerEvent('Notify', 'vermelho', err, 6000)
    cb({ ok = false, error = err })
  end
end)

RegisterNUICallback('setTerritoryCooldown', function(data, cb)
  local r = vSERVER.DominacaoSetTerritoryCooldown(data)
  if type(r) == 'table' and r.ok then
    TriggerEvent('Notify', 'verde', 'Cooldown atualizado.', 4000)
    SendReactMessage('territoryDetailRefresh', { id = tonumber(data.id) })
    cb({ ok = true })
  else
    local err = (type(r) == 'table' and r.error) or 'Erro.'
    TriggerEvent('Notify', 'vermelho', err, 6000)
    cb({ ok = false, error = err })
  end
end)

RegisterNUICallback('deleteTerritory', function(data, cb)
  local id = tonumber(data and data.id)
  if not id then
    cb({ ok = false })
    return
  end
  local r = vSERVER.DominacaoDeleteTerritory(id)
  if type(r) == 'table' and r.ok then
    TriggerEvent('Notify', 'verde', 'Território removido.', 5000)
    SendReactMessage('territoryDeleted', { id = id })
    cb({ ok = true })
  else
    local err = (type(r) == 'table' and r.error) or 'Erro ao excluir.'
    TriggerEvent('Notify', 'vermelho', err, 6000)
    cb({ ok = false, error = err })
  end
end)

RegisterNUICallback('startTerritoryPolyEdit', function(data, cb)
  local id = tonumber(data and data.id)
  if not id then
    cb({ ok = false })
    return
  end
  cb({ ok = true })
  local row = vSERVER.DominacaoGetTerritory(id)
  if not row or type(row.points) ~= 'table' then
    TriggerEvent('Notify', 'vermelho', 'Não foi possível carregar a poly.', 5000)
    return
  end
  TriggerEvent('Notify', 'amarelo', 'Redesenhe a polyzone no mundo.', 6000)
  VD_StartDominationPolyEditFlow(
    id,
    row.points,
    tonumber(row.min_z) or 0.0,
    tonumber(row.max_z) or 0.0,
    function(payload)
      local r = vSERVER.DominacaoUpdateTerritoryGeometry({
        id = id,
        min_z = payload.minZ,
        max_z = payload.maxZ,
        points = payload.points,
      })
      if type(r) == 'table' and r.ok then
        TriggerEvent('Notify', 'verde', 'Polyzone atualizada.', 5000)
        SetNuiFocus(true, true)
        SendReactMessage('setNuiState', {
          visible = true,
          mode = 'admin',
          section = 'territory',
        })
        SendReactMessage('openTerritoryDetail', { id = id })
        SendReactMessage('territoryDetailRefresh', { id = id })
      else
        local err = (type(r) == 'table' and r.error) or 'Erro ao salvar poly.'
        TriggerEvent('Notify', 'vermelho', err, 6000)
        SetNuiFocus(true, true)
        SendReactMessage('setNuiState', {
          visible = true,
          mode = 'admin',
          section = 'territory',
        })
        SendReactMessage('openTerritoryDetail', { id = id })
      end
    end,
    nil
  )
end)

RegisterNUICallback('createDominationStart', function(_, cb)
  TriggerEvent('Notify', 'amarelo', 'Modo criação: siga as instruções na parte inferior da tela.', 6000)
  cb({ ok = true })
  VD_StartDominationCreateFlow(function(payload)
    SetNuiFocus(true, true)
    SendReactMessage('setNuiState', {
      visible = true,
      mode = 'admin',
      section = 'dominations',
    })
    SendReactMessage('openDominationWizard', payload)
  end)
end)

RegisterNUICallback('saveTerritory', function(data, cb)
  local r = vSERVER.DominacaoCreateTerritory(data)
  if type(r) == 'table' and r.ok then
    TriggerEvent('Notify', 'verde', 'Dominação criada com sucesso.', 5000)
    SendReactMessage('closeDominationWizard', {})
    cb({ ok = true })
  else
    local err = (type(r) == 'table' and r.error) or 'Erro ao salvar.'
    TriggerEvent('Notify', 'vermelho', err, 6000)
    cb({ ok = false, error = err })
  end
end)
