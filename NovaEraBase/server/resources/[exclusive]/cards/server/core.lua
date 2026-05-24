-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("cards", Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARDS:PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("cards:Payment")
AddEventHandler("cards:Payment", function(Price)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Price then
		vRP.GiveBank(Passport, Price)
		TriggerClientEvent("Notify", source, "verde", "Você ganhou <b>$"..Price.." dólares </b>na raspadinha.", 5000)
	end
end)