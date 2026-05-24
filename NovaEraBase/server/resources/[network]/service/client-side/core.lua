-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("service")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	-- Emergency
	{ vec3(-432.46,-318.46,34.91),"Paramedic-1",1.0 },
	{ vec3(-1139.78,-1705.37,5.04),"Bombeiro-1",1.0 },
	-- Mechanic
	{ vec3(893.6,-2099.34,34.88),"Mechanic-1",1.0 },
	{ vec3(2747.5,3506.67,55.74),"Mechanic2-1",1.0 },
	-- Police
	{ vec3(1366.26,-733.7,65.85),"PMERJ-1",1.0 },
	{ vec3(-291.83,-1055.6,27.21),"PCERJ-1",1.0 },
	{ vec3(2618.02,5346.37,46.71),"PRF-1",1.0 },
	{ vec3(2509.8,-356.65,94.09),"BOPE-1",1.0 },
	{ vec3(-1716.17,-730.69,12.17),"RECOM-1",1.0 },
	{ vec3(-2349.5,3268.98,32.81),"BPCHQ-1",1.0 },
	{ vec3(3950.7,-5025.32,6.64),"EX-1",1.0 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number = 1,#List do
		exports["target"]:AddCircleZone("Service:"..List[Number][2],List[Number][1],1.75,{
			name = "Service:"..List[Number][2],
			heading = 0.0
		},{
			shop = Number,
			Distance = List[Number][3],
			options = {
				{
					label = "Entrar em Serviço",
					event = "service:Toggle",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Toggle")
AddEventHandler("service:Toggle",function(Service)
	TriggerServerEvent("service:Toggle",List[Service][2])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:LABEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Label")
AddEventHandler("service:Label",function(Service,Text)
	if Service == "Paramedic" then
		exports["target"]:LabelText("Service:Paramedic",Text)
	elseif Service == "Bombeiro" then
		exports["target"]:LabelText("Service:Bombeiro",Text)
    elseif Service == "PMERJ" then
		exports["target"]:LabelText("Service:PMERJ",Text)
	elseif Service == "PCERJ" then
		exports["target"]:LabelText("Service:PCERJ",Text)
	elseif Service == "PRF" then
		exports["target"]:LabelText("Service:PRF",Text)
	elseif Service == "BOPE" then
		exports["target"]:LabelText("Service:BOPE",Text)
	elseif Service == "RECOM" then
		exports["target"]:LabelText("Service:RECOM",Text)
	elseif Service == "BPCHQ" then
		exports["target"]:LabelText("Service:BPCHQ",Text)
	elseif Service == "EX" then
		exports["target"]:LabelText("Service:EX",Text)
	elseif Service == "Mechanic" then
		exports["target"]:LabelText("Service:Mechanic",Text)
	elseif Service == "Mechanic2" then
		exports["target"]:LabelText("Service:Mechanic2",Text)
	else
		exports["target"]:LabelText("Service:"..Service,Text)
	end
end)