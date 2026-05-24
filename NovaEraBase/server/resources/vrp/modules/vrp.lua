-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = {}
tvRP = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNNER/PROXY
-----------------------------------------------------------------------------------------------------------------------------------------
Proxy.addInterface("vRP",vRP)
Tunnel.bindInterface("vRP",tvRP)
REQUEST = Tunnel.getInterface("request")
SURVIVAL = Tunnel.getInterface("survival")
MEMORY = Tunnel.getInterface("memory")
LOCKPICK = Tunnel.getInterface("t3_lockpick")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SMARTPHONE:SERVICE_REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("smartphone:service_request", function(Data)
    local Service = vRP.NumPermission(Data["service"]["permission"])
    local Passport = vRP.Passport(Data["source"])
    local Identity = vRP.Identity(Passport)
    local Answered = false

    for Passport, sources in pairs(Service) do
        async(function()
            TriggerClientEvent("NotifyPush", sources, {code = 20,phone = Identity["phone"],title = "Chamado de " .. Data["name"],text = Data["content"],x = Data["location"][1],y = Data["location"][2],z = Data["location"][3],time = "Recebido às " .. os.date("%H:%M"),blipColor = 2})

            if vRP.Request(sources, "Aceitar o chamado de <b>" .. Data["name"] .. "?", "Sim", "Não") then
                if not Answered then
                    Answered = true
                    TriggerClientEvent("smartphone:pusher", Data["source"], "SERVICE_RESPONSE", {})
                    TriggerClientEvent("smartphone:pusher",sources,"GPS",{location = Data["location"]})
                else
                    TriggerClientEvent("Notify",sources,"verde","Chamado atendido.",5000)
                end
            end
        end)
    end

    SetTimeout(30000, function()
        if not Answered then
            TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_REJECT",{})
        end
    end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP.REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Request(source,Message,Accept,Reject)
	return REQUEST.Function(source,Message,Accept or "Sim",Reject or "Não")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP.MEMORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Memory(source)
	return MEMORY.Memory(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP.STARTLOCKPICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.startLockpick(source, strength, difficulty, pins)
	return startLockpick(source,strength, difficulty, pins)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP.REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Revive(source, Health, Arena)
    return SURVIVAL.Revive(source, Health, Arena)
end