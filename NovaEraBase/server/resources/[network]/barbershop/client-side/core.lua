-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("barbershop",Creative)
vSERVER = Tunnel.getInterface("barbershop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawn = nil
local Camera = nil
local Barbershop = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Finish",function(Data,Callback)
	exports["barbershop"]:Apply(Data)
	SetNuiFocus(false,false)
	vSERVER.Update(Data)
	vRP.Destroy()
	if Spawn then
		if DefaultSkinshop then
			TriggerEvent("skinshop:Open",Spawn)
		else
			FreezeEntityPosition(PlayerPedId(),false)
			SetEntityCoordsNoOffset(PlayerPedId(), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, true, true, true)
			SetEntityHeading(PlayerPedId(), SpawnCoords.w)
		end
	else
		FreezeEntityPosition(PlayerPedId(),false)
	end
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Cancel",function(Data,Callback)
	exports["barbershop"]:Apply(LocalPlayer["state"]["Barbershop"])
	LocalPlayer["state"]:set("Barbershop",{},true)
	SetNuiFocus(false,false)
	vRP.Destroy()
	if Spawn then
		if DefaultSkinshop then
			TriggerEvent("skinshop:Open",Spawn)
		else
			FreezeEntityPosition(PlayerPedId(),false)
			SetEntityCoordsNoOffset(PlayerPedId(), SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, true, true, true)
			SetEntityHeading(PlayerPedId(), SpawnCoords.w)
		end
	else
		FreezeEntityPosition(PlayerPedId(),false)
	end
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	local Ped = PlayerPedId()
	exports["barbershop"]:Apply(Data)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	local Ped = PlayerPedId()
	local Heading = GetEntityHeading(Ped)
	if Data == "Left" then
		SetEntityHeading(Ped,Heading + 10)
	else
		SetEntityHeading(Ped,Heading - 10)
	end
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOP:APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("barbershop:Apply")
AddEventHandler("barbershop:Apply",function(Data)
	exports["barbershop"]:Apply(Data)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Apply",function(Data,Ped)
	if not Ped then
		Ped = PlayerPedId()
	end

	if Data then
		Barbershop = Data
	end

	for Number = 1, 47 do
		if not Barbershop[Number] then
			if Number == 45 then
				Barbershop[Number] = 17
			else
				Barbershop[Number] = 0
			end
		end
	end

	SetPedHeadBlendData(Ped,Fathers[Barbershop[1] + 1],Mothers[Barbershop[2] + 1],0,Barbershop[5],0,0,Barbershop[3] + 0.0,0,0,false)

	SetPedEyeColor(Ped,Barbershop[4])

	SetPedComponentVariation(Ped,2,Barbershop[10],0,0)
	SetPedHairColor(Ped,Barbershop[11],Barbershop[12])

	SetPedHeadOverlay(Ped,0,Barbershop[7],1.0)
	SetPedHeadOverlayColor(Ped,0,0,0,0)

	SetPedHeadOverlay(Ped,1,Barbershop[22],Barbershop[23])
	SetPedHeadOverlayColor(Ped,1,1,Barbershop[24],Barbershop[24])

	SetPedHeadOverlay(Ped,2,Barbershop[19],Barbershop[20])
	SetPedHeadOverlayColor(Ped,2,1,Barbershop[21],Barbershop[21])

	SetPedHeadOverlay(Ped,3,Barbershop[9],1.0)
	SetPedHeadOverlayColor(Ped,3,0,0,0)

	SetPedHeadOverlay(Ped,4,Barbershop[13],Barbershop[14])
	SetPedHeadOverlayColor(Ped,4,2,Barbershop[15],Barbershop[15])

	SetPedHeadOverlay(Ped,5,Barbershop[25],Barbershop[26])
	SetPedHeadOverlayColor(Ped,5,2,Barbershop[27],Barbershop[27])

	SetPedHeadOverlay(Ped,6,Barbershop[6],1.0)
	SetPedHeadOverlayColor(Ped,6,0,0,0)

	SetPedHeadOverlay(Ped,8,Barbershop[16],Barbershop[17])
	SetPedHeadOverlayColor(Ped,8,2,Barbershop[18],Barbershop[18])

	SetPedHeadOverlay(Ped,9,Barbershop[8],1.0)
	SetPedHeadOverlayColor(Ped,9,0,0,0)

	SetPedHeadOverlay(Ped,10,Barbershop[45],Barbershop[47])
	SetPedHeadOverlayColor(Ped,10,1,5,5)

	SetPedFaceFeature(Ped,0,Barbershop[28])
	SetPedFaceFeature(Ped,1,Barbershop[29])
	SetPedFaceFeature(Ped,2,Barbershop[30])
	SetPedFaceFeature(Ped,3,Barbershop[31])
	SetPedFaceFeature(Ped,4,Barbershop[32])
	SetPedFaceFeature(Ped,5,Barbershop[33])
	SetPedFaceFeature(Ped,6,Barbershop[44])
	SetPedFaceFeature(Ped,7,Barbershop[34])
	SetPedFaceFeature(Ped,8,Barbershop[36])
	SetPedFaceFeature(Ped,9,Barbershop[35])
	SetPedFaceFeature(Ped,10,Barbershop[45])
	SetPedFaceFeature(Ped,12,Barbershop[42])
	SetPedFaceFeature(Ped,13,Barbershop[46])
	SetPedFaceFeature(Ped,14,Barbershop[37])
	SetPedFaceFeature(Ped,15,Barbershop[38])
	SetPedFaceFeature(Ped,16,Barbershop[40])
	SetPedFaceFeature(Ped,17,Barbershop[39])
	SetPedFaceFeature(Ped,18,Barbershop[41])
	SetPedFaceFeature(Ped,19,Barbershop[43])
end)	
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENBARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenBarbershop(Mode)

	Spawn = Mode == "spawn"

	for Number = 1, 47 do
		if not Barbershop[Number] then
			Barbershop[Number] = 0
			if Number == 45 then
				Barbershop[Number] = 25
			end
		end
	end

	LocalPlayer["state"]:set("Barbershop",Barbershop,true)

	local Ped = PlayerPedId()
	local Heading = GetEntityHeading(Ped)
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,0.5,0)

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"] + 0.6)
	RenderScriptCams(true,true,100,true,true)
	SetCamRot(Camera,0.0,0.0,Heading + 180)
	SetEntityHeading(Ped,Heading)
	SetCamActive(Camera,true)
	SendNUIMessage({ name = "Open", mode = Mode, payload = { Barbershop, GetNumberOfPedDrawableVariations(Ped,2) - 1 } })
	SetNuiFocus(true,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Tables = {}

	for Number = 1,#Barbershops do
		Tables[#Tables + 1] = { Barbershops[Number]["x"],Barbershops[Number]["y"],Barbershops[Number]["z"],2.5,"E","Barbearia","Pressione para abrir" }
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)
				for Number = 1,#Barbershops do
					if #(Coords - Barbershops[Number]) <= 2.5 then
						TimeDistance = 1
						if IsControlJustPressed(1,38) and vSERVER.CheckWanted() then
							FreezeEntityPosition(Ped,true)
							OpenBarbershop("barber")
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOP:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("barbershop:Open")
AddEventHandler("barbershop:Open",function(Mode)
	OpenBarbershop(Mode)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERCOMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("barbershop", function()
	if vSERVER.CheckPerm() == true then
		OpenBarbershop()
	end
end)