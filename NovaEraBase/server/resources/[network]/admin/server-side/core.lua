-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("admin",Creative)
vCLIENT = Tunnel.getInterface("admin")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = {}
local Blips = false
local Checkpoint = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Quake"] = false
-------------------------------------------------------------------------------------------------------------------------------------
-- NADANDO
-------------------------------------------------------------------------------------------------------------------------------------
function Creative.Nadando()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.ConsultItem(Passport, "dollars", 1) then
            vRP.TakeItem(Passport, "dollars", 1, true)
            --TriggerClientEvent("Notify", source, "vermelho", "Você caiu na água e molhou seus pertences.", 5000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:Doords")
AddEventHandler("admin:Doords",function(Coords,Model,Heading)
	vRP.Archive("coordenadas.txt","Coords = "..Coords..", Hash = "..Model..", Heading = "..Heading)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:Coords")
AddEventHandler("admin:Coords",function(Coords)
	vRP.Archive("coordenadas.txt",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"]))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:keyCopyCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:keyCopyCoords")
AddEventHandler("admin:keyCopyCoords",function(Coords)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vKEYBOARD.keyCopy(source,"Cordenadas:",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.buttonTxt()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin",1) then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local heading = GetEntityHeading(Ped)

			vRP.Archive(Passport..".txt",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"])..","..mathLength(heading))
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RaceConfig(Left,Center,Right,Distance)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.Archive(Passport..".txt","{")

		vRP.Archive(Passport..".txt","['Left'] = vec3("..mathLength(Left["x"])..","..mathLength(Left["y"])..","..mathLength(Left["z"]).."),")
		vRP.Archive(Passport..".txt","['Center'] = vec3("..mathLength(Center["x"])..","..mathLength(Center["y"])..","..mathLength(Center["z"]).."),")
		vRP.Archive(Passport..".txt","['Right'] = vec3("..mathLength(Right["x"])..","..mathLength(Right["y"])..","..mathLength(Right["z"]).."),")
		vRP.Archive(Passport..".txt","['Distance'] = "..Distance)

		vRP.Archive(Passport..".txt","},")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.raceCoords(vehCoords,leftCoords,rightCoords)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Checkpoint = Checkpoint + 1

		vRP.Archive("races.txt","["..Checkpoint.."] = {")

		vRP.Archive("races.txt","{ "..mathLength(vehCoords["x"])..","..mathLength(vehCoords["y"])..","..mathLength(vehCoords["z"]).." },")
		vRP.Archive("races.txt","{ "..mathLength(leftCoords["x"])..","..mathLength(leftCoords["y"])..","..mathLength(leftCoords["z"]).." },")
		vRP.Archive("races.txt","{ "..mathLength(rightCoords["x"])..","..mathLength(rightCoords["y"])..","..mathLength(rightCoords["z"]).." }")

		vRP.Archive("races.txt","},")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEVTOOLSKICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:DevToolsKick")
AddEventHandler("admin:DevToolsKick", function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.Kick(source,"Expulso da cidade.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Spectate[Passport] then
		Spectate[Passport] = nil
	end
end)