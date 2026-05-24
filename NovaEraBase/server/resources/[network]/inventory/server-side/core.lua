-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("inventory",Creative)
vPLAYER = Tunnel.getInterface("player")
vGARAGE = Tunnel.getInterface("garages")
vTASKBAR = Tunnel.getInterface("taskbar")
vDELIVER = Tunnel.getInterface("deliver")
vCLIENT = Tunnel.getInterface("inventory")
vKEYBOARD = Tunnel.getInterface("keyboard")
vPARAMEDIC = Tunnel.getInterface("paramedic")
vLOCKPICK = Tunnel.getInterface("lockpicking")
MEMORY = Tunnel.getInterface("memory")
DEVICE = Tunnel.getInterface("device")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Drops = {}
Drugs = {}
Carry = {}
Ammos = {}
Active = {}
Trashs = {}
Armors = {}
Heroin = {}
Plates = {}
Trunks = {}
Healths = {}
Animals = {}
Attachs = {}
Scanners = {}
Temporary = {}
atmTimers = {}
Registers = {}
Loots = {}
Property = {}
RobberyType = {}
Electricity = {}
verifyObjects = {}
verifyAnimals = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.WeaponPolice()
	local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasService(Passport, "Policia") then
            return true 
        else
            TriggerClientEvent("Notify", source, "police", "Você não é Policial ou Precisa estar em Serviço para usar esse Armamento.", 7500) 
            return false
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONVIP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.WeaponVip()
	local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasPermission(Passport, 'Premium') or vRP.HasPermission(Passport, 'PremiumOuro') or vRP.HasPermission(Passport, 'PremiumPrata') then
            return true 
        else
            TriggerClientEvent("Notify", source, 'amarelo', "Armamento Permitido somente para Vip's.", 7500) 
            return false
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEAPONARMAPORTE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.WeaponArmaPorte()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Result = vRP.Query("characters/CheckGun", { Passport = Passport })
        if Result[1] and tonumber(Result[1].gun) == 1 then
            return true
        else
            TriggerClientEvent("Notify", source, "amarelo", "Armamento permitido somente para cidadãos que possuem Porte de Arma.", 7500)
            return false
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP.MEMORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Memory(source)
	return MEMORY.Memory(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP.DEVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Device(source,Seconds)
	return DEVICE.Device(source,Seconds)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:PARACHUTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Inventory:Parachute")
AddEventHandler("Inventory:Parachute", function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
    	vRP.TakeItem(Passport, "GADGET_PARACHUTE", 1 ,true)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Loot(Entity,Service)
	local source = source
	local Entity = tostring(Entity)
	local Passport = vRP.Passport(source)
	if Passport and LootItens[Service] then
		if not Loots[Passport] and not Active[Passport] then
			if not Boxes[Entity] then
				Boxes[Entity] = {}
			end

			if Boxes[Entity][Passport] then
				if os.time() <= Boxes[Entity][Passport] then
					local Cooldown = MinimalTimers(Boxes[Entity][Passport] - os.time())
					TriggerClientEvent("Notify", source, "azul", "Aguarde <b>" .. Cooldown .. "</b>.", 5000)
					return
				end
			end

			Loots[Passport] = Entity
			Active[Passport] = os.time() + 10
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close", source)
			TriggerClientEvent("Progress", source, "Vasculhando", 10000)
			Boxes[Entity][Passport] = os.time() + LootItens[Service]["Cooldown"]
			vRPC.playAnim(source,false,{ "anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer" },true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.stopAnim(source, false)
					Player(source)["state"]["Buttons"] = false

					local randItem = math.random(#LootItens[Service]["List"])
					local randAmount = math.random(LootItens[Service]["List"][randItem]["min"],
						LootItens[Service]["List"][randItem]["max"])
					local itemSelect = { LootItens[Service]["List"][randItem]["item"], randAmount }

					if (vRP.InventoryWeight(Passport) + itemWeight(itemSelect[1]) * itemSelect[2]) <= vRP.GetWeight(Passport) then
						if Buffs["Luck"][Passport] then
							if Buffs["Luck"][Passport] > os.time() then
								vRP.GenerateItem(Passport, itemSelect[1], itemSelect[2] * 0.1, true)
							end
						else
							vRP.GenerateItem(Passport, itemSelect[1], itemSelect[2], true)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","Mochila Sobrecarregada Sua recompensa caiu no chão.",5000)
						exports["inventory"]:Drops(Passport,source, itemSelect[1], itemSelect[2] )
						Boxes[Entity][Passport] = nil
					end

					Loots[Passport] = nil
				end

				Wait(100)
			until not Active[Passport]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.requestInventory()
    local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Inv = {}
		local Inventory = vRP.Inventory(Passport)
		for Index,v in pairs(Inventory) do
			if (parseInt(v["amount"]) <= 0 or not itemBody(v["item"])) then
				vRP.RemoveItem(Passport,v["item"],parseInt(v["amount"]),false)
			else
				v["amount"] = parseInt(v["amount"])
				v["name"] = itemName(v["item"])
				v["peso"] = itemWeight(v["item"])
				v["index"] = itemIndex(v["item"])
				v["max"] = itemMaxAmount(v["item"])
				v["desc"] = itemDescription(v["item"]) or ""
				v["economy"] = parseFormat(itemEconomy(v["item"]))
				v["key"] = v["item"]
				v["slot"] = Index

				local Split = splitString(v["item"],"-")
				if Split[2] ~= nil then
					if Split[1] == "identity" or Split[1] == "fidentity" or string.sub(v["item"],1,5) == "badge" then
						local Number = parseInt(Split[2])
						local Identity = vRP.Identity(Number)

						if Split[1] == "fidentity" then
							Identity = vRP.FalseIdentity(Number)
						end

						if Identity then
							v["Passport"] = Number
							v["Premium"] = "Nenhum"
							v["Rolepass"] = "Inativo"
							v["Gemstone"] = Identity["gems"]
							v["Blood"] = Sanguine(Identity["blood"])
							v["Name"] = vRP.FullName(Number)
						end
					end

					if Split[1] == "trabalho" then
						v["desc"] = v["desc"] or ""
						local Number = tonumber(Split[2])
						local Identity = vRP.Identity(Number)
						if Identity then
							v["Passport"] = Number
							v["Name"] = Identity["name"].." "..Identity["name2"]
							local Work = vRP.GetWork(Number) or "Nenhum"
							v["Work"] = ClassWork(Work)
							v["desc"] = v["desc"].."<br><description>Passaporte: <green>"..v["Passport"].."</green>.<br>Nome: <green>"..v["Name"].."</green>.<br>Status Carteira: <green>"..v["Work"].."</green>.</description>"
						end
					end					

					if Split[1] == "vehkey" then
						v["Vehkey"] = Split[2]
					end

					if Split[1] == "driverlicense" then
						local info = json.decode(Split[3])
						v["desc"] = v["desc"].."<br><legenda>Nome: <r>"..info["name"].."</r> <br>Emissão: <r>"..os.date("%d/%m/%Y", info["issued"]).."</r><br>Validade: <r>"..os.date("%d/%m/%Y", info["expiration"]).."</r><br>Categoria: <r>"..string.gsub(json.encode(info["categories"]), '[^%a,]', '').."</r></legenda>"
					end

					if Split[1] == "dmvdocs" then
						local identity = vRP.Identity(parseInt(Split[2]))
						v["desc"] = v["desc"].."<br><legenda>Nome: <r>"..identity["name"].." "..identity["name2"].."</r> <br>Prática: <r>"..string.gsub(Split[5], '[^%a,]', '').."</r><br>Teórica: <r>"..string.gsub(Split[4], '[^%a,]', '').."</r><br>Categoria: <r>"..string.gsub(Split[3], '[^%a,]', '').."</r></legenda>"
					end

					if Split[1] == "notepad" and Split[2] then
						v["desc"] = vRP.GetSrvData(v["item"],true)
					end

					if Split[1] == "suitcase" then
						v["Suitcase"] = parseFormat(Split[2])
					end

					if itemType(Split[1]) == "Armamento" and Split[3] then
						local DonoSerial = Split[3]
						local UserSerial = vRP.UserSerial(DonoSerial)
						if UserSerial then
							local Identity = vRP.Identity(UserSerial["id"])
							if Identity and Identity["serial"] then
								v["desc"] = "<br><description>Serial da Arma: <green>"..Identity["serial"].."</green>.</description>"
							end
						else
							v["desc"] = "<br><description>Serial da Arma: <green>Desconhecido</green>.</description>"
						end
					end			
					
					if itemCharges(v["item"]) then
						v["charges"] = parseInt(Split[2] * 33)
					end

					if itemDurability(v["item"]) then
						v["durability"] = parseInt(os.time() - Split[2])
						v["days"] = itemDurability(v["item"])
					else
						v["durability"] = 0
						v["days"] = 1
					end
				else
					v["durability"] = 0
					v["days"] = 1
				end

				Inv[Index] = v
			end
		end

		return Inv,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DropServer(Coords,Item,Amount)
	local Number = 0

	repeat
		Number = Number + 1
	until not Drops[tostring(Number)]

	Drops[tostring(Number)] = {
		["key"] = Item,
		["amount"] = Amount,
		["Coords"] = { Coords["x"],Coords["y"],Coords["z"] },
		["name"] = itemName(Item),
		["peso"] = itemWeight(Item),
		["index"] = itemIndex(Item),
		["days"] = 1,
		["durability"] = 0,
		["charges"] = nil
	}

	TriggerClientEvent("drops:Adicionar",-1,tostring(Number),Drops[tostring(Number)])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Drops(Item, Slot, Amount, x, y, z)
    local source = source
    local Slot = tostring(Slot)
    local Passport = vRP.Passport(source)
    if Passport then
        if not Active[Passport] and not Player(source)["state"]["Handcuff"] and not exports["hud"]:Wanted(Passport) and not vRP.InsideVehicle(source) and GetPlayerRoutingBucket(source) < 900000 then
            if itemBlock(Item) then
                TriggerClientEvent("inventory:Update", source, "Backpack")
                return
            end

            if not vRP.CheckDamaged(Item) then
                if vRP.TakeItem(Passport, Item, Amount, false, Slot) then
                    local Days = 1
                    local Number = 0
                    local Charges = nil
                    local Durability = 0
                    local Split = splitString(Item, "-")

                    repeat
                        Number = Number + 1
                    until not Drops[tostring(Number)]

                    if Split[2] ~= nil then
                        if itemCharges(Item) then
                            Charges = parseInt(Split[2] * 33)
                        end

                        if itemDurability(Item) then
                            Durability = parseInt(os.time() - Split[2])
                            Days = itemDurability(Item)
                        end
                    end

                    Drops[tostring(Number)] = {
                        ["key"] = Item,
                        ["amount"] = Amount,
                        ["Coords"] = { x, y, z },
                        ["name"] = itemName(Item),
                        ["peso"] = itemWeight(Item),
                        ["index"] = itemIndex(Item),
                        ["days"] = Days,
                        ["durability"] = Durability,
                        ["charges"] = Charges
                    }

                    Player(source)["state"]["Buttons"] = true
                    Player(source)["state"]["Cancel"] = true

                    if not vRP.InsideVehicle(source) then
                        vRPC.playAnim(source, false, { "pickup_object", "pickup_low" }, true)
                        Active[Passport] = os.time() + 100

                        SetTimeout(1000, function()
                            vRPC.Destroy(source)
                            Active[Passport] = nil
                        end)
                    end

                    TriggerClientEvent("drops:Adicionar", -1, tostring(Number), Drops[tostring(Number)])
                    TriggerClientEvent("inventory:Update", source, "Backpack")
                    Player(source)["state"]["Buttons"] = false
                    Player(source)["state"]["Cancel"] = false

                    TriggerEvent("Discord", "InventoryDrops", "**[Dropou um item]**\n\n**Passaporte:** " .. Passport .. "\n**Dropou:** " .. Amount .. "x " .. itemName(Item) .. "\n**Localização:** (" .. x .. "," .. y .. "," .. z .. ")" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não pode descartar itens danificados.",3000)
            end
        else
            TriggerClientEvent("inventory:Update", source, "Backpack")
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Pickup(Number,Amount,Slot)
	local source = source
	local Slot = tostring(Slot)
	local Number = tostring(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] and GetPlayerRoutingBucket(source) < 900000 then
			if not Drops[Number] then
				TriggerClientEvent("inventory:Update",source,"Backpack")
				return
			else
				if (vRP.InventoryWeight(Passport) + itemWeight(Drops[Number]["key"]) * Amount) <= vRP.GetWeight(Passport) then
					if not Drops[Number] or Drops[Number]["amount"] < Amount then
						TriggerClientEvent("inventory:Update",source,"Backpack")
						return
					end

					if vRP.MaxItens(Passport,Drops[Number]["key"],Amount) then
						TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
						TriggerClientEvent("inventory:Update",source,"Backpack")
						return
					end

					if Drops[Number] then
						local inventory = vRP.Inventory(Passport)
						if inventory[Slot] and Drops[Number]["key"] then
							if inventory[Slot]["item"] == Drops[Number]["key"] then
								vRP.GiveItem(Passport,Drops[Number]["key"],Amount,false,Slot)
							else
								vRP.GiveItem(Passport,Drops[Number]["key"],Amount,false)
							end
						else
							if Drops[Number] then
								vRP.GiveItem(Passport,Drops[Number]["key"],Amount,false,Slot)
							end
						end

						TriggerEvent("Discord","InventoryPegou","**[Pegou um item]**\n\n**Passaporte:** "..Passport.."\n**Pegou:** "..Amount.."x "..itemName(Drops[Number]["key"]).."\n**Localização:** ("..Drops[Number]["Coords"][1]..","..Drops[Number]["Coords"][2]..","..Drops[Number]["Coords"][3]..")" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)

						Drops[Number]["amount"] = Drops[Number]["amount"] - Amount
						if Drops[Number]["amount"] <= 0 then
							TriggerClientEvent("drops:Remover",-1,Number)
							Drops[Number] = nil
						else
							TriggerClientEvent("drops:Atualizar",-1,Number,Drops[Number]["amount"])
						end

						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true

						if not vRP.InsideVehicle(source) then
							vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)
							Active[Passport] = os.time() + 100

							SetTimeout(1000,function()
								vRPC.Destroy(source)
								Active[Passport] = nil
							end)
						end

						TriggerClientEvent("inventory:Update",source,"Backpack")
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
					else
						TriggerClientEvent("inventory:Update",source,"Backpack")
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					TriggerClientEvent("inventory:Update",source,"Backpack")
					return
				end
			end
		else
			TriggerClientEvent("inventory:Update",source,"Backpack")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SendItem(Slot,Amount)
	local source = source
	local Slot = tostring(Slot)
	local Amount = parseInt(Amount)
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and GetPlayerRoutingBucket(source) < 900000 then
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			Active[Passport] = os.time() + 100

			local inventory = vRP.Inventory(Passport)
			if not inventory[Slot] or not inventory[Slot]["item"] then
				Active[Passport] = nil
				return
			end

			if Amount <= 0 then Amount = 1 end
			local Item = inventory[Slot]["item"]

			if vRP.CheckDamaged(Item) or itemBlock(Item) then
				Active[Passport] = nil
				return
			end

			local OtherPassport = vRP.Passport(ClosestPed)
			if not vRP.MaxItens(OtherPassport,Item,Amount) then
				if (vRP.InventoryWeight(OtherPassport) + itemWeight(Item) * Amount) <= vRP.GetWeight(OtherPassport) then
					Active[Passport] = os.time() + 3
					Player(source)["state"]["Cancel"] = true
					Player(source)["state"]["Buttons"] = true
					Player(ClosestPed)["state"]["Cancel"] = true
					Player(ClosestPed)["state"]["Buttons"] = true
					vRPC.CreateObjects(source,"mp_safehouselost@","package_dropoff","prop_paper_bag_small",16,28422,0.0,-0.05,0.05,180.0,0.0,0.0)

					repeat
						if os.time() >= parseInt(Active[Passport]) then
							Active[Passport] = nil
							vRPC.Destroy(source)
							Player(source)["state"]["Cancel"] = false
							Player(source)["state"]["Buttons"] = false
							Player(ClosestPed)["state"]["Cancel"] = false
							Player(ClosestPed)["state"]["Buttons"] = false


							if vRP.TakeItem(Passport,Item,Amount,true,Slot) then
								vRP.GiveItem(OtherPassport,Item,Amount,true)
								TriggerClientEvent("inventory:Update",source,"Backpack")
								TriggerClientEvent("inventory:Update",ClosestPed,"Backpack")
							end
						end

						Wait(100)
					until not Active[Passport]

					TriggerEvent("Discord","InventoryEnviou","**[Enviou um item]**\n\n**Passaporte:** "..Passport.."\n**Enviou:** "..Amount.."x "..itemName(Item).."\n**Para o Passaporte:** "..OtherPassport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
			end

			Active[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deliver(Slot)
	local source = source
	local Slot = tostring(Slot)
	local Passport = vRP.Passport(source)
	if Passport then
		local Inventory = vRP.Inventory(Passport)
		if not Inventory[Slot] or not Inventory[Slot]["item"] then
			return
		end

		local Split = splitString(Inventory[Slot]["item"],"-")
		local Full = Inventory[Slot]["item"]
		local Item = Split[1]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRASH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Trash(Slot, Amount)
    local source = source
    local Slot = tostring(Slot)
    local Amount = parseInt(Amount)
    local Passport = vRP.Passport(source)
    
    if Passport then
        if not Active[Passport] and not Player(source)["state"]["Handcuff"] and not exports["hud"]:Wanted(Passport) and not vRP.InsideVehicle(source) and GetPlayerRoutingBucket(source) < 900000 then
            if Amount <= 0 then Amount = 1 end

            local Inventory = vRP.Inventory(Passport)
            if not Inventory[Slot] or not Inventory[Slot]["item"] then
                return
            end

            local Split = splitString(Inventory[Slot]["item"], "-")
            local Full = Inventory[Slot]["item"]
            local Item = Split[1]

            if not ForbiddenItens[Item] then
                if vRP.Request(source, "Tem Certeza que Deseja Jogar " .. itemName(Item) .. " no Lixo") then
                    if vRP.TakeItem(Passport, Full, Amount, true, Slot) then
                        Player(source)["state"]["Buttons"] = true
                        Player(source)["state"]["Cancel"] = true

                        if not vRP.InsideVehicle(source) then
                            vRPC.playAnim(source, false, {"pickup_object", "pickup_low"}, true)
                            Active[Passport] = os.time() + 100

                            SetTimeout(1000, function()
                                vRPC.Destroy(source)
                                Active[Passport] = nil
                            end)
                        end

                        TriggerClientEvent("inventory:Update", source, "Backpack")
                        Player(source)["state"]["Buttons"] = false
                        Player(source)["state"]["Cancel"] = false

                        TriggerEvent("Discord", "InventoryLixo", "**[Jogou um item no lixo]**\n\n**Passaporte:** " .. Passport .. "\n**Jogou Lixo:** " .. Amount .. "x " .. itemName(Item) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
                    end
                else
                    TriggerClientEvent("Notify", source, "vermelho", "Tempo acabou e seu item voltou para você.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não pode jogar este item no lixo.", 5000)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UseItem(Slot, Amount)
    local source = source
    local Slot = tostring(Slot)
    local Amount = parseInt(Amount)
    local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and not Player(source)["state"]["Handcuff"] then
        if Amount <= 0 then Amount = 1 end

        local Inventory = vRP.Inventory(Passport)
        if not Inventory[Slot] or not Inventory[Slot]["item"] then
            return
        end

        local Split = splitString(Inventory[Slot]["item"], "-")
        local Full = Inventory[Slot]["item"]
        local Item = Split[1]

        if Player(source)["state"]["Handcuff"] and Item == "lockpick" then
            local taskResult = vTASKBAR.taskHandcuff(source)
            if taskResult then
                Player(source)["state"]["Handcuff"] = false
				Player(source)["state"]["Commands"] = false
				TriggerClientEvent("sounds:source", source, "uncuff", 0.5)
				vRPC.stopAnim(source,false)
                return true
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você errou a tarefa. Permanece algemado.", 5000)
            end
        end

        if itemDurability(Full) then
            if vRP.CheckDamaged(Full) then
                TriggerClientEvent("Notify", source, "vermelho", "<b>"..itemName(Item).."</b> danificado.", 5000)
                return
            end
        end

		if (vCLIENT.checkWater(source) and Item ~= "soap") or (not vCLIENT.checkWater(source) and Item == "soap") then
			return
		end

		if itemType(Full) == "Armamento" and parseInt(Slot) <= 5 and not Player(source)["state"]["Safezone"] then
			if vCLIENT.CheckArms(source) then
				TriggerClientEvent("Notify",source,"amarelo","Mão machucada.",5000)
				return
			end

			if vRP.InsideVehicle(source) then
				if not itemVehicle(Full) then
					return
				end
			end

			if vCLIENT.returnWeapon(source) then
				local Check,Ammo,Hash = vCLIENT.storeWeaponHands(source)

				if Check then
					local wHash = itemAmmo(Hash)
					if wHash then
						if Ammo > 0 then
							if not Ammos[Passport] then  
								Ammos[Passport] = {}
							end

							Ammos[Passport][wHash] = Ammo
						else
							if Ammos[Passport] and Ammos[Passport][wHash] then
								Ammos[Passport][wHash] = nil
							end
						end
					end

					TriggerClientEvent("itensNotify",source,{ "-",itemIndex(Hash),1,itemName(Hash) })
					exports["inventory"]:CleanWeapons(Passport,false)
				end
			else
				Ammo = 0
				local wHash = itemAmmo(Item)
				if wHash then
					if not Ammos[Passport] then
						Ammos[Passport] = {}
					end

					if not Ammos[Passport][wHash] then
						Ammos[Passport][wHash] = 0
					else
						Ammo = Ammos[Passport][wHash]
					end
				end

				if not Attachs[Passport] then
					Attachs[Passport] = {}
				end

				if not Attachs[Passport][Item] then
					Attachs[Passport][Item] = {}
				end

				if vCLIENT.putWeaponHands(source,Item,Ammo,Attachs[Passport][Item]) then
					TriggerClientEvent("itensNotify",source,{ "-",itemIndex(Full),1,itemName(Full) })
				end
			end
		elseif itemType(Full) == "Munição" then
			local Weapon,Hash,Ammo = vCLIENT.rechargeCheck(source,Item)

			if Weapon then
				if Hash == "WEAPON_PETROLCAN" then
					if (Ammo + Amount) > 4500 then
						Amount = 4500 - Ammo
					end
				else
					if (Ammo + Amount) > 250 then
						Amount = 250 - Ammo
					end
				end

				if Item ~= itemAmmo(Hash) or Amount <= 0 then
					return
				end

				if vRP.TakeItem(Passport,Full,Amount,false,Slot) then
					if not Ammos[Passport] then
						Ammos[Passport] = {}
					end

					Ammos[Passport][Item] = Ammo + Amount

					TriggerClientEvent("itensNotify",source,{ "-",itemIndex(Full),Amount,itemName(Full) })
					TriggerClientEvent("inventory:Update",source,"Backpack")
					vCLIENT.rechargeWeapon(source,Hash,Amount)
				end
			end
		elseif itemType(Full) == "Throwing" then
			if vCLIENT.returnWeapon(source) then
				local Check,Ammo,Hash = vCLIENT.storeWeaponHands(source)

				if Check then
					local wHash = itemAmmo(Hash)
					if wHash then
						if Ammo > 0 then
							if not Ammos[Passport] then
								Ammos[Passport] = {}
							end

							Ammos[Passport][wHash] = Ammo
						else
							if Ammos[Passport] and Ammos[Passport][wHash] then
								Ammos[Passport][wHash] = nil
							end
						end
					end

					TriggerClientEvent("itensNotify",source,{ "-",itemIndex(Hash),1,itemName(Hash) })
					exports["inventory"]:CleanWeapons(Passport,false)
				end
			else
				if vCLIENT.putWeaponHands(source,Item,1,nil,Full) then
					TriggerClientEvent("itensNotify",source,{ "-",itemIndex(Full),1,itemName(Full) })
				end
			end
		elseif Item == "attachsFlashlight" or Item == "attachsCrosshair" or Item == "attachsSilencer" or Item == "attachsMagazine" or Item == "attachsGrip" or Item == "attachsMuzzleHeavy" or Item == "attachsBarrel" or Item == "attachsMuzzleFat" then
			local Weapon = vCLIENT.returnWeapon(source)
			if Weapon then
				if vCLIENT.checkAttachs(source,Item,Weapon) then
					if not Attachs[Passport] then
						Attachs[Passport] = {}
					end

					if not Attachs[Passport][Weapon] then
						Attachs[Passport][Weapon] = {}
					end

					if not Attachs[Passport][Weapon][Item] then
						if vRP.TakeItem(Passport,Full,1,false,Slot) then
							TriggerClientEvent("itensNotify",source,{ "-",itemIndex(Full),1,itemName(Full) })
							TriggerClientEvent("inventory:Update",source,"Backpack")
							Attachs[Passport][Weapon][Item] = true
							vCLIENT.putAttachs(source,Item,Weapon)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","O armamento não possui suporte ao componente.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","O armamento já possui o componente equipado.",5000)
				end
			end
		elseif Use[Item] then
			Use[Item](source,Passport,Amount,Slot,Full,Item,Split)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Cancel()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Active[Passport] ~= nil then
			Active[Passport] = nil
			vGARAGE.UpdateHotwired(source,false)
			Player(source)["state"]["Buttons"] = false
			TriggerClientEvent("Progress",source,"Cancelando",1000)

			if verifyObjects[Passport] then
				local Model = verifyObjects[Passport][1]
				local Hash = verifyObjects[Passport][2]

				if Trashs[Model] then
					if Trashs[Model][Hash] then
						Trashs[Model][Hash] = nil
					end
				end

				verifyObjects[Passport] = nil
			end

			if verifyAnimals[Passport] then
				local Model = verifyAnimals[Passport][1]

				if Animals[Model] then
					local netObjects = verifyAnimals[Passport][2]

					if Animals[Model][netObjects] then
						Animals[Model][netObjects] = Animals[Model][netObjects] - 1
						verifyAnimals[Passport] = nil
					end
				end
			end
		end

		if Carry[Passport] then
			TriggerClientEvent("player:ropeCarry",Carry[Passport],source)
			TriggerClientEvent("player:Commands",Carry[Passport],false)
			vRPC.Destroy(Carry[Passport])
			Carry[Passport] = nil
		end

		if Scanners[Passport] then
			TriggerClientEvent("inventory:updateScanner", source, false)
			TriggerClientEvent("inventory:ScannerBlips", source)
			Player(source)["state"]["Buttons"] = false
			Player(source)["state"]["Scanner"] = false
			Scanners[Passport] = nil
		end

		vRPC.Destroy(source)

		if GetPlayerRoutingBucket(source) > 900000 then
			TriggerEvent("arena:Cancel",source,Passport)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkInventory()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Active[Passport] then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFYWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.verifyWeapon(Item,Ammo)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not vRP.ConsultItem(Passport,Item,1) then
		local Ammunation = itemAmmo(Item)
		if Ammunation and Ammos[Passport] and Ammos[Passport][Ammunation] then
			if Ammo and Ammo > 0 then
				Ammos[Passport][Ammunation] = Ammo
			end

			if Ammos[Passport][Ammunation] > 0 then
				vRP.GenerateItem(Passport,Ammunation,Ammos[Passport][Ammunation])
				Ammos[Passport][Ammunation] = nil
			end
		end

		if Attachs[Passport] and Attachs[Passport][Item] then
			for Component,_ in pairs(Attachs[Passport][Item]) do
				vRP.GenerateItem(Passport,Component,1)
			end

			Attachs[Passport][Item] = nil
		end

		TriggerClientEvent("inventory:Update",source,"Backpack")
		exports["inventory"]:CleanWeapons(Passport,false)

		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.dropWeapons(Item)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Item ~= "" and Item and not vRP.ConsultItem(Passport,Item,1) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETHROWING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.removeThrowing(Item)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Item ~= "" and Item ~= nil then
		vRP.TakeItem(Passport,Item,1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVENTWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.preventWeapon(Item,Ammo)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Ammos[Passport] then
		local Ammunation = itemAmmo(Item)

		if Ammunation and Ammos[Passport][Ammunation] then
			if Ammo > 0 then
				Ammos[Passport][Ammunation] = Ammo
			else
				Ammos[Passport][Ammunation] = nil
				exports["inventory"]:CleanWeapons(Passport,false)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFYOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.VerifyObjects(Entity,Service)
	local source = source
	local Passport = vRP.Passport(source)

	if Passport and not Active[Passport] then
		if Service == "Lixeiro" then
			if vRP.GetWork(Passport) == CheckWorkGarbageman then
				if not vRPC.LastVehicle(source,VehicleWorkGarbageman) then
					TriggerClientEvent("Notify",source,"amarelo","Precisa utilizar o veículo do <b>Lixeiro</b>.",3000)
					return
				end
			else
				TriggerClientEvent("Notify", source, "amarelo", "Você precisa ter a sua <b>Carteira de Trabalho</b> assinada no emprego de <b>"..ClassWork(CheckWorkGarbageman).."</b> para conseguir trabalhar aqui.", 5000)
				return
			end
		end

		if Entity[1] and Entity[2] and Entity[4] then
			local Hash = Entity[1]
			local Model = Entity[2]
			local Coords = Entity[4]

			if not verifyObjects[Passport] then
				if not Trashs[Model] then
					Trashs[Model] = {}
				end

				for _,v in pairs(Trashs[Model]) do
					if #(v["Coords"] - Coords) <= 0.75 and os.time() <= v["timer"] then
						local Cooldown = v["timer"] - os.time()
						TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Cooldown.."</b> segundos.",5000)
						return
					end
				end

				Active[Passport] = os.time() + 5
				TriggerClientEvent("Progress",source,"Vasculhando",5000)
				vRPC.playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)

				verifyObjects[Passport] = { Model,Hash }
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				Trashs[Model][Hash] = { ["Coords"] = Coords, ["timer"] = os.time() + TrashsTimerVerify }

				repeat
					if os.time() >= Active[Passport] then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if Service == "Lixeiro" then
							local Experience = vRP.GetExperience(Passport, ExperienceWorkGarbageman)
							local Category = ClassCategory(Experience)
							local Valuation = PaymentDefaultGarbageman + (CategoryIncrementsGarbageman[Category] or 0)

							vRP.PutExperience(Passport, ExperienceWorkGarbageman, LevelExperienceWorkGarbageman)

							local RandomItem = math.random(1, #ItensWorkGarbageman)
							local Data = ItensWorkGarbageman[RandomItem]
							local Amount = math.random(Data.Amount[1], Data.Amount[2])

							local weight = vRP.GetItemWeight(Data.item) or 0
							if (vRP.InventoryWeight(Passport) + weight * Amount) <= vRP.GetWeight(Passport) then
								vRP.GenerateItem(Passport, Data.item, Amount, true)
							else
								exports["inventory"]:Drops(Passport, source, Data.item, Amount)
								TriggerClientEvent("Notify", source, "amarelo", "Mochila cheia, sua recompensa foi dropada no chão.", 5000)
								Trashs[Model][Hash] = nil
							end

							vRP.GenerateItem(Passport, ItemPaymentGarbageman, Valuation, true)
						else
							TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
						end

						verifyObjects[Passport] = nil
					end
					Wait(100)
				until not Active[Passport]
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:APPLYPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:applyPlate")
AddEventHandler("inventory:applyPlate",function(Entity)
	local source = source
	local consultItem = {}
	local Plate = Entity[1]
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		if not Plates[Plate] then
			consultItem = vRP.InventoryItemAmount(Passport,"plate")
			if consultItem[1] <= 0 then
				TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("plate").."</b>.",5000)
				return
			end
		end

		local consultPliers = vRP.InventoryItemAmount(Passport,"pliers")
		if consultPliers[1] <= 0 then
			TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("pliers").."</b>.",5000)
			return
		end

		if Plates[Plate] ~= nil then
			if os.time() < Plates[Plate][1] then
				local plateTimers = parseInt(Plates[Plate][1] - os.time())
				if plateTimers ~= nil then
					TriggerClientEvent("Notify",source,"azul","Aguarde "..CompleteTimers(plateTimers)..".",5000)
				end

				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("Progress",source,"Trocando",10000)
		vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if not Plates[Plate] then
					if vRP.TakeItem(Passport,consultItem[2],1,true) then
						local newPlate = vRP.GeneratePlate()
						TriggerEvent("plateEveryone",newPlate)
						Plates[newPlate] = { os.time() + 3600,Plate }

						local Network = NetworkGetEntityFromNetworkId(Entity[4])
						if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
							SetVehicleNumberPlateText(Network,newPlate)
						end
					end
				else
					local Network = NetworkGetEntityFromNetworkId(Entity[4])
					if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
						SetVehicleNumberPlateText(Network,Plates[Plate][2])
					end

					if math.random(100) >= 50 then
						vRP.GenerateItem(Passport,"plate",1,true)
					else
						TriggerClientEvent("Notify",source,"azul","Após remove-la a mesma quebrou.",5000)
					end

					TriggerEvent("plateReveryone",Plate)
					Plates[Plate] = nil
				end
			end

			Wait(100)
		until not Active[Passport]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEALTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StealTrunk(Entity)
	local source = source
	local Plate = Entity[1]
	local Network = Entity[4]
	local vehModels = Entity[2]
	local Passport = vRP.Passport(source)

	for _, group in ipairs(NoStealTrunk) do
		if vRP.HasGroup(Passport, group) then
			TriggerClientEvent("Notify", source, "vermelho", "Você não pode fazer isso.", 5000)
			return false
		end
	end
	
	if Passport and not Active[Passport] then
		if not vCLIENT.checkWeapon(source,StealTrunkRequired) then
			TriggerClientEvent("Notify",source,"amarelo","<b>Pé de Cabra</b> não encontrado.",5000)
			return
		end

		if not vRP.PassportPlate(Plate) then
			if not Trunks[Plate] then
				Trunks[Plate] = os.time()
			end

			if os.time() >= Trunks[Plate] then
				vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
				Active[Passport] = os.time() + 100

				if vTASKBAR.stealTrunk(source) then
					Active[Passport] = os.time() + 10
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("Progress",source,"Vasculhando",10000)
					TriggerClientEvent("player:Residuals",source,"Resíduo de Ferro.")
					TriggerClientEvent("player:syncDoorsOptions",source,Network,"open")

					repeat
						if os.time() >= parseInt(Active[Passport]) then
							Active[Passport] = nil
							vRPC.stopAnim(source,false)
							Player(source)["state"]["Buttons"] = false
							TriggerClientEvent("player:syncDoorsOptions",source,Network,"close")

							if os.time() >= Trunks[Plate] then
								local randItens = math.random(#StealItens)
								if math.random(250) <= StealItens[randItens]["rand"] then
									local randAmounts = math.random(StealItens[randItens]["min"],StealItens[randItens]["max"])

									if (vRP.InventoryWeight(Passport) + itemWeight(StealItens[randItens]["item"]) * randAmounts) <= vRP.GetWeight(Passport) then
										vRP.GenerateItem(Passport,StealItens[randItens]["item"],randAmounts,true)
										Trunks[Plate] = os.time() + 3600
										vRP.UpgradeStress(Passport,2)
									else
										TriggerClientEvent("Notify",source,"amarelo","Mochila Sobrecarregada Sua recompensa caiu no chão.",5000)
										exports["inventory"]:Drops(Passport,source,StealItens[randItens]["item"],randAmounts)
									end
								else
									TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
									Trunks[Plate] = os.time() + 3600
								end
							end
						end

						Wait(100)
					until not Active[Passport]
				else
					TriggerClientEvent("inventory:vehicleAlarm",source,Network,Plate)
					vRPC.stopAnim(source,false)
					Active[Passport] = nil

					local Coords = vRP.GetEntityCoords(source)
					local Service = vRP.NumPermission(StealTrunkPermission)
					for Passports,Sources in pairs(Service) do
						async(function()
							TriggerClientEvent("NotifyPush",Sources,{ code = 31, title = "Roubo de Porta-Malas", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehModels).." - "..Plate, time = "Recebido às "..os.date("%H:%M"), color = 44 })
						end)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Veículo protegido pela seguradora.",1000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Animals(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetWork(Passport) ~= CheckWorkHunting then
			TriggerClientEvent("Notify", source, "amarelo", "Você precisa ter a sua <b>Carteira de Trabalho</b> assinada no emprego de <b>"..ClassWork(CheckWorkHunting).."</b> para conseguir trabalhar.", 5000)
			return
		end

		if Entity[2] ~= nil and Entity[3] ~= nil then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)

			if not vCLIENT.checkWeapon(source, NeedItemHunting) then
				TriggerClientEvent("Notify", source, "amarelo", "Você precisa colocar o <b>" .. itemName(NeedItemHunting) .. "</b> em mãos.", 5000)
				return
			end

			local Model = Entity[2]
			local netObjects = Entity[3]

			if not Animals[Model] then
				Animals[Model] = {}
			end

			if not Animals[Model][netObjects] then
				Animals[Model][netObjects] = 0
			end

			if not verifyAnimals[Passport] and not Active[Passport] and Animals[Model][netObjects] < 5 then
				if (vRP.InventoryWeight(Passport) + 2.25) <= vRP.GetWeight(Passport) then
					if vTASKBAR.taskOne(source) then
						Active[Passport] = os.time() + 10
						TriggerClientEvent("Progress", source, "Esfolando", 10000)

						if not vCLIENT.animalAnim(source) then
							vRPC.Destroy(source)
							vRPC.playAnim(source, false, { "amb@medic@standing@kneel@base", "base" }, true)
							vRPC.playAnim(source, true, { "anim@gangops@facility@servers@bodysearch@", "player_search" }, true)
						end

						Player(source)["state"]["Buttons"] = true
						TriggerClientEvent("inventory:Close", source)
						verifyAnimals[Passport] = { Model, netObjects }
						Animals[Model][netObjects] = Animals[Model][netObjects] + 1

						repeat
							if Active[Passport] and os.time() >= parseInt(Active[Passport]) then
								Active[Passport] = nil
								verifyAnimals[Passport] = nil
								Player(source)["state"]["Buttons"] = false

								if Animals[Model] then
									if Player(source)["state"]["Hunting"] then
										local RewardList = AnimalRewards[Model]
										if RewardList then
											local ChanceItems = {}
											local FixedItems = {}

											for _, v in ipairs(RewardList) do
												if v.chance then
													table.insert(ChanceItems, v)
												elseif v.amount then
													table.insert(FixedItems, v)
												end
											end

											local total = 0
											for _, v in ipairs(ChanceItems) do
												total = total + v.chance
											end

											if total > 0 then
												local rand = math.random(1, total)
												local sum = 0
												for _, v in ipairs(ChanceItems) do
													sum = sum + v.chance
													if rand <= sum then
														vRP.GenerateItem(Passport, v.item, 1, true)
														break
													end
												end
											end

											if #FixedItems > 0 then
												local FixedDrop = FixedItems[math.random(#FixedItems)]
												local amount = math.random(FixedDrop.amount[1], FixedDrop.amount[2])
												vRP.GenerateItem(Passport, FixedDrop.item, amount, true)
											end
										end
									end

									vRPC.Destroy(source)
									Animals[Model][netObjects] = nil
									TriggerEvent("DeletePed", netObjects)
									Player(source)["state"]["Hunting"] = false
								end

								local Experience = vRP.GetExperience(Passport, ExperienceWorkHunting)
								local Category = ClassCategory(Experience)
								local Valuation = PaymentDefaultHunting + (CategoryIncrementsHunting[Category] or 0)

								vRP.PutExperience(Passport, ExperienceWorkHunting, LevelExperienceWorkHunting)
								vRP.GenerateItem(Passport, ItemPaymentHunting, Valuation, true)

								vRPC.stopAnim(source, false)
							end
							Wait(100)
						until not Active[Passport]
					end
				else
					TriggerClientEvent("Notify", source, "vermelho", "Mochila cheia.", 5000)
				end
			end
		else
			TriggerClientEvent("Notify", source, "vermelho", "Nada encontrado.", 5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StoreObjects(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Objects[Number] then
			if (vRP.InventoryWeight(Passport) + itemWeight(Objects[Number]["item"])) <= vRP.GetWeight(Passport) then
				vRP.GiveItem(Passport,Objects[Number]["item"],1,true)
				TriggerClientEvent("objects:Remover",-1,Number)
				Objects[Number] = nil
			else
				TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEPRODUCTS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.MakeProducts(Table)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then
		return
	end

	local Split = splitString(Table,"-")
	local Selected = Split[1]

	if Selected == "milkBottle" and vRP.GetWork(Passport) ~= CheckWorkMilkman then
		TriggerClientEvent("Notify", source, "amarelo", "Você precisa ter a sua <b>Carteira de Trabalho</b> assinada no emprego de <b>"..ClassWork(CheckWorkMilkman).."</b> para conseguir trabalhar aqui.", 5000)
		return
	end

	if Products[Selected] then
		local Need = {}
		local Consult = {}
		local Number = math.random(#Products[Selected])

		if Products[Selected][Number]["item"] then
			if vRP.MaxItens(Passport,Products[Selected][Number]["item"],Products[Selected][Number]["itemAmount"]) then
				TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
				return
			end

			if (vRP.InventoryWeight(Passport) + itemWeight(Products[Selected][Number]["item"]) * Products[Selected][Number]["itemAmount"]) > vRP.GetWeight(Passport) then
				TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				return
			end
		end

		if Products[Selected][Number]["need"] then
			local needItem = Products[Selected][Number]["need"]

			if type(needItem) == "table" then
				for k,v in pairs(needItem) do
					Consult = vRP.InventoryItemAmount(Passport,v["item"])
					if Consult[1] < v["amount"] then
						TriggerClientEvent("Notify",source,"amarelo","Necessário possuir <b>"..v["amount"].."x "..itemName(v["item"]).."</b>.",5000)
						return
					end

					Need[k] = { Consult[2],v["amount"] }
				end
			else
				local needAmount = Products[Selected][Number]["needAmount"]
				Consult = vRP.InventoryItemAmount(Passport,needItem)
				if Consult[1] < needAmount then
					TriggerClientEvent("Notify",source,"amarelo","Necessário possuir <b>"..needAmount.."x "..itemName(needItem).."</b>.",5000)
					return
				end
			end
		end

		Player(source)["state"]["Buttons"] = true
		Active[Passport] = os.time() + Products[Selected][Number]["timer"]
		TriggerClientEvent("Progress",source,"Produzindo",Products[Selected][Number]["timer"] * 1000)
		vRPC.stopAnim(source,false)

		if Selected == "tablecoke" then
			vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
		elseif Selected == "paper" then
			vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
		elseif Selected == "tablemeth" then
			vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
		elseif Selected == "tableweed" then
			vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
		elseif Selected == "milkBottle" then
			vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			vRP.PutExperience(Passport, ExperienceWorkMilkman, LevelExperienceWorkMilkman)
		elseif Selected == "fishfillet" then
			vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
		elseif Selected == "marshmallow" then
			vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
		elseif Selected == "animalmeat" then
			vRPC.playAnim(source,false,{"anim@amb@business@coc@coc_unpack_cut@","fullcut_cycle_v6_cokecutter"},true)
		elseif Selected == "emptybottle" then
			vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
		elseif Selected == "tablecoke" then
			vRPC.playAnim(source, false, { "anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_v6_cokecutter" }, true)

			if vTASKBAR.taskThree(source) then
				TriggerClientEvent("Notify", source, "verde", "Você acertou na mistura.", 5000)
			else
				local Coords = vRP.GetEntityCoords(source)
				TriggerClientEvent("vRP:CoordExplosion", source, Coords["x"], Coords["y"], Coords["z"])
			end
		elseif Selected == "tablemeth" then
			if vTASKBAR.taskThree(source) then
				vRPC.playAnim(source, false, { "anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_v6_cokecutter" }, true)
				TriggerClientEvent("Notify", source, "verde", "Você acertou na mistura.", 5000)
			else
				local Coords = vRP.GetEntityCoords(source)
				TriggerClientEvent("vRP:CoordExplosion", source, Coords["x"], Coords["y"], Coords["z"])
			end
		elseif Selected == "tableweed" then
			vRPC.playAnim(source, false, { "anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_v6_cokecutter" }, true)

			if vTASKBAR.taskThree(source) then
				TriggerClientEvent("Notify", source, "verde", "Você acertou na mistura.", 5000)
			else
				local Coords = vRP.GetEntityCoords(source)
				TriggerClientEvent("vRP:CoordExplosion", source, Coords["x"], Coords["y"], Coords["z"])
			end
		else
			vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
		end

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Player(source)["state"]["Buttons"] = false
				Active[Passport] = nil
				local Points = 0

				if Selected ~= "scanner" then
					vRPC.stopAnim(source,false)
				end

				if Products[Selected][Number]["need"] then
					if type(Products[Selected][Number]["need"]) == "table" then
						for k,v in pairs(Need) do
							local Split = splitString(v[1],"-")
							if Split[1] == "weedleaf" and Split[2] ~= nil then
								Points = Split[2]
							end

							vRP.RemoveItem(Passport,v[1],v[2],false)
						end
					else
						vRP.RemoveItem(Passport,Consult[2],needAmount,false)
					end
				end

				if Products[Selected][Number]["item"] then
					if Selected == "tableweed" then
						vRP.GenerateItem(Passport,Products[Selected][Number]["item"].."-"..Points,Products[Selected][Number]["itemAmount"],true)
					else
						vRP.GenerateItem(Passport,Products[Selected][Number]["item"],Products[Selected][Number]["itemAmount"],true)
					end
				end
			end

			Wait(100)
		until not Active[Passport]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RemoveTyres(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and Entity[2] ~= "veto" and Entity[2] ~= "veto2" then
		if not vCLIENT.checkWeapon(source,"WEAPON_WRENCH") then
			TriggerClientEvent("Notify",source,"amarelo","<b>Chave Inglesa</b> não encontrada.",5000)
			return
		end

		local Vehicle = NetworkGetEntityFromNetworkId(Entity[4])
		if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
			if vCLIENT.tyreHealth(source,Entity[4],Entity[5]) == 1000.0 then
				if vRP.MaxItens(Passport,"tyres",1) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					return
				end

				if vRP.PassportPlate(Entity[1]) then
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)
					vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

					if vTASKBAR.taskThree(source) then
						Active[Passport] = os.time() + 10
						TriggerClientEvent("Progress",source,"Removendo",10000)

						repeat
							if os.time() >= parseInt(Active[Passport]) then
								Active[Passport] = nil

								local Vehicle = NetworkGetEntityFromNetworkId(Entity[4])
								if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
									if vCLIENT.tyreHealth(source,Entity[4],Entity[5]) == 1000.0 then
										TriggerClientEvent("inventory:explodeTyres",source,Entity[4],Entity[1],Entity[5])
										vRP.GenerateItem(Passport,"tyres",1,true)
									end
								end
							end

							Wait(100)
						until not Active[Passport]
					end

					Player(source)["state"]["Buttons"] = false
					vRPC.Destroy(source)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DRINK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Drink")
AddEventHandler("inventory:Drink",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.CreateObjects(source,"amb@world_human_drinking@coffee@male@idle_a","idle_c","prop_plastic_cup_02",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRP.UpgradeThirst(Passport,15)
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEALPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.StealPeds()
    local source = source
    local Passport = vRP.Passport(source)
    
    if Passport then
		local Rand = math.random(#StealPeds)
		if math.random(250) <= StealPeds[Rand]["rand"] then
		local Amount = math.random(StealPeds[Rand]["min"],StealPeds[Rand]["max"])

        if vRP.MaxItens(Passport, StealPeds[Rand]["item"], Amount) then
            TriggerClientEvent("Notify", source, "amarelo", "Limite atingido.", 5000)
            return true
        end

        	if (vRP.InventoryWeight(Passport) + itemWeight(StealPeds[Rand]["item"]) * Amount) <= vRP.GetWeight(Passport) then
            	vRP.GenerateItem(Passport, StealPeds[Rand]["item"], Amount, true)

				if math.random(100) >= 25 then
					local Coords = vRP.GetEntityCoords(source)
					local Service = vRP.NumPermission(StealPedsPermission)

					for Passports, Sources in pairs(Service) do
						Citizen.Wait(0)
						vRPC.PlaySound(Sources, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
						TriggerClientEvent("NotifyPush", Sources, { code = 32, title = "Assalto a Americanos", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Ligação Anônima", color = 16 })
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Mochila Sobrecarregada Sua recompensa caiu no chão.",5000)
				exports["inventory"]:Drops(Passport,source, StealPeds[Rand]["item"], Amount )
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:ROLLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:RollVehicle")
AddEventHandler("player:RollVehicle",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 20
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Desvirando",20000)
		vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source)
				Player(source)["state"]["Buttons"] = false

				local Players = vRPC.Players(source)
				for _,v in pairs(Players) do
					async(function()
						TriggerClientEvent("target:RollVehicle",v,Entity[4])
					end)
				end
			end

			Wait(100)
		until not Active[Passport]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERSTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RegistersTimers(Number)
    local source = source
    local Passport = vRP.Passport(source)

	for _, group in ipairs(NoThefeRegister) do
		if vRP.HasGroup(Passport, group) then
			TriggerClientEvent("Notify", source, "vermelho", "Você não pode fazer isso.", 5000)
			return false
		end
	end

    if Passport then
        local Service, Total = vRP.NumPermission(RegisterPermission)
        if Total >= RegisterNeed then
            TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
            Player(source)["state"]["Buttons"] = false
            return false
        end

        if vRP.ConsultItem(Passport, RegisterRequired, 1) then
            if vTASKBAR.taskLockpick(source) then
                if Registers[Number] then
                    if GetGameTimer() < Registers[Number] then
                        TriggerClientEvent("Notify", source, "amarelo", "Sistema indisponível no momento.", 5000)
                        return false
                    else
                        InitRegisters(Number, source)
                        return true
                    end
                else
                    InitRegisters(Number, source)
                    return true
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Falha ao manipular o lockpick!", 5000)
                
                local Ped = GetPlayerPed(source)
                local Coords = GetEntityCoords(Ped)
                local Service = vRP.NumPermission(RegisterPermission)
                for Passports, Sources in pairs(Service) do
                    async(function()
                        TriggerClientEvent("NotifyPush", Sources, {
                            code = 31,
                            title = "Tentativa Roubo Registradora",
                            x = Coords.x,
                            y = Coords.y,
                            z = Coords.z,
                            criminal = "Alarme de segurança",
                            time = "Recebido às " .. os.date("%H:%M"),
                            color = 44
                        })
                    end)
                end

                return false
            end
        else
            TriggerClientEvent("Notify", source, "amarelo", "<b>Lockpick</b> não encontrado.", 5000)
            return false
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITREGISTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function InitRegisters(Number, source)
    Registers[Number] = os.time() + RegisterCooldownTime

    local Ped = GetPlayerPed(source)
    local Coords = GetEntityCoords(Ped)

    local Service = vRP.NumPermission(RegisterPermission)
    for Passports, Sources in pairs(Service) do
        async(function()
            TriggerClientEvent("NotifyPush", Sources, {
                code = 31,
                title = "Roubo Caixa Registradora",
                x = Coords["x"],
                y = Coords["y"],
                z = Coords["z"],
                criminal = "Alarme de segurança",
                time = "Recebido às " .. os.date("%H:%M"),
                color = 44
            })
        end)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTERSPAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RegistersPay()
	local source = source
	local Passport = vRP.Passport(source)
	local coords = GetEntityCoords(GetPlayerPed(source))
	local coordText = string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z)
	if Passport then
		Active[Passport] = os.time() + 30
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Roubando",30000)
		vRPC.playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source)
				Player(source)["state"]["Buttons"] = false

				vRP.GenerateItem(Passport,RegisterItem,RegisterAmount,true)
				vRP.UpgradeStress(Passport,math.random(1,2))
				TriggerEvent("Wanted",source,Passport,20)
				TriggerClientEvent("player:Residuals",source,"Resíduo de Arrombamento.")
				TriggerEvent("Discord", "RobberysRegisters", "**[Roubo a Caixa Registradora]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Dinheiro Sujo Recebido:** " .. RegisterAmount .. "\n" .. "**Coordenadas:** " .. coordText .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			end

			Wait(100)
		until not Active[Passport]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Experience(Category)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		return vRP.GetExperience(Passport,Category)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckWork(Work)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.GetWork(Passport) == Work then
			return true
		else
			TriggerClientEvent("Notify", source, "amarelo", "Você precisa ter a sua <b>Carteira de Trabalho</b> assinada no emprego de <b>"..ClassWork(Work).."</b> para conseguir trabalhar aqui.", 5000)
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET:GARBAGEMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("preset:garbageman")
AddEventHandler("preset:garbageman", function(Number)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Model = vRP.ModelPlayer(source)

        if Model == "mp_m_freemode_01" or Model == "mp_f_freemode_01" then
            TriggerClientEvent("skinshop:Apply", source, PresetGarbageman[Model])
			TriggerClientEvent('Notify', source, 'verde', 'Você vestiu o Traje de Lixeiro', 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET:FISHERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("preset:fisherman")
AddEventHandler("preset:fisherman", function(Number)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Model = vRP.ModelPlayer(source)

        if Model == "mp_m_freemode_01" or Model == "mp_f_freemode_01" then
            TriggerClientEvent("skinshop:Apply", source, PresetFisherman[Model])
			TriggerClientEvent('Notify', source, 'verde', 'Você vestiu o Traje de Lixeiro', 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET:HUNTING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("preset:hunting")
AddEventHandler("preset:hunting", function(Number)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Model = vRP.ModelPlayer(source)

        if Model == "mp_m_freemode_01" or Model == "mp_f_freemode_01" then
            TriggerClientEvent("skinshop:Apply", source, PresetHunting[Model])
			TriggerClientEvent('Notify', source, 'verde', 'Você vestiu o Traje de Caçador', 5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:PAINTVEHICLE
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
-- INVENTORY:BLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Blackout")
AddEventHandler("inventory:Blackout",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("Notify",source,"amarelo","Sistema indisponivel.",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BUFFSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:BuffServer",function(source,Passport,Name,Amount)
	if not Buffs[Name][Passport] then
		Buffs[Name][Passport] = 0
	end

	if os.time() >= Buffs[Name][Passport] then
		Buffs[Name][Passport] = os.time() + Amount
	else
		Buffs[Name][Passport] = Buffs[Name][Passport] + Amount

		if (Buffs[Name][Passport] - os.time()) >= 3600 then
			Buffs[Name][Passport] = os.time() + 3600
		end
	end

	TriggerClientEvent("hud:"..Name,source,Buffs[Name][Passport] - os.time())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPS
-----------------------------------------------------------------------------------------------------------------------------------------
local Amounts = 0
exports("Drops",function(Passport,source,Item,Amount)
    local Amount = parseInt(Amount,true)
    local Route = GetPlayerRoutingBucket(source)

    Amounts = Amounts + 1
    if not Drops[Route] then
        Drops[Route] = {}
    end

    local Number = 0

    repeat
        Number = Number + 1
    until not Drops[tostring(Number)]

    Drops[tostring(Number)] = {
        ["key"] = Item,
        ["amount"] = Amount,
        ["Coords"] = vCLIENT.EntityCoordsZ(source),
        ["name"] = itemName(Item),
        ["peso"] = itemWeight(Item),
        ["index"] = itemIndex(Item),
        ["days"] = 1,
        ["durability"] = 0,
        ["charges"] = nil
    }

    TriggerClientEvent("drops:Adicionar",-1,tostring(Number),Drops[tostring(Number)])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARWEAPONS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("CleanWeapons",function(Passport,Clean)
	local source = vRP.Source(Passport)
	if source then
		local Ped = GetPlayerPed(source)
		local Weapon = GetSelectedPedWeapon(Ped)

		RemoveWeaponFromPed(Ped,Weapon)
		RemoveAllPedWeapons(Ped,false)
		SetPedAmmo(Ped,Weapon,0)

		if Clean then
			Attachs[Passport] = {}
			Ammos[Passport] = {}
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	Ammos[Passport] = vRP.UserData(Passport,"Ammos")
	Attachs[Passport] = vRP.UserData(Passport,"Attachs")

	TriggerClientEvent("objects:Table", source, Objects)
    TriggerClientEvent("drops:Table", source, Drops)

	for Name,_ in pairs(Buffs) do
		if Buffs[Name] and Buffs[Name][Passport] and os.time() < Buffs[Name][Passport] then
			TriggerClientEvent("hud:"..Name,source,Buffs[Name][Passport] - os.time())
		end
	end

end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Ammos[Passport] and Attachs[Passport] then
		if Temporary[Passport] then
			Ammos[Passport] = Temporary[Passport]["Ammos"]
			Attachs[Passport] = Temporary[Passport]["Attachs"]
			Temporary[Passport] = nil
		end

		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Attachs", dvalue = json.encode(Attachs[Passport]) })
		vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Ammos", dvalue = json.encode(Ammos[Passport]) })

		Attachs[Passport] = nil
		Ammos[Passport] = nil
	end

	if Active[Passport] then
		Active[Passport] = nil
	end

	if verifyObjects[Passport] then
		verifyObjects[Passport] = nil
	end

	if verifyAnimals[Passport] then
		verifyAnimals[Passport] = nil
	end

	if Healths[Passport] then
		Healths[Passport] = nil
	end

	if Armors[Passport] then
		Armors[Passport] = nil
	end

	if Heroin[Passport] then
		Heroin[Passport] = nil
	end

	if Scanners[Passport] then
		Scanners[Passport] = nil
	end

	if Carry[Passport] then
		TriggerClientEvent("player:Commands",Carry[Passport],false)
		vRPC.Destroy(Carry[Passport])
		Carry[Passport] = nil
	end

	if Drugs[Passport] then
		Drugs[Passport] = nil
	end
end)
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- -- OBJECTS
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Objects = {
--     -- MEDIC
-- 	["1"] = { x = 594.59, y = 146.52, z = 97.30, h = 70.04, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["2"] = { x = 660.44, y = 268.29, z = 102.04, h = 152.09, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["3"] = { x = 552.54, y = -198.45, z = 53.75, h = 89.32, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["4"] = { x = 339.75, y = -580.95, z = 73.42, h = 67.19, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["5"] = { x = 696.12, y = -965.69, z = 23.26, h = 271.33, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["6"] = { x = -2235.42, y = 363.52, z = 173.91, h = 23.73, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["7"] = { x = 1382.1, y = -2081.97, z = 51.25, h = 220.16, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["8"] = { x = 589.32, y = -2802.73, z = 5.32, h = 328.01, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["9"] = { x = -453.19, y = -2810.47, z = 6.56, h = 225.82, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["10"] = { x = -1007.18, y = -2836.12, z = 13.20, h = 149.3, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["11"] = { x = -2018.21, y = -361.03, z = 47.36, h = 324.55, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["12"] = { x = -1727.77, y = 250.26, z = 61.65, h = 24.7, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["13"] = { x = -1089.6, y = 2717.05, z = 18.33, h = 40.52, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["14"] = { x = 321.27, y = 2874.98, z = 42.71, h = 27.62, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["15"] = { x = 1163.47, y = 2722.09, z = 37.26, h = 179.11, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["16"] = { x = 1745.86, y = 3326.69, z = 40.30, h = 115.55, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["17"] = { x = 2013.4, y = 3934.36, z = 31.65, h = 236.38, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["18"] = { x = 2526.3, y = 4191.6, z = 44.53, h = 236.44, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["19"] = { x = 2874.05, y = 4861.57, z = 61.35, h = 87.57, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["20"] = { x = 1985.16, y = 6200.39, z = 41.33, h = 330.21, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["21"] = { x = 1552.97, y = 6610.24, z = 2.12, h = 145.64, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["22"] = { x = -298.32, y = 6392.66, z = 29.87, h = 302.99, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["23"] = { x = -813.88, y = 5384.45, z = 33.77, h = 356.87, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["24"] = { x = -1606.5, y = 5259.26, z = 1.35, h = 114.45, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["25"] = { x = -199.22, y = 3638.8, z = 63.70, h = 39.84, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["26"] = { x = -1487.45, y = 2688.99, z = 2.94, h = 317.89, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["27"] = { x = -3266.12, y = 1139.82, z = 1.91, h = 249.17, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["28"] = { x = 170.71, y = -1070.94, z = 28.5, h = 339.6, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["29"] = { x = 487.23, y = -1093.93, z = 28.71, h = 0.74, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["30"] = { x = 584.63, y = -1419.69, z = 18.52, h = 180.41, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["31"] = { x = 694.07, y = -1453.5, z = 19.03, h = 0.45, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["32"] = { x = 892.49, y = -2490.3, z = 28.88, h = 175.48, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["33"] = { x = 1463.09, y = -2613.91, z = 48.17, h = 76.65, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["34"] = { x = 1877.42, y = -1065.71, z = 80.22, h = 97.79, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["35"] = { x = 2557.67, y = -598.5, z = 64.23, h = 12.71, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["36"] = { x = 2546.8, y = 395.31, z = 107.92, h = 268.3, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["37"] = { x = 2074.59, y = 1403.29, z = 74.88, h = 300.3, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["38"] = { x = 2405.44, y = 2903.85, z = 39.67, h = 217.41, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["39"] = { x = 2895.84, y = 3735.4, z = 43.5, h = 289.37, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["40"] = { x = 1677.25, y = 4882.36, z = 46.62, h = 59.7, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["41"] = { x = -437.08, y = 6339.84, z = 12.06, h = 216.59, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["42"] = { x = 431.15, y = 6472.57, z = 28.08, h = 140.5, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["43"] = { x = -2303.74, y = 3389.16, z = 30.56, h = 324.26, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["44"] = { x = -2096.92, y = 3258.17, z = 32.12, h = 239.97, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["45"] = { x = -1773.55, y = 2995.46, z = 32.11, h = 330.02, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["46"] = { x = -2086.61, y = 2816.89, z = 32.27, h = 354.52, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
-- 	["47"] = { x = -1511.83, y = 1520.27, z = 114.59, h = 255.31, object = "sm_prop_smug_crate_s_medical", item = "", Distance = 50, mode = "Medic" },
--     -- WEAPONS
-- 	["48"] = { x = 574.01, y = 132.56, z = 98.48, h = 70.99, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["49"] = { x = 344.79, y = 929.2, z = 202.44, h = 268.09, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["50"] = { x = -123.8, y = 1896.67, z = 196.34, h = 358.95, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["51"] = { x = -1099.85, y = 2703.51, z = 21.99, h = 221.35, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["52"] = { x = -2198.91, y = 4243.21, z = 46.92, h = 128.84, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["53"] = { x = -1487.02, y = 4983.14, z = 62.67, h = 174.11, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["54"] = { x = 1346.49, y = 6396.73, z = 32.42, h = 90.94, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["55"] = { x = 2535.72, y = 4661.39, z = 33.08, h = 316.4, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["56"] = { x = 1155.62, y = -1334.48, z = 33.72, h = 174.97, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["57"] = { x = 1116.06, y = -2498.07, z = 32.37, h = 193.39, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["58"] = { x = 261.06, y = -3135.82, z = 4.8, h = 88.83, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["59"] = { x = -1619.81, y = -1035.0, z = 12.16, h = 50.84, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["60"] = { x = -3420.87, y = 977.0, z = 10.91, h = 226.29, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["61"] = { x = -1909.53, y = 4624.93, z = 56.07, h = 135.57, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["62"] = { x = 894.51, y = 3211.45, z = 38.09, h = 273.04, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["63"] = { x = 1791.71, y = 4602.84, z = 36.69, h = 185.86, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["64"] = { x = 464.8, y = 6462.03, z = 28.76, h = 334.71, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["65"] = { x = 63.22, y = 6323.67, z = 37.87, h = 301.22, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["66"] = { x = -736.64, y = 5594.98, z = 40.66, h = 268.78, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["67"] = { x = 720.76, y = 2330.87, z = 50.76, h = 179.99, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["68"] = { x = 1909.47, y = 611.47, z = 177.41, h = 65.57, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["69"] = { x = 1796.6, y = -1350.06, z = 98.75, h = 61.5, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["70"] = { x = 955.32, y = -3101.26, z = 4.91, h = 266.38, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["71"] = { x = -1306.41, y = -3387.9, z = 12.95, h = 59.92, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["72"] = { x = -1219.66, y = -2079.82, z = 13.16, h = 351.04, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["73"] = { x = -1203.53, y = -1804.25, z = 2.91, h = 245.4, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["74"] = { x = -720.47, y = -399.49, z = 33.9, h = 351.27, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["75"] = { x = -503.39, y = -1438.17, z = 13.16, h = 346.71, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["76"] = { x = 1398.24, y = 2117.57, z = 104.02, h = 131.36, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["77"] = { x = -1811.62, y = 3104.09, z = 31.85, h = 60.36, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["78"] = { x = -1812.86, y = 3101.95, z = 31.85, h = 62.1, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["79"] = { x = -1850.29, y = 3156.66, z = 31.82, h = 150.22, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["80"] = { x = -2052.86, y = 3173.31, z = 31.82, h = 240.03, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["81"] = { x = -2409.94, y = 3355.95, z = 31.83, h = 61.29, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
-- 	["82"] = { x = -2450.39, y = 2946.63, z = 31.97, h = 330.0, object = "prop_mb_crate_01a", item = "", Distance = 50, mode = "Weapons" },
--     -- SUPPLIES
-- 	["83"] = { x = -257.5, y = -966.54, z = 30.22, h = 26.06, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["84"] = { x = -2682.86, y = 2304.87, z = 20.85, h = 164.19, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["85"] = { x = -1282.33, y = 2559.98, z = 17.4, h = 148.06, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["86"] = { x = 159.65, y = 3118.8, z = 42.44, h = 16.37, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["87"] = { x = 1061.43, y = 3527.62, z = 33.15, h = 255.93, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["88"] = { x = 2370.22, y = 3156.55, z = 47.21, h = 221.77, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["89"] = { x = 2520.51, y = 2637.83, z = 36.95, h = 314.33, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["90"] = { x = 2572.37, y = 477.44, z = 107.68, h = 269.49, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["91"] = { x = 1223.15, y = -1079.56, z = 37.53, h = 123.38, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["92"] = { x = 1048.49, y = -247.53, z = 68.66, h = 149.33, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["93"] = { x = 499.41, y = -529.38, z = 23.76, h = 262.13, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["94"] = { x = 592.53, y = -2115.87, z = 4.76, h = 100.96, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["95"] = { x = 523.43, y = -2578.67, z = 13.82, h = 318.38, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["96"] = { x = -2.98, y = -1299.67, z = 28.28, h = 359.37, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["97"] = { x = 183.11, y = -1086.93, z = 28.28, h = 348.57, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["98"] = { x = 713.88, y = -850.95, z = 23.3, h = 271.63, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["99"] = { x = -2438.82, y = 2999.82, z = 32.07, h = 194.35, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["100"] = { x = -2440.04, y = 2999.46, z = 32.07, h = 194.41, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["101"] = { x = -2092.59, y = 3113.14, z = 31.82, h = 240.25, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["102"] = { x = -1824.95, y = 3016.0, z = 31.82, h = 329.62, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["103"] = { x = -202.03, y = 3651.99, z = 50.74, h = 192.39, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["104"] = { x = -203.41, y = 3651.71, z = 50.74, h = 192.96, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["105"] = { x = 2007.81, y = 4964.86, z = 40.71, h = 158.28, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["106"] = { x = 1904.26, y = 4930.73, z = 47.97, h = 156.61, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["107"] = { x = 1702.14, y = 4819.3, z = 40.96, h = 97.05, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["108"] = { x = 2030.66, y = 4727.43, z = 40.61, h = 294.35, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["109"] = { x = 2122.12, y = 4784.69, z = 39.98, h = 116.71, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["110"] = { x = 2177.23, y = 2169.39, z = 116.31, h = 229.64, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["111"] = { x = 2395.2, y = 2032.72, z = 90.35, h = 318.06, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["112"] = { x = 2619.31, y = 1691.36, z = 26.6, h = 270.01, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["113"] = { x = 1454.52, y = -1680.69, z = 65.03, h = 25.31, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["114"] = { x = 1453.05, y = -1681.37, z = 64.96, h = 24.93, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["115"] = { x = 240.42, y = -1864.8, z = 25.82, h = 49.31, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["116"] = { x = -139.01, y = -1995.56, z = 21.81, h = 181.56, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["117"] = { x = -343.54, y = -1333.09, z = 36.31, h = 89.4, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["118"] = { x = -350.99, y = -1333.15, z = 36.31, h = 269.98, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["119"] = { x = -346.45, y = -1337.38, z = 36.31, h = 359.9, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	["120"] = { x = -267.45, y = -971.56, z = 30.22, h = 25.86, object = "gr_prop_gr_rsply_crate03a", item = "", Distance = 50, mode = "Supplies" },
-- 	-- ROBBERY CLOTHESHOP
-- 	["121"] = { x = 70.27, y = -1389.11, z = 29.13, h = 90.28, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["122"] = { x = -706.01, y = -150.49, z = 37.17, h = 28.61, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["123"] = { x = -167.66, y = -301.67, z = 39.49, h = 161.34, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["124"] = { x = -821.69, y = -1067.22, z = 11.08, h = 31.23, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["125"] = { x = -1186.62, y = -772.55, z = 17.09, h = 215.93, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["126"] = { x = -1446.85, y = -240.38, z = 49.57, h = 316.88, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["127"] = { x = 5.53, y = 6506.07, z = 31.63, h = 222.68, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["128"] = { x = 1699.51, y = 4819.72, z = 41.82, h = 277.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["129"] = { x = 117.83, y = -223.56, z = 54.31, h = 70.89, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["130"] = { x = 621.58, y = 2765.81, z = 41.84, h = 275.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["131"] = { x = 1200.46, y = 2715.37, z = 37.98, h = 0.24, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["132"] = { x = -3178.48, y = 1044.46, z = 20.62, h = 66.61, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["133"] = { x = -1102.05, y = 2716.93, z = 18.86, h = 40.85, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["134"] = { x = 430.72, y = -810.01, z = 29.25, h = 270.35, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	-- ROBBERY WEAPONSHOP
-- 	["135"] = { x = 1688.78, y = 3759.13, z = 34.46, h = 47.5, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["136"] = { x = 256.35, y = -47.51, z = 69.7, h = 249.76, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["137"] = { x = 846.13, y = -1036.62, z = 27.95, h = 178.74, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["138"] = { x = -335.18, y = 6083.29, z = 31.21, h = 45.57, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["139"] = { x = -665.98, y = -932.24, z = 21.58, h = 358.38, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["140"] = { x = -1301.93, y = -391.36, z = 36.45, h = 255.85, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["141"] = { x = -1122.59, y = 2698.25, z = 18.31, h = 42.82, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["142"] = { x = 2571.67, y = 291.28, z = 108.49, h = 180.02, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["143"] = { x = 2571.66, y = 291.29, z = 108.49, h = 181.06, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["144"] = { x = 19.57, y = -1103.0, z = 29.55, h = 339.07, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["145"] = { x = 813.92, y = -2160.34, z = 29.37, h = 179.33, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	-- ROBBERY BARBERSHOP
-- 	["146"] = { x = -807.9, y = -180.83, z = 37.32, h = 299.3, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["147"] = { x = 139.56, y = -1704.12, z = 29.05, h = 320.25, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["148"] = { x = -1278.11, y = -1116.66, z = 6.75, h = 270.07, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["149"] = { x = 1928.89, y = 3734.04, z = 32.6, h = 29.2, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["150"] = { x = 1217.05, y = -473.45, z = 65.96, h = 255.89, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["151"] = { x = -34.08, y = -157.01, z = 56.83, h = 159.63, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["152"] = { x = -274.5, y = 6225.27, z = 31.45, h = 225.27, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	-- ROBBERY TATTOOSHOP
-- 	["153"] = { x = 1327.98, y = -1654.78, z = 52.03, h = 218.71, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["154"] = { x = -1149.04, y = -1428.64, z = 4.71, h = 215.2, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["155"] = { x = 322.01, y = 186.24, z = 103.34, h = 339.28, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["156"] = { x = -3175.64, y = 1075.54, z = 20.58, h = 65.96, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["157"] = { x = 1866.01, y = 3748.07, z = 32.79, h = 299.38, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	["158"] = { x = -295.51, y = 6199.21, z = 31.24, h = 133.05, object = "p_v_43_safe_s", item = "", Distance = 50 },
-- 	-- OTHER OBJECTS
-- 	["9998"] = { x = -584.12, y = -1062.95, z = 22.38, h = 33.14, object = "bkr_prop_fakeid_clipboard_01a", item = "", Distance = 15 },
-- 	["9999"] = { x = -1188.9, y = -897.82, z = 13.95, h = 130.04, object = "bkr_prop_fakeid_clipboard_01a", item = "", Distance = 15 }
-- }