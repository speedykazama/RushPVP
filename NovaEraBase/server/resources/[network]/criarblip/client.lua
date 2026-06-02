local blipsCriados = {} -- Tabela que armazena os blips ativos

RegisterNetEvent("blips:CriarInGame")
AddEventHandler("blips:CriarInGame", function(x, y, z, sprite, cor, nome)
    local blipSprite = tonumber(sprite)
    local blipColour = tonumber(cor)

    -- Se já existir um blip com esse mesmo nome, remove o antigo antes de criar o novo
    if blipsCriados[nome] then
        RemoveBlip(blipsCriados[nome])
    end

    local blip = AddBlipForCoord(x, y, z)
    
    SetBlipSprite(blip, blipSprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, blipColour)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(nome)
    EndTextCommandSetBlipName(blip)

    -- Salva a ID do blip atrelada ao nome dele
    blipsCriados[nome] = blip
end)

-- EVENTO DE REMOÇÃO
RegisterNetEvent("blips:RemoverInGame")
AddEventHandler("blips:RemoverInGame", function(nome)
    -- Verifica se o blip com esse nome realmente existe na memória do jogo
    if blipsCriados[nome] then
        RemoveBlip(blipsCriados[nome]) -- Deleta o blip nativamente do mapa
        blipsCriados[nome] = nil       -- Limpa a tabela
    end
end)