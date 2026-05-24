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
Tunnel.bindInterface("engine",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Vehicles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RechargeFuel(Price)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Players = vRPC.Players(source)

		if vRP.PaymentFull(Passport,Price) then
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("engine:syncFuel",v,Plate,VehFuel,Network)
				end)
			end

			return true
		else
			for _,v in ipairs(Players) do
				async(function()
					TriggerClientEvent("engine:syncFuel",v,Plate,LastFuel,Network)
				end)
			end

			TriggerClientEvent("Notify",source,"amarelo","<b>Dólares</b> insuficientes.",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.VehicleFuel(Plate)
	if not Vehicles[Plate] and Plate then
		Vehicles[Plate] = 50
	end

	return Vehicles[Plate]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:TRYFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("engine:tryFuel")
AddEventHandler("engine:tryFuel",function(Plate,VehFuel)
	if Plate ~= nil then
		Vehicles[Plate] = VehFuel
	end
end)