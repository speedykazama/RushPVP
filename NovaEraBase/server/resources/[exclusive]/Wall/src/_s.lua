GlobalState["Creative_wall"] = math.random(213444500,213445500)
GlobalState["svCreative"] = math.random(113444500,113445500)

Creative = {}
module("vrp","lib/Tunnel").bindInterface(GlobalState["svCreative"],Creative)
local chain = GlobalState["Creative_wall"]
vRP = module("vrp","lib/Proxy").getInterface("vRP")

local wall_infos = {}
function Creative.setWallInfos()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then 
		local identity = vRP.Identity(Passport)
        wall_infos[source] = {}
        wall_infos[source].Passport = Passport
        local name = identity.name.." "..identity.name2
        if name == nil or name == "" or name == -1 then
            name = "N/A"
        else
            wall_infos[source].name = name
        end
        wall_infos[source].wallstats = false
	end
end

RegisterCommand("wall", function(source, args)
    local Passport = vRP.Passport(source)
    if vRP.HasGroup(Passport, "Admin", 5) then
        if Player(source).state.StaffTime then
            if wall_infos[source].wallstats == true then
                wall_infos[source].wallstats = false

                Player(source).state:set("WallActive", false, true) 
                
                TriggerClientEvent(chain..":wall", source, wall_infos[source].wallstats)
                TriggerEvent("Discord", "Wall", "**[Wall Desativado]**\n\n**Passaporte:** " .. Passport .. "\n**Estado Anterior:** Ativada\n**Novo Estado:** Desativada\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
            else
                wall_infos[source].wallstats = true
                
                Player(source).state:set("WallActive", true, true)
                
                TriggerClientEvent(chain..":wall", source, wall_infos[source].wallstats)
                TriggerEvent("Discord", "Wall", "**[Wall Ativado]**\n\n**Passaporte:** " .. Passport .. "\n**Estado Anterior:** Desativada\n**Novo Estado:** Ativada\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
            end

        else
            TriggerClientEvent("Notify", source, "vermelho", "Precisas de entrar em modo <b>/staff</b> primeiro!", 5000)
        end
    end
end)

function Creative.getWallInfos()
	return wall_infos
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local source = source
	if Passport then 
		local identity = vRP.Identity(Passport)
        wall_infos[source] = {}
        wall_infos[source].Passport = Passport
		wall_infos[source].name = identity.name.." "..identity.name2
        wall_infos[source].wallstats = false
	end
end)

