-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Name = nil
local Plate = nil
local Amounts = 1
local Selected = 1
local Active = false
local Vehicle = false
Travel = {}
Boosting = {}
Dismantle = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
exports("GeneratePlate",function()
	local Plate = ""

	repeat
		Plate = vRP.GenerateString("DDLLLDDD")
	until not Dismantle[Plate] and not Boosting[Plate]

	return Plate
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]:set("Dismantle", false, true)
LocalPlayer["state"]:set("DismantleModel", "", true)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BOOSTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:Boosting",function(Plate,Status)
	if not Boosting[Plate] then
		Boosting[Plate] = Status
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dismantle:Init")
AddEventHandler("dismantle:Init", function()
	if not Active then
		Experience = vSERVER.Experience("Dismantle")

		Plate = "DISM" .. (1000 + LocalPlayer["state"]["Passport"])

		local Level = ClassCategory(Experience)
		local RandLevels = math.random(Level)
		local Model = math.random(#Category[RandLevels])

		Selected = math.random(#Dismantles)
		Name = Category[RandLevels][Model]
		Active = true
		Amounts = 1

		if Level == 3 or Level == 4 then
			Amounts = 2
		elseif Level == 5 or Level == 6 then
			Amounts = 3
		elseif Level == 7 or Level == 8 then
			Amounts = 4
		elseif Level == 9 or Level == 10 then
			Amounts = 5
		end

		LocalPlayer["state"]:set("Dismantle", true, true)
		LocalPlayer["state"]:set("DismantleModel", Name, true)

		TriggerEvent("NotifyPush", { code = 20, title = "Localização Veículo", x = Dismantles[Selected]["x"], y = Dismantles[Selected]["y"], z = Dismantles[Selected]["z"], vehicle = VehicleName(Name), blipColor = 44 })
		TriggerEvent("Notify", "azul", "Contrato iniciado, espero que você consiga me ajudar com esse serviço, tome muito cuidado.",  10000)
		exports["target"]:LabelText("Dismantle", "Finalizar")
	else
		TriggerEvent("Notify", "amarelo", "Ainda preciso de seus serviços, então não vou poder finalizar seu contrato por enquanto.", 10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DismantleStatus()
	return Active
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:DISMANTLERESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:DismantleReset")
AddEventHandler("target:DismantleReset", function()
	Name = nil
	Amounts = 1
	Selected = 1
	Plate = nil
	Active = false
	Vehicle = false

	exports["target"]:LabelText("Dismantle", "Iniciar")

	LocalPlayer["state"]:set("Dismantle", false, true)
	LocalPlayer["state"]:set("DismantleModel", "", true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Active and not Vehicle then
			local Ped = PlayerPedId()
			if #(GetEntityCoords(Ped) - Dismantles[Selected]["xyz"]) <= 75 then
				Vehicle = vGARAGE.ServerVehicle(Name, Dismantles[Selected][1], Dismantles[Selected][2], Dismantles[Selected][3], Dismantles[Selected][4], Plate, 1000, nil, 1000)

				local OhterNetwork = NetToEnt(Vehicle)
				DecorSetInt(OhterNetwork, "Player_Vehicle", -1)
				SetVehRadioStation(OhterNetwork, "OFF")

				if NetworkDoesNetworkIdExist(Vehicle) then
					local Network = NetToEnt(Vehicle)
					if NetworkDoesNetworkIdExist(Network) then
						SetVehicleOnGroundProperly(Network)
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DISMAPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Dismapatch")
AddEventHandler("inventory:Dismapatch", function()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local Heading = GetEntityHeading(Ped)

	for Number = 1, Amounts do
		local Cooldown = 0
		local OtherPeds = math.random(#Peds)
		local SpawnX = Coords["x"] + math.random(-20, 20)
		local SpawnY = Coords["y"] + math.random(-20, 20)
		local HitZ, GroundZ = GetGroundZFor_3dCoord(SpawnX, SpawnY, Coords["z"], true)
		local HitSafe, SafeCoords = GetSafeCoordForPed(SpawnX, SpawnY, GroundZ, false, 16)

		repeat
			Cooldown = Cooldown + 1
			SpawnX = Coords["x"] + math.random(-20, 20)
			SpawnY = Coords["y"] + math.random(-20, 20)
			HitZ, GroundZ = GetGroundZFor_3dCoord(SpawnX, SpawnY, Coords["z"], true)
			HitSafe, SafeCoords = GetSafeCoordForPed(SpawnX, SpawnY, GroundZ, false, 16)
		until (HitZ and HitSafe) or Cooldown >= 100

		if HitZ and HitSafe then
			local Application, Network = vRPS.CreatePed(Peds[OtherPeds], SafeCoords["x"], SafeCoords["y"], SafeCoords["z"], Heading, 28)
			if Application then
				SetTimeout(1000, function()
					local Entity = LoadNetwork(Network)
					if Entity then
						SetPedArmour(Entity, 100)
						SetPedAccuracy(Entity, 75)
						SetPedAlertness(Entity, 3)
						SetPedAsEnemy(Entity, true)
						SetPedMaxHealth(Entity, 200)
						SetEntityHealth(Entity, 200)
						SetPedKeepTask(Entity, true)
						SetPedCombatRange(Entity, 1)
						StopPedSpeaking(Entity, true)
						SetPedCombatMovement(Entity, 2)
						DisablePedPainAudio(Entity, true)
						SetPedPathAvoidFire(Entity, true)
						SetPedConfigFlag(Entity, 208, true)
						SetPedSeeingRange(Entity, 10000.0)
						SetPedCanEvasiveDive(Entity, false)
						SetPedHearingRange(Entity, 10000.0)
						SetPedDiesWhenInjured(Entity, false)
						SetPedPathCanUseLadders(Entity, true)
						SetPedFleeAttributes(Entity, 0, false)
						SetPedCombatAttributes(Entity, 46, true)
						SetPedFiringPattern(Entity, 0xC6EE6B4C)
						SetCanAttackFriendly(Entity, true, false)
						SetPedSuffersCriticalHits(Entity, false)
						SetPedPathCanUseClimbovers(Entity, true)
						SetPedDropsWeaponsWhenDead(Entity, false)
						SetPedEnableWeaponBlocking(Entity, false)
						SetPedPathCanDropFromHeight(Entity, false)
						RegisterHatedTargetsAroundPed(Entity, 100.0)
						GiveWeaponToPed(Entity, "WEAPON_GOLFCLUB", -1, false, true)
						SetCurrentPedWeapon(Entity, "WEAPON_GOLFCLUB", true)
						SetPedInfiniteAmmo(Entity, true, "WEAPON_GOLFCLUB")
						SetPedRelationshipGroupHash(Entity, GetHashKey("HATES_PLAYER"))
						SetEntityCanBeDamagedByRelationshipGroup(Entity, false, "HATES_PLAYER")
						SetRelationshipBetweenGroups(5, GetHashKey("HATES_PLAYER"), GetHashKey("PLAYER"))
						SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("HATES_PLAYER"))
						TaskCombatPed(Entity, Ped, 0, 16)

						SetTimeout(1000, function()
							TaskWanderInArea(Entity, SafeCoords["x"], SafeCoords["y"], SafeCoords["z"], 25.0, 0.0, 0.0)
							SetModelAsNoLongerNeeded(Peds[OtherPeds])
						end)
					end
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DISMANTLEBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:DismantleBlips")
AddEventHandler("inventory:DismantleBlips", function(Coords)
	local Vehicle = AddBlipForCoord(Coords["x"], Coords["y"], Coords["z"])
	SetBlipSprite(Vehicle, 225)
	SetBlipDisplay(Vehicle, 4)
	SetBlipAsShortRange(Vehicle, true)
	SetBlipColour(Vehicle, 5)
	SetBlipScale(Vehicle, 1.0)
	SetBlipFlashes(Vehicle, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Veículo Procurado")
	EndTextCommandSetBlipName(Vehicle)

	SetTimeout(15000, function()
		if DoesBlipExist(Vehicle) then
			RemoveBlip(Vehicle)
		end
	end)
end)