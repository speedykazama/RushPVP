-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("admin",Creative)
vSERVER = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Flash = false
local PegandoFogo = false
local Explodir = false
local Pulo = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVISIBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Spectate"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:blips")
AddEventHandler("admin:blips",function(players)
    Blipmin = not Blipmin

    while Blipmin do
        for Entity, v in pairs(GetPlayers()) do
            local playerID = GlobalState["Players"][v]
            if playerID then
                local fullName = players[playerID]["fullName"]
                DrawText3D(GetEntityCoords(Entity), "~o~ID:~w~ " .. playerID .. "     ~g~Vida:~w~ " .. GetEntityHealth(Entity) .. "     ~y~Colete:~w~ " .. GetPedArmour(Entity).. "     ~b~Nome:~w~ " .. fullName, 0.425)
            end
        end

        Wait(0)
    end
end)

CreateThread(function()
    StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM",false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM",false)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones",false,true)
    SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones",true,true)
    SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN",false)
    SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",false)
    StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    SetAudioFlag("PoliceScannerDisabled",true)
    SetAudioFlag("DisableFlightMusic",true)
    SetPlayerCanUseCover(PlayerId(),false)
    SetRandomEventFlag(false)
    SetDeepOceanScaler(0.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.teleportWay()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		Ped = GetVehiclePedIsUsing(Ped)
	end

	local Wayblip = GetFirstBlipInfoId(8)
	local Coordsblip = GetBlipCoords(Wayblip)
	if DoesBlipExist(Wayblip) then
		for Number = 1, 1000 do
			SetEntityCoordsNoOffset(Ped, Coordsblip["x"], Coordsblip["y"], Number + 0.0, 1, 0, 0)

			RequestCollisionAtCoord(Coordsblip["x"], Coordsblip["y"], Coordsblip["z"])
			while not HasCollisionLoadedAroundEntity(Ped) do
				Wait(1)
			end

			if GetGroundZFor_3dCoord(Coordsblip["x"], Coordsblip["y"], Number + 0.0) then
				break
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTLIMBO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.TeleportLimbo()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local _, Node = GetNthClosestVehicleNode(Coords["x"], Coords["y"], Coords["z"], 1, 0, 0, 0)

	SetEntityCoords(Ped, Node["x"], Node["y"], Node["z"] + 1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:CHANGEVEHICLESPEED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:ChangeVehicleSpeed")
AddEventHandler("admin:ChangeVehicleSpeed", function(Speed)
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)
		if GetPedInVehicleSeat(Vehicle, -1) == Ped then
			SetVehicleEnginePowerMultiplier(Vehicle, GetVehicleCheatPowerIncrease(Vehicle) * Speed)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:TYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:TyreBurst")
AddEventHandler("admin:TyreBurst", function(Tyre)
	if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
		SetVehicleTyreBurst(GetVehiclePedIsIn(PlayerPedId(), false), Tyre, true, 1000.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:LIGHTNINGTHUNDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:LightningThunder")
AddEventHandler("admin:LightningThunder", function(Value)
	for i=1, tonumber(Value) do
		CreateLightningThunder()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:Tuning")
AddEventHandler("admin:Tuning", function()
    local Ped = PlayerPedId()
    if IsPedInAnyVehicle(Ped) then
        local Vehicle = GetVehiclePedIsUsing(Ped)

        SetVehicleModKit(Vehicle, 0)
        SetVehicleMod(Vehicle, 11, GetNumVehicleMods(Vehicle, 11) - 1, false)
        SetVehicleMod(Vehicle, 12, GetNumVehicleMods(Vehicle, 12) - 1, false)
        SetVehicleMod(Vehicle, 13, GetNumVehicleMods(Vehicle, 13) - 1, false)
        SetVehicleMod(Vehicle, 15, GetNumVehicleMods(Vehicle, 15) - 1, false)
        ToggleVehicleMod(Vehicle, 18, true)
        SetVehicleColours(Vehicle, 12, 12) 
        SetVehicleExtraColours(Vehicle, 12, 12)
        SetVehicleWindowTint(Vehicle, 1)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:INITSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:initSpectate")
AddEventHandler("admin:initSpectate",function(source)
	if not NetworkIsInSpectatorMode() then
		local Pid = GetPlayerFromServerId(source)
		local Ped = GetPlayerPed(Pid)

		LocalPlayer["state"]["Spectate"] = true
		NetworkSetInSpectatorMode(true,Ped)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:resetSpectate")
AddEventHandler("admin:resetSpectate",function()
	if NetworkIsInSpectatorMode() then
		NetworkSetInSpectatorMode(false)
		LocalPlayer["state"]["Spectate"] = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NADANDO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local Ped = PlayerPedId()
        if IsPedSwimming(Ped) then
            vSERVER.Nadando()
        end
    end
end)
-------------------------------------------------------------------------------------------------------------------------------------
-- GETPOSTIONS
-------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetPostions()
	local Ped = PlayerPedId()
	local coords = GetEntityCoords(Ped)
	return coords
end
-------------------------------------------------------------------------------------------------------------------------------------
-- RGBCAR
-------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("rgbcar")
AddEventHandler("rgbcar",function()
    rgbColor()
end)

local r = 255
local g = 0
local b = 0
local rgbStatus = 1

function rgbColor()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
     if IsEntityAVehicle(vehicle) then      
        if rgbStatus == 1 then 
            g = g + 1  
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if g == 255 then 
                rgbStatus = 2
            end 
        elseif rgbStatus == 2 then 
            r = r - 1     
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if r < 130 then 
                b = b + 1
            end 
    
            if r == 0 then 
                rgbStatus = 3
            end 
        elseif rgbStatus == 3 then 
            b = b + 1  
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if b == 255 then 
                rgbStatus = 4
            end
        elseif rgbStatus == 4 then 
            g = g - 1    
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)        
            if g < 130 then 
                r = r + 1
            end
            if g == 0 then 
                rgbStatus = 5
            end
        elseif rgbStatus == 5 then 
            r = r + 1
            
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)  
            if r == 255 then 
                rgbStatus = 6
            end
        elseif rgbStatus == 6 then 
            b = b - 1
            SetVehicleModColor_1(vehicle,r,g,b)
            SetVehicleModColor_2(vehicle,r,g,b)
            SetVehicleCustomPrimaryColour(vehicle,r,g,b)
            SetVehicleCustomSecondaryColour(vehicle,r,g,b)
            SetVehicleNeonLightEnabled(vehicle,0,true)
            SetVehicleNeonLightEnabled(vehicle,1,true)
            SetVehicleNeonLightEnabled(vehicle,2,true)
            SetVehicleNeonLightEnabled(vehicle,3,true)
            SetVehicleNeonLightsColour(vehicle,r,g,b)  

            if b < 130 then 
                g = g + 1
            end 

            if b == 0 then 
                rgbStatus = 1
            end
        end  
        Citizen.Wait(4)
        rgbColor()
    end    
end
-------------------------------------------------------------------------------------------------------------------------------------
-- CR
-------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cr",function(source,args)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped,false)
    local speed = GetEntitySpeed(veh) * 3.6
    if GetPedInVehicleSeat(veh,-1) == ped and math.ceil(speed) >= 0 and GetEntityModel(veh) ~= -2076478498 and not IsEntityInAir(veh) then
        if args[1] == nil then
            SetEntityMaxSpeed(veh,GetVehicleHandlingFloat(veh,"CHandlingData","fInitialDriveMaxFlatVel"))
            TriggerEvent("Notify","sucesso","Cruiser desligado com sucesso.",5000)
        else
            SetEntityMaxSpeed(veh,(parseInt(args[1])/3.6))
            TriggerEvent("Notify","sucesso","Velocidade máxima travada em <b>"..args[1].." KM</b>.",5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEYMAR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Neymar(ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
	SetPedToRagdollWithFall(PlayerPedId(),1500,2000,0,ForwardVector,1.0,0.0,0.0,0.0,0.0,0.0,0.0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FLY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Fly()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped))

    SetEntityCoordsNoOffset(ped, x, y, z + 1000, true, true, true)
    GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false, true)
    SetPedParachuteTintIndex(PlayerPedId(), math.random(7))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Limparea(Coords)
	ClearAreaOfPeds(Coords["x"], Coords["y"], Coords["z"], 100.0, 0)
	ClearAreaOfCops(Coords["x"], Coords["y"], Coords["z"], 100.0, 0)
	ClearAreaOfObjects(Coords["x"], Coords["y"], Coords["z"], 100.0, 0)
	ClearAreaOfProjectiles(Coords["x"], Coords["y"], Coords["z"], 100.0, 0)
	ClearAreaOfVehicles(Coords["x"], Coords["y"], Coords["z"], 100.0, false, false, false, false, false)
	ClearAreaLeaveVehicleHealth(Coords["x"], Coords["y"], Coords["z"], 100.0, false, false, false, false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPLODIR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Explodir()
    local Ped = PlayerPedId()
    if Explodir then return end

    Explodir = true
    local Pos = GetEntityCoords(Ped)

    Citizen.CreateThread(function()
        SetEntityInvincible(Ped, true)
        Citizen.Wait(100)
        AddExplosion(Pos.x, Pos.y, Pos.z, 4, 1000.0, true, false, 1.0)
        Citizen.Wait(2000)
        SetEntityInvincible(Ped, false)

        Explodir = false
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOGO
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Fogo()
    local Ped = PlayerPedId()

    if not PegandoFogo then
        PegandoFogo = true
        Citizen.Wait(100)
        StartEntityFire(Ped)
        SetEntityInvincible(Ped, true)
        Citizen.Wait(10000)
        PegandoFogo = false
        StopEntityFire(Ped)
        SetEntityInvincible(Ped, false)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONGELAR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Congelar()
    local Ped = PlayerPedId()
    
    if not Congelar then
        Congelar = true
        FreezeEntityPosition(Ped, true)
        
        Citizen.CreateThread(function()
            Citizen.Wait(10000)
            FreezeEntityPosition(Ped, false)
            Congelar = false
        end)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FLASH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Flash()
	local Pid = PlayerId()
	if not Flash then
		TriggerEvent("Notify", "verde", "Super velocidade ativada.", 5000)
		SetRunSprintMultiplierForPlayer(Pid, 1.49)
		SetPedMoveRateOverride(Pid, 10.0)
		Flash = true
	else
		Flash = false
		SetRunSprintMultiplierForPlayer(Pid, 1.0)
		TriggerEvent("Notify", "amarelo", "Super velocidade desativada.", 5000)
	end
end
-------------------------------------------------------------------------------------------------------------------------------------
-- PULO
-------------------------------------------------------------------------------------------------------------------------------------
function Creative.Pulo()
    Pulo = not Pulo

    if Pulo then
        TriggerEvent("Notify", "verde", "Pulo ativado.", 5000)
    else
        TriggerEvent("Notify", "vermelho", "Pulo desativado.", 5000)
    end

    CreateThread(function()
        while Pulo do
            SetSuperJumpThisFrame(PlayerId())
            Wait(0)
        end
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Quake",nil,function(Name,Key,Value)
	ShakeGameplayCam("SKY_DIVING_SHAKE",1.0)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA DESENHAR TEXTO 3D (SEM FUNDO)
-----------------------------------------------------------------------------------------------------------------------------------------
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
    if onScreen then
        SetTextScale(0.35, 0.35) 
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    
    end
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local idle = 1000 
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, player in ipairs(GetActivePlayers()) do
            local otherPed = GetPlayerPed(player)
            
            if DoesEntityExist(otherPed) then
                local otherCoords = GetEntityCoords(otherPed)
                local distance = #(playerCoords - otherCoords)

                if distance < 20.0 then
                    local otherServerId = GetPlayerServerId(player)
                    
                    
                    local staffLabel = Player(otherServerId).state.StaffTime

                    
                    if staffLabel then
                        idle = 0 
                        
                        local headCoords = GetPedBoneCoords(otherPed, 31086)
                        
                  
                        DrawText3D(headCoords.x, headCoords.y, headCoords.z + 0.65, staffLabel)
                    end
                end
            end
        end

        Wait(idle)
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGICA THANOS - CLIENT SIDE (INVENCIBILIDADE REAL)
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local idle = 1000
       
        if LocalPlayer.state.ThanosActive then
            idle = 5
            
            
            SetEntityInvincible(PlayerPedId(), true)
            SetPlayerInvincible(PlayerId(), true)
            
        
            if GetEntityHealth(PlayerPedId()) < 400 then
                SetEntityHealth(PlayerPedId(), 400)
            end
        else

            if idle == 1000 then 
                SetEntityInvincible(PlayerPedId(), false)
                SetPlayerInvincible(PlayerId(), false)
            end
        end
        Wait(idle)
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- EFEITO VISUAL STAFF (CHOQUE/ELETRICIDADE)
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:StaffEffect")
AddEventHandler("admin:StaffEffect", function(targetSource)

    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSource))
    
    if DoesEntityExist(targetPed) then
        local coords = GetEntityCoords(targetPed)
    
        if not HasNamedPtfxAssetLoaded("core") then
            RequestNamedPtfxAsset("core")
            while not HasNamedPtfxAssetLoaded("core") do
                Wait(1)
            end
        end

        UseParticleFxAssetNextCall("core")
        StartParticleFxNonLoopedAtCoord("ent_dst_electrical", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 2.0, false, false, false)
        UseParticleFxAssetNextCall("core")
        StartParticleFxNonLoopedAtCoord("ent_dst_elec_fire_sp", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.5, false, false, false)
        PlaySoundFromCoord(-1, "Emp_Blast_One", coords.x, coords.y, coords.z, "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 0, 0, 0)
    end
end)