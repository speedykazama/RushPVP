-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Wanted = {}
local Reposed = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Wanted",function(source,Passport,Seconds)
	if Passport and Seconds then
		Wanted[Passport] = os.time() + parseInt(Seconds)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Reposed",function(source,Passport,Seconds)
	if Passport and Seconds then
		Reposed[Passport] = os.time() + parseInt(Seconds)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wanted",function(Passport)
	if Wanted[Passport] and Wanted[Passport] > os.time() then
		return true
	end

	return false
end)

exports("Reposed",function(Passport)
	if Reposed[Passport] and Reposed[Passport] > os.time() then
		return true
	end

	return false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:UPDATEAVATAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:UpdateAvatar")
AddEventHandler("hud:UpdateAvatar",function(Url)
	local source = source
	local Passport = vRP.Passport(source)

	if Passport and Url and type(Url) == "string" and #Url <= 255 then
		vRP.Query("characters/updateAvatar",{ Passport = Passport, avatar = Url })
		TriggerClientEvent("hud:Avatar",source,Url)
	end
end)
