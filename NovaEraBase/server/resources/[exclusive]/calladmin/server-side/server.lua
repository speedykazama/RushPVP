-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface(GetCurrentResourceName(), Creative)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local command = splitString(config["Command"], " ")
local calls = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDWEBHOOKMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERCOMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(#command < 1 and command or command[1], function(source, args)
    local Passport = vRP.Passport(source)
    local identity = vRP.Identity(Passport)
    local Coords = vRP.GetEntityCoords(source)

    if #command < 1 or args[1] == command[2] then
        for i, v in ipairs(calls) do
            if v.id == Passport then
                local time = secondsToTimeDesc(vCLIENT.getTime(source))
                TriggerClientEvent("Notify", source, "vermelho", "Você já possui um chamado aberto, aguarde"..(time[3] > 0 and " "..time[3].."h" or "")..(time[2] > 0 and " "..time[2].."m" or "").." "..time[1].."s",5000)
                return
            end
        end

        local Keyboard = vKEYBOARD.keySingle(source, "Descrição:", "")
        if Keyboard ~= false then
            if #Keyboard[1] > 100 then
                TriggerClientEvent("Notify", source, "vermelho", "Você ultrapassou o limite de 100 caracteres!",5000)
                return
            end

            local AdminsOnline = false
            for _, permission in pairs(config["Permissions"]) do
                local GetPermission = vRP.NumPermission(permission)
                if #GetPermission > 0 then
                    AdminsOnline = true
                    break
                end
            end

            if not AdminsOnline then
                TriggerClientEvent("Notify", source, "amarelo", "Nenhum administrador está online no momento.",5000)
                return
            end

            table.insert(calls, {
                id = Passport,
                description = Keyboard,
                name = identity.name.." "..identity.name2,
                position = GetEntityCoords(GetPlayerPed(source)),
                time = os.date("%H:%M")
            })

            SetTimeout(config["Timeout"] * 1000, function()
                for i, v in ipairs(calls) do
                    if v.id == Passport then
                        table.remove(calls, i)
                        break
                    end
                end
            end)

            vCLIENT._countTime(source)

            for _, permission in pairs(config["Permissions"]) do
                local GetPermission = vRP.NumPermission(permission)
                for k, v in pairs(GetPermission) do
                    TriggerClientEvent("NotifyPush", v, { code = 31, title = "Chamado Admin | Passaporte: "..Passport, x = Coords["x"], y = Coords["y"], z = Coords["z"], time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
                    vRPclient._PlaySound(v, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS")
                    vCLIENT._updateCalls(v)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCEPT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.accept(id)
    local source = source
    local Passport = vRP.Passport(source)
    local identity = vRP.Identity(Passport)
    local found = false

    local hasPermission = false
    for _, perm in pairs(config["Permissions"]) do
        if vRP.HasPermission(Passport, perm) then
            hasPermission = true
            break
        end
    end

    if hasPermission then
        for i, v in ipairs(calls) do
            if v.id == id then
                found = true
                
                SendWebhookMessage(config["Webhook"],"```prolog\n[ID]: "..Passport.."\n[PLAYER]: "..v.id.."\n[DESCRIÇÃO]: "..v.description[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                
                TriggerClientEvent("Notify", vRP.Source(v.id), "verde", identity.name.." "..identity.name2.." ("..Passport..") Aceitou seu chamado!",15000)

                table.remove(calls, i)

                for _, perm in pairs(config["Permissions"]) do
                    for _, user in ipairs(vRP.NumPermission(perm)) do
                        vCLIENT._updateCalls(user)
                    end
                end

                if vRP.Request(source, "Você deseja se teletransportar para o chamado aceitado?") then
                    SetEntityCoords(source, v.position.x + 2, v.position.y + 2, v.position.z + 2)
                end
                break
            end
        end
    end

    if not found then
        TriggerClientEvent("Notify", source, "vermelho", "Chamado não encontrado ou já atendido!")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCALLS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.getCalls()
    return calls
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkPermission()
    local source = source
    local Passport = vRP.Passport(source)

    for _, perm in pairs(config["Permissions"]) do
        if vRP.HasPermission(Passport, perm) then
            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SECONDSTOTIMEDESC
-----------------------------------------------------------------------------------------------------------------------------------------
function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		
		return {sec, min, hou}
	end
	return ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport, source)
    for i, v in ipairs(calls) do
        if v.id == Passport then
            table.remove(calls, i)
            break
        end
    end
end)