-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("inventory",Creative)
vGARAGE = Tunnel.getInterface("garages")
vSERVER = Tunnel.getInterface("inventory")
vPLAYER = Tunnel.getInterface("player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Drops = {}
local weaponTints = {}
local weaponSkins = {}
local Types = ""
local Weapon = ""
local UseSlots = 1
local Actived = false
local Backpack = false
local TakeWeapon = false
local StoreWeapon = false
local Reloaded = GetGameTimer()
local UseCooldown = GetGameTimer()
local Firecracker = GetGameTimer()
local DrugsTimer = GetGameTimer()
local StealTimer = GetGameTimer()
local CorPadrao = 0
local CorSalva = CorPadrao
local ComponentePadrao = 0
local ComponenteSalvo = ComponentePadrao
local Blips = {}
local scanTable = {}
local initSounds = {}
local DrugsPeds = {}
local StealPeds = {}
local SoundScanner = 999
local InitScanner = false
local Wheelchair = false
LocalPlayer["state"]["Buttons"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERKEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("openBackpack","Manusear a mochila.","keyboard","OEM_3")
RegisterKeyMapping("exit_wheelchair", "Sair da cadeira de rodas", "keyboard", "e")
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Cancel")
AddEventHandler("inventory:Cancel",function()
	vSERVER.Cancel()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:VERIFYOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:VerifyObjects")
AddEventHandler("inventory:VerifyObjects",function(Entity,Service)
	vSERVER.VerifyObjects(Entity,Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:LOOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Loot")
AddEventHandler("inventory:Loot",function(Entity,Service)
	vSERVER.Loot(Entity,Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STEALTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:StealTrunk")
AddEventHandler("inventory:StealTrunk",function(Entity)
	local DriverPed = GetPedInVehicleSeat(Entity[3], -1)
    if DriverPed ~= 0 and not IsPedAPlayer(DriverPed) then
		TriggerEvent("Notify", "amarelo", "Você não pode arrombar o porta malas com pessas dentro do veículo.", 5000)
		return
	end

	vSERVER.StealTrunk(Entity)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Animals")
AddEventHandler("inventory:Animals", function(Entity, Service)
    local netObjects = Entity[3]
    local entity = NetworkGetEntityFromNetworkId(netObjects)
    
    if DoesEntityExist(entity) and not IsEntityDead(entity) then
        TriggerEvent("Notify", "vermelho", "Você só pode esfolar animais mortos.",5000)
        return
    end

    vSERVER.Animals(Entity, Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STOREOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:StoreObjects")
AddEventHandler("inventory:StoreObjects",function(Number)
	vSERVER.StoreObjects(Number)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:MAKEPRODUCTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:MakeProducts")
AddEventHandler("inventory:MakeProducts",function(Service)
	vSERVER.MakeProducts(Service)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Dismantle")
AddEventHandler("inventory:Dismantle",function(Entity)
	vSERVER.Dismantle(Entity)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REMOVETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RemoveTyres")
AddEventHandler("inventory:RemoveTyres",function(Entity)
	vSERVER.RemoveTyres(Entity)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Weapons",function()
	return Weapon
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLEANWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:CleanWeapons")
AddEventHandler("inventory:CleanWeapons",function(Create)
	if Weapon ~= "" then
		if Create and UseSlots <= 5 then
			TriggerEvent("inventory:CreateWeapon",Weapon)
		end

		RemoveAllPedWeapons(PlayerPedId(),true)
	end

	TriggerEvent("hud:Weapon",false)
	TriggerEvent("Weapon","")
	Actived = false
	Weapon = ""
	Types = ""
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLOCKBUTTONS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if LocalPlayer["state"]["Buttons"] then
			TimeDistance = 1
			DisableControlAction(1,75,true)
			DisableControlAction(1,47,true)
			DisableControlAction(1,257,true)
			DisablePlayerFiring(Ped,true)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	if Backpack then
		Backpack = false
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "hideMenu" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function(Data,Callback)
	TriggerEvent("inventory:Close")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Craft",function(Data,Callback)
	Backpack = false
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })

	TriggerEvent("crafting:openSource")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Deliver",function(Data,Callback)
	vSERVER.Deliver(Data["slot"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Trash",function(Data,Callback)
	vSERVER.Trash(Data["slot"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:SLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Slot")
AddEventHandler("inventory:Slot",function(Number,Amount)
	UseSlots = parseInt(Number)
	vSERVER.UseItem(Number,Amount)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("useItem",function(Data,Callback)
	if GetGameTimer() >= UseCooldown then
		TriggerEvent("inventory:Slot",Data["slot"],Data["amount"])
		UseCooldown = GetGameTimer() + 1000
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sendItem",function(Data,Callback)
	vSERVER.SendItem(Data["slot"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(Data,Callback)
	vRPS.invUpdate(Data["slot"],Data["target"],Data["amount"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Update")
AddEventHandler("inventory:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:VERIFYWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:verifyWeapon")
AddEventHandler("inventory:verifyWeapon",function(Item)
	local Split = splitString(Item,"-")
	local Name = Split[1]

	if Weapon == Name then
		local Ped = PlayerPedId()
		local Ammo = GetAmmoInPedWeapon(Ped,Weapon)
		if not vSERVER.verifyWeapon(Weapon,Ammo) then
			TriggerEvent("inventory:CleanWeapons",false)
		end
	else
		if Weapon == "" then
			vSERVER.verifyWeapon(Name)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:PREVENTWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:preventWeapon")
AddEventHandler("inventory:preventWeapon",function()
	if Weapon ~= "" then
		local Ped = PlayerPedId()
		local Ammo = GetAmmoInPedWeapon(Ped,Weapon)

		TriggerEvent("inventory:CreateWeapon",Weapon)
		vSERVER.preventWeapon(Weapon,Ammo)
		TriggerEvent("hud:Weapon",false)
		RemoveAllPedWeapons(Ped,true)
		TriggerEvent("Weapon","")

		Actived = false
		Weapon = ""
		Types = ""
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("openBackpack",function()
	if not IsPauseMenuActive() and GetEntityHealth(PlayerPedId()) > 100 and not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not IsPlayerFreeAiming(PlayerId()) then
		Backpack = true
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "showMenu" })
		TriggerEvent("sounds:source","chest",0.7)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRENGINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairEngine")
AddEventHandler("inventory:repairEngine",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				local Tyres = {}

				for i = 0,7 do
					local Status = false

					if GetTyreHealth(Vehicle,i) ~= 1000.0 then
						Status = true
					end

					Tyres[i] = Status
				end

				local Fuel = GetVehicleFuelLevel(Vehicle)

				SetVehicleEngineHealth(Vehicle,1000.0)
				SetVehiclePetrolTankHealth(Vehicle,1000.0)

				SetVehicleFuelLevel(Vehicle,Fuel)

				for Tyre,Burst in pairs(Tyres) do
					if Burst then
						SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairVehicle")
AddEventHandler("inventory:repairVehicle",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				local vehTyres = {}

				for i = 0,7 do
					local Status = false

					if GetTyreHealth(Vehicle,i) ~= 1000.0 then
						Status = true
					end

					vehTyres[i] = Status
				end

				local Fuel = GetVehicleFuelLevel(Vehicle)

				SetVehicleFixed(Vehicle)
				SetVehicleDeformationFixed(Vehicle)

				SetVehicleFuelLevel(Vehicle,Fuel)

				for Tyre,Burst in pairs(vehTyres) do
					if Burst then
						SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REPAIRTYRE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairTyre")
AddEventHandler("inventory:repairTyre",function(Vehicle,Tyres,Plate)
	if NetworkDoesNetworkIdExist(Vehicle) then
		local Vehicle = NetToEnt(Vehicle)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				for i = 0,7 do
					if GetTyreHealth(Vehicle,i) ~= 1000.0 then
						SetVehicleTyreBurst(Vehicle,i,true,1000.0)
					end
				end

				SetVehicleTyreFixed(Vehicle,Tyres)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairPlayer")
AddEventHandler("inventory:repairPlayer",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleEngineHealth(Vehicle,1000.0)
				SetVehicleBodyHealth(Vehicle,1000.0)
				SetEntityHealth(Vehicle,1000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPAIRADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:repairAdmin")
AddEventHandler("inventory:repairAdmin",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				local Fuel = GetVehicleFuelLevel(Vehicle)

				SetVehicleFixed(Vehicle)
				SetVehicleDeformationFixed(Vehicle)

				SetVehicleFuelLevel(Vehicle,Fuel)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEALARM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:vehicleAlarm")
AddEventHandler("inventory:vehicleAlarm",function(Index,Plate)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleAlarm(Vehicle,true)
				StartVehicleAlarm(Vehicle)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTIITYCOORDSZ
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.EntityCoordsZ()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local _,GroundZ = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

	return vec3(Coords["x"],Coords["y"],GroundZ)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARACHUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Parachute()
    local Ped = PlayerPedId()
    GiveWeaponToPed(Ped, "GADGET_PARACHUTE", 1, false, true)
    SetPedParachuteTintIndex(Ped, math.random(7))

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            if IsPedInParachuteFreeFall(Ped) then
                TriggerServerEvent("Inventory:Parachute")
                break
            end
        end
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHINGCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Fishing()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	if #(Coords - Fishings) <= FishingsMaxDistance then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FISHINGANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.fishingAnim()
	local Ped = PlayerPedId()
	if IsEntityPlayingAnim(Ped,"amb@world_human_stand_fishing@idle_a","idle_c",3) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALANIM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.animalAnim()
	local Ped = PlayerPedId()
	if IsEntityPlayingAnim(Ped,"anim@gangops@facility@servers@bodysearch@","player_search",3) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.returnWeapon()
	if Weapon ~= "" then
		return Weapon
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkWeapon(Hash)
	if Weapon == Hash then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkAttachs(nameItem,nameWeapon)
	return weaponAttachs[nameItem][nameWeapon]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.putAttachs(nameItem,nameWeapon)
	GiveWeaponComponentToPed(PlayerPedId(),nameWeapon,weaponAttachs[nameItem][nameWeapon])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONPOLICEBLOCKED
-----------------------------------------------------------------------------------------------------------------------------------------
function WeaponPoliceBlocked(weaponName)
    for _, WeaponsPoliceBlock in ipairs(WeaponsPoliceBlock) do
        if weaponName == WeaponsPoliceBlock then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONVIPBLOCKED
-----------------------------------------------------------------------------------------------------------------------------------------
function WeaponVipBlocked(weaponName)
    for _, WeaponsVip in ipairs(WeaponsVip) do
        if weaponName == WeaponsVip then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONARMAPORTEBLOCKED
-----------------------------------------------------------------------------------------------------------------------------------------
function WeaponArmaPorteBlocked(weaponName)
    for _, WeaponsArmaPorteBlock in ipairs(WeaponsArmaPorteBlock) do
        if weaponName == WeaponsArmaPorteBlock then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PUTWEAPONHANDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.putWeaponHands(Name, Ammo, Components, Type)
    local source = source
    local Ped = PlayerPedId()

    if BloquearArmaPolice and WeaponPoliceBlocked(Name) and not vSERVER.WeaponPolice(source) then
        return false
    end

    if BloquearArmaVip and WeaponVipBlocked(Name) and not vSERVER.WeaponVip(source) then
        return false
    end

	if BloquearArmaPorte and WeaponArmaPorteBlocked(Name) and not vSERVER.WeaponArmaPorte(source) then
        return false
    end
	
    if not TakeWeapon then
        if not Ammo then
            Ammo = 0
        end

        if Ammo > 0 then
            Actived = true
        end

        TakeWeapon = true
        LocalPlayer["state"]:set("Cancel", true, true)

        RemoveAllPedWeapons(Ped, true)

        if not IsPedInAnyVehicle(Ped) then
            if LoadAnim("reaction@intimidation@1h") then
                TaskPlayAnim(Ped, "reaction@intimidation@1h", "intro", 8.0, 8.0, -1, 48, 1, 0, 0, 0)
            end

            Wait(1250)

            Weapon = Name
            TriggerEvent("Weapon", Name)
            TriggerEvent("inventory:RemoveWeapon", Name)
            GiveWeaponToPed(Ped, Name, Ammo, false, true)

            Wait(300)

            ClearPedTasks(Ped)
        else
            Weapon = Name
            TriggerEvent("Weapon", Name)
            TriggerEvent("inventory:RemoveWeapon", Name)
            GiveWeaponToPed(Ped, Name, Ammo, false, true)
        end

        if Components then
            for nameItem, _ in pairs(Components) do
                Creative.putAttachs(nameItem, Name)
				PintarArmaComCorSalva()
				AplicarComponenteSalvo()
            end
        end

        if Type then
            Types = Type
        end

		local tintIndex = weaponTints[GetHashKey(Name)]
        if tintIndex then
            SetPedWeaponTintIndex(Ped, GetHashKey(Name), tintIndex)
        end

        local savedSkin = weaponSkins[GetHashKey(Name)]
        if savedSkin then
            GiveWeaponComponentToPed(Ped, GetHashKey(Name), savedSkin)
        end

        TakeWeapon = false
        LocalPlayer["state"]:set("Cancel", false, true)

        if itemAmmo(Name) then
            TriggerEvent("hud:Weapon", true, Name)
        end

        if vSERVER.dropWeapons(Name) then
            TriggerEvent("inventory:CleanWeapons", true)
        end

        return true
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALVARCORESCOLHIDA
-----------------------------------------------------------------------------------------------------------------------------------------
function SalvarCorEscolhida(Tinta)
    corSalva = Tinta
    TriggerEvent('Notify', 'verde', 'Cor da arma salva com sucesso.', 5000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGARCORSALVA
-----------------------------------------------------------------------------------------------------------------------------------------
function PegarCorSalva()
    return corSalva
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PINTARARMACOMCORSALVA
-----------------------------------------------------------------------------------------------------------------------------------------
function PintarArmaComCorSalva()
    local Ped = PlayerPedId()
    local CorSalva = PegarCorSalva()
    SetPedWeaponTintIndex(Ped, GetSelectedPedWeapon(Ped), corSalva)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cor", function(source, Message)
    local Ped = PlayerPedId()
    local Tinta = tonumber(Message[1])

    if vPLAYER.CheckVip('ambos') or vPLAYER.CheckBooster() then
        if Tinta and Tinta >= 0 then
            SalvarCorEscolhida(Tinta)
            SetPedWeaponTintIndex(Ped, GetSelectedPedWeapon(Ped), Tinta)
            TriggerEvent('Notify', 'verde', 'Você pintou sua arma com a Tinta ' .. Tinta .. '.', 5000)
        else
            TriggerEvent('Notify', 'vermelho', 'Você precisa especificar uma pintura válida.', 5000)
        end
    else
        TriggerEvent('Notify', 'vermelho', 'Somente membros <b>VIP</b> e <b>Booster</b> conseguem fazer pinturas.', 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATETHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local Ped = PlayerPedId()
        if IsPedArmed(Ped, 6) then
            PintarArmaComCorSalva()
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALVARCOMPONENTEESCOLHIDO
-----------------------------------------------------------------------------------------------------------------------------------------
function SalvarComponenteEscolhido(componente)
    ComponenteSalvo = componente
    TriggerEvent('Notify', 'verde', 'Componente da arma salvo com sucesso.', 5000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGARCOMPONENTESALVO
-----------------------------------------------------------------------------------------------------------------------------------------
function PegarComponenteSalvo()
    return ComponenteSalvo
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APLICARCOMPONENTESALVO
-----------------------------------------------------------------------------------------------------------------------------------------
function AplicarComponenteSalvo()
    local ped = PlayerPedId()
    local componenteSalvo = PegarComponenteSalvo()
    local arma = GetSelectedPedWeapon(ped)
    if componenteSalvo ~= ComponentePadrao then
        GiveWeaponComponentToPed(ped, arma, componenteSalvo)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTACHS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("attachs", function(source, args)
    local ped = PlayerPedId()
    local arma = GetSelectedPedWeapon(ped)
    local tipo = args[1] and string.lower(args[1]) or nil

    if not tipo or not WeaponsAttachments[tipo] then
        TriggerEvent('Notify', 'amarelo', 'Você deve especificar o componente que deseja equipar.\n\n/attachs <componente>. Componentes:\n- lan (lanterna)\n- mira (mira)\n- emp (empunhadura)\n- todos (Todos os acima)', 5000)
        return
    end

    for armaNome, componentes in pairs(WeaponsAttachments[tipo]) do
        if arma == GetHashKey(armaNome) then
            if type(componentes) == "string" then
                local compHash = GetHashKey(componentes)
                GiveWeaponComponentToPed(ped, arma, compHash)
                SalvarComponenteEscolhido(compHash)
                TriggerEvent('Notify', 'verde', 'Você equipou o componente.', 5000)
            elseif type(componentes) == "table" then
                for _, compName in ipairs(componentes) do
                    local compHash = GetHashKey(compName)
                    GiveWeaponComponentToPed(ped, arma, compHash)
                end
                if componentes[1] then
                    SalvarComponenteEscolhido(GetHashKey(componentes[1]))
                end
                TriggerEvent('Notify', 'verde', 'Você equipou todos os componentes.', 5000)
            end
            return
        end
    end

    TriggerEvent('Notify', 'vermelho', 'Nenhum componente encontrado para esta arma.', 5000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATETHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            AplicarComponenteSalvo()
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREWEAPONHANDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.storeWeaponHands()
	if not StoreWeapon then
		StoreWeapon = true

		local Last = Weapon
		local Ped = PlayerPedId()
		LocalPlayer["state"]:set("Cancel",true,true)

		if not IsPedInAnyVehicle(Ped) then
			if LoadAnim("reaction@intimidation@1h") then
				TaskPlayAnim(Ped, "reaction@intimidation@1h", "outro", 8.0, 8.0, -1, 48, 1, 0, 0, 0)
			end

			Wait(1600)

			ClearPedTasks(Ped)
		end

		local Ammos = GetAmmoInPedWeapon(Ped,Weapon)

		StoreWeapon = false
		TriggerEvent("inventory:CleanWeapons",true)
		LocalPlayer["state"]:set("Cancel",false,true)

		return true,Ammos,Last
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGECHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.rechargeCheck(ammoType)
	local weaponAmmo = 0
	local weaponHash = nil
	local Ped = PlayerPedId()
	local weaponStatus = false

	if weaponAmmos[ammoType] then
		weaponAmmo = GetAmmoInPedWeapon(Ped,Weapon)

		for _,v in pairs(weaponAmmos[ammoType]) do
			if Weapon == v then
				weaponHash = Weapon
				weaponStatus = true
				break
			end
		end
	end

	return weaponStatus,weaponHash,weaponAmmo
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECHARGEWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.rechargeWeapon(Hash,Ammo)
	AddAmmoToPed(PlayerPedId(),Hash,Ammo)
	Actived = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTOREWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Actived and Weapon ~= "" then
			TimeDistance = 10

			local Ped = PlayerPedId()
			local Ammo = GetAmmoInPedWeapon(Ped,Weapon)

			if GetGameTimer() >= Reloaded and IsPedReloading(Ped) then
				vSERVER.preventWeapon(Weapon,Ammo)
				Reloaded = GetGameTimer() + 100
			end

			if Ammo <= 0 or (Weapon == "WEAPON_PETROLCAN" and Ammo <= 135 and IsPedShooting(Ped)) or IsPedSwimming(Ped) then
				if Types ~= "" then
					vSERVER.removeThrowing(Types)
				else
					vSERVER.preventWeapon(Weapon,Ammo)
				end

				TriggerEvent("inventory:CleanWeapons",true)
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKCRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkCracker()
	if GetGameTimer() <= Firecracker then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Firecracker")
AddEventHandler("inventory:Firecracker",function()
	if LoadPtfxAsset("scr_indep_fireworks") then
		Firecracker = GetGameTimer() + (5 * 60000)

		local Explosive = 25
		local Ped = PlayerPedId()
		local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,0.6,0.0)
		local Progression,Network = vRPS.CreateObject("ind_prop_firework_03",Coords["x"],Coords["y"],Coords["z"])
		if Progression then
			local Entity = LoadNetwork(Network)
			FreezeEntityPosition(Entity,true)
			PlaceObjectOnGroundProperly(Entity)
			SetModelAsNoLongerNeeded("ind_prop_firework_03")

			Wait(8000)

			repeat
				Wait(2000)
				Explosive = Explosive - 1
				UseParticleFxAssetNextCall("scr_indep_fireworks")
				StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst",Coords["x"],Coords["y"],Coords["z"],0.0,0.0,0.0,2.5,false,false,false,false)
			until Explosive <= 0

			TriggerServerEvent("DeleteObject",Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINTVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:paintVehicle")
AddEventHandler("inventory:paintVehicle", function(Index, Plate, Color)
	if NetworkDoesNetworkIdExist(Index) then
		local Vehicle = NetToEnt(Index)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleColours(Vehicle, Color, Color)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWATER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkWater()
	return IsPedSwimming(PlayerPedId())
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("dropItem",function(Data,Callback)
	if not TakeWeapon and not StoreWeapon then
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local _,Z = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

		vSERVER.Drops(Data["item"],Data["slot"],Data["amount"],Coords["x"],Coords["y"],Z)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Table")
AddEventHandler("drops:Table",function(Table)
	Drops = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:ADICIONAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Adicionar")
AddEventHandler("drops:Adicionar",function(Number,Table)
	Drops[Number] = Table
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Remover")
AddEventHandler("drops:Remover",function(Number)
	if Drops[Number] then
		Drops[Number] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS:ATUALIZAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("drops:Atualizar")
AddEventHandler("drops:Atualizar",function(Number,Amount)
	if Drops[Number] then
		Drops[Number]["amount"] = Amount
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPSREMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:DropsRemover")
AddEventHandler("inventory:DropsRemover",function(Route,Number)
	if Drops[Route] and Drops[Route][Number] then
		Drops[Route][Number] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPSATUALIZAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:DropsAtualizar")
AddEventHandler("inventory:DropsAtualizar",function(Route,Number,Amount)
	if Drops[Route] and Drops[Route][Number] then
		Drops[Route][Number]["Amount"] = Amount
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDROPBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			for _,v in pairs(Drops) do
				local Distance = #(Coords - vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]))
				if Distance <= 50 then
					TimeDistance = 1
					DrawMarker(21,v["Coords"][1],v["Coords"][2],v["Coords"][3] + 0.25,0.0,0.0,0.0,0.0,180.0,0.0,0.25,0.35,0.25,52,152,235,500,1,1,1,1)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestInventory",function(Data,Callback)
	local Items = {}

	if LocalPlayer["state"]["Route"] < 900000 then
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local _,Z = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])

		for Index,v in pairs(Drops) do
			local Distance = #(vec3(Coords["x"],Coords["y"],Z) - vec3(v["Coords"][1],v["Coords"][2],v["Coords"][3]))
			if Distance <= 0.9 then
				local Number = #Items + 1

				Items[Number] = v
				Items[Number]["id"] = Index
			end
		end
	end

	local inventario,invPeso,invMaxpeso = vSERVER.requestInventory()
	if inventario then
		Callback({ inventario = inventario, drop = Items, invPeso = invPeso, invMaxpeso = invMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("pickupItem",function(Data,Callback)
	vSERVER.Pickup(Data["id"],Data["amount"],Data["target"])

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHEELCHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.wheelChair(Plate)
	local Ped = PlayerPedId()
	local heading = GetEntityHeading(Ped)
	local Coords = GetOffsetFromEntityInWorldCoords(Ped,0.0,0.75,0.0)
	local myVehicle = vGARAGE.ServerVehicle("wheelchair",Coords["x"],Coords["y"],Coords["z"],heading,Plate,0,nil,1000)

	if NetworkDoesNetworkIdExist(myVehicle) then
		local vehicleNet = NetToEnt(myVehicle)
		if NetworkDoesNetworkIdExist(vehicleNet) then
			SetVehicleOnGroundProperly(vehicleNet)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WHEELCHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("exit_wheelchair", function()
    local Ped = PlayerPedId()
    local Vehicle = GetVehiclePedIsUsing(Ped)

    if Wheelchair then
        DeleteEntity(Vehicle)
        TaskLeaveVehicle(Ped, Vehicle, 0)
        Wheelchair = false
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATETHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local Ped = PlayerPedId()
        if IsPedInAnyVehicle(Ped) then
            local Vehicle = GetVehiclePedIsUsing(Ped)
            local Model = GetEntityModel(Vehicle)
            if Model == -1178021069 then
                if not IsEntityPlayingAnim(Ped,"missfinale_c2leadinoutfin_c_int","_leadin_loop2_lester",3) then
                    vRP.playAnim(true,{"missfinale_c2leadinoutfin_c_int","_leadin_loop2_lester"},true)
                    Wheelchair = true
                end
            end
        else
            if Wheelchair then
                vRP.removeObjects("one")
                Wheelchair = false
            end
        end

        Wait(1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:UPDATESCANNER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:updateScanner")
AddEventHandler("inventory:updateScanner",function(Status)
	InitScanner = Status
	SoundScanner = 999
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSCANNER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if InitScanner then
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				local Coords = GetEntityCoords(Ped)

				for k,v in pairs(scanTable) do
					local Distance = #(Coords - vec3(v[1],v[2],v[3]))
					if Distance <= 7.25 then
						SoundScanner = 1000

						if not initSounds[k] then
							initSounds[k] = true
						end

						if Distance <= 1.25 then
							TimeDistance = 1
							SoundScanner = 250

							if IsControlJustPressed(1,38) then
								TriggerEvent("inventory:MakeProducts","scanner")

								local rand = math.random(#scanCoords)
								scanTable[k] = scanCoords[rand]
								initSounds[k] = nil
								SoundScanner = 999
							end
						end
					else
						if initSounds[k] then
							initSounds[k] = nil
							SoundScanner = 999
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSCANNERSOUND
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if InitScanner and (SoundScanner == 1000 or SoundScanner == 250) then
			PlaySoundFrontend(-1,"MP_IDLE_TIMER","HUD_FRONTEND_DEFAULT_SOUNDSET")
		end

		Wait(SoundScanner)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:SCANNERBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:ScannerBlips")
AddEventHandler("inventory:ScannerBlips", function()
	if json.encode(Blips) ~= "[]" then
		for _, v in pairs(Blips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end

		Blips = {}

		TriggerEvent("Notify", "amarelo", "Marcações desativadas.",5000)
	else
		for k, v in pairs(scanCoords) do
			Blips[k] = AddBlipForCoord(v[1], v[2], v[3])
			SetBlipSprite(Blips[k], 119)
			SetBlipDisplay(Blips[k], 4)
			SetBlipAsShortRange(Blips[k], true)
			SetBlipColour(Blips[k], 41)
			SetBlipScale(Blips[k], 0.3)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Tesouro")
			EndTextCommandSetBlipName(Blips[k])
		end

		TriggerEvent("Notify", "verde", "Marcações ativadas.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:EXPLODETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:explodeTyres")
AddEventHandler("inventory:explodeTyres",function(Network,Plate,Tyre)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRESTATUS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.tyreStatus()
	local Ped = PlayerPedId()
	if not IsPedInAnyVehicle(Ped) then
		local Vehicle = vRP.ClosestVehicle(7)
		if IsEntityAVehicle(Vehicle) then
			local Coords = GetEntityCoords(Ped)

			for Index,Tyre in pairs(TyreList) do
				local Selected = GetEntityBoneIndexByName(Vehicle,Index)
				if Selected ~= -1 then
					local CoordsWheel = GetWorldPositionOfEntityBone(Vehicle,Selected)
					local Distance = #(Coords - CoordsWheel)
					if Distance <= 1.0 then
						return true,Tyre,VehToNet(Vehicle),GetVehicleNumberPlateText(Vehicle)
					end
				end
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREHEALTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.tyreHealth(Network,Tyre)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			return GetTyreHealth(Vehicle,Tyre)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOESOBJECTEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.objectExist(Coords,Hash)
	return DoesObjectOfTypeExistAtCoords(Coords["x"],Coords["y"],Coords["z"],0.35,Hash,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTERIOR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckInterior()
	local Ped = PlayerPedId()
	return GetInteriorFromEntity(Ped) ~= 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKATM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkAtm(Coords)
	local BombZone = false
	local AtmSelected = false

	for Number,v in pairs(ATMList) do
		local Distance = #(vec3(Coords["x"],Coords["y"],Coords["z"]) - vec3(v[1],v[2],v[3]))
		if Distance <= 1.0 then
			BombZone = vec3(v[1],v[2],v[3] - 1)
			AtmSelected = Number
			break
		end
	end

	return BombZone,AtmSelected
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTEALNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if not IsPedInAnyVehicle(Ped) and IsPedArmed(Ped,7) then
			local Handler,Selected = FindFirstPed()

			repeat
				if not IsEntityDead(Selected) and not StealPeds[Selected] and not DrugsPeds[Selected] and not IsPedDeadOrDying(Selected) and GetPedArmour(Selected) <= 0 and not IsPedAPlayer(Selected) and not IsPedInAnyVehicle(Selected) and GetPedType(Selected) ~= 28 then
					local Coords = GetEntityCoords(Ped)
					local pCoords = GetEntityCoords(Selected)
					local Distance = #(Coords - pCoords)

					if Distance <= 5 then
						TimeDistance = 100

						local Pid = PlayerId()
						if Distance <= 2 and (IsPedInMeleeCombat(Ped) or IsPlayerFreeAiming(Pid)) then
							ClearPedTasks(Selected)
							ClearPedSecondaryTask(Selected)
							ClearPedTasksImmediately(Selected)

							TaskSetBlockingOfNonTemporaryEvents(Selected,true)
							SetBlockingOfNonTemporaryEvents(Selected,true)
							SetEntityAsMissionEntity(Selected,true,true)
							SetPedDropsWeaponsWhenDead(Selected,false)
							TaskTurnPedToFaceEntity(Selected,Ped,3.0)
							SetPedSuffersCriticalHits(Selected,false)
							StealPeds[Selected] = true

							local randomMessage = GetMessagesRobberys()
							DrawText3D(pCoords.x, pCoords.y, pCoords.z + 1.0, randomMessage)

							local SelectedRobbery = 500
							LocalPlayer["state"]["Buttons"] = true
							LocalPlayer["state"]["Commands"] = true

							if math.random(100) >= 75 then
								vSERVER.CallPolice()

								LocalPlayer["state"]["Buttons"] = false
								LocalPlayer["state"]["Commands"] = false

								SetPedArmour(Selected,99)
								SetPedAccuracy(Selected,100)
								SetPedRelationshipGroupHash(Selected,GetHashKey("HATES_PLAYER"))
								SetPedKeepTask(Selected,true)
								SetCanAttackFriendly(Selected,false,true)
								TaskCombatPed(Selected,Ped,0,16)
								SetPedCombatAttributes(Selected,46,true)
								SetPedCombatAbility(Selected,0)
								SetPedCombatAttributes(Selected,0,true)
								SetPedDropsWeaponsWhenDead(Selected,false)
								SetPedCombatRange(Selected,2)
								SetPedFleeAttributes(Selected,0,0)
								SetPedConfigFlag(Selected,58,true)
								SetPedConfigFlag(Selected,75,true)
								SetPedFiringPattern(Selected,-957453492)
								SetBlockingOfNonTemporaryEvents(Selected,true)

								SetModelAsNoLongerNeeded(GetEntityModel(Selected))

								SetTimeout(60000,function()
									ClearPedTasks(Selected)
									TaskWanderStandard(Selected,10.0,10)
									TaskReactAndFleePed(Selected,Ped)
									SetPedKeepTask(Selected,true)
								end)
							else
								if LoadAnim("random@mugging3") then
									TaskPlayAnim(Selected,"random@mugging3","handsup_standing_base",8.0,8.0,-1,16,0,0,0,0)
								end

								while true do
									local Coords = GetEntityCoords(Ped)
									local pCoords = GetEntityCoords(Selected)
									local Distance = #(Coords - pCoords)

									DrawText3D(pCoords.x, pCoords.y, pCoords.z + 1.0, randomMessage)

									if Distance <= 2 and (IsPedInMeleeCombat(Ped) or IsPlayerFreeAiming(Pid)) then
										SelectedRobbery = SelectedRobbery - 1

										if not IsEntityPlayingAnim(Selected,"random@mugging3","handsup_standing_base",3) then
											TaskPlayAnim(Selected,"random@mugging3","handsup_standing_base",8.0,8.0,-1,16,0,0,0,0)
										end

										if SelectedRobbery <= 0 then
											if LoadModel("prop_paper_bag_small") then
												local Object = CreateObject("prop_paper_bag_small",Coords["x"],Coords["y"],Coords["z"],false,false,false)
												AttachEntityToEntity(Object,Selected,GetPedBoneIndex(Selected,28422),0.0,-0.05,0.05,180.0,0.0,0.0,false,false,false,false,2,true)

												if LoadAnim("mp_safehouselost@") then
													TaskPlayAnim(Selected,"mp_safehouselost@","package_dropoff",8.0,8.0,-1,16,0,0,0,0)
												end

												Wait(3000)

												if DoesEntityExist(Object) then
													DeleteEntity(Object)
												end

												vSERVER.StealPeds(Selected)
												ClearPedSecondaryTask(Selected)
												TaskWanderStandard(Selected,10.0,10)

												LocalPlayer["state"]["Buttons"] = false
												LocalPlayer["state"]["Commands"] = false

												break
											end
										end
									else
										ClearPedSecondaryTask(Selected)
										TaskWanderStandard(Selected,10.0,10)

										LocalPlayer["state"]["Buttons"] = false
										LocalPlayer["state"]["Commands"] = false

										break
									end

									Wait(1)
								end
							end
						end
					end
				end

				Success,Selected = FindNextPed(Handler)
			until not Success EndFindPed(Handler)
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMESSAGESROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetMessagesRobberys()
    local randomIndex = math.random(1, #MessagesRoubos)
    return MessagesRoubos[randomIndex]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckMods(Vehicle,Mod)
	return GetNumVehicleMods(Vehicle,Mod) - 1
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKCAR
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckCar(Vehicle)
	local Model = GetEntityModel(Vehicle)
	return IsThisModelACar(Model)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVEMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ActiveMods(Vehicle,Plate,Mod,Number)
	if NetworkDoesNetworkIdExist(Vehicle) then
		local Vehicle = NetToEnt(Vehicle)
		if DoesEntityExist(Vehicle) then
			if GetVehicleNumberPlateText(Vehicle) == Plate then
				SetVehicleMod(Vehicle,Mod,Number)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TINTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tints",function()
	if not IsPauseMenuActive() then
		if IsPedArmed(GetPlayerPed(-1), 7) and IsPedArmed(GetPlayerPed(-1), 4) then
			if LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and MumbleIsConnected() then
				if LocalPlayer["state"]["Premium"] then
					exports["dynamic"]:AddButton("Padrão","Clique alterar seu armamento.","inventory:ChooseTint",0,false,false)

					if CheckNormal(Weapon) then
						exports["dynamic"]:SubMenu("Normais","Para armas <b>Normais</b>.","Normal")
						exports["dynamic"]:AddButton("Green","Clique alterar seu armamento.","inventory:ChooseTint",1,"Normal",false)
						exports["dynamic"]:AddButton("Gold","Clique alterar seu armamento.","inventory:ChooseTint",2,"Normal",false)
						exports["dynamic"]:AddButton("Pink","Clique alterar seu armamento.","inventory:ChooseTint",3,"Normal",false)
						exports["dynamic"]:AddButton("Army","Clique alterar seu armamento.","inventory:ChooseTint",4,"Normal",false)
						exports["dynamic"]:AddButton("LSPD","Clique alterar seu armamento.","inventory:ChooseTint",5,"Normal",false)
						exports["dynamic"]:AddButton("Orange","Clique alterar seu armamento.","inventory:ChooseTint",6,"Normal",false)
						exports["dynamic"]:AddButton("Platinum","Clique alterar seu armamento.","inventory:ChooseTint",7,"Normal",false)
					elseif CheckSpecial(Weapon) then
						exports["dynamic"]:SubMenu("Especiais","Para armas <b>MK2</b>.","MK2")
						exports["dynamic"]:AddButton("Classic Gray","Clique alterar seu armamento.","inventory:ChooseTint",1,"MK2",false)
						exports["dynamic"]:AddButton("Classic Two-Tone","Clique alterar seu armamento.","inventory:ChooseTint",2,"MK2",false)
						exports["dynamic"]:AddButton("Classic White","Clique alterar seu armamento.","inventory:ChooseTint",3,"MK2",false)
						exports["dynamic"]:AddButton("Classic Beige","Clique alterar seu armamento.","inventory:ChooseTint",4,"MK2",false)
						exports["dynamic"]:AddButton("Classic Green","Clique alterar seu armamento.","inventory:ChooseTint",5,"MK2",false)
						exports["dynamic"]:AddButton("Classic Blue","Clique alterar seu armamento.","inventory:ChooseTint",6,"MK2",false)
						exports["dynamic"]:AddButton("Classic Earth","Clique alterar seu armamento.","inventory:ChooseTint",7,"MK2",false)
						exports["dynamic"]:AddButton("Classic Brown & Black","Clique alterar seu armamento.","inventory:ChooseTint",8,"MK2",false)
						exports["dynamic"]:AddButton("Red Contrast","Clique alterar seu armamento.","inventory:ChooseTint",9,"MK2",false)
						exports["dynamic"]:AddButton("Blue Contrast","Clique alterar seu armamento.","inventory:ChooseTint",10,"MK2",false)
						exports["dynamic"]:AddButton("Yellow Contrast","Clique alterar seu armamento.","inventory:ChooseTint",11,"MK2",false)
						exports["dynamic"]:AddButton("Orange Contrast","Clique alterar seu armamento.","inventory:ChooseTint",12,"MK2",false)
						exports["dynamic"]:AddButton("Bold Pink","Clique alterar seu armamento.","inventory:ChooseTint",13,"MK2",false)
						exports["dynamic"]:AddButton("Bold Purple & Yellow","Clique alterar seu armamento.","inventory:ChooseTint",14,"MK2",false)
						exports["dynamic"]:AddButton("Bold Orange","Clique alterar seu armamento.","inventory:ChooseTint",15,"MK2",false)
						exports["dynamic"]:AddButton("Bold Green & Purple","Clique alterar seu armamento.","inventory:ChooseTint",16,"MK2",false)
						exports["dynamic"]:AddButton("Bold Red Features","Clique alterar seu armamento.","inventory:ChooseTint",17,"MK2",false)
						exports["dynamic"]:AddButton("Bold Green Features","Clique alterar seu armamento.","inventory:ChooseTint",18,"MK2",false)
						exports["dynamic"]:AddButton("Bold Cyan Features","Clique alterar seu armamento.","inventory:ChooseTint",19,"MK2",false)
						exports["dynamic"]:AddButton("Bold Yellow Features","Clique alterar seu armamento.","inventory:ChooseTint",20,"MK2",false)
						exports["dynamic"]:AddButton("Bold Red & White","Clique alterar seu armamento.","inventory:ChooseTint",21,"MK2",false)
						exports["dynamic"]:AddButton("Bold Blue & White","Clique alterar seu armamento.","inventory:ChooseTint",22,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Gold","Clique alterar seu armamento.","inventory:ChooseTint",23,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Platinum","Clique alterar seu armamento.","inventory:ChooseTint",24,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Gray & Lilac","Clique alterar seu armamento.","inventory:ChooseTint",25,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Purple & Lime","Clique alterar seu armamento.","inventory:ChooseTint",26,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Red","Clique alterar seu armamento.","inventory:ChooseTint",27,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Green","Clique alterar seu armamento.","inventory:ChooseTint",28,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Blue","Clique alterar seu armamento.","inventory:ChooseTint",29,"MK2",false)
						exports["dynamic"]:AddButton("Metallic White & Aqua","Clique alterar seu armamento.","inventory:ChooseTint",30,"MK2",false)
						exports["dynamic"]:AddButton("Metallic Orange & Yellow","Clique alterar seu armamento.","inventory:ChooseTint",31,"MK2",false)
						exports["dynamic"]:AddButton("Mettalic Red and Yellow","Clique alterar seu armamento.","inventory:ChooseTint",32,"MK2",false)
					end

					exports["dynamic"]:openMenu()
				else
					TriggerEvent("Notify", "amarelo", "Você precisa ser <b>Premium</b>.", 5000)
				end
			end
		else
			TriggerEvent("Notify", "default", "Você precisa estar armado.",  5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CHOOSETINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:ChooseTint")
AddEventHandler("inventory:ChooseTint", function(Tint)
	if Weapon ~= "" then
		local Ped = PlayerPedId()
		SetPedWeaponTintIndex(Ped, Weapon, parseInt(Tint))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKNORMAL
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckNormal(Name)
	local Weapon = SplitOne(Name)

	if NormalWeaponsTints[Weapon] then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSPECIAL
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckSpecial(Name)
	local Weapon = SplitOne(Name)

	if SpecialWeaponsTints[Weapon] then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skins", function()
    if not IsPauseMenuActive() then
        local ped = GetPlayerPed(-1)
        
        if IsPedArmed(ped, 7) or IsPedArmed(ped, 4) then
            if LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and MumbleIsConnected() then
                if LocalPlayer["state"]["Premium"] or LocalPlayer["state"]["Skins"] then
                    local Weapon = GetSelectedPedWeapon(ped)
                    local WeaponName = GetWeaponNameFromHash(Weapon)
                    
                    local hasSkins = false
                    
                    exports["dynamic"]:SubMenu("Skins", "Selecione uma skin para sua arma ou remova a atual.", "SkinsMenu")
					exports["dynamic"]:AddButton("Remover Skin", "Clique para remover a skin.", "inventory:RemoveSkin", "", "", false)

                    for component, skinData in pairs(SkinsComponents) do
                        if skinData.arma == WeaponName then
                            hasSkins = true
                            exports["dynamic"]:AddButton(skinData.nome, "Clique para selecionar essa skin.", "inventory:ChooseSkin", component, "", false)
                        end
                    end
                    
                    if not hasSkins then
                        TriggerEvent("Notify", "default", "Esta arma não possui skins disponíveis.", 5000)
                    end

                    exports["dynamic"]:openMenu()
                else
                    TriggerEvent("Notify", "amarelo", "Você precisa ser <b>Premium ou Vip Skins</b> para usar skins.", 5000)
                end
            end
        else
            TriggerEvent("Notify", "default", "Você precisa estar armado com uma arma de fogo.", 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CHOOSESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:ChooseSkin")
AddEventHandler("inventory:ChooseSkin", function(skinComponent)
    local ped = PlayerPedId()
    local Weapon = GetSelectedPedWeapon(ped)
    local WeaponName = GetWeaponNameFromHash(Weapon)

    if SkinsComponents[skinComponent] and SkinsComponents[skinComponent].arma == WeaponName then
        local skinHash = GetHashKey(skinComponent)
        
        if DoesWeaponTakeWeaponComponent(Weapon, skinHash) then
            GiveWeaponComponentToPed(ped, Weapon, skinHash)
            weaponSkins[Weapon] = skinHash
            TriggerEvent("Notify", "verde", "Skin aplicada com sucesso!", 5000)
        else
            TriggerEvent("Notify", "vermelho", "Skin inválida para esta arma.", 5000)
        end
    else
        TriggerEvent("Notify", "vermelho", "Não foi possível aplicar a skin.", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REMOVESKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:RemoveSkin")
AddEventHandler("inventory:RemoveSkin", function()
    local ped = PlayerPedId()
    local Weapon = GetSelectedPedWeapon(ped)

    if weaponSkins[Weapon] then
        local skinHash = weaponSkins[Weapon]

        if DoesWeaponTakeWeaponComponent(Weapon, skinHash) then
            RemoveWeaponComponentFromPed(ped, Weapon, skinHash)
            weaponSkins[Weapon] = nil
            TriggerEvent("Notify", "verde", "Skin removida com sucesso!", 5000)
        else
            TriggerEvent("Notify", "vermelho", "Não foi possível remover a skin.", 5000)
        end
    else
        TriggerEvent("Notify", "amarelo", "Esta arma não tem uma skin equipada.", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWEAPONNAMEFROMHASH
-----------------------------------------------------------------------------------------------------------------------------------------
function GetWeaponNameFromHash(hash)
    for weaponName, _ in pairs(SkinsWeapons) do
        if GetHashKey(weaponName) == hash then
            return weaponName
        end
    end
    return nil
end