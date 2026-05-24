-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Night = {}
Tunnel.bindInterface("ponto",Night)
vSERVER = Tunnel.getInterface("ponto")
-----------------------------------------------------------------------------------------------------------------------------------------
-- Ponto
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Ponto",function(data,cb)
	exports["smartphone"]:closeSmartphone()
    Wait(500)
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local PMERJ = #(Coords - vec3(1366.26,-733.7,65.85)) -- localização da PMERJ
	local PCERJ = #(Coords - vec3(-291.83,-1055.6,27.21)) -- localização da PCERJ
	local PRF = #(Coords - vec3(2618.02,5346.37,46.71)) -- localização da PRF
	local BOPE = #(Coords - vec3(2509.8,-356.65,94.09)) -- localização da BOPE
	local RECOM = #(Coords - vec3(-1716.17,-730.69,12.17)) -- localização da RECOM
	local BPCHQ = #(Coords - vec3(-834.92,-2677.52,14.2)) -- localização do BPCHQ
	local EX = #(Coords - vec3(3950.7,-5025.32,6.64)) -- localização do EX
	local Hospital = #(Coords - vec3(-432.46,-318.46,34.91)) -- localização do Hospital
	local Bombeiro = #(Coords - vec3(-1139.78,-1705.37,5.04)) -- localização do Bombeiro
	local Mecanica = #(Coords - vec3(893.6,-2099.34,34.88)) -- localizacação da Mecânica East Custom
	local Mecanica2 = #(Coords - vec3(2747.5,3506.67,55.74)) -- localizacação da Mecânica Red Line
	if PMERJ <= 10 then -- Distancia
		TriggerServerEvent("service:PMERJ")
	elseif PCERJ <= 10 then -- Distancia
		TriggerServerEvent("service:PCERJ")
	elseif PRF <= 10 then -- Distancia
		TriggerServerEvent("service:PRF")
	elseif BOPE <= 10 then -- Distancia
		TriggerServerEvent("service:BOPE")
	elseif RECOM <= 10 then -- Distancia
		TriggerServerEvent("service:RECOM")
	elseif BPCHQ <= 10 then -- Distancia
		TriggerServerEvent("service:BPCHQ")
	elseif EX <= 10 then -- Distancia
		TriggerServerEvent("service:EX")
	elseif Bombeiro <= 10 then -- Distancia
		TriggerServerEvent("service:Bombeiro")
	elseif Hospital <= 10 then -- Distancia
		TriggerServerEvent("service:Hospital")
	elseif Mecanica <= 10 then -- Distancia
		TriggerServerEvent("service:Mecanica")
	elseif Mecanica2 <= 10 then -- Distancia
		TriggerServerEvent("service:Mecanica2")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PMERJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:PMERJ") 
AddEventHandler("service:PMERJ",function()
	TriggerServerEvent("service:Toggle","PMERJ")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PCERJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:PCERJ") 
AddEventHandler("service:PCERJ",function()
	TriggerServerEvent("service:Toggle","PCERJ")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:PRF") 
AddEventHandler("service:PRF",function()
	TriggerServerEvent("service:Toggle","PRF")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOPE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:BOPE") 
AddEventHandler("service:BOPE",function()
	TriggerServerEvent("service:Toggle","BOPE")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECOM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:RECOM") 
AddEventHandler("service:RECOM",function()
	TriggerServerEvent("service:Toggle","RECOM")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BPCHQ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:BPCHQ") 
AddEventHandler("service:BPCHQ",function()
	TriggerServerEvent("service:Toggle","BPCHQ")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:EX") 
AddEventHandler("service:EX",function()
	TriggerServerEvent("service:Toggle","EX")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOSPITAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Hospital")
AddEventHandler("service:Hospital",function()
	TriggerServerEvent("service:Toggle","Paramedic")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOMBEIRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Bombeiro")
AddEventHandler("service:Bombeiro",function()
	TriggerServerEvent("service:Toggle","Bombeiro")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MECÂNICA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Mecanica")
AddEventHandler("service:Mecanica",function()
	TriggerServerEvent("service:Toggle","Mechanic")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MECÂNICA2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Mecanica2")
AddEventHandler("service:Mecanica2",function()
	TriggerServerEvent("service:Toggle","Mechanic2")
end)