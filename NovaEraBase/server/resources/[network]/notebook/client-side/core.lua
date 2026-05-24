-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("notebook",Creative)
vSERVER = Tunnel.getInterface("notebook")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleData(vehicle)
	local vehBoost = {
		driveinertia = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveInertia"),
		steeringlock = GetVehicleHandlingFloat(vehicle,"CHandlingData","fSteeringLock"),
		tractioncurvemax = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMax"),
		tractioncurvemin = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMin"),
		tractioncurvelateral = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveLateral"),
		lowspeedtractionlossmult = GetVehicleHandlingFloat(vehicle,"CHandlingData","fLowSpeedTractionLossMult"),
		initialdragcoeff = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDragCoeff"),
		drivebiasfront = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveBiasFront")
	}

	return vehBoost
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function saveData(vehicle,data)
	local driveinertia = data.driveinertia*1.0
	local steeringlock = data.steeringlock*1.0
	local tractioncurvemax = data.tractioncurvemax*1.0
	local tractioncurvemin = data.tractioncurvemin*1.0
	local tractioncurvelateral = data.tractioncurvelateral*1.0
	local lowspeedtractionlossmult = data.lowspeedtractionlossmult*1.0
	local initialdragcoeff = data.initialdragcoeff*1.0
	local drivebiasfront = data.drivebiasfront
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveInertia",driveinertia)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fSteeringLock",steeringlock)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMax",tractioncurvemax)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMin",tractioncurvemin)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveLateral",tractioncurvelateral)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fLowSpeedTractionLossMult",lowspeedtractionlossmult)
	SetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDragCoeff",initialdragcoeff)
	if initialdragcoeff > 50.0 then
		local multiply = drivebiasfront
		ModifyVehicleTopSpeed(vehicle, initialdragcoeff*multiply)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("save",function(data,cb)
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped) then
        local vehicle = GetVehiclePedIsUsing(ped)

        if GetPedInVehicleSeat(vehicle,-1) == ped then
            saveData(vehicle,data)
            vSERVER.SaveRemap(vehicleData(vehicle),GetVehicleNumberPlateText(vehicle))
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("exit",function()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsUsing(ped)
		if GetPedInVehicleSeat(vehicle,-1) == ped then
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTEBOOK:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("notebook:openSystem")
AddEventHandler("notebook:openSystem", function()
    local ped = PlayerPedId()
    
    if not UsePermissionNotebook or (UsePermissionNotebook and vSERVER.CheckPermission()) then
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsUsing(ped)
            local vehModel = GetEntityModel(vehicle)

            if BlacklistVehiclesRemap[vehModel] then
                TriggerEvent("Notify","amarelo","O <b>Remap</b> não pode ser aplicado nesse veículo.",5000)
                return
            end

            if GetPedInVehicleSeat(vehicle,-1) == ped then
                local plate = GetVehicleNumberPlateText(vehicle)
                local remap = vSERVER.LoadRemap(plate)

                if remap then
                    saveData(vehicle, remap)
                end

                local default1 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveInertia")
                local default2 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fSteeringLock")
                local default3 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMax")
                local default4 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveMin")
                local default5 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fTractionCurveLateral")
                local default6 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fLowSpeedTractionLossMult")
                local default7 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDragCoeff")
                local default8 = GetVehicleHandlingFloat(vehicle,"CHandlingData","fDriveBiasFront")

                SetNuiFocus(true,true)
                SendNUIMessage({
                    type = "togglemenu",
                    state = true,
                    data = remap or vehicleData(vehicle),
                    driveinertiavalue = default1,
                    steeringlockvalue = default2,
                    tractioncurvemaxvalue = default3,
                    tractioncurveminvalue = default4,
                    tractioncurvelateralvalue = default5,
                    lowspeedtractionlossmultvalue = default6,
                    initialdragcoeffvalue = default7,
                    drivebiasfrontvalue = default8
                })
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEMENU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("togglemenu",function(data,cb)
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTEBOOK:APPLYREMAP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("notebook:ApplyRemap")
AddEventHandler("notebook:ApplyRemap", function(Network, Plate)
    CreateThread(function()
        local vehicle
        local time = GetGameTimer()

        repeat
            vehicle = NetworkGetEntityFromNetworkId(Network)
            Wait(100)
        until DoesEntityExist(vehicle) or GetGameTimer() - time >= 10000

        if DoesEntityExist(vehicle) then
            local remap = vSERVER.LoadRemap(Plate)
            if remap then
                saveData(vehicle, remap)
                TriggerEvent("Notify", "verde", "Remap automático aplicado no veículo.", 5000)
            end
        end
    end)
end)