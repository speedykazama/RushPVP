local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

CreateThread(function()
	GlobalState["Weather"] = FixedWeather or "CLEAR"
	GlobalState["Hours"] = FixedHours or 12
	GlobalState["Minutes"] = FixedMinutes or 0
	GlobalState["Blackout"] = false
end)

RegisterCommand('clima', function(source)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport, "Admin") then
        TriggerClientEvent('clima:open', source)
    else
        TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para acessar o recurso.", 5000)
    end
end)

RegisterNetEvent('clima:updateSettings')
AddEventHandler('clima:updateSettings', function(hour, minute, weather, blackout)
    local source = source
    local Passport = vRP.Passport(source)

    if AlwaysDayClear then
        TriggerClientEvent("Notify", source, "amarelo", "O clima está fixo em dia limpo (CLEAR).", 5000)
        return
    end

    if Passport and vRP.HasGroup(Passport, "Admin") then
        if hour and hour >= 0 and hour <= 23 then
            -- Configura o estado global
            GlobalState["Hours"] = hour
            GlobalState["Minutes"] = minute
            GlobalState["Weather"] = weather
            GlobalState["Blackout"] = blackout

            -- Altera o horário, clima e blackout do jogo para todos os jogadores
            TriggerClientEvent('clima:updateTime', -1, hour, minute)
            TriggerClientEvent('clima:updateWeather', -1, weather)
            TriggerClientEvent('clima:updateBlackout', -1, blackout)
        end
    end
end)
