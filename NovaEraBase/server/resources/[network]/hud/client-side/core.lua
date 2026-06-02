-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = false
local Avatar = DefaultAvatar
local Voip = 2
local Radio = "Offline"
local Weapon = false
local WeaponName = ""
local MinimapReady = false
local MinimapScaleform = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIMAP
-----------------------------------------------------------------------------------------------------------------------------------------
local function SetupMinimap()
	if MinimapReady then
		return
	end

	RequestStreamedTextureDict("circlemap",false)

	local Timeout = GetGameTimer() + 10000
	while not HasStreamedTextureDictLoaded("circlemap") and GetGameTimer() < Timeout do
		Wait(100)
	end

	if not HasStreamedTextureDictLoaded("circlemap") then
		return
	end

	AddReplaceTexture("platform:/textures/graphics","radarmasksm","circlemap","radarmasksm")
	SetMinimapClipType(1)
	SetMinimapComponentPosition("minimap","L","B",MinimapPosX,MinimapPosY,MinimapWidth,MinimapHeight)
	SetMinimapComponentPosition("minimap_mask","L","B",MinimapPosX,MinimapPosY,MinimapWidth,MinimapHeight)
	SetMinimapComponentPosition("minimap_blur","L","B",0.012,0.022,0.256,0.337)

	MinimapScaleform = RequestScaleformMovie("minimap")
	SetRadarBigmapEnabled(true,false)
	Wait(150)
	SetRadarBigmapEnabled(false,false)

	MinimapReady = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD COMPONENTS
-----------------------------------------------------------------------------------------------------------------------------------------
local HideComponents = { 1,2,3,4,6,7,8,9,13,17,20,21,22 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active",function(Status)
	Active = Status

	if Active then
		SetupMinimap()
	end

	DisplayRadar(Active)
	SendNUIMessage({ Action = "Body", Payload = Active })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUDACTIVED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hudActived")
AddEventHandler("hudActived",function(Status)
	Active = Status
	DisplayRadar(Active)
	SendNUIMessage({ Action = "Body", Payload = Active })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:AVATAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Avatar")
AddEventHandler("hud:Avatar",function(Url)
	if Url and Url ~= "" then
		Avatar = Url
	else
		Avatar = DefaultAvatar
	end

	SendNUIMessage({ Action = "Avatar", Payload = Avatar })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voip")
AddEventHandler("hud:Voip",function(Mode)
	Voip = parseInt(Mode)
	SendNUIMessage({ Action = "Voip", Payload = Voip })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Radio")
AddEventHandler("hud:Radio",function(Frequency)
	Radio = Frequency or "Offline"
	SendNUIMessage({ Action = "Radio", Payload = Radio })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voice")
AddEventHandler("hud:Voice",function(Status)
	SendNUIMessage({ Action = "Voice", Payload = Status })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Weapon")
AddEventHandler("hud:Weapon",function(Status,Name)
	Weapon = Status
	WeaponName = Name or ""
	SendNUIMessage({ Action = "Weapon", Payload = { Status = Weapon, Name = WeaponName } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEHOOD / SCUBA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveHood")
AddEventHandler("hud:RemoveHood",function() end)

RegisterNetEvent("hud:ScubaRemove")
AddEventHandler("hud:ScubaRemove",function() end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
	SendNUIMessage({ Action = "Passport", Payload = { Passport = Passport, Name = Name, Avatar = Avatar } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIMAP THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if MinimapReady and MinimapScaleform and Active then
			BeginScaleformMovieMethod(MinimapScaleform,"SETUP_HEALTH_ARMOUR")
			ScaleformMovieMethodAddParamInt(3)
			EndScaleformMovieMethod()
		end

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetupMinimap()

	while true do
		local TimeDistance = 500

		if Active and LocalPlayer["state"]["Active"] then
			TimeDistance = 200

			local Ped = PlayerPedId()
			local Health = math.max(0,math.min(100,GetEntityHealth(Ped) - 100))
			local Armour = GetPedArmour(Ped)

			for Number = 1,#HideComponents do
				HideHudComponentThisFrame(HideComponents[Number])
			end

			SendNUIMessage({
				Action = "Player",
				Payload = {
					Health = Health,
					Armour = Armour,
					Avatar = Avatar,
					Voip = Voip,
					Radio = Radio
				}
			})
		end

		Wait(TimeDistance)
	end
end)
