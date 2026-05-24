-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("blipsystem",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Players = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.playerList()
	for Source,v in pairs(Players) do
		local Ped = GetPlayerPed(Source)
		if DoesEntityExist(Ped) then
			v["Coords"] = GetEntityCoords(Ped)
		end
	end

	return Players
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTER
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Enter",function(source,Permission)
	if not Players[source] then
		Players[source] = Permission

		local Service = vRP.NumPermission("Emergency")
		for _,Sources in pairs(Service) do
			async(function()
				TriggerClientEvent("markers:Add",Sources,source,Permission)
			end)
		end

		TriggerClientEvent("markers:Full",source,Players)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXIT
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Exit",function(source)
	if Players[source] then
		Players[source] = nil

		local Service = vRP.NumPermission("Emergency")
		for _,Sources in pairs(Service) do
			async(function()
				TriggerClientEvent("markers:Remove",Sources,source)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:ENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("blipsystem:Enter")
AddEventHandler("blipsystem:Enter",function(source,Service,Connect)
	Players[source] = {
		["Coords"] = vec3(0,0,0),
		["service"] = Service
	}

	for Sources,_ in pairs(Players) do
		if Sources ~= source then
			TriggerClientEvent("blipsystem:Enter",Sources,source,Players[source])
		end
	end

	if Connect then
		TriggerClientEvent("blipsystem:Full",source,Players)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPSYSTEM:EXIT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("blipsystem:Exit",function(source)
	if Players[source] then
		Players[source] = nil
		TriggerClientEvent("blipsystem:Clear",source)

		for Sources,_ in pairs(Players) do
			if Sources ~= source then
				TriggerClientEvent("blipsystem:Exit",Sources,source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Players[source] then
		Players[source] = nil

		for Sources,_ in pairs(Players) do
			TriggerClientEvent("blipsystem:Exit",Sources,source)
		end
	end
end)