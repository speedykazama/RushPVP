-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Model = nil
local Entity = nil
local Blip = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKRATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckRation()
	if not Entity or not DoesEntityExist(Entity) then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Animals()
	return Entity, Model
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:RATION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Ration")
AddEventHandler("inventory:Ration", function(Coords)
    local Ped = PlayerPedId()
    local PlayerCoords = GetEntityCoords(Ped)
    local Heading = GetEntityHeading(Ped)

    Model = Animals[math.random(#Animals)]

    local Cooldown = 0
    local SpawnX, SpawnY, SpawnZ
    local HitZ, GroundZ
    local HitSafe, SafeCoords

    repeat
        Cooldown = Cooldown + 1
        SpawnX = PlayerCoords.x + math.random(-75, 75)
        SpawnY = PlayerCoords.y + math.random(-75, 75)
        HitZ, GroundZ = GetGroundZFor_3dCoord(SpawnX, SpawnY, PlayerCoords.z, true)
        HitSafe, SafeCoords = GetSafeCoordForPed(SpawnX, SpawnY, GroundZ, false, 16)
    until (HitZ and HitSafe) or Cooldown >= 100

    if HitZ and HitSafe then
        local Application, Network = vRPS.CreatePed("a_c_"..Model, SafeCoords.x, SafeCoords.y, SafeCoords.z, Heading, 28)
        if Application then
            SetTimeout(2500, function()
                Entity = LoadNetwork(Network)
                if Entity then
                    SetPedAlertness(Entity, 3)
                    SetPedPathAvoidFire(Entity, 1)
                    DisablePedPainAudio(Entity, true)
                    SetPedFleeAttributes(Entity, 0, 0)
                    SetPedPathCanUseLadders(Entity, 1)
                    SetPedSeeingRange(Entity, 10000.0)
                    SetPedHearingRange(Entity, 10000.0)
                    SetPedDiesWhenInjured(Entity, true)
                    SetPedPathCanUseClimbovers(Entity, 1)
                    SetPedPathCanDropFromHeight(Entity, 1)
                    SetPedCombatAttributes(Entity, 5, true)
                    SetPedCombatAttributes(Entity, 2, true)
                    SetPedCombatAttributes(Entity, 1, true)
                    SetPedCombatAttributes(Entity, 16, true)
                    SetPedCombatAttributes(Entity, 46, true)
                    SetPedCombatAttributes(Entity, 26, true)
                    SetPedCombatAttributes(Entity, 3, false)
                    SetCanAttackFriendly(Entity, false, true)
                    SetPedSuffersCriticalHits(Entity, false)
                    SetPedEnableWeaponBlocking(Entity, true)
                    SetPedDropsWeaponsWhenDead(Entity, false)
                    SetBlockingOfNonTemporaryEvents(Entity, true)
                    SetModelAsNoLongerNeeded(Model)

                    TaskWanderInArea(Entity, SafeCoords.x, SafeCoords.y, SafeCoords.z, 25.0, 0.0, 0.0)

                    Blip = AddBlipForEntity(Entity)
                    SetBlipSprite(Blip, 141)
                    SetBlipAsShortRange(Blip, true)

                    Citizen.CreateThread(function()
                        while DoesEntityExist(Entity) and not IsEntityDead(Entity) do
                            Citizen.Wait(1000)
                        end

                        if Blip then
                            RemoveBlip(Blip)
                            Blip = nil
                        end
                    end)
                end
            end)
        end
    end
end)