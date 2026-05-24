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
Tunnel.bindInterface("safezone",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local LastVehicle = false
local MapBlipHandles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAPBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local function RemoveSafezoneMapBlips()
	for _, Handle in pairs(MapBlipHandles) do
		if DoesBlipExist(Handle) then
			RemoveBlip(Handle)
		end
	end
	MapBlipHandles = {}
end

local function CreateSafezoneMapBlips()
	RemoveSafezoneMapBlips()

	for _, Zone in pairs(Safezone) do
		if Zone["ShowMapBlip"] and Zone["PolyZone"] and Zone["PolyZone"].center and Zone["PolyZone"].boundingRadius then
			local Center = Zone["PolyZone"].center
			local Z = Zone["MapBlipZ"] or 0.0
			local Radius = Zone["PolyZone"].boundingRadius
			local RadiusBlip = AddBlipForRadius(Center.x, Center.y, Z, Radius)

			SetBlipColour(RadiusBlip, SafezoneMapBlipColour or 2)
			SetBlipAlpha(RadiusBlip, SafezoneMapBlipAlpha or 100)
			SetBlipAsShortRange(RadiusBlip, false)
			SetBlipDisplay(RadiusBlip, 4)
			MapBlipHandles[#MapBlipHandles + 1] = RadiusBlip

			if Zone["MapBlipLabel"] and Zone["MapBlipLabel"] ~= "" then
				local IconBlip = AddBlipForCoord(Center.x, Center.y, Z)
				SetBlipSprite(IconBlip, 487)
				SetBlipColour(IconBlip, SafezoneMapBlipColour or 2)
				SetBlipScale(IconBlip, 0.85)
				SetBlipAsShortRange(IconBlip, false)
				SetBlipDisplay(IconBlip, 4)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Zone["MapBlipLabel"])
				EndTextCommandSetBlipName(IconBlip)
				MapBlipHandles[#MapBlipHandles + 1] = IconBlip
			end
		end
	end
end

AddEventHandler("onClientResourceStart", function(Resource)
	if Resource == GetCurrentResourceName() then
		CreateSafezoneMapBlips()
	end
end)

AddEventHandler("onResourceStop", function(Resource)
	if Resource == GetCurrentResourceName() then
		RemoveSafezoneMapBlips()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSAFEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Index,v in pairs(Safezone) do
			if v["PolyZone"]:isPointInside(Coords) then
				if not LocalPlayer["state"]["Safezone"] then
					NetworkSetFriendlyFireOption(false)
					LocalPlayer["state"]:set("Safezone",Index,true)
					LocalPlayer["state"]:set("Invincible",true,false)
					SetEntityInvincible(Ped,true)

					if PlayerAndVehicleGhost then
						SetLocalPlayerAsGhost(true)
					end

					if ShowNotify then
						TriggerEvent("Notify","verde","Você está seguro.",5000)
					end 

					if CleanWeapons and IsPedArmed(Ped,7) then
						TriggerEvent("inventory:CleanWeapons",true)
					end
				end
			else
				if LocalPlayer["state"]["Safezone"] and LocalPlayer["state"]["Safezone"] == Index then
					if PlayerAndVehicleGhost then
						SetLocalPlayerAsGhost(false)
					end
					
					SetEntityInvincible(Ped,false)
					NetworkSetFriendlyFireOption(true)
					LocalPlayer["state"]:set("Invincible",false,false)
					LocalPlayer["state"]:set("Safezone",false,true)

					if ShowNotify then
						TriggerEvent("Notify","vermelho","Você não está mais seguro.",5000)
					end 
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Safezone"] then
			TimeDistance = 1

			for _, Control in ipairs(DisableControlActionList) do
				DisableControlAction(0, Control, true)
			end

			local Ped = PlayerPedId()
			DisablePlayerFiring(Ped,true)

			if PlayerAndVehicleGhost then
				if IsPedInAnyVehicle(Ped) then
					if not LastVehicle then
						LastVehicle = GetVehiclePedIsIn(Ped,false)
						if LastVehicle and DoesEntityExist(LastVehicle) then
							SetNetworkVehicleAsGhost(LastVehicle,true)
						end
					end
				else
					if LastVehicle and DoesEntityExist(LastVehicle) then
						SetNetworkVehicleAsGhost(LastVehicle,false)
						LastVehicle = false
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)