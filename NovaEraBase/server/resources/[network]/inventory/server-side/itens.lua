-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESENTE
-----------------------------------------------------------------------------------------------------------------------------------------
Presente = {
	{ ["Item"] = "dollarsroll", ["Min"] = 10000, ["Max"] = 14000 },
	{ ["Item"] = "dollars", ["Min"] = 5000, ["Max"] = 7500 },
	{ ["Item"] = "presente", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "bandage", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "medkit", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "meth", ["Min"] = 20, ["Max"] = 40 },
	{ ["Item"] = "cocaine", ["Min"] = 20, ["Max"] = 40 },
	{ ["Item"] = "lean", ["Min"] = 20, ["Max"] = 40 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOXES
-----------------------------------------------------------------------------------------------------------------------------------------
Boxes = {
	{ ["Item"] = "sapphire_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "emerald_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "ruby_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "gold_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "iron_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "lead_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "sulfur_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "tin_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "diamond_pure", ["Min"] = 8, ["Max"] = 16 },
	{ ["Item"] = "copper_pure", ["Min"] = 8, ["Max"] = 16 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEODES
-----------------------------------------------------------------------------------------------------------------------------------------
Geodes = {
	{ ["Item"] = "sapphire_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "emerald_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "ruby_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "gold_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "iron_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "lead_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "sulfur_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "tin_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "gunpowder", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "diamond_pure", ["Min"] = 2, ["Max"] = 4 },
	{ ["Item"] = "copper_pure", ["Min"] = 2, ["Max"] = 4 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIVERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
DiverList = {
    { ["Item"] = "gold_pure", ["Min"] = 5, ["Max"] = 10 },
    { ["Item"] = "ruby_pure", ["Min"] = 5, ["Max"] = 10 },
    { ["Item"] = "glassbottle", ["Min"] = 3, ["Max"] = 6 },
	{ ["Item"] = "diamond_pure", ["Min"] = 5, ["Max"] = 10 },
	{ ["Item"] = "copper_pure", ["Min"] = 5, ["Max"] = 10 },
	{ ["Item"] = "sapphire_pure", ["Min"] = 5, ["Max"] = 10 },
	{ ["Item"] = "emerald_pure", ["Min"] = 5, ["Max"] = 10 },
    { ["Item"] = "dollars", ["Min"] = 275, ["Max"] = 575 },
	{ ["Item"] = "binoculars", ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "camera", ["Min"] = 1, ["Max"] = 2 },
	{ ["Item"] = "silvercoin", ["Min"] = 30, ["Max"] = 50 },
	{ ["Item"] = "goldcoin", ["Min"] = 30, ["Max"] = 50 },
	{ ["Item"] = "watch", ["Min"] = 2, ["Max"] = 4 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- USE
-----------------------------------------------------------------------------------------------------------------------------------------
Use = {
	["ration"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if vRP.GetWork(Passport) ~= CheckWorkHunting then
			TriggerClientEvent("Notify", source, "amarelo", "Você precisa ter a sua <b>Carteira de Trabalho</b> assinada no emprego de <b>"..ClassWork(CheckWorkHunting).."</b> para conseguir trabalhar.", 5000)
			return
		end

		local Coords = vRP.GetEntityCoords(source)
		for _, v in pairs(HunterInfluences) do
			local Distance = #(Coords - vec3(v[1], v[2], v[3]))
			if Distance <= v[4] then
				if not vRPC.InsideVehicle(source) and not vCLIENT.CheckRation(source) then
					Active[Passport] = os.time() + 5
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close", source)
					TriggerClientEvent("Progress", source, "Chamando animal", 5000)
					vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)

					repeat
						if Active[Passport] and os.time() >= parseInt(Active[Passport]) then
							Active[Passport] = nil
							vRPC.stopAnim(source, false)
							Player(source)["state"]["Buttons"] = false

							if vRP.TakeItem(Passport, Full, 1, true, Slot) then
								Player(source)["state"]["Hunting"] = true
								TriggerClientEvent("inventory:Ration", source, Coords)
							end
						end

						Wait(100)
					until not Active[Passport]

					return
				end
			end
		end

		TriggerClientEvent("Notify", source, "amarelo", "Precisa estar na Área de <b>Caça</b>.", 5000)
	end,

	["combo1"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"hamburger",2,true)
				vRP.GenerateItem(Passport,"water",2,true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["combo2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"hamburger4",3,true)
				vRP.GenerateItem(Passport,"water",1,true)
				vRP.GenerateItem(Passport,"orangejuice",2,true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["combo3"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"hamburger5",5,true)
				vRP.GenerateItem(Passport,"chickenfries",2,true)
				vRP.GenerateItem(Passport,"water",2,true)
				vRP.GenerateItem(Passport,"milkshake",2,true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["woodenbarrel"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if not vCLIENT.checkWeapon(source, "WEAPON_CROWBAR") then
			TriggerClientEvent("Notify", source, "amarelo", "Coloque o <b>"..itemName("WEAPON_CROWBAR").."</b> em mãos.", 5000)
			return
		end
	
		if vRP.TakeItem(Passport, Full, 1, true, Slot) then
			local Rand = math.random(#DiverList)
			local Amount = math.random(DiverList[Rand]["Min"], DiverList[Rand]["Max"])
			vRP.GenerateItem(Passport, DiverList[Rand]["Item"], Amount, true)
			TriggerClientEvent("inventory:Update", source, "Backpack")
		end
	end,
	
    ["mochilapremiump"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        local index = 'mochilapremiump-50'

        TriggerClientEvent("inventory:Close",source)
        TriggerClientEvent("chest:Open", source, index, "Backpack")
    end,

    ["mochilapremiumm"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        local index = "mochilapremiumm-100"

        TriggerClientEvent("inventory:Close",source)
        TriggerClientEvent("chest:Open", source, index, "Backpack")
    end,

    ["mochilapremiumg"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        local index = "mochilapremiumg-150"

        TriggerClientEvent("inventory:Close",source)
        TriggerClientEvent("chest:Open", source, index, "Backpack")
    end,
	
	["scratchcard"] = function(source,Passport,Amount,Slot,Full,Item,Split)
        if vRP.TakeItem(Passport,Full,1,true,Slot) then
            TriggerClientEvent("inventory:Close",source)

            TriggerClientEvent("cards:Open", source)
        end
    end,
	
	["contrabandbox1"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"plastic",math.random(3,5),true)
				vRP.GenerateItem(Passport,"techtrash",math.random(3,5),true)
				vRP.GenerateItem(Passport,"explosives",math.random(3,5),true)
				vRP.GenerateItem(Passport,"aluminum",math.random(3,5),true)
				vRP.GenerateItem(Passport,"iron_pure",math.random(3,5),true)
				vRP.GenerateItem(Passport,"fabric",math.random(3,5),true)
				vRP.GenerateItem(Passport,"sheetmetal",math.random(3,5),true)
				vRP.GenerateItem(Passport,"tarp",math.random(3,5),true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["presente"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local Selected = math.random(#Presente)
		local Rand = math.random(Presente[Selected]["Min"], Presente[Selected]["Max"])
	
		if (vRP.InventoryWeight(Passport) + (itemWeight(Presente[Selected]["Item"]) * Rand)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport, Full, 1, false, Slot) then
				vRP.GenerateItem(Passport, Presente[Selected]["Item"], Rand, true)
				TriggerClientEvent("inventory:Update", source, "Backpack")
				TriggerClientEvent("Notify", source, "verde", "Parabens você ganhou <b>"..Rand.."x "..itemName(Presente[Selected]["Item"]).." </b> no seu Presente", 5000)
			end
		else
			TriggerClientEvent("Notify", source, "vermelho", "Mochila cheia.", 5000)
		end
	end,
	
	["identity"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("openIdentity", source)
	end,

	["contrabandbox2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"tin_pure",math.random(3,5),true)
				vRP.GenerateItem(Passport,"glass",math.random(3,5),true)
				vRP.GenerateItem(Passport,"plastic",math.random(3,5),true)
				vRP.GenerateItem(Passport,"techtrash",math.random(3,5),true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["ammobox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"lead_pure",math.random(5,8),true)
				vRP.GenerateItem(Passport,"copper_pure",math.random(5,8),true)
				vRP.GenerateItem(Passport,"gunpowder",math.random(5,8),true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["ammobox2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"lead_pure",math.random(5,8),true)
				vRP.GenerateItem(Passport,"copper_pure",math.random(5,8),true)
				vRP.GenerateItem(Passport,"gunpowder",math.random(5,8),true)
				vRP.GenerateItem(Passport,"wheatflour",math.random(2,5),true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["weaponbox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"copper_pure",math.random(3,6),true)
				vRP.GenerateItem(Passport,"iron_pure",math.random(3,6),true)
				vRP.GenerateItem(Passport,"pistolbody",math.random(1,2),true)
				vRP.GenerateItem(Passport,"smgbody",math.random(1,2),true)
				vRP.GenerateItem(Passport,"riflebody",math.random(1,2),true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["drone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		if vRP.ConsultItem(Passport,"dronecontrol",1) then
			if vRP.TakeItem(Passport, Full, 1, true, Slot) then

				TriggerClientEvent("Drones:UseDrone", source, {
					label = "Basit Drone 1",                      
					name = "drone",                               
					public = true,                                
					price = 10000,                                
					model = GetHashKey('ch_prop_casino_drone_02a'),       
					stats = {                        
						speed   = 1.0,            
						agility = 1.0,            
						range   = 100.0,          
						maxSpeed    = 2,             
						maxAgility  = 2,
						maxRange    = 200,
					},
					abilities = {
						infared     = true,
						nightvision = true,
						boost       = false,
						tazer       = false,
						explosive   = false,
					},
					restrictions = {}, 
				})
	
			end	
		else
			TriggerClientEvent("Notify",source,"amarelo","Precisa do <b>"..itemName("dronecontrol").."</b>.",5000)
		end
	end,

	["weedclone"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if vRP.ConsultItem(Passport, "bucket", 1) then
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close", source)
		
			local Hash = "bkr_prop_weed_med_01a"
			local Application, Coords = vRPC.objectCoords(source, Hash)
			if Application then
				if not vCLIENT.objectExist(source, Coords, Hash) then
					if vRP.TakeItem(Passport, Full, 1, false, Slot) then
						vRPC.playAnim(source, false, {"amb@prop_human_bum_bin@base", "base"}, true)
	
						if vTASKBAR.Weeds(source) then
							local Points = 0
							local Route = GetPlayerRoutingBucket(source)
	
							if Split[2] ~= nil then
								Points = parseInt(Split[2])
							end
	
							vRP.RemoveItem(Passport, "bucket", 1, true)
							exports["plants"]:Plants(Coords, Route, Points)
						end
					else
						local Service = vRP.NumPermission("Policia")
						for Passports, Sources in pairs(Service) do
							async(function()
								TriggerClientEvent("sounds:source", Sources, "crime", 0.5)
								TriggerClientEvent("NotifyPush", Sources, { 
									code = 20, 
									title = "Manejo de Drogas", 
									x = Coords["x"], 
									y = Coords["y"], 
									z = Coords["z"], 
									criminal = "Ligação Anônima", 
									color = 16 
								})
							end)
						end
					end

					vRPC.Destroy(source)
				end
			end
	
			Player(source)["state"]["Buttons"] = false
		else
			TriggerClientEvent("Notify", source, "amarelo", "Você precisa de <b>1x " .. itemName("bucket") .. "</b>.", 5000)
		end
	end,

	["mushseed"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local RandMush = math.random(2)
		local MushType = "prop_stoneshroom"..RandMush

		local Hash = MushType
		local Application, Coords = vRPC.ObjectControlling(source, Hash)
		if Application then
			if not vCLIENT.objectExist(source, Coords, Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)

					local Points = 0
					local Owner = vRP.Passport(source)
					local Route = GetPlayerRoutingBucket(source)

					if Split[2] ~= nil then
						Points = parseInt(Split[2])
					end

					exports["plants"]:Plants(Hash, Owner, Coords, Route, Points, Full)
					vRPC.Destroy(source)
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["medicbag"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close", source)
		
		local Hash = "xm_prop_x17_bag_med_01a"
		local application, Coords, heading = vRPC.objectCoords(source, Hash)
		if application then
			if not vCLIENT.objectExist(source, Coords, Hash) then
				if vRP.TakeItem(Passport, Full, 1, true, Slot) then
					local Number = 0
					
					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]
					
					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]),
					z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 50,
					mode = "4" }
					TriggerClientEvent("objects:Adicionar", -1, tostring(Number), Objects[tostring(Number)])
				end
			end
		end
		
		Player(source)["state"]["Buttons"] = false
	end,

	["medicbed"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close", source)
		
		local Hash = "prop_ld_binbag_01"
		local application, Coords, heading = vRPC.objectCoords(source, Hash)
		if application then
			if not vCLIENT.objectExist(source, Coords, Hash) then
				local mHash = GetHashKey(Hash)
				local Object = CreateObject(mHash, Coords["x"], Coords["y"], Coords["z"] - 0.86, true, true, false)
				
				while not DoesEntityExist(Object) do
					Wait(100)
				end
				
				if DoesEntityExist(Object) then
					SetEntityHeading(Object, heading)
					FreezeEntityPosition(Object, true)
				end
			end
		end
		
		Player(source)["state"]["Buttons"] = false
	end,		

	["c4"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		for _, group in ipairs(NoThefeATM) do
			if vRP.HasGroup(Passport, group) then
				TriggerClientEvent("Notify", source, "vermelho", "Você não pode fazer isso.", 5000)
				return false
			end
		end

		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close", source)

		local Hash = "ch_prop_ch_ld_bomb_01a"
		local Application, Coords, Heading = vRPC.objectCoords(source, Hash)
		if Application then
			local CoordsAtm, NumberAtm = vCLIENT.checkAtm(source, Coords)

			if CoordsAtm then
				if not atmTimers[NumberAtm] then
					atmTimers[NumberAtm] = os.time()
				end

				if os.time() < atmTimers[NumberAtm] then
					local Cooldown = parseInt(atmTimers[NumberAtm] - os.time())
					TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Cooldown.."</b> segundos.",5000)
					Player(source)["state"]["Buttons"] = false
					return
				end

				local Service, Total = vRP.NumPermission(ATMPermission)
				if Total < ATMNeed then
					TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
					Player(source)["state"]["Buttons"] = false
					return false
				end

				if vRP.TakeItem(Passport, Full, 1, true, Slot) then
					local Number = 0
					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(Heading), object = Hash, item = Full, Distance = 100 }
					TriggerClientEvent("objects:Adicionar", -1, tostring(Number), Objects[tostring(Number)])
					vRPC.playAnim(source, false, { "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@", "plant_floor" }, true)
					TriggerClientEvent("Progress", source, "Plantando", 5000)
					Wait(5000)
					vRPC.stopAnim(source)
					atmTimers[NumberAtm] = os.time() + ATMCooldownTime

					local ExplosionProgress = 5

					for Passports, Sources in pairs(Service) do
						async(function()
							vRPC.PlaySound(Sources, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
							TriggerClientEvent("NotifyPush", Sources, { code = 20, title = "Caixa Eletrônico", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alarme de segurança", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
						end)
					end

					repeat
						Wait(1000)
						ExplosionProgress = ExplosionProgress - 1
					until ExplosionProgress <= 0

					Creative.DropServer(CoordsAtm, ATMItem, ATMAmount)
					TriggerClientEvent("player:Residuals", source, "Resíduo de Explosivo.")
					TriggerClientEvent("objects:Remover", -1, tostring(Number))
					TriggerClientEvent("vRP:Explosion", source, Coords)
					TriggerEvent("Wanted", source, Passport, 60)
					TriggerEvent("Discord", "RobberysC4", "**[Ação C4]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Dinheiro Sujo Recebido:** " .. ATMAmount .. "\n" .. "**Coordenadas:** " .. CoordsAtm .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["adrenaline"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Distance = {
			{ 1603.14,3568.94,38.77,212.6 },
			{ -470.91,6289.1,13.61,235.28 }
		}
	
		local Service = vRP.NumPermission("Emergencia")
		if parseInt(#Service) > 0 and not Distance then
			return
		end

		local Ped = GetPlayerPed(source)
		local entity = vRPC.ClosestPed(source,2)
		if entity then
			local OtherPassport = vRP.Passport(entity)
			if OtherPassport then
				if vRP.GetHealth(entity) <= 150 then
					TriggerEvent("paramedic:Revive",entity)
				end
			end
		end
	end,

	["treasurebox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Selected = math.random(#Boxes[Full]["List"])
		local Rand = math.random(Boxes[Full]["List"][Selected]["Min"],Boxes[Full]["List"][Selected]["Max"])

		if (vRP.InventoryWeight(Passport) + (itemWeight(Boxes[Full]["List"][Selected]["Item"]) * Rand)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,Boxes[Full]["List"][Selected]["Item"],Rand,false)
				TriggerClientEvent("inventory:Update",source,"Backpack")
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["backpack"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.GetWeight(Passport) >= 100 then
			TriggerClientEvent("Notify",source,"amarelo","Limite de <b>"..itemName("backpack").."</b> atingido.",5000)
		    return
		end

		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("Progress",source,"Usando",10000)
		TriggerClientEvent("inventory:Close",source)
		vRPC.playAnim(source,true,{"clothingtie","try_tie_negative_a"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source,false)
				Active[Passport] = nil

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.SetWeight(Passport,10)
					TriggerClientEvent("inventory:Update",source,"Backpack")
					TriggerClientEvent("Notify",source,"verde","<b>"..itemName("backpack").."</b> usada.",5000)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["binoculars"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Ped = GetPlayerPed(source)
		if GetSelectedPedWeapon(Ped) ~= GetHashKey("WEAPON_UNARMED") then
			return
		end

		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("inventory:Camera", source, true)
	end,

	["camera"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Ped = GetPlayerPed(source)
		if GetSelectedPedWeapon(Ped) ~= GetHashKey("WEAPON_UNARMED") then
			return
		end

		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("inventory:Camera", source)
	end,

	["megaphone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("player:Megaphone",source)
		TriggerClientEvent("pma-voice:Megaphone",source,true)
		TriggerEvent("pma-voice:Megaserver",source,true)
		TriggerClientEvent("emotes",source,"megaphone")
	end,

	["badge01"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		TriggerClientEvent("inventory:Close", source)
		vRPC.CreateObjects(source, "paper_1_rcm_alt1-8", "player_one_dual-8", "prop_police_badge", 49, 28422, 0.065, 0.029, -0.035, 80.0, -1.90, 75.0)
	end,
	
	["badge02"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		TriggerClientEvent("inventory:Close", source)
		vRPC.CreateObjects(source, "paper_1_rcm_alt1-8", "player_one_dual-8", "prop_medic_badge", 49, 28422, 0.065, 0.029, -0.035, 80.0, -1.90, 75.0)
	end,

	["nigirizushi"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,25)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["sushi"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cupcake"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["milkshake"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.CreateObjects(source,"amb@world_human_aa_coffee@idle_a","idle_a","p_amb_coffeecup_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,20)
					vRP.DowngradeStress(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["milkshakepeanut"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.CreateObjects(source,"amb@world_human_aa_coffee@idle_a","idle_a","p_amb_coffeecup_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)
					vRP.DowngradeStress(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cappuccino"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.CreateObjects(source,"amb@world_human_aa_coffee@idle_a","idle_a","p_amb_coffeecup_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)
					vRP.DowngradeStress(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["applelove"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["nitro"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
			if Vehicle then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 10
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Trocando",10000)
				TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
				vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							local Nitro = GlobalState["Nitro"]
							Nitro[Plate] = 2000
							GlobalState:set("Nitro",Nitro,true)
						end
					end

					Wait(100)
				until not Active[Passport]

				TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
			end
		end
	end,

	["postit"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		TriggerClientEvent("inventory:Close", source)
		TriggerClientEvent("postit:initPostit", source)
	end,

	["tabletpolice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("police:Open",source)
	end,

	["spike"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "xs_prop_arena_spikes_01a"
		local application, Coords, heading = vRPC.objectCoords(source, Hash)
		if application then
			if not vCLIENT.objectExist(source, Coords, Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 100, mode = "3" }

					TriggerClientEvent("objects:Adicionar", -1, tostring(Number), Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["barrier"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "prop_barier_conc_05b"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 100, mode = "3" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["escada"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash =  "escada-relikiashop"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]),y = mathLength(Coords["y"]),z = mathLength(Coords["z"]),h = mathLength(heading),object = Hash,item = Full,Distance = 100,mode = "3" }

					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["barricada"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "prop_bollard_02a"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 100, mode = "3" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["barricada2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "prop_cons_cements01"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 100, mode = "3" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["barricada3"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "prop_barier_conc_02b"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 100, mode = "3" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["barricada4"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "nt_objeto_han"
		local application,Coords,heading = vRPC.objectCoords(source,Hash)
		if application then
			if not vCLIENT.objectExist(source,Coords,Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 100, mode = "3" }
					TriggerClientEvent("objects:Adicionar",-1,tostring(Number),Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["dismantle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vCLIENT.DismantleStatus(source) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("inventory:Close",source)

				TriggerClientEvent("dismantle:Init", source)
			end
		else
			TriggerClientEvent("Notify", source, "vermelho", "Você possui um contrato ativo.", 5000)
		end
	end,

	["cat"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_cat_01")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["hen"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_hen")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["husky"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_husky")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["pig"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_pig")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["poodle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_poodle")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["pug"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_pug")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["retriever"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_retriever")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["rottweiler"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_rottweiler")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["shepherd"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_shepherd")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["westy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("dynamic:animalSpawn", source, "a_c_westy")
		vRPC.playAnim(source, true, { "rcmnigel1c", "hailing_whistle_waive_a" }, false)
	end,

	["vpn"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not Player(source)["state"]["Handcuff"] then
			local Vehicle,Network,Plate,vehName,vehClass = vRPC.VehicleList(source,4)
			if Vehicle then
				if vehClass == 15 or vehClass == 16 or vehClass == 19 then
					return
				end

				if string.sub(Plate,1,4) == "DISM" then
					Player(source)["state"]["Buttons"] = true
					vRPC.AnimActive(source)
					TriggerClientEvent("inventory:Close",source)
					vRPC.playAnim(source,false,{"missfbi_s4mop","clean_mop_back_player"},true)
					if vTASKBAR.taskRobberys(source) then
						Active[Passport] = os.time() + 10
						TriggerClientEvent("inventory:Dismapatch", source)
						TriggerClientEvent("Progress",source,"Usando",10000)

						if math.random(100) >= 25 then
							local Coords = vRP.GetEntityCoords(source)
							local Service = vRP.NumPermission("Policia")
							for Passports,Sources in pairs(Service) do
								async(function()
									TriggerClientEvent("NotifyPush",Sources,{ code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName).." - "..Plate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
								end)
							end
						end

						repeat
							if os.time() >= parseInt(Active[Passport]) then
								vRPC.stopAnim(source)
								Active[Passport] = nil

								TriggerEvent("plateEveryone",Plate)
								TriggerClientEvent("target:Dismantles",source)
								TriggerClientEvent("inventory:vehicleAlarm",source,Network,Plate)
								Player(source)["state"]["Buttons"] = false

								local Network = NetworkGetEntityFromNetworkId(Network)
								if GetVehicleDoorLockStatus(Network) == 2 then
									SetVehicleDoorsLocked(Network,1)
								end
							end

							Wait(100)
						until not Active[Passport]
					else
						Player(source)["state"]["Buttons"] = false
						vRPC.stopAnim(source)
					end
				end
			end
		end
	end,

	["blocksignal"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not Player(source)["state"]["Handcuff"] then
			local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
			if Vehicle and vRPC.InsideVehicle(source) then
				if not exports["garages"]:Signal(Plate) then
					vRPC.AnimActive(source)
					vGARAGE.StartHotwired(source)
					Active[Passport] = os.time() + 100
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)

					if vTASKBAR.taskThree(source) then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							TriggerClientEvent("Notify",source,"verde","<b>Bloqueador de Sinal</b> instalado.",5000)
							TriggerEvent("signalRemove",Plate)
						end
					end

					Player(source)["state"]["Buttons"] = false
					vGARAGE.StopHotwired(source)
					Active[Passport] = nil
				else
					TriggerClientEvent("Notify",source,"amarelo","<b>Bloqueador de Sinal</b> já instalado.",5000)
				end
			end
		end
	end,

	["sulfuric"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 3
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",3000)
		vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRPC.DowngradeHealth(source,50)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["notebook"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("notebook:openSystem",source)
	end,

	["vehkey"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Vehicle,Network,Plate = vRPC.VehicleList(source,5)
		if Vehicle then
			if Plate == Split[2] then
				TriggerEvent("garages:LockVehicle",source,Network)
			end
		end
	end,

	["evidence01"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local Microscope = {
			{ 1796.19, 3615.33, 36.5 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1], v[2], v[3]))
			if Distance <= 1 then
				local TargetPassport = Split[2]
				local Identity = vRP.Identity(TargetPassport)
				if Identity then
					TriggerClientEvent("Notify", source, "azul", 
						"<b>Passaporte:</b> " .. TargetPassport .. 
						"<br><b>Nome:</b> " .. vRP.FullName(TargetPassport) .. 
						"<br><b>Telefone:</b> " .. Identity['phone'] .. 
						"<br><b>Sexo:</b> " .. Identity['sex'] .. 
						"<br><b>Multas:</b> " .. Identity['fines'] .. 
						"<br><b>Tipo Sanguíneo:</b> " .. Sanguine(Identity['blood']), 15000)
					break
				end
			end
		end
	end,

	["evidence02"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local Microscope = {
			{ 1796.19, 3615.33, 36.5 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1], v[2], v[3]))
			if Distance <= 1 then
				local TargetPassport = Split[2]
				local Identity = vRP.Identity(TargetPassport)
				if Identity then
					TriggerClientEvent("Notify", source, "azul", 
						"<b>Passaporte:</b> " .. TargetPassport .. 
						"<br><b>Nome:</b> " .. vRP.FullName(TargetPassport) .. 
						"<br><b>Telefone:</b> " .. Identity['phone'] .. 
						"<br><b>Sexo:</b> " .. Identity['sex'] .. 
						"<br><b>Multas:</b> " .. Identity['fines'] .. 
						"<br><b>Tipo Sanguíneo:</b> " .. Sanguine(Identity['blood']), 15000)
					break
				end
			end
		end
	end,

	["evidence03"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local Microscope = {
			{ 1796.19, 3615.33, 36.5 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1], v[2], v[3]))
			if Distance <= 1 then
				local TargetPassport = Split[2]
				local Identity = vRP.Identity(TargetPassport)
				if Identity then
					TriggerClientEvent("Notify", source, "azul", 
						"<b>Passaporte:</b> " .. TargetPassport .. 
						"<br><b>Nome:</b> " .. vRP.FullName(TargetPassport) .. 
						"<br><b>Telefone:</b> " .. Identity['phone'] .. 
						"<br><b>Sexo:</b> " .. Identity['sex'] .. 
						"<br><b>Multas:</b> " .. Identity['fines'] .. 
						"<br><b>Tipo Sanguíneo:</b> " .. Sanguine(Identity['blood']), 15000)
					break
				end
			end
		end
	end,

	["evidence04"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local Microscope = {
			{ 1796.19, 3615.33, 36.5 }
		}

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(Microscope) do
			local Distance = #(Coords - vec3(v[1], v[2], v[3]))
			if Distance <= 1 then
				local TargetPassport = Split[2]
				local Identity = vRP.Identity(TargetPassport)
				if Identity then
					TriggerClientEvent("Notify", source, "azul", 
						"<b>Passaporte:</b> " .. TargetPassport .. 
						"<br><b>Nome:</b> " .. vRP.FullName(TargetPassport) .. 
						"<br><b>Telefone:</b> " .. Identity['phone'] .. 
						"<br><b>Sexo:</b> " .. Identity['sex'] .. 
						"<br><b>Multas:</b> " .. Identity['fines'] .. 
						"<br><b>Tipo Sanguíneo:</b> " .. Sanguine(Identity['blood']), 15000)
					break
				end
			end
		end
	end,

	["defibrillator"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		TriggerClientEvent("skinshop:Defibrillator", source)
	end,

	["gemstone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.TakeItem(Passport,Full,Amount,false,Slot) then
			TriggerClientEvent("inventory:Update",source,"Backpack")
			vRP.UpgradeGemstone(Passport,Amount)
		end
	end,

	["radio"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("radio:Open",source)
		vRPC.AnimActive(source)
	end,

	["vest"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if Armors[Passport] then
			if os.time() < Armors[Passport] then
				local armorTimers = parseInt(Armors[Passport] - os.time())
				TriggerClientEvent("Notify", source, "azul", "Aguarde <b>" .. armorTimers .. "</b> segundos.", 5000)
				return
			end
		end
	
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close", source)
		TriggerClientEvent("Progress", source, "Vestindo", 10000)
		vRPC.playAnim(source, true, { "clothingtie", "try_tie_negative_a" }, true)
	
		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				Player(source)["state"]["Buttons"] = false
	
				if vRP.TakeItem(Passport, Full, 1, true, Slot) then
					Armors[Passport] = os.time() + 300
					vRP.SetArmour(source, 100)
					vRPC.stopAnim(source, false)
				end
			end
	
			Wait(100)
		until not Active[Passport]
	end,

	["bandage"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 5
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Passando",5000)
				vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							TriggerClientEvent("sounds:source",source,"bandage",0.5)
							Healths[Passport] = os.time() + 30
							vRP.UpgradeStress(Passport,2)
							vRPC.UpgradeHealth(source,25)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,"amarelo","Não pode utilizar de vida cheia ou nocauteado.",5000)
			end
		else
			local Timer = parseInt(Healths[Passport] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Timer.."</b> segundos.",5000)
		end
	end,

	["medkit"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 10
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Passando",10000)
				vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							Healths[Passport] = os.time() + 60
							vRPC.UpgradeHealth(source,60)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,"amarelo","Não pode utilizar de vida cheia ou nocauteado.",5000)
			end
		else
			local Timer = parseInt(Healths[assport] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Timer.."</b> segundos.",5000)
		end
	end,

	["fishingrod"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.GetWork(Passport) ~= CheckWorkFisherman then
			TriggerClientEvent("Notify", source, "amarelo", "Você precisa ter a sua <b>Carteira de Trabalho</b> assinada no emprego de <b>"..ClassWork(CheckWorkFisherman).."</b> para conseguir trabalhar.", 5000)
			return
		end

		if vCLIENT.Fishing(source) then
			if vRP.ConsultItem(Passport,NeedBaitFishing,1) then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)

				vRPC.CreateObjects(source,"amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",49,60309)

				if vTASKBAR.taskFishing(source) then
					local FishIndex = math.random(#ItensWorkFisherman)
					local FishData = ItensWorkFisherman[FishIndex]
					local Amount = math.random(FishData.Amount[1], FishData.Amount[2])

					if (vRP.InventoryWeight(Passport) + itemWeight(FishData.item) * Amount) <= vRP.GetWeight(Passport) then
						local Experience = vRP.GetExperience(Passport,ExperienceWorkFisherman)
						local Category = ClassCategory(Experience)
						local Valuation = PaymentDefaultFisherman + (CategoryIncrementsFisherman[Category] or 0)

						if vRP.TakeItem(Passport,NeedBaitFishing,1,false) then
							vRP.PutExperience(Passport,ExperienceWorkFisherman,LevelExperienceWorkFisherman)
							vRP.GenerateItem(Passport, ItemPaymentFisherman, Valuation, true)
							vRP.GenerateItem(Passport, FishData.item, Amount, true)
						end
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName(NeedBaitFishing).."</b>.",5000)
			end

			Player(source)["state"]["Buttons"] = false
			vRPC.Destroy(source,"one")
			Active[Passport] = nil
		else
			TriggerClientEvent("Notify",source,"amarelo","Precisa estar na Área de <b>Pesca</b>.",5000)
		end
	end,

	["wheat"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,5)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["joint"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,"lighter",1) then
			Active[Passport] = os.time() + 30
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Fumando",30000)
			vRPC.CreateObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						vRP.WeedTimer(Passport,2)
						vRP.DowngradeHunger(Passport,30)
						vRP.DowngradeThirst(Passport,30)
						vRP.DowngradeStress(Passport,10)

						TriggerClientEvent("Joint",source)
						vPLAYER.movementClip(source,"move_m@shadyped@a")
					end
				end

				Wait(100)
			until not Active[Passport]
		else
			TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("lighter").."</b>.",5000)
		end
	end,

	["tablecoke"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "bkr_prop_coke_table01a"
		local application, Coords, heading = vRPC.objectCoords(source, Hash)
		if application then
			if not vCLIENT.objectExist(source, Coords, Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = heading, object = Hash, item = Full, Distance = 50, mode = "1" }

					TriggerClientEvent("objects:Adicionar", -1, tostring(Number), Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["tablemeth"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close", source)
		local favela = Creative.FavelaDistance(source)
	
		if not favela then
			TriggerClientEvent("Notify", source, "vermelho", "Você não pode usar isso aqui!", 5000)
			TriggerClientEvent("inventory:Close", source)
			Player(source)["state"]["Buttons"] = false
			return
		end
	
		local Hash = "bkr_prop_meth_table01a"
		local application, Coords, heading = vRPC.objectCoords(source, Hash)
	
		if application then
			if not vCLIENT.objectExist(source, Coords, Hash) then
				if vRP.TakeItem(Passport, Full, 1, true, Slot) then
					local Number = 0
	
					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]
	
					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 50, mode = "1" }
	
					TriggerClientEvent("objects:Adicionar", -1, tostring(Number), Objects[tostring(Number)])
				end
			end
		end
	
		Player(source)["state"]["Buttons"] = false
	end,	

	["tableweed"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)

		local Hash = "bkr_prop_weed_table_01a"
		local application, Coords, heading = vRPC.objectCoords(source, Hash)
		if application then
			if not vCLIENT.objectExist(source, Coords, Hash) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					local Number = 0

					repeat
						Number = Number + 1
					until not Objects[tostring(Number)]

					Objects[tostring(Number)] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]), h = mathLength(heading), object = Hash, item = Full, Distance = 50, mode = "1" }

					TriggerClientEvent("objects:Adicionar", -1, tostring(Number), Objects[tostring(Number)])
				end
			end
		end

		Player(source)["state"]["Buttons"] = false
	end,

	["geode"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,"WEAPON_HAMMER",1) then
			local Selected = math.random(#Geodes)
			local Rand = math.random(Geodes[Selected]["Min"],Geodes[Selected]["Max"])

			if (vRP.InventoryWeight(Passport) + (itemWeight(Geodes[Selected]["Item"]) * Rand)) <= vRP.GetWeight(Passport) then
				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,Geodes[Selected]["Item"],Rand,true)
					TriggerClientEvent("inventory:Update",source,"Backpack")
				end
			else
				TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","<b>Martelo</b> não encontrado.",5000)
		end
	end,

	["cocaine"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Cheirando",5000)
		vRPC.playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.ChemicalTimer(Passport,10)
					TriggerClientEvent("Cocaine",source)
					TriggerClientEvent("Energetic",source,30,1.40)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["lean"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.ChemicalTimer(Passport,10)
					TriggerClientEvent("Lean",source)
					vRP.DowngradeStress(Passport,2)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["meth"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Armors[Passport] then
			if os.time() < Armors[Passport] then
				local armorTimers = parseInt(Armors[Passport] - os.time())
				TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..armorTimers.."</b> segundos.",5000)
				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Inalando",10000)
		vRPC.playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("Methamphetamine",source)
					Armors[Passport] = os.time() + 20
					vRP.UpgradeStress(Passport,50)
					vRP.ChemicalTimer(Passport,10)
					vRP.SetArmour(source,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,
	["rolepass"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRP.CheckRolepass(source) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerEvent("vRP:ActivePass",source)
				TriggerClientEvent("Notify",source,"verde","Você ativou <b>Rolepass</b>.",5000)
			end
		end
	end,

	["creator"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		if vRP.Request(source, "Tem Certeza que Deseja Refazer sua Aparência?") then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("barbershop:Open", source, "open", true)
			end
		end
	end,

	["creators"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("inventory:Update",source,"Backpack")
				TriggerEvent("Salary:Add",Passport,"Streamer")
				vRP.SetPermission(Passport,"Streamer",1)
				vRP.GenerateItem(Passport,"backpack",4,true)
				vRP.GenerateItem(Passport,"gemstone",50,true)
				TriggerClientEvent("Notify",source,"amarelo","<b>Night Creators</b> Disponível em <b>03/06</b>.",5000)
			end
		end
	end,

	["verify"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("inventory:Update",source,"Backpack")
				TriggerEvent("Salary:Add",Passport,"Streamer")
				vRP.SetPermission(Passport,"Verify",1)
				TriggerClientEvent("Notify",source,"amarelo","<b>Voce Ativou seu verificado</b>.",5000)
			end
		end
	end,

	["premium7days"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if vRP.TakeItem(Passport, Full, 1, true, Slot) then
			TriggerClientEvent("inventory:Update", source, "Backpack")
			TriggerEvent("Salary:Add", Passport, "Premium7days", 1)
			vRP.SetPermission(Passport, "Premium7days", 1)
			vRP.SetWeight(Passport, 15)
			vRP.SetPremium7days(source)
			vRP.UpgradeChars(source)
			TriggerClientEvent("Notify", source, "verde", "Você ativou seu <b>Premium 7 Dias</b> e ativou o salário e seus benefícios", 10000)
		else
			if vRP.HasPermission(Passport, "Premium7days", 1) and vRP.TakeItem(Passport, Full, 1, true, Slot) then
				TriggerClientEvent("inventory:Update", source, "Backpack")
				TriggerEvent("Salary:Add", Passport, "Premium7days", 1)
				vRP.SetPermission(Passport, "Premium7days", 1)
				vRP.UpgradePremium7days(source)
				TriggerClientEvent("Notify", source, "verde", "Você renovou seu <b>Premium 7 Dias</b>.", 5000)
	
				if vRP.GetWeight(Passport) >= 115 then
					TriggerClientEvent("Notify", source, "amarelo", "Sua mochila de <b>15kg</b> não foi adicionada pois você atingiu o limite.", 10000)
					return
				end
	
				vRP.SetWeight(Passport, 15)
			end
		end
	end,
	
	["premiumprata"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if vRP.TakeItem(Passport, Full, 1, true, Slot) then
			TriggerClientEvent("inventory:Update", source, "Backpack")
			vRP.SetPermission(Passport, "PremiumPrata", 1)
			vRP.SetWeight(Passport, 15)
			vRP.SetPremiumPrata(source)
			vRP.UpgradeChars(source)
			vRP.GenerateItem(Passport, "chip", 1, true)
			vRP.GenerateItem(Passport, "verify", 1, true)
			vRP.GenerateItem(Passport, "gemstone", 50, true)
			vRP.GenerateItem(Passport, "dollars", 100000, true)
			vRP.GenerateItem(Passport, "WEAPON_PICKAXE_PLUS", 1, true)
			TriggerClientEvent("Notify", source, "verde", "Você ativou seu <b>Premium Prata</b> e ativou o salário e seus benefícios", 10000)
		else
			if vRP.HasPermission(Passport, "PremiumPrata", 1) and vRP.TakeItem(Passport, Full, 1, true, Slot) then
				TriggerClientEvent("inventory:Update", source, "Backpack")
				vRP.SetPermission(Passport, "PremiumPrata", 1)
				vRP.UpgradePremiumPrata(source)
				TriggerClientEvent("Notify", source, "verde", "Você renovou seu <b>Premium Prata</b>.", 5000)
	
				if vRP.GetWeight(Passport) >= 115 then
					TriggerClientEvent("Notify", source, "amarelo", "Sua mochila de <b>15kg</b> não foi adicionada pois você atingiu o limite.", 10000)
					return
				end
	
				vRP.SetWeight(Passport, 15)
			end
		end
	end,

	["premiumouro"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if vRP.TakeItem(Passport, Full, 1, true, Slot) then
			TriggerClientEvent("inventory:Update", source, "Backpack")
			vRP.SetPermission(Passport, "PremiumOuro", 1)
			vRP.SetWeight(Passport,30)
			vRP.SetPremiumOuro(source)
			vRP.UpgradeChars(source)
			vRP.GenerateItem(Passport, "chip", 1, true)
			vRP.GenerateItem(Passport, "verify", 1, true)
			vRP.GenerateItem(Passport, "premiumplate", 1, true)
			vRP.GenerateItem(Passport, "dollars", 150000, true)
			vRP.GenerateItem(Passport, "gemstone", 80, true)
			vRP.GenerateItem(Passport, "WEAPON_PICKAXE_PLUS", 1, true)
			TriggerClientEvent("Notify", source, "verde", "Você ativou seu <b>Premium Ouro</b> e ativou o salário e seus benefícios", 10000)
		else
			if vRP.HasPermission(Passport, "PremiumOuro", 1) and vRP.TakeItem(Passport, Full, 1, true, Slot) then
				TriggerClientEvent("inventory:Update", source, "Backpack")
				vRP.SetPermission(Passport, "PremiumOuro", 1)
				vRP.UpgradePremiumOuro(source)
				TriggerClientEvent("Notify", source, "verde", "Você renovou seu <b>Premium Ouro</b>.", 5000)
	
				if vRP.GetWeight(Passport) >= 130 then
					TriggerClientEvent("Notify", source, "amarelo", "Sua mochila de <b>30kg</b> não foi adicionada pois você atingiu o limite.", 10000)
					return
				end
	
				vRP.SetWeight(Passport, 30)
			end
		end
	end,

	["premiumplatina"] = function(source,Passport,Amount,Slot,Full,Item,Split)
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("inventory:Update",source,"Backpack")
				vRP.SetPermission(Passport,"Premium",1)
				vRP.SetWeight(Passport,50)
				vRP.SetPremium(source)
				vRP.UpgradeChars(source)
				vRP.GenerateItem(Passport,"chip",1,true)
				vRP.GenerateItem(Passport,"verify",1,true)
				vRP.GenerateItem(Passport,"premiumplate",1,true)
				vRP.GenerateItem(Passport,"dollars",200000,true)
				vRP.GenerateItem(Passport,"gemstone",120,true)   
				vRP.GenerateItem(Passport,"WEAPON_PICKAXE_PLUS",1,true)
				TriggerClientEvent("Notify",source,"verde","Você ativou seu <b>Premium Platinum</b> e Ativou Salario e seus Benefícios",10000)
		else
			if vRP.HasPermission(Passport,"Premium",1) and vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("inventory:Update",source,"Backpack")
				vRP.SetPermission(Passport,"Premium",1)
				vRP.UpgradePremium(source)
				TriggerClientEvent("Notify",source,"verde","Você renovou seu <b>Premium Platinum</b>.",5000)

				if vRP.GetWeight(Passport) >= 150 then
					TriggerClientEvent("Notify",source,"amarelo","Sua mochila de <b>50kg</b> não foi adicionada pois você atingiu o limite.",10000)
					return
				end

				vRP.SetWeight(Passport,50)
			end
		end
	end,
	
	["kitinicial"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (vRP.InventoryWeight(Passport) + itemWeight(Full)) <= vRP.GetWeight(Passport) then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				vRP.GenerateItem(Passport,"chip",1,true)
				vRP.GenerateItem(Passport,"dollars",50000,true)   
				vRP.GenerateItem(Passport,"WEAPON_PICKAXE_PLUS",1,true)
				vRP.GenerateItem(Passport,"lockpick",10,true)
				vRP.GenerateItem(Passport,"backpack",3,true)
				TriggerClientEvent("inventory:Update",source,"Backpack")
				TriggerClientEvent("Notify",source,"verde","Eba!! Ativou seu Kit Inicial e Começou com o Pé Direito",10000)
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		end
	end,

	["carrogratis"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if vRP.TakeItem(Passport, Full, 1, true, Slot) then
			TriggerClientEvent("inventory:Close", source)
			TriggerClientEvent("initial:Open", source)
		end
	end,

	["boxamggtr"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "amggtr"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["box2019chiron"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "2019chiron"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["box21camaro"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "21camaro"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["box911turbos"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "911turbos"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxaudirs6"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "audirs6"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxaudirs7"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "audirs7"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxb63s"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "b63s"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxbmci"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "bmci"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxbmwm3f80"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "bmwm3f80"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxbmwm4gts"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "bmwm4gts"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxdodgechargersrt"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "dodgechargersrt"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxferrariitalia"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "ferrariitalia"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxfocusrs"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "focusrs"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxfordmustang"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "fordmustang"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxfpacehm"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "fpacehm"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxlamborghinihuracan"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "lamborghinihuracan"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxlancerevolution9"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "lancerevolution9"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxlancerevolutionx"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "lancerevolutionx"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxmacan"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "macan"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxmazdarx7"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "mazdarx7"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxa45amg"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "a45amg"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxrr14"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "rr14"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxmers63c"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "mers63c"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxnissan370z"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "nissan370z"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxnissangtr"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "nissangtr"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxnissanskyliner34"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "nissanskyliner34"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxp1"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "p1"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxpanamera17turbo"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "panamera17turbo"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxraptor2017"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "raptor2017"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxrs6c8"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "rs6c8"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxtoyotasupra"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "toyotasupra"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxvelociraptor"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "velociraptor"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxrrst"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "rrst"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxbmwg07"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "bmwg07"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxcayenneturbo"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "cayenneturbo"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["box22g63"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "22g63"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxvelar"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "velar"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxx6m"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "x6m"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxteslax"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "teslax"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["boxttrs"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local vehName = "ttrs"
		TriggerClientEvent("inventory:Close", source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..VehicleName(vehName).."</b>.",3000)
		else
			vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = vehName, plate = vRP.GeneratePlate(), work = "false" })
			TriggerClientEvent("Notify",source,"verde","Você adicionou <b>"..VehicleName(vehName).."</b> na sua garagem!",5000)
			vRP.TakeItem(Passport, Full, 1, true, Slot)
		end
	end,

	["tabletserial"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        TriggerClientEvent("inventory:Close", source)
        
        local Passport = vRP.Passport(source)
        
        if vRP.HasGroup(Passport, "Policia") then
            local Keyboard = vKEYBOARD.keySingle(source, "SERIAL:")
            if Keyboard then
                local UserSerial = vRP.UserSerial(Keyboard[1])
                
                if UserSerial then
                    local Identity = vRP.Identity(UserSerial["id"])

                    if Identity then
						TriggerClientEvent("Notify", source, "amarelo", "<b>Serial de:</b> " .. Identity["name"] .. " " .. Identity["name2"] .. "<br><b>Telefone:</b> " .. Identity["phone"], 10000)
					end
                else
                    TriggerClientEvent("Notify", source, "vermelho", "Serial não encontrado no sistema.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Nenhum serial foi inserido no campo de pesquisa.", 5000)
            end
        else
            TriggerClientEvent("Notify", source, "vermelho", "Sua digital não está autorizada em acessar o sistema.", 5000)
        end
    end,

	["mask"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        TriggerClientEvent("skinshop:setMask", source, Passport, Amount, Slot, Full, Item, Split)
    end,

    ["hat"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        TriggerClientEvent("skinshop:setHat", source, Passport, Amount, Slot, Full, Item, Split)
    end,

    ["gloves"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        TriggerClientEvent("skinshop:setArms", source, Passport, Amount, Slot, Full, Item, Split)
    end,

    ["glasses"] = function(source, Passport, Amount, Slot, Full, Item, Split)
        TriggerClientEvent("skinshop:setGlasses", source, Passport, Amount, Slot, Full, Item, Split)
    end,

	["premiumplate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local vehModel = vRPC.VehicleName(source)
		local vehicle = vRP.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehModel })
		if vehicle[1] then
			local Keyboard = vKEYBOARD.keySingle(source,"Placa: (8 Caracteres)")
			if Keyboard then
				local namePlate = string.sub(Keyboard[1],1,8)
				local plateCheck = sanitizeString(namePlate,"abcdefghijklmnopqrstuvwxyz0123456789",true)

				if string.len(plateCheck) ~= 8 then
					TriggerClientEvent("Notify",source,"vermelho","O nome de definição para a placa inválida.",5000)
					return
				else
					if vRP.PassportPlate(namePlate) then
						TriggerClientEvent("Notify",source,"amarelo","A placa escolhida já possui em outro veículo.",5000)
						return
					else
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							vRP.Query("vehicles/plateVehiclesUpdate",{ Passport = Passport, vehicle = vehModel, plate = string.upper(namePlate) })
							TriggerClientEvent("Notify",source,"verde","Placa atualizada.",5000)
						end
					end
				end
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Modelo de veículo não encontrado.",5000)
		end
	end,

	["newchars"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.TakeItem(Passport,Full,1,false,Slot) then
			vRP.UpgradeChars(source)
			TriggerClientEvent("inventory:Update",source,"Backpack")
			TriggerClientEvent("Notify",source,"verde","Personagem liberado.",5000)
		end
	end,

	["wheelchair"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		local Plate = "WCH" .. math.random(10000, 99999)
		TriggerEvent("plateEveryone", Plate)
		vCLIENT.wheelChair(source, Plate)
	end,

	["namechange"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local Keyboard = vKEYBOARD.keyDouble(source,"Nome:","Sobrenome:")
		if Keyboard then
			if vRP.TakeItem(Passport,Full,1,true,Slot) then
				TriggerClientEvent("Notify",source,"verde","Nome atualizado.",5000)
				vRP.UpgradeNames(Passport,Keyboard[1],Keyboard[2])
			end
		end
	end,

	["chip"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local Keyboard = vKEYBOARD.keyDouble(source, "Três primeiros digitos:", "Três ultimos digitos:")
		if Keyboard then
			local Fir = sanitizeString(Keyboard[1], "0123456789", true)
			local Sec = sanitizeString(Keyboard[2], "0123456789", true)
			if string.len(Fir) == 3 and string.len(Sec) == 3 then
				if not vRP.UserPhone(Keyboard[1] .. "-" .. Keyboard[2]) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						TriggerClientEvent("Notify", source, "verde", "Telefone atualizado.",5000)
						TriggerClientEvent("inventory:Update",source,"Backpack")
						vRP.UpgradePhone(Passport, Keyboard[1] .. "-" .. Keyboard[2])
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "O número escolhido já possui um proprietário.", 5000)
				end
			else
				TriggerClientEvent("Notify", source, "vermelho", "O número telefônico deve conter 6 dígitos e somente números.",5000)
			end
		end
	end,

	["milkbottle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,"emptybottle",1)
					vRP.UpgradeThirst(Passport,30)
					TriggerClientEvent("Lean",source)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["guarananatural"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"amb@world_human_drinking@coffee@male@idle_a","idle_c","prop_food_bs_juice02",49,28422,0.0,-0.01,-0.15,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,25)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["water"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Player(source)["state"]["Buttons"] = false
				vRPC.Destroy(source,"one")
				Active[Passport] = nil

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,"emptybottle",1)
					vRP.UpgradeThirst(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["dirtywater"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.GenerateItem(Passport,"emptybottle",1)
					TriggerClientEvent("resetDrugs",source)
					vRPC.DowngradeHealth(Passport,5)
					vRP.UpgradeThirst(Passport,15)
					vRP.UpgradeCough(Passport,5)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["emptybottle"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local Status,Style = vCLIENT.checkFountain(source)
		if Status then
			if Style == "fountain" then
				if vRP.MaxItens(Passport,"water",Amount) then
					TriggerClientEvent("Notify",source,"vermelho","Limite atingido.",5000)
					return
				end
				
				vRPC.playAnim(source,true,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			elseif Style == "floor" then
				if vRP.MaxItens(Passport,"dirtywater",Amount) then
					TriggerClientEvent("Notify",source,"vermelho","Limite atingido.",5000)
					return
				end

				vRPC.playAnim(source,true,{"amb@world_human_bum_wash@male@high@base","base"},true)
			end

			vRPC.AnimActive(source)
			Active[Passport] = os.time() + 30
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Coletando",30000)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source,"one")
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						if Style == "floor" then
							vRP.GenerateItem(Passport,"dirtywater",Amount,true)
						else
							vRP.GenerateItem(Passport,"water",Amount,true)
						end
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["coffee"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.CreateObjects(source,"amb@world_human_aa_coffee@idle_a","idle_a","p_amb_coffeecup_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("Energetic",source,20,1.10)
					vRP.UpgradeThirst(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,
	
	["energetic"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close", source)
		TriggerClientEvent("Progress", source, "Bebendo", 10000)
		TriggerClientEvent("inventory:Buttons", source, true)
		vRPC.CreateObjects(source, "mp_player_intdrink", "loop_bottle", "prop_energy_drink", 49, 60309, 0.0, 0.0, -0.06, 0.0, 0.0, 130.0)
	
		Citizen.SetTimeout(10000, function()
			Active[Passport] = nil
			vRPC.Destroy(source, "one")
			Player(source)["state"]["Buttons"] = false
	
			if vRP.TakeItem(Passport, Full, 1, true, Slot) then
				TriggerClientEvent("Energetic",source,30,1.30)
				vRP.UpgradeThirst(Passport, 15)
			end
	
			TriggerClientEvent("Notify", source, "verde", "O efeito do energético acabou.", 3000)
		end)
	end,
	

	["energetic2"] = function(source,Passport,Amount,Slot,Full,Item,Split)	
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 1
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",1000)
		TriggerClientEvent("inventory:Buttons",source,true)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","prop_energy_drink",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("Energetic",source,60,1.30)
					vRP.UpgradeThirst(Passport,15)
					TriggerClientEvent("Notify",source,"verde","O Efeito do Energetico vai Durar 1 Minuto!",10000)

				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cola"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","prop_ecola_can",49,60309,0.01,0.01,0.05,0.0,0.0,90.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tacos"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_taco_01",49,18905,0.16,0.06,0.02,-50.0,220.0,60.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["fries"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_bs_chips",49,18905,0.10,0.0,0.08,150.0,320.0,160.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["friesbacon"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_bs_chips",49,18905,0.10,0.0,0.08,150.0,320.0,160.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,25)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["soda"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",5000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","ng_proc_sodacan_01b",49,60309,0.0,0.0,-0.04,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["apple"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["orange"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["strawberry"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["coffee2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["grape"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tange"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["banana"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["guarana"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["acerola"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["passion"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tomato"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",10000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,3)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cookies"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
					vRP.DowngradeStress(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["orangejuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["tangejuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["grapejuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["strawberryjuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["bananajuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["acerolajuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["passionjuice"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,50)
					vRP.DowngradeStress(Passport,100)
					vRP.GenerateItem(Passport,"emptybottle",1)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cannedsoup"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["canofbeans"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source,false)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["marshmallow"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 3
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",3000)
		vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,5)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hamburger"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,15)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hamburger2"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,50)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hamburger3"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,50)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hamburger4"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,50)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hamburger5"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,50)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["onionrings"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["chickenfries"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["pizzamozzarella"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,40)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["pizzabanana"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,40)
					vRP.DowngradeStress(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["pizzachocolate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
					vRP.DowngradeStress(Passport,20)

					TriggerEvent("inventory:BuffServer", source, Passport, "Luck", 600)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["calzone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["hotdog"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["donut"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_amb_donut",49,28422)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
					vRP.DowngradeStress(Passport,20)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,
	
	["lockpick"] = function(source, Passport, Amount, Slot, Full, Item, Split)
	 	Boosting = {}
		local homeName = exports["propertys"]:homesTheft(source)
		if homeName then
			vRPC.stopActived(source)
			vRP.upgradeStress(Passport, 2)
			TriggerClientEvent("inventory:Close", source)
			TriggerClientEvent("inventory:Buttons", source, true)
			vRPC.playAnim(source, false, {"missheistfbi3b_ig7", "lift_fibagent_loop"}, false)
	
			if vLOCKPICK.Task(source) then
				exports["propertys"]:enterHomes(source, Passport, homeName, true)
			else
				exports["propertys"]:resetTheft(homeName)
	
				if math.random(100) >= 10 then
					TriggerClientEvent("inventory:Dismapatch", source)
					TriggerClientEvent("Notify", source, "amarelo", "A vizinhança foi avisada de um suposto roubo.", 5000)
					local Players = vRPC.Players(source)
					for _, v in ipairs(Players) do
						async(function()
							TriggerClientEvent("sounds:source", v, "alarm", 1.0)
						end)
					end
				end
			end
	
			TriggerClientEvent("inventory:Buttons", source, false)
			vRPC.stopAnim(source, false)
		end
	
		local Vehicle, Network, Plate, vehName, vehClass = vRPC.VehicleList(source, 8)
		if Vehicle then
			local Brokenpick = 950
			if vehClass == 15 or vehClass == 16 or vehClass == 19 then
				return
			end
	
			if vRP.InsideVehicle(source) then
				vRPC.AnimActive(source)
				vGARAGE.StartHotwired(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close", source)
	
				if vLOCKPICK.Task(source) then
					TriggerClientEvent("Notify", source, "verde", "Veículo ligado com sucesso!", 5000)
					if math.random(100) >= 10 then
						Brokenpick = 900
						TriggerEvent("plateEveryone", Plate)
						TriggerEvent("platePlayers", Plate, Passport)
						TriggerClientEvent("inventory:vehicleAlarm", source, Network, Plate)
	
						local Network = NetworkGetEntityFromNetworkId(Network)
						if GetVehicleDoorLockStatus(Network) == 2 then
							SetVehicleDoorsLocked(Network, 1)
						end
					end
	
					if math.random(100) >= 75 then
						local Coords = vRP.GetEntityCoords(source)
						local Service = vRP.NumPermission("Policia")
						for Passports, Sources in pairs(Service) do
							async(function()
								TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName) .. " - " .. Plate, time = "Recebido às " .. os.date("%H:%M"), blipColor = 44 })
							end)
						end
					end
				end
	
				if math.random(1000) >= Brokenpick then
					if vRP.TakeItem(Passport, Full, 1, false) then
						vRP.GiveItem(Passport, "lockpick-0", 1, false)
						TriggerClientEvent("itensNotify", source, { "-", "lockpick", 1, "Lockpick de Alumínio" })
					end
				end
	
				Player(source)["state"]["Buttons"] = false
				vGARAGE.StopHotwired(source, vehicle)
				Active[Passport] = nil
			else
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close", source)
				vRPC.playAnim(source, false, { "missfbi_s4mop", "clean_mop_back_player" }, true)
	
				if string.sub(Plate, 1, 4) == "DISM" then
					if vTASKBAR.UpgradeVehicle(source) then
						Brokenpick = 900
						Active[Passport] = os.time() + 15
						TriggerClientEvent("inventory:Dismapatch", source)
						TriggerClientEvent("Progress", source, "Usando", 15000)
						
						if Boosting[Plate] then
							TriggerClientEvent("boosting:Dispatch",source)
						end
	
						if math.random(100) >= 25 then
							local Coords = vRP.GetEntityCoords(source)
							local Service = vRP.NumPermission("Policia")
							for Passports, Sources in pairs(Service) do
								async(function()
									TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName) .. " - " .. Plate, time = "Recebido às " .. os.date("%H:%M"), blipColor = 44 })
								end)
							end
						end
	
						repeat
							if os.time() >= parseInt(Active[Passport]) then
								Active[Passport] = nil
	
								TriggerEvent("plateEveryone", Plate)
								TriggerClientEvent("target:Dismantles",source)
								TriggerClientEvent("inventory:vehicleAlarm", source, Network, Plate)
	
								local Network = NetworkGetEntityFromNetworkId(Network)
								if GetVehicleDoorLockStatus(Network) == 2 then
									SetVehicleDoorsLocked(Network, 1)
								end
							end
	
							Wait(100)
						until not Active[Passport]
					end
				else
					if vLOCKPICK.Task(source) then
						TriggerClientEvent("Notify", source, "verde", "Veículo ligado com sucesso!", 5000)
						Brokenpick = 900
	
						if math.random(100) >= 5 then
							TriggerEvent("plateEveryone", Plate)
							TriggerClientEvent("inventory:vehicleAlarm", source, Network, Plate)
	
							-- Caso queira que o veículo fique com nitro, depois de passar uma  lockpick, basta descomentar as 3 linhas abaixo
							-- local Nitro = GlobalState["Nitro"]
							-- Nitro[Plate] = 2000
							-- GlobalState:set("Nitro", Nitro, true)
							local Network = NetworkGetEntityFromNetworkId(Network)
							if GetVehicleDoorLockStatus(Network) == 2 then
								SetVehicleDoorsLocked(Network, 1)
							end
						end
	
						if math.random(100) >= 25 then
							local Coords = vRP.GetEntityCoords(source)
							local Service = vRP.NumPermission("Policia")
							for Passports, Sources in pairs(Service) do
								async(function()
									TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo de Veículo", x = Coords["x"], y = Coords["y"], z = Coords["z"], vehicle = VehicleName(vehName) .. " - " .. Plate, time = "Recebido às " .. os.date("%H:%M"), blipColor = 44 })
								end)
							end
						end
					end
				end
	
				if math.random(1000) >= Brokenpick then
					if vRP.TakeItem(Passport, Full, 1, false) then
						vRP.GiveItem(Passport, "lockpick-0", 1, false)
						TriggerClientEvent("itensNotify", source, { "-", "lockpick", 1, "Lockpick de Alumínio" })
					end
				end
	
				Player(source)["state"]["Buttons"] = false
				vRPC.Destroy(source)
				Active[Passport] = nil
			end
		end
	end,	

	["toolbox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
			if Vehicle then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
				vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

				if vTASKBAR.taskMechanic(source) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Players = vRPC.Players(source)
						for _,v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:repairEngine",v,Network,Plate)
							end)
						end
					end
				end

				TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source,false)
				Active[Passport] = nil
			end
		end
	end,

	["advtoolbox"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Split then
			if not vRPC.InsideVehicle(source) then
				local Vehicle,Network,Plate = vRPC.VehicleList(source,4)
				if Vehicle then
					vRPC.AnimActive(source)
					Active[Passport] = os.time() + 100
					Player(source)["state"]["Buttons"] = true
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("player:syncHoodOptions",source,Network,"open")
					vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)

					if vTASKBAR.taskMechanic(source) then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							local Players = vRPC.Players(source)
							for _,v in pairs(Players) do
								async(function()
									TriggerClientEvent("inventory:repairVehicle",v,Network,Plate)
								end)
							end

							local Number = parseInt(Split[2]) - 1

							if Number >= 1 then
								vRP.GiveItem(Passport,"advtoolbox-"..Number,1,false)
							end
						end
					end

					TriggerClientEvent("player:syncHoodOptions",source,Network,"close")
					Player(source)["state"]["Buttons"] = false
					vRPC.stopAnim(source,false)
					Active[Passport] = nil
				end
			end
		end
	end,

	["notepad"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		if vRP.TakeItem(Passport,Full,1,true,Slot) then
			TriggerClientEvent("inventory:Close", source)
			TriggerClientEvent("notepad:createNotepad", source)
		end
	end,	

	["tyres"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			if not vCLIENT.checkWeapon(source,"WEAPON_WRENCH") then
				TriggerClientEvent("Notify",source,"vermelho","Coloque a <b>Chave Inglesa</b> em mãos.",5000)
				return
			end

			local tyreStatus,Tyre,Network,Plate = vCLIENT.tyreStatus(source)
			if tyreStatus then
				local Vehicle = NetworkGetEntityFromNetworkId(Network)
				if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
					if vCLIENT.tyreHealth(source,Network,Tyre) ~= 1000.0 then
						vRPC.AnimActive(source)
						Active[Passport] = os.time() + 100
						Player(source)["state"]["Buttons"] = true
						TriggerClientEvent("inventory:Close",source)
						vRPC.playAnim(source, false, { "amb@medic@standing@kneel@idle_a", "idle_a" }, true)
						vRPC.CreateObjects(source, "anim@heists@box_carry@", "idle", "imp_prop_impexp_tyre_01a", 49, 28422, -0.02, -0.1, 0.2, 10.0, 0.0, 0.0)

						if vTASKBAR.taskTyre(source) then
							if vRP.TakeItem(Passport,Full,1,true,Slot) then
								local Players = vRPC.Players(source)
								for _,v in pairs(Players) do
									async(function()
										TriggerClientEvent("inventory:repairTyre",v,Network,Tyre,Plate)
									end)
								end
							end
						end

						Player(source)["state"]["Buttons"] = false
						vRPC.stopAnim(source,false)
						Active[Passport] = nil
					end

					vRPC.Destroy(source)
				end
			end
		end
	end,

	["scuba"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("hud:Scuba",source)
	end,

	["handcuff"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local ClosestPed = vRPC.ClosestPed(source,1)
			if ClosestPed then
				Player(source)["state"]["Cancel"] = true
				Player(source)["state"]["Buttons"] = true

				if Player(ClosestPed)["state"]["Handcuff"] then
					Player(ClosestPed)["state"]["Handcuff"] = false
					Player(ClosestPed)["state"]["Commands"] = false
					TriggerClientEvent("sounds:source",source,"uncuff",0.5)
					TriggerClientEvent("sounds:source",ClosestPed,"uncuff",0.5)

					vRPC.Destroy(ClosestPed)
				else
					TriggerClientEvent("radio:RadioClean",ClosestPed)
					TriggerClientEvent("player:Carry",ClosestPed,source,"handcuff")
					vRPC.playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)
					vRPC.playAnim(ClosestPed,false,{"mp_arrest_paired","crook_p2_back_left"},false)

					Wait(3500)

					vRPC.Destroy(source)
					Player(ClosestPed)["state"]["Handcuff"] = true
					Player(ClosestPed)["state"]["Commands"] = true
					TriggerClientEvent("inventory:Close",ClosestPed)
					TriggerClientEvent("sounds:source",source,"cuff",0.5)
					TriggerClientEvent("sounds:source",ClosestPed,"cuff",0.5)
					TriggerClientEvent("player:Carry",ClosestPed,source)
				end

				Player(source)["state"]["Cancel"] = false
				Player(source)["state"]["Buttons"] = false
			end
		end
	end,

	["rope"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRP.InsideVehicle(source) then
			if Carry[Passport] then
				TriggerClientEvent("player:ropeCarry",Carry[Passport],source)
				TriggerClientEvent("player:Commands",Carry[Passport],false)
				vRPC.Destroy(Carry[Passport])
				vRPC.Destroy(source)
				Carry[Passport] = nil
			else
				local ClosestPed = vRPC.ClosestPed(source,3)
				if ClosestPed then
					if vRP.GetHealth(ClosestPed) <= 100 or Player(ClosestPed)["state"]["Handcuff"] then
						Carry[Passport] = ClosestPed

						TriggerClientEvent("player:ropeCarry",Carry[Passport],source)
						TriggerClientEvent("player:Commands",Carry[Passport],true)
						TriggerClientEvent("inventory:Close",Carry[Passport])

						vRPC.playAnim(ClosestPed,false,{"nm","firemans_carry"},true)
						vRPC.playAnim(source,true,{"missfinale_c2mcs_1","fin_c2_mcs_1_camman"},true)
					end
				end
			end
		end
	end,

	["hood"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local OtherSource = vRPC.ClosestPed(source,2)
		local OtherPassport = vRP.Passport(OtherSource)
		if OtherSource and OtherPassport then
			TriggerClientEvent("hud:Hood",OtherSource)
			TriggerClientEvent("inventory:Close",OtherSource)
			TriggerClientEvent("Notify",source,"amarelo","Você usou o <b>"..itemName("hood").."</b> em <b>"..vRP.FullName(OtherPassport).."</b>.",5000)
		end
	end,

	["ritmoneury"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Tomando",5000)
		vRPC.CreateObjects(source,"mp_player_intdrink","loop_bottle","vw_prop_casino_water_bottle_01a",49,60309,0.0,0.0,-0.06,0.0,0.0,130.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeThirst(Passport,5)
					vRP.ChemicalTimer(Passport,3)
					vRP.DowngradeStress(Passport,30)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["cigarette"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,"lighter",1) then
			Active[Passport] = os.time() + 10
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Fumando",10000)
			vRPC.CreateObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						vRP.DowngradeStress(Passport,10)
						vRP.UpgradeCough(Passport,2)
						
						local Ped = GetPlayerPed(source)
						local Coords = GetEntityCoords(Ped)
					end
				end

				Wait(100)
			until not Active[Passport]
		else
			TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("lighter").."</b>.",5000)
		end
	end,

	["vape"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 15
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Fumando",15000)
		vRPC.CreateObjects(source,"amb@world_human_smoking@male@male_b@base","base","xm3_prop_xm3_vape_01a",49,28422,-0.02,-0.02,0.02,58.0,110.0,10.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRP.DowngradeStress(Passport,20)
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end,

	["chocolate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,8)
					vRP.DowngradeStress(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["sandwich"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 5
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Comendo",5000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_sandwich_01",49,18905,0.13,0.05,0.02,-50.0,16.0,60.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.UpgradeHunger(Passport,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["rose"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		vRPC.CreateObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","prop_single_rose",49,18905,0.13,0.15,0.0,-100.0,0.0,-20.0)
	end,

	["teddy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		vRPC.CreateObjects(source,"impexp_int-0","mp_m_waremech_01_dual-0","v_ilev_mr_rasberryclean",49,24817,-0.20,0.46,-0.016,-180.0,-90.0,0.0)
	end,

	["skate"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("skate:start",source)
	end,

	["suspensionair"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("zo_install_suspe_ar",source)
	end,

	["moduleneon"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("zo_install_mod_neon",source)
	end,
	
	["modulexenon"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("zo_install_mod_xenon",source)
	end,

	["absolut"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["chandon"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["dewars"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_blr",49,28422,0.0,0.0,-0.10,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["scanner"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Scanners[Passport] = true
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Scanner"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("inventory:ScannerBlips", source)
		TriggerClientEvent("inventory:updateScanner", source, true)
		vRPC.CreateObjects(source, "mini@golfai", "wood_idle_a", "w_am_digiscanner", 49, 18905, 0.15, 0.1, 0.0, -270.0, -180.0, -170.0)
	end,

	["maquinadecartao"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)
		vRPC.AnimActive(source)
		vRPC.CreateObjects(source,'cellphone@', 'cellphone_text_read_base',"bzzz_prop_payment_terminal",49,57005,0.18, 0.01, 0.0, -54.0, 220.0, 43.0, false, false, false, false, 1, true)
	end,

	["hennessy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		vRPC.AnimActive(source)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Bebendo",10000)
		vRPC.CreateObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422,0.0,0.0,0.05,0.0,0.0,0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					vRP.AlcoholTimer(Passport,1)
					vRP.UpgradeThirst(Passport,20)
					TriggerClientEvent("setDrunkTime",source,90)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["GADGET_PARACHUTE"] = function(source, Passport, Amount, Slot, Full, Item, Split)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close", source)
		TriggerClientEvent("Progress", source, "Usando Paraquedas", 10000)
		vRPC.playAnim(source, true, { "clothingtie", "try_tie_negative_a" }, true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source, false)
				vCLIENT.Parachute(source)
			end
			Wait(100)
		until not Active[Passport]
	end,

	["pager"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if Player(ClosestPed)["state"]["Handcuff"] then
				local OtherPassport = vRP.Passport(ClosestPed)
				if OtherPassport then
					if vRP.HasService(OtherPassport,"Policia") then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							vRP.ServiceLeave(ClosestPed,OtherPassport,"PMERJ")
							vRP.ServiceLeave(ClosestPed,OtherPassport,"PCERJ")
							vRP.ServiceLeave(ClosestPed,OtherPassport,"PRF")
							vRP.ServiceLeave(ClosestPed,OtherPassport,"BOPE")
							vRP.ServiceLeave(ClosestPed,OtherPassport,"RECOM")
							vRP.ServiceLeave(ClosestPed,OtherPassport,"BPCHQ")
							vRP.ServiceLeave(ClosestPed,OtherPassport,"EX")
							TriggerClientEvent("Notify",source,"amarelo","Todas as comunicações foram retiradas.",5000)
						end
					end
	
					if vRP.HasService(OtherPassport,"Emergencia") then
						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							vRP.ServiceLeave(ClosestPed,OtherPassport,"Paramedic")
							vRP.ServiceLeave(ClosestPed,OtherPassport,"Bombeiro")
							TriggerClientEvent("Notify",source,"amarelo","Todas as comunicações foram retiradas.",5000)
						end
					end
				end
			end
		end
	end,

	["firecracker"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) and not vCLIENT.checkCracker(source) then
			Active[Passport] = os.time() + 3
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Acendendo",3000)
			vRPC.playAnim(source,false,{"anim@mp_fireworks","place_firework_3_box"},true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.stopAnim(source,false)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						TriggerClientEvent("inventory:Firecracker",source)
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["analgesic"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 3
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Tomando",3000)
				vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							Healths[Passport] = os.time() + 15
							vRP.UpgradeStress(Passport,1)
							vRPC.UpgradeHealth(source,10)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,"amarelo","Não pode utilizar de vida cheia ou nocauteado.",5000)
			end
		else
			local Timer = parseInt(Healths[Passport] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Timer.."</b> segundos.",5000)
		end
	end,

	["oxy"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if (not Healths[Passport] or os.time() > Healths[Passport]) then
			if vRP.GetHealth(source) > 100 and vRP.GetHealth(source) < 200 then
				Active[Passport] = os.time() + 3
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Tomando",3000)
				vRPC.playAnim(source,true,{"mp_suicide","pill"},true)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						vRPC.stopAnim(source,false)
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							Healths[Passport] = os.time() + 15
							vRP.UpgradeStress(Passport,1)
							vRPC.UpgradeHealth(source,10)

							TriggerClientEvent("Oxycontin",source)
						end
					end

					Wait(100)
				until not Active[Passport]
			else
				TriggerClientEvent("Notify",source,"amarelo","Não pode utilizar de vida cheia ou nocauteado.",5000)
			end
		else
			local Timer = parseInt(Healths[Passport] - os.time())
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..Timer.."</b> segundos.",5000)
		end
	end,

	["crack"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vRP.ConsultItem(Passport,"lighter",1) then
			Active[Passport] = os.time() + 10
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Fumando",10000)
			vRPC.CreateObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Ped = GetPlayerPed(source)
						local Coords = GetEntityCoords(Ped)
						vRP.DowngradeHunger(Passport,100)
						vRP.DowngradeThirst(Passport,100)
						TriggerClientEvent("inventory:client:hallucinogenic_chicken_weed",source)
					end
				end

				Wait(100)
			until not Active[Passport]
		else
			TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName("lighter").."</b>.",5000)
		end
	end,

	["heroin"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Heroin[Passport] then
			if os.time() < Heroin[Passport] then
				local HeroinTimers = parseInt(Heroin[Passport] - os.time())
				TriggerClientEvent("Notify",source,false,"Aguarde <b>"..HeroinTimers.."</b> segundos.","azul",5000)
				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Injetando",10000)
		vRPC.playAnim(source,true,{"rcmpaparazzo1ig_4","miranda_shooting_up"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					TriggerClientEvent("Heroin",source)
					vRPC.UpgradeHealth(source,50)
					vRP.UpgradeHunger(Passport,100)
					vRP.UpgradeThirst(Passport,100)
					Heroin[Passport] = os.time() + 60
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["metadone"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Armors[Passport] then
			if os.time() < Armors[Passport] then
				local armorTimers = parseInt(Armors[Passport] - os.time())
				TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..armorTimers.."</b> segundos.",false,5000)
				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Inalando",10000)
		vRPC.playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.stopAnim(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					--TriggerClientEvent("inventory:client:hallucinogenic_pug_weed",source)
					Armors[Passport] = os.time() + 60
					vRP.ChemicalTimer(Passport,10)
					vRP.SetArmour(source,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["lancaperfume"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if Armors[Passport] then
			if os.time() < Armors[Passport] then
				local armorTimers = parseInt(Armors[Passport] - os.time())
				TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..armorTimers.."</b> segundos.",false,5000)
				return
			end
		end

		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Baforando",10000)

		vRPC.CreateObjects(source,"amb@incar@male@smoking@enter","enter","mah_lanca_02", 48, 28422, 0.0, 0.01, 0.0, -10.0, -10.0, 0.0)

		repeat
			if os.time() >= parseInt(Active[Passport]) then
				Active[Passport] = nil
				vRPC.Destroy(source)
				Player(source)["state"]["Buttons"] = false

				if vRP.TakeItem(Passport,Full,1,true,Slot) then
					Armors[Passport] = os.time() + 60
					vRP.ChemicalTimer(Passport,10)
					vRP.SetArmour(source,10)
				end
			end

			Wait(100)
		until not Active[Passport]
	end,

	["gauze"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vPARAMEDIC.Bleeding(source) > 0 then
			Active[Passport] = os.time() + 3
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Passando",3000)
			vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.stopAnim(source,false)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						vPARAMEDIC.Bandage(source)
						vRPC.UpgradeHealth(source,10)
					end
				end

				Wait(100)
			until not Active[Passport]
		else
			TriggerClientEvent("Notify",source,false,"Nenhum ferimento encontrado.","amarelo",5000)
		end
	end,

	["gsrkit"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			Active[Passport] = os.time() + 5
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Usando",5000)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Informations = vPLAYER.checkSoap(ClosestPed)
						if Informations then
							local Number = 0
							local Message = ""

							for Value,v in pairs(Informations) do
								Number = Number + 1
								Message = Message.."<b>"..Number.."</b>: "..Value.."<br>"
							end

							TriggerClientEvent("Notify",source,"azul",Message,15000)
						else
							TriggerClientEvent("Notify",source,"amarelo","Nenhum resultado encontrado.",5000)
						end
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["gdtkit"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			local OtherPassport = vRP.Passport(ClosestPed)
			local Identity = vRP.Identity(OtherPassport)
			if OtherPassport and Identity then
				Active[Passport] = os.time() + 5
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("Progress",source,"Usando",5000)

				repeat
					if os.time() >= parseInt(Active[Passport]) then
						Active[Passport] = nil
						Player(source)["state"]["Buttons"] = false

						if vRP.TakeItem(Passport,Full,1,true,Slot) then
							local weed = vRP.WeedReturn(OtherPassport)
							local chemical = vRP.ChemicalReturn(OtherPassport)
							local alcohol = vRP.AlcoholReturn(OtherPassport)

							local chemStr = ""
							local alcoholStr = ""
							local weedStr = ""

							if chemical == 0 then
								chemStr = "Nenhum"
							elseif chemical == 1 then
								chemStr = "Baixo"
							elseif chemical == 2 then
								chemStr = "Médio"
							elseif chemical >= 3 then
								chemStr = "Alto"
							end

							if alcohol == 0 then
								alcoholStr = "Nenhum"
							elseif alcohol == 1 then
								alcoholStr = "Baixo"
							elseif alcohol == 2 then
								alcoholStr = "Médio"
							elseif alcohol >= 3 then
								alcoholStr = "Alto"
							end

							if weed == 0 then
								weedStr = "Nenhum"
							elseif weed == 1 then
								weedStr = "Baixo"
							elseif weed == 2 then
								weedStr = "Médio"
							elseif weed >= 3 then
								weedStr = "Alto"
							end

							TriggerClientEvent("Notify",source,"azul","<b>Químicos:</b> "..chemStr.."<br><b>Álcool:</b> "..alcoholStr.."<br><b>Drogas:</b> "..weedStr,15000)
						end
					end

					Wait(100)
				until not Active[Passport]
			end
		end
	end,

	["silvercoin"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Jogando",1750)
		vRPC.playAnim(source,true,{"anim@mp_player_intcelebrationmale@wank","wank"},true)

		Wait(1750)

		Active[Passport] = nil
		vRPC.stopAnim(source,false)
		Player(source)["state"]["Buttons"] = false

		local Coins = math.random(2)
		local Sides = { "Cara","Coroa" }
		local Identity = vRP.Identity(Passport)
		local Players = vRPC.ClosestPeds(source,5)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("chat:ClientMessage",v,Identity["name"].." "..Identity["name2"],Sides[Coins])
			end)
		end
	end,

	["goldcoin"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Jogando",1750)
		vRPC.playAnim(source,true,{"anim@mp_player_intcelebrationmale@wank","wank"},true)

		Wait(1750)

		Active[Passport] = nil
		vRPC.stopAnim(source,false)
		Player(source)["state"]["Buttons"] = false

		local Coins = math.random(2)
		local Sides = { "Cara","Coroa" }
		local Identity = vRP.Identity(Passport)
		local Players = vRPC.ClosestPeds(source,5)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("chat:ClientMessage",v,Identity["name"].." "..Identity["name2"],Sides[Coins])
			end)
		end
	end,

	["dices"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		Active[Passport] = os.time() + 10
		Player(source)["state"]["Buttons"] = true
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("Progress",source,"Jogando",1750)
		vRPC.playAnim(source,true,{"anim@mp_player_intcelebrationmale@wank","wank"},true)

		Wait(1750)

		Active[Passport] = nil
		vRPC.stopAnim(source,false)
		Player(source)["state"]["Buttons"] = false

		local Dice = math.random(6)
		local Players = vRPC.Players(source)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("showme:pressMe",v,source,"<img src='images/"..Dice..".png'>",10,true)
			end)
		end
	end,

	["deck"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		TriggerClientEvent("inventory:Close",source)

		local card = math.random(13)
		local cards = { "A","2","3","4","5","6","7","8","9","10","J","Q","K" }

		local naipe = math.random(4)
		local naipes = { "<black>♣</black>","<red>♠</red>","<black>♦</black>","<red>♥</red>" }

		local Identity = vRP.Identity(Passport)
		local Players = vRPC.ClosestPeds(source,5)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("chat:ClientMessage",v,Identity["name"].." "..Identity["name2"],"Tirou "..cards[card]..naipes[naipe].." do baralho.")
			end)
		end
	end,

	["soap"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if vPLAYER.checkSoap(source) ~= nil then
			Active[Passport] = os.time() + 10
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("Progress",source,"Usando",10000)
			vRPC.playAnim(source,false,{"amb@world_human_bum_wash@male@high@base","base"},true)

			repeat
				if os.time() >= parseInt(Active[Passport]) then
					Active[Passport] = nil
					vRPC.Destroy(source)
					Player(source)["state"]["Buttons"] = false

					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						TriggerClientEvent("player:Residuals",source)
					end
				end

				Wait(100)
			until not Active[Passport]
		end
	end,

	["adesive01"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle, Network, Plate = vRPC.VehicleList(source, 4)
			if Vehicle then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				vRPC.playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)

				if vTASKBAR.taskThree(source) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Players = vRPC.Players(source)
						for _, v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:paintVehicle", v, Network, Plate, 150)
							end)
						end
					end
				end

				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source, false)
				Active[Passport] = nil
			end
		end
	end,

	["adesive02"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle, Network, Plate = vRPC.VehicleList(source, 4)
			if Vehicle then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				vRPC.playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)

				if vTASKBAR.taskThree(source) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Players = vRPC.Players(source)
						for _, v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:paintVehicle", v, Network, Plate, 55)
							end)
						end
					end
				end

				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source, false)
				Active[Passport] = nil
			end
		end
	end,

	["adesive03"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle, Network, Plate = vRPC.VehicleList(source, 4)
			if Vehicle then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				vRPC.playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)

				if vTASKBAR.taskThree(source) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Players = vRPC.Players(source)
						for _, v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:paintVehicle", v, Network, Plate, 70)
							end)
						end
					end
				end

				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source, false)
				Active[Passport] = nil
			end
		end
	end,

	["adesive04"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle, Network, Plate = vRPC.VehicleList(source, 4)
			if Vehicle then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				vRPC.playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)

				if vTASKBAR.taskThree(source) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Players = vRPC.Players(source)
						for _, v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:paintVehicle", v, Network, Plate, 88)
							end)
						end
					end
				end

				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source, false)
				Active[Passport] = nil
			end
		end
	end,

	["adesive05"] = function(source,Passport,Amount,Slot,Full,Item,Split)
		if not vRPC.InsideVehicle(source) then
			local Vehicle, Network, Plate = vRPC.VehicleList(source, 4)
			if Vehicle then
				vRPC.AnimActive(source)
				Active[Passport] = os.time() + 100
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Close",source)
				vRPC.playAnim(source, false, { "mini@repair", "fixing_a_player" }, true)

				if vTASKBAR.taskThree(source) then
					if vRP.TakeItem(Passport,Full,1,true,Slot) then
						local Players = vRPC.Players(source)
						for _, v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:paintVehicle", v, Network, Plate, 109)
							end)
						end
					end
				end

				Player(source)["state"]["Buttons"] = false
				vRPC.stopAnim(source, false)
				Active[Passport] = nil
			end
		end
	end
}