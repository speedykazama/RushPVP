-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Skate = {}
Attached = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKATE:START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("skate:start")
AddEventHandler("skate:start",function() 
	local ped = PlayerPedId()
	if DoesEntityExist(Skate.Entity) then return end
	Skate.Spawn()
	while DoesEntityExist(Skate.Entity) and DoesEntityExist(Skate.Driver) do
		Citizen.Wait(5)
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(Skate.Entity),true)
		Skate.HandleKeys(distanceCheck)
		if distanceCheck <= 3 then
			if not NetworkHasControlOfEntity(Skate.Driver) then
				NetworkRequestControlOfEntity(Skate.Driver)
			elseif not NetworkHasControlOfEntity(Skate.Entity) then
				NetworkRequestControlOfEntity(Skate.Entity)
			end
		else
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,6,2500)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEKEYS
-----------------------------------------------------------------------------------------------------------------------------------------
function Skate.HandleKeys(distanceCheck)
	local ped = PlayerPedId()
	if distanceCheck <= 1.5 then
		if IsControlJustPressed(0,38) and IsInputDisabled(0) and not Attached then
			Skate.Attach("pick")
		end
		if IsControlJustReleased(0,244) and IsInputDisabled(0) then
			if Attached then
				Skate.AttachPlayer(false)
			else
				Skate.AttachPlayer(true)
			end
		end
		if not Attached then
			DrawText3Ds(GetEntityCoords(Skate.Entity).x,GetEntityCoords(Skate.Entity).y,GetEntityCoords(Skate.Entity).z+0.5,"~r~E ~w~ PEGAR      ~g~M ~w~ SUBIR",500)
		end
	end
	if distanceCheck <= 1.5 and Attached then
		if IsControlPressed(0,32) and IsInputDisabled(0) and not IsControlPressed(0,33)  and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,9,1)
		end
		if IsControlJustReleased(0,22) and IsInputDisabled(0) and Attached then
			local vel = GetEntityVelocity(Skate.Entity)
			if not IsEntityInAir(Skate.Entity) then
				SetEntityVelocity(Skate.Entity,vel.x,vel.y,vel.z+5.0)
				Citizen.Wait(20)
			end		
		end	
		if IsControlJustReleased(0,32) or IsControlJustReleased(0,33) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,6,2500)
		end
		if IsControlPressed(0,33) and not IsControlPressed(0,32) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,22,1)
		end
		if IsControlPressed(0,34) and IsControlPressed(0,33) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,13,1)
		end
		if IsControlPressed(0,35) and IsControlPressed(0,33) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,14,1)
		end
		if IsControlPressed(0,32) and IsControlPressed(0,33) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,30,100)
		end
		if IsControlPressed(0,34) and IsControlPressed(0,32) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,7,1)
		end
		if IsControlPressed(0,35) and IsControlPressed(0,32) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,8,1)
		end
		if IsControlPressed(0,34) and not IsControlPressed(0,32) and not IsControlPressed(0,33) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,4,1)
		end
		if IsControlPressed(0,35) and not IsControlPressed(0,32) and not IsControlPressed(0,33) and IsInputDisabled(0) then
			TaskVehicleTempAction(Skate.Driver,Skate.Entity,5,1)
		end	
	end
	Citizen.CreateThread(function()
    	Citizen.Wait(1)
    	if Attached then
	        local x = GetEntityRotation(Skate.Entity).x
	        local y = GetEntityRotation(Skate.Entity).y

	        if (-60.0 < x and x > 60.0) or (-60.0 < y and y > 60.0) or (HasEntityCollidedWithAnything(Skate.Entity) and GetEntitySpeed(Skate.Entity) > 12.6) then
	        	Skate.AttachPlayer(false)
	        	SetPedToRagdoll(ped,4000,4000,0,true,true,false)
	        elseif IsPedArmed(ped,7) or IsEntityInWater(Skate.Entity) or GetEntityHealth(ped) <= 101 then
	        	Skate.AttachPlayer(false)
	        	DetachEntity(Skate.Entity)
			end	
	    end           
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
function Skate.Spawn()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then
		Skate.LoadModels({ GetHashKey("rcbandito"),68070371,GetHashKey("p_defilied_ragdoll_01_s"),"pickup_object","move_strafe@stealth" })
		local spawnCoords,spawnHeading = GetEntityCoords(ped)+GetEntityForwardVector(ped)*2.0,GetEntityHeading(ped)
		Skate.Entity = CreateVehicle(GetHashKey("rcbandito"),spawnCoords,spawnHeading,true)
		Skate.Skate = CreateObject(GetHashKey("p_defilied_ragdoll_01_s"),0.0,0.0,0.0,true,true,true)
		while not DoesEntityExist(Skate.Entity) do
			Citizen.Wait(5)
		end
		while not DoesEntityExist(Skate.Skate) do
			Citizen.Wait(5)
		end
		SetVehicleHandlingFloat(Skate.Entity,"CHandlingData","fSuspensionForce",1.5)
		SetVehicleEngineTorqueMultiplier(Skate.Entity,0.1)
		SetEntityNoCollisionEntity(Skate.Entity,ped,false)
		SetEntityVisible(Skate.Entity,false)
		SetAllVehiclesSpawn(Skate.Entity,true,true,true,true)
		AttachEntityToEntity(Skate.Skate,Skate.Entity,GetPedBoneIndex(ped,28422),0.0,0.0,-0.15,0.0,0.0,90.0,true,true,true,true,1,true)	
		SetEntityCollision(Skate.Skate,true,true)
		Skate.Driver = CreatePed(5,68070371,spawnCoords,spawnHeading,true)
		SetEntityInvincible(Skate.Driver,true)
		SetEntityVisible(Skate.Driver,false)
		FreezeEntityPosition(Skate.Driver,true)
		SetPedAlertness(Skate.Driver,0.0)
		TaskWarpPedIntoVehicle(Skate.Driver,Skate.Entity,-1)
		while not IsPedInVehicle(Skate.Driver,Skate.Entity) do
			Citizen.Wait(0)
		end
		Skate.Attach("place")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACH
-----------------------------------------------------------------------------------------------------------------------------------------
function Skate.Attach(param)
	local ped = PlayerPedId()
	if not DoesEntityExist(Skate.Entity) or GetEntityHealth(ped) <= 101 then
		return
	end
	if param == "place" then
		AttachEntityToEntity(Skate.Entity,ped,GetPedBoneIndex(ped,28422),-0.1,0.0,-0.2,70.0,0.0,270.0,1,1,0,0,2,1)
		TaskPlayAnim(ped,"pickup_object","pickup_low",8.0,-8.0,-1,0,0,false,false,false)
		Citizen.Wait(800)
		DetachEntity(Skate.Entity,false,true)
		PlaceObjectOnGroundProperly(Skate.Entity)
	elseif param == "pick" then
		Citizen.Wait(100)
		TaskPlayAnim(ped,"pickup_object","pickup_low",8.0,-8.0,-1,0,0,false,false,false)
		Citizen.Wait(600)
		AttachEntityToEntity(Skate.Entity,ped,GetPedBoneIndex(ped,28422),-0.1,0.0,-0.2,70.0,0.0,270.0,1,1,0,0,2,1)
		Citizen.Wait(900)
		DetachEntity(Skate.Entity)
		DeleteEntity(Skate.Skate)
		DeleteVehicle(Skate.Entity)
		DeleteEntity(Skate.Driver)
		for modelIndex = 1,#Skate.CachedModels do
			local model = Skate.CachedModels[modelIndex]
			if IsModelValid(model) then
				SetModelAsNoLongerNeeded(model)
			else
				RemoveAnimDict(model)   
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOADMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
function Skate.LoadModels(models)
	for modelIndex = 1, #models do
		local model = models[modelIndex]
		if not Skate.CachedModels then
			Skate.CachedModels = {}
		end
		table.insert(Skate.CachedModels,model)
		if IsModelValid(model) then
			while not HasModelLoaded(model) do
				RequestModel(model)	
				Citizen.Wait(10)
			end
		else
			while not HasAnimDictLoaded(model) do
				RequestAnimDict(model)
				Citizen.Wait(10)
			end    
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function Skate.AttachPlayer(toggle)
	local ped = PlayerPedId()
	if toggle then
		TaskPlayAnim(ped,"move_strafe@stealth","idle",8.0,8.0,-1,1,1.0,false,false,false)
		AttachEntityToEntity(ped,Skate.Entity,20,0.0,0.0,0.98,0.0,0.0,-15.0,true,true,true,true,true,true)
		SetEntityCollision(ped,true,false)
		Attached = true		
	elseif not toggle then
		DetachEntity(ped,false,false)
		Attached = false
		StopAnimTask(ped,"move_strafe@stealth","idle",1.0)	
	end	
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z,text,size)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/size
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end