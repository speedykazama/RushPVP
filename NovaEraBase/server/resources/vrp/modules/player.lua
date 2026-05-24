-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
local Global = {}
Objects = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("CharacterChosen", function(Passport, source)
    local Datatable = vRP.Datatable(Passport)
    local Identity = vRP.Identity(Passport)
    if Datatable and Identity then
        if Datatable["Pos"] then
            if not (Datatable["Pos"]["x"] and Datatable["Pos"]["y"] and Datatable["Pos"]["z"]) then
                Datatable["Pos"] = { x = SpawnCreatorCoords["x"], y = SpawnCreatorCoords["y"], z = SpawnCreatorCoords["z"] }
            end
        else
            Datatable["Pos"] = { x = SpawnCreatorCoords["x"], y = SpawnCreatorCoords["y"],  z = SpawnCreatorCoords["z"] }
        end

        if not Datatable["Skin"] then
            Datatable["Skin"] = "mp_m_freemode_01"
        end

        if not Datatable["Inventory"] then
            Datatable["Inventory"] = {}
        end

        if not Datatable["Health"] then
            Datatable["Health"] = 200
        end

        if not Datatable["Armour"] then
            Datatable["Armour"] = 0
        end

        if not Datatable["Weight"] then
            Datatable["Weight"] = BackpackWeightDefaultNormal
        end

        vRPC.Skin(source,Datatable["Skin"])
        vRP.SetArmour(source,Datatable["Armour"])
        vRPC.SetHealth(source,Datatable["Health"])
        vRP.Teleport(source,Datatable["Pos"]["x"],Datatable["Pos"]["y"],Datatable["Pos"]["z"])

        TriggerClientEvent("barbershop:Apply",source,vRP.UserData(Passport,"Barbershop"))
        TriggerClientEvent("skinshop:Apply",source,vRP.UserData(Passport,"Clothings"))
        TriggerClientEvent("tattooshop:Apply",source,vRP.UserData(Passport,"Tatuagens"))

        TriggerClientEvent("vRP:Active",source,Passport,Identity["name"].." "..Identity["name2"])
        
        Player(source)["state"]["Passport"] = Passport

		if GetResourceMetadata("vrp", "creator") == "yes" then
			if vRP.UserData(Passport, "Creator") == 1 then
				if Global[Passport] then
					TriggerClientEvent("spawn:justSpawn", source, false, false)
				else
					TriggerClientEvent("spawn:justSpawn", source, true, vec3(Datatable["Pos"]["x"], Datatable["Pos"]["y"], Datatable["Pos"]["z"]))
				end
			else
				vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Creator", dvalue = json.encode(1) })
				TriggerClientEvent("spawn:justSpawn", source, false, true)
			end
		elseif Global[Passport] then
			TriggerClientEvent("spawn:justSpawn", source, false, false)
		else
			TriggerClientEvent("spawn:justSpawn", source, true, vec3(Datatable["Pos"]["x"], Datatable["Pos"]["y"], Datatable["Pos"]["z"]))
		end

		TriggerEvent("Connect", Passport, source, Global[Passport] == nil)
		Global[Passport] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JUSTOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:justObjects")
AddEventHandler("vRP:justObjects",function()
    local source = source
    local Passport = vRP.Passport(source)
    local Inventory = vRP.Inventory(Passport)
    if Passport then
        for i = 1, 5 do
            if Inventory[tostring(i)] and "Armamento" == itemType(Inventory[tostring(i)]["item"]) then
                TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(i)]["item"])
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BACKPACKWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:BackpackWeight")
AddEventHandler("vRP:BackpackWeight",function(value)
    local source = source
    local Passport = vRP.Passport(source)
    local Datatable = vRP.Datatable(Passport)
    if Passport then
        if value then
            if not Global[Passport] then
                Datatable["Weight"] = Datatable["Weight"] + 50
                Global[Passport] = true
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DeleteObject")
AddEventHandler("DeleteObject",function(index,value)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if value and Objects[Passport] and Objects[Passport][value] then
            index = Objects[Passport][value]
            Objects[Passport][value] = nil
        end
    end
    TriggerEvent("DeleteObjectServer",index)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEOBJECTSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("DeleteObjectServer",function(entIndex)
    local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId(entIndex)
    if DoesEntityExist(NetworkGetEntityFromNetworkId) and not IsPedAPlayer(NetworkGetEntityFromNetworkId) and 3 == GetEntityType(NetworkGetEntityFromNetworkId) then
        DeleteEntity(NetworkGetEntityFromNetworkId)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("DeletePed")
AddEventHandler("DeletePed",function(entIndex)
    local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId(entIndex)
    if DoesEntityExist(NetworkGetEntityFromNetworkId) and not IsPedAPlayer(NetworkGetEntityFromNetworkId) and 1 == GetEntityType(NetworkGetEntityFromNetworkId) then
        DeleteEntity(NetworkGetEntityFromNetworkId)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("DebugObjects",function(value)
    if Objects[value] then
        for k,v in pairs(Objects[value]) do
            Objects[value][k] = nil
            TriggerEvent("DeleteObjectServer", k)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("DebugWeapons",function(value)
    if Objects[value] then
        for k,v in pairs(Objects[value]) do
            TriggerEvent("DeleteObjectServer", v)
            Objects[value] = nil
        end
        Objects[value] = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("gg", function(source)
    local source = source
    local Passport = vRP.Passport(source)
    
    if GetPlayerRoutingBucket(source) < 900000 and Passport and SURVIVAL.CheckDeath(source) then
        
        local Datatable = vRP.Datatable(Passport)
        local newWeight = BackpackWeightDefaultNormal
        
        if vRP.HasPermission(Passport, "PremiumPrata") then
            if ClearInventoryPremiumPrata then
                vRP.ClearInventory(Passport)
            end
            newWeight = BackpackWeightPremiumPrata
        elseif vRP.HasPermission(Passport, "PremiumOuro") then
            if ClearInventoryPremiumOuro then
                vRP.ClearInventory(Passport)
            end
            newWeight = BackpackWeightPremiumOuro
        elseif vRP.HasPermission(Passport, "PremiumPlatina") then
            if ClearInventoryPremiumPlatina then
                vRP.ClearInventory(Passport)
            end
            newWeight = BackpackWeightPremiumPlatina
        elseif CleanDeathInventory then
            vRP.ClearInventory(Passport)
        end
        
        if Datatable then
            Datatable.Weight = newWeight
        end

        TriggerEvent("Discord", "Airport", "**[Renasceu no Aeroporto]**\n\n**Passaporte:** " .. Passport .. "\n**IP:** " .. GetPlayerEndpoint(source) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
        
        SURVIVAL.Respawn(source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ClearInventory(Passport)
    local source = vRP.Source(Passport)
    local Datatable = vRP.Datatable(Passport)
    if source and Datatable and Datatable["Inventory"] then
        exports["inventory"]:CleanWeapons(parseInt(Passport),true)

        TriggerEvent("DebugObjects",parseInt(Passport))
        TriggerEvent("DebugWeapons",parseInt(Passport))

        Datatable["Inventory"] = {}
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER/THIRST/STRESS DESATIVADOS
-- Mantemos as funções como no-op para não quebrar chamadas existentes pelos resources.
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeThirst(Passport,Amount) end
function vRP.UpgradeHunger(Passport,Amount) end
function vRP.UpgradeStress(Passport,Amount) end
function vRP.DowngradeThirst(Passport,Amount) end
function vRP.DowngradeHunger(Passport,Amount) end
function vRP.DowngradeStress(Passport,Amount) end
function tvRP.Foods() end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetHealth(source)
    local GetPlayerPed = GetPlayerPed(source)
    return GetEntityHealth(GetPlayerPed)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODELPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ModelPlayer(source)
    local GetPlayerPed = GetPlayerPed(source)
    if GetEntityModel(GetPlayerPed) == GetHashKey("mp_f_freemode_01") then
        return "mp_f_freemode_01"
    elseif GetEntityModel(GetPlayerPed) == GetHashKey("mp_m_freemode_01") then
        return "mp_m_freemode_01"
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetExperience(Passport,Work)
    local Datatable = vRP.Datatable(Passport)
    if Datatable and not Datatable[Work] then
        Datatable[Work] = 0
    end
    return Datatable[Work] or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PutExperience(Passport,Work,Number)
    local Datatable = vRP.Datatable(Passport)
    if Datatable then
        if not Datatable[Work] then
            Datatable[Work] = 0
        end
        Datatable[Work] = Datatable[Work] + Number
        TriggerEvent("pause:AddPoints", Passport, Number)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetArmour(source,Amount)
    local GetPlayerPed = GetPlayerPed(source)
    if GetPedArmour(GetPlayerPed) + Amount > 100 then
        Amount = 100 - GetPedArmour(GetPlayerPed)
    end
    SetPedArmour(GetPlayerPed,GetPedArmour(GetPlayerPed) + Amount)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Teleport(source,x,y,z)
    local GetPlayerPed = GetPlayerPed(source)
    SetEntityCoords(GetPlayerPed, x + 1.0E-4, y + 1.0E-4, z + 1.0E-4, false, false, false, false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETENTITYCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetEntityCoords(source)
    local GetPlayerPed = GetPlayerPed(source)
    return GetEntityCoords(GetPlayerPed)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSIDEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InsideVehicle(source)
    local GetPlayerPed = GetPlayerPed(source)
    if 0 == GetVehiclePedIsIn(GetPlayerPed) or true then
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COSULTPROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ConsultPropertys(query, parameters)
    local rows = vRP.Query(query, parameters)
  
    if rows and rows[1] and rows[1].count then
      return rows[1].count
    else
      return 0
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("CleanVehicle")
AddEventHandler("CleanVehicle",function(entIndex)
	if DoesEntityExist(NetworkGetEntityFromNetworkId(entIndex)) and not IsPedAPlayer(NetworkGetEntityFromNetworkId(entIndex)) and 2 == GetEntityType(NetworkGetEntityFromNetworkId(entIndex)) then
		SetVehicleDirtLevel(NetworkGetEntityFromNetworkId(entIndex),0.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEPED
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.CreatePed(Model, X, Y, Z, Heading, Type)
	local Hash = GetHashKey(Model)
	local Create = CreatePed(Type, Hash, X, Y, Z, Heading, true, false)
	local Network = NetworkGetNetworkIdFromEntity(Create)
	while true do
		if DoesEntityExist(Create) then
			break
		end

		if not (0 <= 1000) then
			break
		end

		Wait(1)
	end

	if DoesEntityExist(Create) then
		return true, Network
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.CreateObject(Model,x,y,z,Weapon)
    local Passport = vRP.Passport(source)
    if Passport then
        local spawnObjects = 0
        local hash = GetHashKey(Model)
        local object = CreateObject(hash,x,y,z,true,true,false)

        while not DoesEntityExist(object) and spawnObjects <= 1000 do
            spawnObjects = spawnObjects + 1
            Wait(1)
        end
        local network = NetworkGetNetworkIdFromEntity(object)
        if DoesEntityExist(object) then
            if Weapon then
                if not Objects[Passport] then
                    Objects[Passport] = {}
                end
                Objects[Passport][Weapon] = network
            else
                if not Objects[Passport] then
                    Objects[Passport] = {}
                end
                Objects[Passport][network] = true
            end
            return true,network
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKETCLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:BucketClient")
AddEventHandler("vRP:BucketClient",function(value)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if value == "Enter" then
            Player(source)["state"]["Route"] = Passport
            SetPlayerRoutingBucket(source, Passport)
        else
            Player(source)["state"]["Route"] = 0
            SetPlayerRoutingBucket(source,0)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKETSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vRP:BucketServer")
AddEventHandler("vRP:BucketServer",function(source,value,bucket)
    if value == "Enter" then
        Player(source)["state"]["Route"] = bucket
        SetPlayerRoutingBucket(source,bucket)
        if bucket > 0 then
            SetRoutingBucketEntityLockdownMode(bucket,"inactive")
            SetRoutingBucketPopulationEnabled(bucket,false)
        end
    else
        Player(source)["state"]["Route"] = 0
        SetPlayerRoutingBucket(source,0)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSAVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    if AutoSave then
        while true do
            TriggerEvent("SaveServer")
            TriggerEvent("SaveServer2")

            if AutoSaveSilenced then
                print(AutoSaveMessage)
            end

            Wait(AutoSaveTime)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
    TriggerEvent("DebugObjects",Passport)
    TriggerEvent("DebugWeapons",Passport)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "vrp" == Resource then
        Wait(3000)
    end
end)