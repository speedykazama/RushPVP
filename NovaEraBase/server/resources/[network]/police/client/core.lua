-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("police", Creative)
vSERVER = Tunnel.getInterface("police")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local InPrison = false
local TablePerimeter = {}
local Perimeter = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:Open")
AddEventHandler("police:Open", function()
	local Ped = PlayerPedId()
	if not IsPedSwimming(Ped) or LocalPlayer["state"]["Policia"] then
		SetNuiFocus(true, true)
		SendNUIMessage({ action = "Open" })
		TriggerEvent("dynamic:closeSystem")

		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			vRP.CreateObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", "prop_cs_tablet",49, 28422, -0.05, 0.0, 0.0, 0.0, 0.0, 0.0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("checkPrison", function()
	return InPrison
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNC
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Sync(Teleport, Status)
	if Teleport then
		if Status then
			SetEntityCoords(PlayerPedId(), SpawnPrison[1], SpawnPrison[2], SpawnPrison[3], 1, 0, 0, 0)
		else
			SetEntityCoords(PlayerPedId(), BackPrison[1], BackPrison[2], BackPrison[3], 1, 0, 0, 0)
		end
	end

	InPrison = Status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:Update")
AddEventHandler("police:Update", function(Action, Data)
	SendNUIMessage({ action = Action, data = Data })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:PERIMETER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:Perimeter")
AddEventHandler("police:Perimeter", function(x, y, z, Action)
    Perimeter = AddBlipForRadius(x, y, z, 150.0)
    table.insert(TablePerimeter, { name = Action, blip = Perimeter, expire = PerimeterExpireTime })
    SetBlipColour(Perimeter, 1)
    SetBlipAlpha(Perimeter, 100)
    SetBlipAsShortRange(Perimeter, false)
    SetBlipDisplay(Perimeter, 4)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:DELETEPERIMETER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:DeletePerimeter")
AddEventHandler("police:DeletePerimeter", function(Action)
    for k, v in pairs(TablePerimeter) do
        if v.name == Action then
            if DoesBlipExist(v.blip) then
                RemoveBlip(v.blip)
            end
            TablePerimeter[k] = nil
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPERIMETER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        for k, v in pairs(TablePerimeter) do
            TablePerimeter[k].expire = v.expire - 1

            if v.expire <= 0 then
                if DoesBlipExist(v.blip) then
                    RemoveBlip(v.blip)
                end
                TablePerimeter[k] = nil
            end
        end
        Citizen.Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close", function(_, Callback)
	SendNUIMessage({ action = "Close" })
	SetNuiFocus(false, false)
	vRP.Destroy()
	Callback("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Prison", function(Data, Callback)
	vSERVER.Prison(
		Data["passaporte"],
		Data["servicos"],
		Data["multas"],
		Data["texto"],
		Data["associacao"],
		Data["material"],
		Data["url"],
		Data["militares"]
	)
	Callback("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CheckPrison", function(Data, Callback)
	Callback({ result = vSERVER.CheckPrison(parseInt(Data["idprisao"])) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Fine", function(Data, Callback)
	vSERVER.Fine(Data["passaporte"], Data["multas"], Data["texto"], Data["driverlicense"])
	Callback("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Search", function(Data, Callback)
	local r = vSERVER.Search(parseInt(Data["passaporte"]))
	Callback({ result = r })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GiveGunlicense", function(Data, Callback)
	vSERVER.GiveGunlicense(parseInt(Data["passaporte"]), Data["serial"], Data["status"], Data["arma"], Data["exame"])
	Callback("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EDITGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("EditGunlicense", function(Data, Callback)
	vSERVER.EditGunlicense(parseInt(Data["id"]), parseInt(Data["passaporte"]), Data["serial"], Data["status"], Data["weapon"],
		Data["exame"])
	Callback("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("DeleteGunlicense", function(Data, Callback)
	vSERVER.DeleteGunlicense(Data["excluirporte"])
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetGunlicense", function(Data, Callback)
	Callback({ result = vSERVER.GetGunlicense(Data["idedporte"]) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCHGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("SearchGunlicense", function(Data, Callback)
	if Data["type"] == "consultar" then
		Callback({ result = vSERVER.SearchGunlicense() })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Warrant", function(Data, Callback)
	vSERVER.Warrant(parseInt(Data["passaporte"]), Data["texto"])
	Callback("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Warrant
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("DeleteWarrant", function(Data, Callback)
	vSERVER.DeleteWarrant(Data["excluirpro"])
	Callback("ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CheckWarrant", function(Data, Callback)
	local r = vSERVER.CheckWarrant(Data["idprocurado"])
	Callback({ result = r })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWARRANT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetWarrant", function(Data, Callback)
	if Data["type"] == "consultar" then
		Callback({ result = vSERVER.GetWarrant() })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Reports", function(_, Callback)
	Callback(vSERVER.Reports())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPORTSOLVED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ReportSolved", function(Data, Callback)
	vSERVER.ReportSolved(Data["id"])
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPORTREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ReportRemove", function(Data, Callback)
	vSERVER.ReportRemove(Data["id"])
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDREPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("AddReport", function(Data, Callback)
	vSERVER.AddReport(Data)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("UpdatePort", function(Data)
	vSERVER.UpdatePort(Data["passaporte"])
end)