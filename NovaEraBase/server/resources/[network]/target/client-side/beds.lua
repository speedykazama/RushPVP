------------------------------------------------------------------------------------------------------------------------------------------
--- VARIABLES
------------------------------------------------------------------------------------------------------------------------------------------
local Previous = nil
local Treatment = false
local TreatmentTimer = 0
LocalPlayer["state"]["Bed"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index in pairs(Beds) do
		exports["target"]:AddTargetModel({Index}, {
			options = {
				{
					event = "target:PutBed",
					label = "Deitar",
					tunnel = "client"
				},
				{
					event = "target:Treatment",
					label = "Tratamento",
					tunnel = "client"
				}
			},
			Distance = 1.25,
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:PUTBED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:PutBed")
AddEventHandler("target:PutBed", function(SelectedData)
    Selected = SelectedData
    if Selected and Selected[1] and Selected[2] then
        local Ped = PlayerPedId()
        local objCoords = GetEntityCoords(Selected[1])
        local bedData = Beds[Selected[2]]
        if bedData then
            SetEntityCoords(Ped, objCoords.x, objCoords.y, objCoords.z + bedData[1], 1, 0, 0, 0)
            SetEntityHeading(Ped, GetEntityHeading(Selected[1]) + bedData[2] - 180.0)
            vRP.playAnim(false, {"anim@gangops@morgue@table@", "body_search"}, true)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPBED
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterNetEvent("target:UpBed")
-- AddEventHandler("target:UpBed", function()
-- 	if Previous then
-- 		local Ped = PlayerPedId()
-- 		SetEntityCoords(Ped, Previous["x"], Previous["y"], Previous["z"] - 1, false, false, false, false)
-- 		Previous = nil
-- 	end
-- end)

RegisterNetEvent("target:UpBed")
AddEventHandler("target:UpBed",function()
	if LocalPlayer["state"]["Bed"] then
		DetachEntity(PlayerPedId(),false,false)
		FreezeEntityPosition(LocalPlayer["state"]["Bed"],true)
		DetachEntity(LocalPlayer["state"]["Bed"],false,false)
		LocalPlayer["state"]["Bed"] = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Treatment")
AddEventHandler("target:Treatment", function(SelectedData)
    Selected = SelectedData
    local Ped = PlayerPedId()
    local Coords = GetEntityCoords(Ped)
	local Object = GetClosestObjectOfType(Coords, 1.5, Selected[2], false, false, false)

    if Object ~= 0 then
        local Model = GetEntityModel(Object)
        Selected = {Object, Model}

        if vSERVER.CheckIn() then
            local objCoords = GetEntityCoords(Object)
            local bedData = Beds[Model]
            if bedData then
                SetEntityCoords(Ped, objCoords.x, objCoords.y, objCoords.z + bedData[1], 1, 0, 0, 0)
                SetEntityHeading(Ped, GetEntityHeading(Object) + bedData[2] - 180.0)
                vRP.playAnim(false, {"anim@gangops@morgue@table@", "body_search"}, true)

                TriggerEvent("inventory:preventWeapon", true)
                LocalPlayer["state"]["Commands"] = true
                LocalPlayer["state"]["Cancel"] = true
                TriggerEvent("paramedic:Reset")

                if GetEntityHealth(Ped) <= 100 then
                    exports["survival"]:Revive(101)
                end

                Treatment = true
            end
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------s
RegisterNetEvent("target:StartTreatment")
AddEventHandler("target:StartTreatment",function()
    if not Treatment then
        LocalPlayer["state"]["Commands"] = true
        LocalPlayer["state"]["Cancel"] = true
        Treatment = true
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:BEDDEITAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:BedDeitar")
AddEventHandler("target:BedDeitar",function()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local Object = GetClosestObjectOfType(Coords,1.0,-935625561,0,0,0)
	if DoesEntityExist(Object) then
		Coords = GetEntityCoords(Object)
		SetEntityCoords(Ped,Coords,false,false,false,false)
		SetEntityHeading(Ped,GetEntityHeading(Object) - 180.0)
		vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
		AttachEntityToEntity(Ped,Object,11816,0.0,0.0,1.0,0.0,0.0,0.0,false,false,false,false,2,true)
		LocalPlayer["state"]["Bed"] = Object
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:BEDPICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:BedPickup")
AddEventHandler("target:BedPickup",function(Selected)
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] then
		local Ped = PlayerPedId()
		if GetEntityHealth(Ped) > 100 then
			local uObject = NetworkGetEntityFromNetworkId(Selected[3])
			local objectControl = NetworkRequestControlOfEntity(uObject)
			while not objectControl do
				objectControl = NetworkRequestControlOfEntity(uObject)
				Wait(1)
			end

			AttachEntityToEntity(uObject,Ped,11816,0.0,1.25,-0.15,0.0,0.0,0.0,false,false,false,false,2,true)
			LocalPlayer["state"]["Bed"] = Selected[1]
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:BEDDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:BedDestroy")
AddEventHandler("target:BedDestroy",function(Selected)
	if not LocalPlayer["state"]["Commands"] or LocalPlayer["state"]["Paramedic"] or LocalPlayer["state"]["Bombeiro"] then
		TriggerServerEvent("DeleteObject",Selected[3])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBEDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if Previous and not IsEntityPlayingAnim(Ped, "amb@world_human_sunbathe@female@back@idle_a", "idle_a", 3) then
			SetEntityCoords(Ped, Previous["x"], Previous["y"], Previous["z"] - 1, false, false, false, false)
			Previous = nil
		end

		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Treatment then
			if GetGameTimer() >= TreatmentTimer then
				local Ped = PlayerPedId()
				local Health = GetEntityHealth(Ped)
				TreatmentTimer = GetGameTimer() + 1000

				if Health < 200 then
					SetEntityHealth(Ped,Health + 1)
				else
					Treatment = false
					LocalPlayer["state"]["Cancel"] = false
					LocalPlayer["state"]["Commands"] = false
					TriggerEvent("Notify","amarelo","Tratamento concluido.",5000)
				end
			end
		end

		Wait(1000)
	end
end)