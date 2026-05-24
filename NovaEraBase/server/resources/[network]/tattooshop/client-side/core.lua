-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("tattooshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Camera = nil
local Tattoos = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TATTOOSHOP:APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tattooshop:Apply")
AddEventHandler("tattooshop:Apply",function(Table)
	Tattoos = Table
	exports["tattooshop"]:Apply()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Apply",function()
	local Ped = PlayerPedId()
	for Index,Overlay in pairs(Tattoos) do
		AddPedDecorationFromHashes(Ped,Overlay,Index)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENTATTOOSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function OpenTattooshop()
	if vSERVER.Verify() then
		CameraActive()
		SetNuiFocus(true,true)

		local Ped = PlayerPedId()
		if GetEntityModel(Ped) == GetHashKey("mp_m_freemode_01") then
			Active = Dataset["Masculino"]

			Clothes(Ped, "Masculino")
		elseif GetEntityModel(Ped) == GetHashKey("mp_f_freemode_01") then
			Active = Dataset["Feminino"]

			Clothes(Ped, "Feminino")
		end

		ClearAllPedProps(Ped)

		vRP.playAnim(true,{"mp_sleep","bind_pose_180"},true)

		SendNUIMessage({ shop = Active, tattoo = Tattoos, gender = GetEntityModel(Ped) == GetHashKey("mp_m_freemode_01") and "Masculino" or "Feminino" })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TATTOOSHOP:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tattooshop:Open")
AddEventHandler("tattooshop:Open",function()
	TriggerEvent("dynamic:closeSystem")

	OpenTattooshop()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAMERAACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function CameraActive()
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	local Ped = PlayerPedId()
	local Heading = GetEntityHeading(Ped)
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.30,1.60,-0.10)

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamCoord(Camera,Coords["x"],Coords["y"],Coords["z"])
	RenderScriptCams(true,true,100,true,true)
	SetCamRot(Camera,0.0,0.0,Heading + 180)
	SetEntityHeading(Ped,Heading - 10)
	SetCamActive(Camera,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		SetCamActive(Camera,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	exports["skinshop"]:Apply()
	SetNuiFocus(false,false)
	vSERVER.Update(Tattoos)
	vRP.Destroy()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Tables = {}

	for Number = 1,#Locations do
		Tables[#Tables + 1] = { Locations[Number]["x"],Locations[Number]["y"],Locations[Number]["z"],2.0,"E","Loja de Tatuagem","Pressione para abrir" }
	end

	TriggerEvent("hoverfy:Insert",Tables)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADLOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for Number = 1,#Locations do
					if #(Coords - Locations[Number]) <= 2.0 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) and vSERVER.CheckWanted() then
							OpenTattooshop()
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Change",function(Data,Callback)
	local Ped = PlayerPedId()
	local Number = Data["id"]
	local Types = Data["type"]

	if Active[Types] and Active[Types][Number] then
		local Name = Active[Types][Number]["name"]

		if Tattoos[Name] then
			Tattoos[Name] = nil
		else
			Tattoos[Name] = Active[Types][Number]["part"]
		end

		ClearPedDecorations(Ped)

		for Index,Overlay in pairs(Tattoos) do
			AddPedDecorationFromHashes(Ped,Overlay,Index)
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Clean",function(Data,Callback)
	ClearPedDecorations(PlayerPedId())
	Tattoos = {}

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	local Ped = PlayerPedId()

	if Data["direction"] == "Left" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) - 5)
	elseif Data["direction"] == "Right" then
		SetEntityHeading(Ped,GetEntityHeading(Ped) + 5)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDSUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("HandsUp",function(Data,Callback)
	local Ped = PlayerPedId()
	if IsEntityPlayingAnim(Ped,"random@mugging3","handsup_standing_base",3) then
		StopAnimTask(Ped,"random@mugging3","handsup_standing_base",8.0)
		vRP.AnimActive()
	else
		vRP.playAnim(true,{"random@mugging3","handsup_standing_base"},true)
	end

	Callback("Ok")
end)