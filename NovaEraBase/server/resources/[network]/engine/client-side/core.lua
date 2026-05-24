-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("engine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Price = 0
local Lasted = 0
local ActiveFuel = 0
local DisplayNui = false
local FuelRecharger = false
local DelayEntered = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,Message)
    if Event == "CEventNetworkPlayerEnteredVehicle" then
        if Message[1] == PlayerId() and GetGameTimer() >= DelayEntered then
            DelayEntered = GetGameTimer() + 5000

            local plate = GetVehicleNumberPlateText(Message[2])
            local VehicleFuel = vSERVER.VehicleFuel(plate)
            ActiveFuel = VehicleFuel or Entity(Message[2])["state"]["fuel"] or 100

            Entity(Message[2])["state"]:set("fuel",ActiveFuel,true)
            SetPedConfigFlag(GetPlayerPed(Message[1]),35,false)
            SetVehicleFuelLevel(Message[2],ActiveFuel + 0.0)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FLOOR
-----------------------------------------------------------------------------------------------------------------------------------------
function floor(Number)
    local Mult = 10 ^ 1
    return math.floor(Number * Mult + 0.5) / Mult
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFUELCONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local TimeDistance = 999
        local Ped = PlayerPedId()
        if IsPedInAnyVehicle(Ped) then
            local Vehicle = GetVehiclePedIsUsing(Ped)
            if GetVehicleFuelLevel(Vehicle) >= 1 then
                local Speed = GetEntitySpeed(Vehicle) * VehVelocity
                if Speed >= 1 then
                    local Rpm = floor(GetVehicleCurrentRpm(Vehicle))
                    local Consumption = Consume[Rpm] or 1.0
                    local ClassModifier = Class[GetVehicleClass(Vehicle)] or 1.0

                    ActiveFuel = ActiveFuel - (Consumption * ClassModifier / 10)
                    SetVehicleFuelLevel(Vehicle, ActiveFuel + 0.0)

                    if GetPedInVehicleSeat(Vehicle, -1) == Ped then
                        local plate = GetVehicleNumberPlateText(Vehicle)
                        TriggerServerEvent("engine:tryFuel", plate, ActiveFuel)
                        Entity(Vehicle)["state"]:set("fuel", ActiveFuel, true)
                    end
                end
            else
                SetVehicleEngineOn(Vehicle, false, true, true)
                TimeDistance = 1
            end
        end
        Wait(TimeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:SUPPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:Supply")
AddEventHandler("engine:Supply",function(Entitys)
    local Vehicle = Entitys[3]
    Lasted = GetVehicleFuelLevel(Vehicle)

    if Lasted < 99.0 then
        local Gallon = Entitys[5]
        if not DisplayNui and not Gallon then
            SendNUIMessage({ name = "Show", payload = true })
            DisplayNui = true
        end

        FuelRecharger = true

        local Ped = PlayerPedId()
        TaskTurnPedToFaceEntity(Ped,Vehicle,5000)

        while FuelRecharger do
            DisableControlAction(0,18,true)
            DisableControlAction(0,22,true)
            DisableControlAction(0,23,true)
            DisableControlAction(0,24,true)
            DisableControlAction(0,29,true)
            DisableControlAction(0,30,true)
            DisableControlAction(0,31,true)
            DisableControlAction(0,140,true)
            DisableControlAction(0,142,true)
            DisableControlAction(0,143,true)
            DisableControlAction(0,257,true)
            DisableControlAction(0,263,true)

            local Coords = GetEntityCoords(Vehicle)
            local VehicleFuel = GetVehicleFuelLevel(Vehicle)

            if not Gallon then
                Price = Price + FuelPrice
                SetVehicleFuelLevel(Vehicle,VehicleFuel + 0.025)
                SendNUIMessage({ name = "Tank", payload = { tank = floor(VehicleFuel), price = Price, lts = FuelPrice * 4 } })
            else
                if GetAmmoInPedWeapon(Ped,883325847) - 0.02 * 100 > 1 then
                    SetPedAmmo(Ped,883325847,math.floor(GetAmmoInPedWeapon(Ped,883325847) - 0.02 * 100))
                    SetVehicleFuelLevel(Vehicle,VehicleFuel + 0.025)
                end
            end

            DrawText3D(Coords,"~g~E~w~   FINALIZAR")

            if not IsEntityPlayingAnim(Ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3) and LoadAnim("timetable@gardener@filling_can") then
                TaskPlayAnim(Ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",8.0,8.0,-1,50,1,0,0,0)
            end

            if VehicleFuel >= 100.0 or GetEntityHealth(Ped) <= 100 or (Gallon and GetAmmoInPedWeapon(Ped,883325847) - 0.02 * 100 <= 1) or IsControlJustPressed(1,38) then
                local plate = GetVehicleNumberPlateText(Vehicle)
                if not Gallon then
                    if vSERVER.RechargeFuel(Price) then
                        Entity(Vehicle)["state"]:set("fuel",VehicleFuel,true)
                        ActiveFuel = VehicleFuel
                        TriggerServerEvent("engine:tryFuel",plate,ActiveFuel)
                    else
                        Entity(Vehicle)["state"]:set("fuel",Lasted,true)
                        ActiveFuel = Lasted
                        TriggerServerEvent("engine:tryFuel",plate,ActiveFuel)
                    end
                    SendNUIMessage({ name = "Show", payload = false })
                else
                    Entity(Vehicle)["state"]:set("fuel",VehicleFuel,true)
                    TriggerServerEvent("engine:tryFuel",plate,VehicleFuel)
                end
                vRP.Destroy()
                FuelRecharger = false
                DisplayNui = false
                Price = 0
            end

            Wait(1)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(Coords,Text)
    local onScreen,x,y = World3dToScreen2d(Coords["x"],Coords["y"],Coords["z"] + 1)
    if onScreen then
        SetTextFont(4)
        SetTextCentre(true)
        SetTextProportional(1)
        SetTextScale(0.35,0.35)
        SetTextColour(255,255,255,150)
        SetTextEntry("STRING")
        AddTextComponentString(Text)
        EndTextCommandDisplayText(x,y)

        local Width = (string.len(Text) + 4) / 170 * 0.45
        DrawRect(x,y + 0.0125,Width,0.03,15,15,15,175)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:VTUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:vehTuning")
AddEventHandler("engine:vehTuning",function()
	local Vehicle = vRP.ClosestVehicle(5)
	if Vehicle then
		local Motor = GetVehicleMod(Vehicle,11)
		local Freio = GetVehicleMod(Vehicle,12)
		local Transmissao = GetVehicleMod(Vehicle,13)
		local Suspensao = GetVehicleMod(Vehicle,15)
		local Blindagem = GetVehicleMod(Vehicle,16)
		local Body = GetVehicleBodyHealth(Vehicle)
		local Engine = GetVehicleEngineHealth(Vehicle)
		local Fuel = GetVehicleFuelLevel(Vehicle)
		local Plate = GetVehicleNumberPlateText(Vehicle)

		if Motor == -1 then
			Motor = "Desativado"
		else
			Motor = "Nível "..(Motor + 1)
		end

		if Freio == -1 then
			Freio = "Desativado"
		else
			Freio = "Nível "..(Freio + 1)
		end

		if Transmissao == -1 then
			Transmissao = "Desativado"
		else
			Transmissao = "Nível "..(Transmissao + 1)
		end

		if Suspensao == -1 then
			Suspensao = "Desativado"
		else
			Suspensao = "Nível "..(Suspensao + 1)
		end

		if Blindagem == -1 then
			Blindagem = "Desativado"
		else
			Blindagem = "Nível "..(Blindagem + 1)
		end

		TriggerEvent("Notify","azul","<b>Motor:</b> "..Motor..
		"<br><b>Freio:</b> "..Freio..
		"<br><b>Transmissão:</b> "..Transmissao..
		"<br><b>Suspensão:</b> "..Suspensao..
		"<br><b>Blindagem:</b> "..Blindagem..
		"<br><b>Lataria:</b> "..parseInt(Body / 10)..
		"%<br><b>Nitro:</b> "..parseInt((GlobalState["Nitro"][Plate] or 0) / 10)..
		"%<br><b>Motor:</b> "..parseInt(Engine / 10)..
		"%<br><b>Gasolina:</b> "..parseInt(Fuel).."%",15000)
	end
end)