-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Night = {}
Tunnel.bindInterface("ponto",Night)
Proxy.addInterface("ponto",Night)
vCLIENT = Tunnel.getInterface("ponto")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG USER
-----------------------------------------------------------------------------------------------------------------------------------------
local nomeApp = shared.nomeApp
local imagemApp = shared.imagemApp
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFICAÇAO DO SHARED.LUA
-----------------------------------------------------------------------------------------------------------------------------------------
local function isStringEmpty(str)
	return str == nil or str:match("^%s*$") ~= nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("service:PMERJ")
AddEventHandler("service:PMERJ",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "PMERJ") then
			TriggerClientEvent("service:PMERJ",source)
		end
	end
end)

RegisterServerEvent("service:PCERJ")
AddEventHandler("service:PCERJ",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "PCERJ") then
			TriggerClientEvent("service:PCERJ",source)
		end
	end
end)

RegisterServerEvent("service:PRF")
AddEventHandler("service:PRF",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "PRF") then
			TriggerClientEvent("service:PRF",source)
		end
	end
end)

RegisterServerEvent("service:BOPE")
AddEventHandler("service:BOPE",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "BOPE") then
			TriggerClientEvent("service:BOPE",source)
		end
	end
end)

RegisterServerEvent("service:RECOM")
AddEventHandler("service:RECOM",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "RECOM") then
			TriggerClientEvent("service:RECOM",source)
		end
	end
end)

RegisterServerEvent("service:BPCHQ")
AddEventHandler("service:BPCHQ",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "BPCHQ") then
			TriggerClientEvent("service:BPCHQ",source)
		end
	end
end)

RegisterServerEvent("service:EX")
AddEventHandler("service:EX",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "EX") then
			TriggerClientEvent("service:EX",source)
		end
	end
end)

RegisterServerEvent("service:Hospital")
AddEventHandler("service:Hospital",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "Paramedic") then
			TriggerClientEvent("service:Hospital",source)
		end
	end
end)

RegisterServerEvent("service:Bombeiro")
AddEventHandler("service:Bombeiro",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "Bombeiro") then
			TriggerClientEvent("service:Bombeiro",source)
		end
	end
end)

RegisterServerEvent("service:Mecanica")
AddEventHandler("service:Mecanica",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "Mechanic") then
			TriggerClientEvent("service:Mecanica",source)
		end
	end
end)

RegisterServerEvent("service:Mecanica2")
AddEventHandler("service:Mecanica2",function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport, "Mechanic2") then
			TriggerClientEvent("service:Mecanica2",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterServerEvent("service:Toggle")
-- AddEventHandler("service:Toggle",function(Service)
-- 	local source = source
-- 	local Passport = vRP.Passport(source)
-- 	if Passport then
-- 		vRP.ServiceToggle(source,Passport,Service,false)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE APP SMARTPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('smartphone:isReady', function()
	exports.smartphone:createApp(
	  nomeApp,
	  nomeApp,
	  imagemApp,
	  'nui://ponto/web-side/index.html#'
	)
end)