-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Robberys")
AddEventHandler("inventory:Robberys", function(Type)
	local source = source
	local Passport = vRP.Passport(source)
	local coords = GetEntityCoords(GetPlayerPed(source))
	local coordText = string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z)
	if Passport and not Active[Passport] then
		if not RobberyType[Type] then
			RobberyType[Type] = os.time()
		end

		if os.time() >= RobberyType[Type] then
			if Type == "banks" then
				local Service, Total = vRP.NumPermission(BanksPermission)
				if Total >= BanksNeed then
					local Consult = vRP.InventoryItemAmount(Passport, BanksWeaponRequired)
					if Consult[1] >= BanksWeaponRequiredAmount then
						if not vRP.CheckDamaged(Consult[2]) then
							if vRP.Device(source, 60) then
								if vRP.TakeItem(Passport, Consult[2], BanksWeaponRequiredAmount, true) then
									TriggerClientEvent("Notify", source, "azul","Rádio da Negociação: <b>" .. BanksRadio .. "</b>", 60000)
		
									local Coords = vRP.GetEntityCoords(source)
									for Passports, Sources in pairs(Service) do
										async(function()
											TriggerClientEvent("sounds:source", Sources, "alarm", 0.5)
											TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo ao Banco", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Rádio da Negociação: " .. BanksRadio, blipColor = 22 })
										end)
									end
		
									vRPC.AnimActive(source)
									Active[Passport] = os.time() + 60
									RobberyType[Type] = os.time() + BanksCooldownTime
									TriggerClientEvent("Progress", source, "Roubando", 60000)
		
									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close", source)
									vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)
		
									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											TriggerEvent("Wanted", source, Passport, 300)
											vRP.GenerateItem(Passport, BanksItem, BanksAmount, true)
											TriggerClientEvent("player:Residuals", source, "Resíduo de Arrombamento.")
											vRPC.stopAnim(source, false)
											vRP.UpgradeStress(Passport, math.random(2))
											Player(source)["state"]["Buttons"] = false
											TriggerEvent("Discord", "RobberysBanks", "**[Roubo ao Banco]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Barra de Ouro Recebida:** " .. BanksAmount .. "\n" .. "**Coordenadas:** " .. coordText .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
										end
										Wait(100)
									until not Active[Passport]
								end
							else
								RobberyType[Type] = os.time() + 60
							end
						else
							TriggerClientEvent("Notify", source, "vermelho", "<b>" .. itemName(BanksWeaponRequired) .. "</b> danificado.", 5000)
						end
					else
						TriggerClientEvent("Notify", source, "amarelo", "Precisa de <b>" .. parseInt(BanksWeaponRequiredAmount) .. "x " .. itemName(BanksWeaponRequired) .. "</b>.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
				end
			elseif Type == "barbershop" then
				local Service, Total = vRP.NumPermission(BarbershopPermission)
				if Total >= BarbershopNeed then
					local Consult = vRP.InventoryItemAmount(Passport, BarbershopRequired)
					if Consult[1] >= BarbershopRequiredAmount then
						if not vRP.CheckDamaged(Consult[2]) then
							if vRP.Device(source, 60) then
								if vRP.TakeItem(Passport, Consult[2], BarbershopRequiredAmount, true) then
									TriggerClientEvent("Notify", source, "azul","Rádio da Negociação: <b>" .. BarbershopRadio .. "</b>", 60000)

									local Coords = vRP.GetEntityCoords(source)
									for Passports, Sources in pairs(Service) do
										async(function()
											TriggerClientEvent("sounds:source", Sources, "alarm", 0.5)
											TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo a Barbearia", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Rádio da Negociação: " .. BarbershopRadio, blipColor = 22 })
										end)
									end

									vRPC.AnimActive(source)
									Active[Passport] = os.time() + 60
									RobberyType[Type] = os.time() + BarbershopCooldownTime
									TriggerClientEvent("Progress", source, "Roubando", 60000)

									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close", source)
									vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											TriggerEvent("Wanted", source, Passport, 300)
											vRP.GenerateItem(Passport, BarbershopItem, BarbershopAmount, true)
											TriggerClientEvent("player:Residuals", source, "Resíduo de Arrombamento.")
											vRPC.stopAnim(source, false)
											vRP.UpgradeStress(Passport, math.random(2))
											Player(source)["state"]["Buttons"] = false
											TriggerEvent("Discord", "RobberysBarbershop", "**[Roubo a Barbearia]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Dinheiro Sujo Recebido:** " .. BarbershopAmount .. "\n" .. "**Coordenadas:** " .. coordText .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
										end
										Wait(100)
									until not Active[Passport]
								end
							else
								RobberyType[Type] = os.time() + 60
							end
						else
							TriggerClientEvent("Notify", source, "vermelho", "<b>" .. itemName(BarbershopRequired) .. "</b> danificado.", 5000)
						end
					else
						TriggerClientEvent("Notify", source, "amarelo", "Precisa de <b>" .. parseInt(BarbershopRequiredAmount) .. "x " .. itemName(BarbershopRequired) .. "</b>.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
				end
			elseif Type == "weaponshop" then
				local Service, Total = vRP.NumPermission(WeaponPermission)
				if Total >= WeaponNeed then
					local Consult = vRP.InventoryItemAmount(Passport, WeaponRequired)
					if Consult[1] >= WeaponRequiredAmount then
						if not vRP.CheckDamaged(Consult[2]) then
							if vRP.Device(source, 60) then
								if vRP.TakeItem(Passport, Consult[2], WeaponRequiredAmount, true) then
									TriggerClientEvent("Notify", source, "azul","Rádio da Negociação: <b>" .. WeaponRadio .. "</b>", 60000)

									local Coords = vRP.GetEntityCoords(source)
									for Passports, Sources in pairs(Service) do
										async(function()
											TriggerClientEvent("sounds:source", Sources, "alarm", 0.5)
											TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo a Loja de Armas", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Rádio da Negociação: " .. WeaponRadio, blipColor = 22 })
										end)
									end

									vRPC.AnimActive(source)
									Active[Passport] = os.time() + 60
									RobberyType[Type] = os.time() + WeaponshopCooldownTime
									TriggerClientEvent("Progress", source, "Roubando", 60000)

									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close", source)
									vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											TriggerEvent("Wanted", source, Passport, 300)
											vRP.GenerateItem(Passport, WeaponItem, WeaponAmount, true)
											TriggerClientEvent("player:Residuals", source, "Resíduo de Arrombamento.")
											vRPC.stopAnim(source, false)
											vRP.UpgradeStress(Passport, math.random(2))
											Player(source)["state"]["Buttons"] = false
											TriggerEvent("Discord", "RobberysWeaponshop", "**[Roubo a Ammu-Nation]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Dinheiro Sujo Recebido:** " .. WeaponAmount .. "\n" .. "**Coordenadas:** " .. coordText .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
										end
										Wait(100)
									until not Active[Passport]
								end
							else
								RobberyType[Type] = os.time() + 60
							end
						else
							TriggerClientEvent("Notify", source, "vermelho", "<b>" .. itemName(WeaponRequired) .. "</b> danificado.", 5000)
						end
					else
						TriggerClientEvent("Notify", source, "amarelo", "Precisa de <b>" .. parseInt(WeaponRequiredAmount) .. "x " .. itemName(WeaponRequired) .. "</b>.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
				end
			elseif Type == "fleecashop" then
				local Service, Total = vRP.NumPermission(FleecasPermission)
				if Total >= FleecasNeed then
					local Consult = vRP.InventoryItemAmount(Passport, FleecasRequired)
					if Consult[1] >= FleecasRequiredAmount then
						if not vRP.CheckDamaged(Consult[2]) then
							if vRP.Device(source, 60) then
								if vRP.TakeItem(Passport, Consult[2], FleecasRequiredAmount, true) then
									TriggerClientEvent("Notify", source, "azul", "Rádio da Negociação: <b>" .. FleecasRadio .. "</b>", 60000)
			
									local Coords = vRP.GetEntityCoords(source)
									for Passports, Sources in pairs(Service) do
										async(function()
											TriggerClientEvent("sounds:source", Sources, "alarm", 0.5)
											TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo a Banco Fleeca", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Rádio da Negociação: " .. FleecasRadio, blipColor = 22 })
										end)
									end
			
									vRPC.AnimActive(source)
									Active[Passport] = os.time() + 60
									RobberyType[Type] = os.time() + FleecashopCooldownTime
									TriggerClientEvent("Progress", source, "Roubando", 60000)
			
									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close", source)
									vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)
			
									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											TriggerEvent("Wanted", source, Passport, 300)
											vRP.GenerateItem(Passport, FleecasItem, FleecasAmount, true)
											TriggerClientEvent("player:Residuals", source, "Resíduo de Arrombamento.")
											vRPC.stopAnim(source, false)
											vRP.UpgradeStress(Passport, math.random(2))
											Player(source)["state"]["Buttons"] = false
											TriggerEvent("Discord", "RobberysFleecashop", "**[Roubo a Bancos Fleecas]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Dinheiro Sujo Recebido:** " .. FleecasAmount .. "\n" .. "**Coordenadas:** " .. coordText .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
										end
										Wait(100)
									until not Active[Passport]
								end
							else
								RobberyType[Type] = os.time() + 60
							end
						else
							TriggerClientEvent("Notify", source, "vermelho", "<b>" .. itemName(FleecasRequired) .. "</b> danificado.", 5000)
						end
					else
						TriggerClientEvent("Notify", source, "amarelo", "Precisa de <b>" .. parseInt(FleecasRequiredAmount) .. "x " .. itemName(FleecasRequired) .. "</b>.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
				end
			elseif Type == "departmentshop" then
				local Service, Total = vRP.NumPermission(DepartmentPermission)
				if Total >= DepartmentNeed then
					local Consult = vRP.InventoryItemAmount(Passport, DepartmentRequired)
					if Consult[1] >= DepartmentRequiredAmount then
						if not vRP.CheckDamaged(Consult[2]) then
							if vRP.Device(source, 60) then
								if vRP.TakeItem(Passport, Consult[2], DepartmentRequiredAmount, true) then
									TriggerClientEvent("Notify", source, "azul","Rádio da Negociação: <b>" .. DepartmentRadio .. "</b>", 60000)

									local Coords = vRP.GetEntityCoords(source)
									for Passports, Sources in pairs(Service) do
										async(function()
											TriggerClientEvent("sounds:source", Sources, "alarm", 0.5)
											TriggerClientEvent("NotifyPush", Sources, { code = 31, title = "Roubo a Loja de Departamento", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Rádio da Negociação: " .. DepartmentRadio, blipColor = 22 })
										end)
									end

									vRPC.AnimActive(source)
									Active[Passport] = os.time() + 60
									RobberyType[Type] = os.time() + DepartmentCooldownTime
									TriggerClientEvent("Progress", source, "Roubando", 60000)

									Player(source)["state"]["Buttons"] = true
									TriggerClientEvent("inventory:Close", source)
									vRPC.playAnim(source, false, { "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer" }, true)

									repeat
										if os.time() >= parseInt(Active[Passport]) then
											Active[Passport] = nil
											TriggerEvent("Wanted", source, Passport, 300)
											vRP.GenerateItem(Passport, DepartmentItem, DepartmentAmount, true)
											TriggerClientEvent("player:Residuals", source, "Resíduo de Arrombamento.")
											vRPC.stopAnim(source, false)
											vRP.UpgradeStress(Passport, math.random(2))
											Player(source)["state"]["Buttons"] = false
											TriggerEvent("Discord", "RobberysDepartmentshop", "**[Roubo a Departamento]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Dinheiro Sujo Recebido:** " .. DepartmentAmount .. "\n" .. "**Coordenadas:** " .. coordText .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
										end
										Wait(100)
									until not Active[Passport]
								end
							else
								RobberyType[Type] = os.time() + 60
							end
						else
							TriggerClientEvent("Notify", source, "vermelho", "<b>" .. itemName(DepartmentRequired) .. "</b> danificado.", 5000)
						end
					else
						TriggerClientEvent("Notify", source, "amarelo", "Precisa de <b>" .. parseInt(DepartmentRequiredAmount) .. "x " .. itemName(DepartmentRequired) .. "</b>.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Contingente indisponível.", 5000)
				end
			end
		else
			local Cooldown = MinimalTimers(RobberyType[Type] - os.time())
			TriggerClientEvent("Notify", source, "azul", "Aguarde <b>" .. Cooldown .. "</b>.", 5000)
		end
	end
end)