
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:DYNAMIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:Dynamic")
AddEventHandler("admin:Dynamic", function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Player(source).state.StaffTime then
			if Mode == "wl" then
				if vRP.HasGroup(Passport,"Admin",3) then
					local Keyboard = vKEYBOARD.keyDouble(source,"ID da Whitelist:","Status: (0 inativa, 1 ativa)")
					if Keyboard then
						TriggerClientEvent("Notify",source,"verde","Whitelist editada.",5000)

						vRP.Query("accounts/updateWhitelist",{ id = Keyboard[1], whitelist = Keyboard[2] })
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "rename" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyTertiary(source,"ID:","Nome:","Sobrenome:")
					if Keyboard then
						vRP.UpgradeNames(Keyboard[1],Keyboard[2],Keyboard[3])
						TriggerClientEvent("Notify",source,"verde","Nome atualizado.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "ugroups" then
				if vRP.HasGroup(Passport,"Admin",5) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						local Result = ""
						local Groups = vRP.Groups()
						local OtherPassport = Keyboard[1]
						for Permission,_ in pairs(Groups) do
							local Data = vRP.DataGroups(Permission)
							if Data[OtherPassport] then
								Result = Result.."<b>Permissão:</b> "..Permission.."<br><b>Nível:</b> "..Data[OtherPassport].."<br>"
							end
						end

						if Result ~= "" then
							TriggerClientEvent("Notify",source,"azul",Result,10000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "clearinv" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						vRP.ClearInventory(Keyboard[1])
						TriggerClientEvent("Notify",source,"verde","Limpeza concluída.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "gem" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source,"ID:","Quantidade:")
					if Keyboard then
						local Amount = parseInt(Keyboard[2])
						local OtherPassport = parseInt(Keyboard[1])
						local Identity = vRP.Identity(OtherPassport)
						if Identity then
							TriggerClientEvent("Notify",source,"verde","Gemas entregues.",5000)

							vRP.UpgradeGemstone(OtherPassport,Amount)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "blips" then
				if vRP.HasGroup(Passport,"Admin",1) then
					vRPC.BlipAdmin(source)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "debug" then
				if vRP.HasGroup(Passport,"Admin",1) then
					TriggerClientEvent("admin:ToggleDebug",source)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "flash" then
				if vRP.HasGroup(Passport,"Admin",1) then
					vCLIENT.Flash(source)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "pulo" then
				if vRP.HasGroup(Passport,"Admin",1) then
					vCLIENT.Pulo(source)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "god" then
				if vRP.HasGroup(Passport, "Admin", 4) then
					local Keyboard = vKEYBOARD.keySingle(source, "ID:")
					if Keyboard then
						local OtherPassport = tonumber(Keyboard[1])
						local ClosestPed = vRP.Source(OtherPassport)
						if ClosestPed then
							vRP.UpgradeThirst(OtherPassport, 100)
							vRP.UpgradeHunger(OtherPassport, 100)
							vRP.DowngradeStress(OtherPassport, 100)
							vRP.Revive(ClosestPed, 200)

							TriggerClientEvent("paramedic:Reset",ClosestPed)

							vRPC.Destroy(ClosestPed)
						end
					else
						TriggerClientEvent("Notify", source, "vermelho", "O ID inserido não é válido.", 5000)
					end
				else
				TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
			end
		elseif Mode == "godall" then
			if vRP.HasGroup(Passport,"Admin",1) then
				local UsersList = vRP.Players()
				for k,v in pairs(UsersList) do
					local OtherPassport = parseInt(k)
					local ClosestPed = vRP.Source(OtherPassport)
					if ClosestPed then
						vRP.UpgradeThirst(OtherPassport,100)
						vRP.UpgradeHunger(OtherPassport,100)
						vRP.DowngradeCough(OtherPassport,100)
						vRP.DowngradeStress(OtherPassport,100)
						vRP.Revive(ClosestPed,200)

						TriggerClientEvent("paramedic:Reset",ClosestPed)

						vRPC.Destroy(ClosestPed)

						TriggerClientEvent("Notify", ClosestPed, "verde", "Você recebeu uma cura divina.",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
			end
		elseif Mode == "magneto" then
			if vRP.HasGroup(Passport,"Admin",1) then
				TriggerClientEvent("admin:ToggleMagneto", source)
			else
				TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
			end
		elseif Mode == "vehiclespeed" then
			if vRP.HasGroup(Passport,"Admin",1) then
				local Keyboard = vKEYBOARD.keySingle(source,"Velocidade:")
				if Keyboard then
					TriggerClientEvent("admin:ChangeVehicleSpeed", source, tonumber(Keyboard[1]))
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
			end
		elseif Mode == "tyreburst" then
			if vRP.HasGroup(Passport,"Admin",1) then
				local Keyboard = vKEYBOARD.keySingle(source,"Número do Pneu: 1 a 8")
				if Keyboard then
					TriggerClientEvent("admin:TyreBurst", source, tonumber(Keyboard[1]))
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
			end
		elseif Mode == "createlightning" then
			if vRP.HasGroup(Passport,"Admin",1) then
				local Keyboard = vKEYBOARD.keySingle(source,"Número:")
				if Keyboard then
					local UsersList = vRP.Players()
					for k, v in pairs(UsersList) do
						local OtherPassport = parseInt(k)
						local OtherSource = vRP.Source(OtherPassport)
						if OtherSource then
							TriggerClientEvent("admin:LightningThunder", OtherSource, tonumber(Keyboard[1]))
						end
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
			end
		elseif Mode == "commands" then
			if vRP.HasGroup(Passport,"Admin",1) then
				local Keyboard = vKEYBOARD.keySingle(source,"Número: (0 = Desativado / 1 = Ativado)")
				if Keyboard then
					if tonumber(Keyboard[1]) == 1 then
						GlobalState["Commands"] = true
						TriggerClientEvent("Notify",source,"verde","Comandos ativados.",5000)
					elseif tonumber(Keyboard[1]) == 0 then
						GlobalState["Commands"] = false
						TriggerClientEvent("Notify",source,"amarelo","Comandos desativados.",5000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
			end
		elseif Mode == "godarea" then
			if vRP.HasGroup(Passport, "Admin", 1) then
				local Keyboard = vKEYBOARD.keySingle(source, "Área em Metros:")
		
				if Keyboard then
					local Range = tonumber(Keyboard[1])
		
					if Range then
						local Text = ""
						local Players = vRPC.ClosestPeds(source, Range)
		
						for _, v in pairs(Players) do
							async(function()
								local OtherPlayer = vRP.Passport(v)
								vRP.UpgradeThirst(OtherPlayer, 100)
								vRP.UpgradeHunger(OtherPlayer, 100)
								vRP.DowngradeStress(OtherPlayer, 100)
								vRP.Revive(v, 200)
								TriggerClientEvent("paramedic:Reset", v)

								vRPC.Destroy(ClosestPed)
		
								if Text == "" then
									Text = OtherPlayer
								else
									Text = Text .. ", " .. OtherPlayer
								end
							end)
						end
		
					else
						TriggerClientEvent("Notify", source, "vermelho", "O ID inserido não é válido.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
				end
			end
			elseif Mode == "armour" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then

						local OtherPassport = parseInt(Keyboard[1])
						local ClosestPed = vRP.Source(OtherPassport)
						if ClosestPed then
							vRP.SetArmour(ClosestPed,100)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "item" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source,"Nome do Item:","Quantidade:")
					if Keyboard then
						if itemBody(Keyboard[1]) ~= nil then

							if Keyboard[1] == "backpackp" or Keyboard[1] == "backpackm" or Keyboard[1] == "backpackg" then
								vRP.GiveItem(Passport,Keyboard[1].."-"..os.time().."-"..Passport,parseInt(Keyboard[2]),true)
							else
								vRP.GenerateItem(Passport,Keyboard[1],parseInt(Keyboard[2]),true)
							end
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "item2" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyTertiary(source,"ID:","Nome do Item:","Quantidade:")
					if Keyboard then
						if itemBody(Keyboard[2]) ~= nil then

							if Keyboard[2] == "backpackp" or Keyboard[2] == "backpackm" or Keyboard[2] == "backpackg" then
								vRP.GiveItem(parseInt(Keyboard[1]),Keyboard[2].."-"..os.time().."-"..parseInt(Keyboard[1]),parseInt(Keyboard[3]),true)
							else
								vRP.GenerateItem(parseInt(Keyboard[1]),Keyboard[2],parseInt(Keyboard[3]),true)
							end
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "itemall" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source,"Nome do Item:","Quantidade:")
					if Keyboard then
						if itemBody(Keyboard[1]) ~= nil then

							local List = vRP.Players()
							for AllPlayers,_ in pairs(List) do
								async(function()
									if Keyboard[1] == "backpackp" or Keyboard[1] == "backpackm" or Keyboard[1] == "backpackg" then
										vRP.GiveItem(AllPlayers,Keyboard[1].."-"..os.time().."-"..AllPlayers,parseInt(Keyboard[2]),true)
									else
										vRP.GenerateItem(AllPlayers,Keyboard[1],parseInt(Keyboard[2]),true)
									end
								end)
							end

							TriggerClientEvent("Notify",source,"verde","Envio concluído.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "delete" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						if Keyboard[1] then
							TriggerClientEvent("dynamic:closeSystem",source)
			
							if vRP.Request(source,"Deletar Conta","Você tem certeza?") then
								local OtherPassport = parseInt(Keyboard[1])
								vRP.Query("characters/removeCharacter",{ id = OtherPassport })
								vRP.Kick(OtherPassport,"A Historia do seu Personagem Chegou ao FIM!.")
								TriggerClientEvent("Notify",source,"verde","Personagem <b>"..OtherPassport.."</b> deletado.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","ID não fornecido.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "skin" then
				if vRP.HasGroup(Passport, "Admin", 1) then
					local Keyboard = vKEYBOARD.keyDouble(source, "ID:", "Skin:")
					if Keyboard then
						local ClosestPed = vRP.Source(Keyboard[1])
						if ClosestPed then
							vRPC.Skin(ClosestPed, Keyboard[2])
							vRP.SkinCharacter(parseInt(Keyboard[1]), Keyboard[2])
							vRP.Query("playerdata/SetData", { Passport = Passport, dkey = "Skin", dvalue = Keyboard[2] })
			
							local sex = nil
							if Keyboard[2] == "mp_m_freemode_01" then
								sex = "M"
							elseif Keyboard[2] == "mp_f_freemode_01" then
								sex = "F"
							end
			
							if sex then
								vRP.Query("characters/SetSex", { Passport = Passport, sex = sex })
							end
			
							TriggerClientEvent("Notify", source, "verde", "Skin <b>"..Keyboard[2].."</b> setada no ID "..parseInt(Keyboard[1])..".", 5000)
						end
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
				end
			elseif Mode == "resetskin" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						local ClosestPed = vRP.Source(Keyboard[1])
						if ClosestPed then
							local OtherPassport = parseInt(Keyboard[1])
							local Identity = vRP.Identity(OtherPassport)
							if Identity then
								if Identity["sex"] == "M" then
									vRPC.Skin(ClosestPed,"mp_m_freemode_01")
									vRP.SkinCharacter(parseInt(Keyboard[1]),"mp_m_freemode_01")
								elseif Identity["sex"] == "F" then
									vRPC.Skin(ClosestPed,"mp_f_freemode_01")
									vRP.SkinCharacter(parseInt(Keyboard[1]),"mp_f_freemode_01")
								end

								TriggerClientEvent("Notify",source,"verde","Skin do ID "..parseInt(Keyboard[1]).." foi resetada.",5000)
							end
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "nc" then
				if vRP.HasGroup(Passport,"Admin",5) then
					vRPC.noClip(source)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "kick" then
				if vRP.HasGroup(Passport,"Admin",3) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						local OtherSource = vRP.Source(Keyboard[1])
						if OtherSource then
							TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..Keyboard[1].."</b> expulso.",5000)
							vRP.Kick(OtherSource,"Expulso da cidade.")
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "ban" then
				if vRP.HasGroup(Passport,"Admin",3) then
					local Keyboard = vKEYBOARD.keyDouble(source,"ID:","Dias:")
					if Keyboard then
						local Days = parseInt(Keyboard[2])
						local OtherPassport = parseInt(Keyboard[1])
						local Identity = vRP.Identity(OtherPassport)
						if Identity then
							local OtherSource = vRP.Source(OtherPassport)
							if OtherSource then
								local Token = GetPlayerTokens(OtherSource)
								for k,v in pairs(Token) do
									vRP.Kick(OtherPassport,"Banido.")
									vRP.Query("banneds/InsertBanned",{ License = Identity["License"], Token = v, Time = Days })
								end

								TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..OtherPassport.."</b> banido por <b>"..Days.."</b> dias.",5000)
							end
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "unban" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						local OtherPassport = parseInt(Keyboard[1])
						local Identity = vRP.Identity(OtherPassport)
						if Identity then
							vRP.Query("banneds/RemoveBanned",{ License = Identity["License"] })
							TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..OtherPassport.."</b> desbanido.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "timeset" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyTertiary(source,"Hora:","Minuto:","Clima:")
					if Keyboard then
						GlobalState["Hours"] = parseInt(Keyboard[1])
						GlobalState["Minutes"] = parseInt(Keyboard[2])
						GlobalState["Weather"] = Keyboard[3]
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "temperatureset" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source,"Região: Sul ou Norte","Temperatura:")
					if Keyboard then
						if Keyboard[1] == "Sul" then
							GlobalState["TemperatureS"] = parseInt(Keyboard[2])
							TriggerClientEvent("Notify",source,"amarelo","Você mudou a temperatura do <b>Sul</b>.",5000)
						elseif Keyboard[1] == "Norte" then
							GlobalState["TemperatureN"] = parseInt(Keyboard[2])
							TriggerClientEvent("Notify",source,"amarelo","Você mudou a temperatura do <b>Norte</b>.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "blackoutset" then
				if vRP.HasGroup(Passport,"Admin",1) then
					if GlobalState["Blackout"] then
						GlobalState["Blackout"] = false
						TriggerClientEvent("Notify",source,"amarelo","Modo blackout desativado.",5000)
					else
						GlobalState["Blackout"] = true
						TriggerClientEvent("Notify",source,"verde","Modo blackout ativado.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "cds" then
				if vRP.HasGroup(Passport,"Admin",5) then
					local Ped = GetPlayerPed(source)
					local Coords = GetEntityCoords(Ped)
					local Heading = GetEntityHeading(Ped)

					vKEYBOARD.keyCopy(source,"Cordenadas:",mathLength(Coords["x"])..","..mathLength(Coords["y"])..","..mathLength(Coords["z"])..","..mathLength(Heading))
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "tpcds" then
				if vRP.HasGroup(Passport,"Admin",5) then
					local Keyboard = vKEYBOARD.keySingle(source,"Coordenada:")
					if Keyboard then
						local Split = splitString(Keyboard[1],",")
						vRP.Teleport(source,Split[1] or 0,Split[2] or 0,Split[3] or 0)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "group" then
					if vRP.HasGroup(Passport, "Admin", 3) then
						local Keyboard = vKEYBOARD.keyTertiary(source, "ID:", "Grupo:", "Hierarquia:")
						if Keyboard then
							local OtherPassport = Keyboard[1]
							local Permission = Keyboard[2]
							local Level = Keyboard[3]
				
							TriggerClientEvent("Notify", source, "verde", "Adicionado <b>"..Permission.."</b> ao passaporte <b>"..OtherPassport.."</b>.", 5000)
							vRP.SetPermission(OtherPassport, Permission, Level)
						end
					else
						TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
					end
			elseif Mode == "ungroup" then
				if vRP.HasGroup(Passport,"Admin",3) then
					local Keyboard = vKEYBOARD.keyDouble(source,"ID:","Grupo:")
					if Keyboard then
						TriggerClientEvent("Notify",source,"verde","Removido <b>"..Keyboard[2].."</b> ao passaporte <b>"..Keyboard[1].."</b>.",5000)
						vRP.RemovePermission(Keyboard[1],Keyboard[2])
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "tptome" then
				if vRP.HasGroup(Passport,"Admin",5) then
					local Keyboard = vKEYBOARD.keySingle(source, "ID:")
					if Keyboard then
						local ClosestPed = vRP.Source(Keyboard[1])
						if ClosestPed then
							local Ped = GetPlayerPed(source)
							local Coords = GetEntityCoords(Ped)

							vRP.Teleport(ClosestPed, Coords["x"], Coords["y"], Coords["z"])
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "tpto" then
				if vRP.HasGroup(Passport,"Admin",5) or vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source, "ID ou local (paleto, docas, samir, pier, aeroporto trevor):")
					if Keyboard and Keyboard[1] then
						local LocX, LocY, LocZ = AdminTptoResolveLocation(Keyboard[1])
						if LocX and LocY and LocZ then
							vRP.Teleport(source, LocX, LocY, LocZ)
						elseif parseInt(Keyboard[1]) > 0 then
							local ClosestPed = vRP.Source(Keyboard[1])
							if ClosestPed then
								local Ped = GetPlayerPed(ClosestPed)
								local Coords = GetEntityCoords(Ped)
								vRP.Teleport(source, Coords["x"], Coords["y"], Coords["z"])
							else
								TriggerClientEvent("Notify",source,"amarelo","Jogador não encontrado ou local inválido.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","Jogador não encontrado ou local inválido.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "tpway" then
				if vRP.HasGroup(Passport,"Admin",5) then
					vCLIENT.teleportWay(source)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "tuning" then
				if vRP.HasGroup(Passport,"Admin",1) then
					TriggerClientEvent("admin:Tuning", source)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "dv" then
				if vRP.HasGroup(Passport, "Admin", 5) then
					TriggerClientEvent("garages:Delete", source)
				else
					TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissões para deletar veículos.", 5000)
				end
			elseif Mode == "fix" then
				if vRP.HasGroup(Passport,"Admin",4) then
					local Vehicle,Network,Plate = vRPC.VehicleList(source,10)
					if Vehicle then
						local Players = vRPC.Players(source)
						for _,v in pairs(Players) do
							async(function()
								TriggerClientEvent("inventory:repairAdmin",v,Network,Plate)
							end)
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "fuel" then
				if vRP.HasGroup(Passport,"Admin",1) then
					if not vRPC.InsideVehicle(source) then
						local Vehicle,Network,Plate = vRPC.VehicleList(source,10)
						if Vehicle then
							local Keyboard = vKEYBOARD.keySingle(source, "Litros:")
							if Keyboard then
								local Networked = NetworkGetEntityFromNetworkId(Network)
								Entity(Networked)["state"]:set("Fuel", Keyboard[1], true)
								TriggerClientEvent("Notify",source,"verde","Veículo com <b>"..parseInt(Keyboard[1]).."% de Gasolina</b>.",5000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","Você precisa sair do veículo.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "limparea" then
				if vRP.HasGroup(Passport,"Admin",2) then
					local Ped = GetPlayerPed(source)
					local Coords = GetEntityCoords(Ped)
					vCLIENT.Limparea(source, Coords)
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "hash" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Vehicle = vRPC.VehicleHash(source)
					if Vehicle then
						vKEYBOARD.keyCopy(source,"Hash do veículo:",Vehicle)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "setbank" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source,"ID:","Quantidade:")
					if Keyboard then
						vRP.GiveBank(Keyboard[1],Keyboard[2])
						TriggerClientEvent("Notify",source,"verde","Envio concluído.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "rembank" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source, "ID:", "Quantidade:")
					if Keyboard then
						vRP.RemoveBank(Keyboard[1],Keyboard[2])
						TriggerClientEvent("Notify",source,"verde","Remoção concluída.",5000)
						TriggerClientEvent("NotifyItens",source,{ "-", "dollars", parseFormat(Keyboard[2]), "Dólares" })
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "players" then
				if vRP.HasGroup(Passport, "Admin",5) then
					local users = vRP.Players()
					local players = ""
					local quantidade = 0
					for k,v in pairs(users) do
						if k ~= #users then
							players = players..", "
						end
						players = players..k
						quantidade = quantidade + 1
					end
					TriggerClientEvent("Notify",source,"azul","TOTAL ONLINE : <b>"..quantidade.."</b><br>ID's ONLINE : <b>"..players.."</b>",5000)
				end
			elseif Mode == "announce" then
				if vRP.HasGroup(Passport, "Admin",5) then
					local message = vKEYBOARD.keyArea(source, "Mensagem:")
					if message and message[1] then
						local finalMessage = message[1] .. "<br></br>Enviada Por: Governador"
						TriggerClientEvent("Notify", -1, "verde", finalMessage .. "</b>", 45000)
					else
						TriggerClientEvent("Notify", source, "vermelho", "A mensagem não pode estar vazia.", 5000)
					end
				else
					TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissões para isso.", 5000)
				end
			elseif Mode == "chatannounce" then
				if vRP.HasGroup(Passport,"Admin",5) then
					local Keyboard = vKEYBOARD.keyArea(source,"Anúncio:")
					if Keyboard then
						local Messages = Keyboard[1]:gsub("[<>]", "")
						TriggerClientEvent("chat:ClientMessage", -1, "Prefeitura", Messages, "Anúncio")
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.","Atenção",5000)
				end
			elseif Mode == "setcar" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source, "ID:", "Veículo:")
					if Keyboard then
						local Consult = vRP.Query("vehicles/selectVehicles",{ Passport = Keyboard[1], vehicle = Keyboard[2] })
						if Consult[1] then
							TriggerClientEvent("Notify",source,"amarelo","O veículo <b>"..Keyboard[2].."</b> já está adicionado.",5000)
							return
						else
							vRP.Query("vehicles/addVehicles",{ Passport = Keyboard[1], vehicle = Keyboard[2], plate = vRP.GeneratePlate(), work = "false" })
						end
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end		
			elseif Mode == "remcar" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source,"ID:","Veículo:")
					if Keyboard then
						TriggerClientEvent("Notify",source,"verde","Veículo removido com sucesso.",5000)
						vRP.Query("vehicles/removeVehicles",{ Passport = Keyboard[1], vehicle = Keyboard[2] })
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "driverlicense" then
				if vRP.HasGroup(Passport, "Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source, "ID:", "Categoria (A, B, C, D):")
					
					if Keyboard then
						local Passport = tonumber(Keyboard[1])
						local Category = ({A = "1", B = "2", C = "3", D = "4"})[Keyboard[2]]
			
						if Category then
							local Identity = vRP.Identity(Passport)
							local Driverlicense = vRP.UserData(Passport, "Driverlicense")
			
							if json.encode(Driverlicense) ~= "[]" then
								Driverlicense.categories[Category] = Keyboard[2]
							else
								Driverlicense = {
									expiration = os.time() + 2628000,
									issued = os.time(),
									categories = { [Category] = Keyboard[2] },
									name = Identity.name .. " " .. Identity.name2
								}
							end
			
							vRP.GiveItem(Passport,"driverlicense-" .. Passport .. "-" .. json.encode(Driverlicense),1,true)
			
							exports["oxmysql"]:executeSync([[
								INSERT INTO playerdata(Passport, dkey, dvalue) 
								VALUES (:Passport, :dkey, :dvalue) ON DUPLICATE KEY 
								UPDATE dvalue = :dvalue
							]], {
								Passport = Passport,
								dkey = 'Driverlicense',
								dvalue = json.encode(Driverlicense),
							})
						end
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
				end
			elseif Mode == "ney" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						vCLIENT.Neymar(Keyboard[1])
						TriggerClientEvent("Notify", source, "azul", "Você Derrubou o ID " .. Keyboard[1], 5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "voar" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						vCLIENT.Fly(Keyboard[1])
						TriggerClientEvent("Notify",source,"azul","Você Mandou o #" .. Keyboard[1],5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "explodir" then
				if vRP.HasGroup(Passport, "Admin", 1) then
					local Keyboard = vKEYBOARD.keySingle(source, "ID:")
					if Keyboard then
						vCLIENT.Explodir(Keyboard[1])
						TriggerClientEvent("Notify", source, "azul", "Você Explodiu o #" .. Keyboard[1], 5000)
					end
				else
					TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
				end	
			elseif Mode == "fogo" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						vCLIENT.Fogo(Keyboard[1])
						TriggerClientEvent("Notify",source,"azul","Você Colocou Fogo no #" .. Keyboard[1],5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "gelo" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keySingle(source,"ID:")
					if Keyboard then
						vCLIENT.Congelar(Keyboard[1])
						TriggerClientEvent("Notify",source,"azul","Você Congelou #" .. Keyboard[1],5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "clearprison" then
				local Passport = vRP.Passport(source)
				if Passport then
					if vRP.HasGroup(Passport, "Admin", 1) then
						local Keyboard = vKEYBOARD.keySingle(source, "ID:")
						if Keyboard and Keyboard[1] then
							local OtherPlayer = vRP.Source(tonumber(Keyboard[1]))
							if OtherPlayer then
								TriggerClientEvent("police:Prisioner", OtherPlayer, false)
								TriggerClientEvent("Notify", OtherPlayer, "azul", "Sua sentença terminou, esperamos não vê-lo novamente.", 5000)
								vRP.Query("characters/CleanPrison", { Passport = tonumber(Keyboard[1]) })
								Player(OtherPlayer)["state"]["Prison"] = false
								vRP.Teleport(tonumber(Keyboard[1]), BackPrison.x, BackPrison.y, BackPrison.z)
							end
						end
					else
						TriggerClientEvent("Notify", source, "amarelo", "Você não tem permissões para isso.", 5000)
					end
				end
			elseif Mode == "changework" then
				if vRP.HasGroup(Passport,"Admin",1) then
					local Keyboard = vKEYBOARD.keyDouble(source,"ID:","(Nenhum)")
					if Keyboard then
						TriggerClientEvent("Notify",source,"verde","Emprego modificado.","Sucesso",5000)
						vRP.ChangeWork(Keyboard[1], Keyboard[2])
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Você não tem permissões para isso.",5000)
				end
			elseif Mode == "stats" then
				local TotalPMERJ, TotalPCERJ, TotalPRF, TotalBOPE, TotalRECOM, TotalBPCHQ, TotalEX, TotalParamedico, TotalBombeiro, TotalMecanico, TotalMecanico2 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
				
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "PMERJ") then
						TotalPMERJ = TotalPMERJ + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "PCERJ") then
						TotalPCERJ = TotalPCERJ + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "PRF") then
						TotalPRF = TotalPRF + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "BOPE") then
						TotalBOPE = TotalBOPE + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "RECOM") then
						TotalRECOM = TotalRECOM + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "BPCHQ") then
						TotalBPCHQ = TotalBPCHQ + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "EX") then
						TotalEX = TotalEX + 1
					end
				end
				
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Paramedic") then
						TotalParamedico = TotalParamedico + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Bombeiro") then
						TotalBombeiro = TotalBombeiro + 1
					end
				end
				
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Mechanic") then
						TotalMecanico = TotalMecanico + 1
					end
				end

				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Mechanic2") then
						TotalMecanico2 = TotalMecanico2 + 1
					end
				end
				
				local message = "<b>Atualmente</b> " .. parseInt(GetNumPlayerIndices()) .. "</b> pessoa(s) conectadas.<br><br>"
				if TotalPMERJ > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalPMERJ).. " Policiais Militares</b> conectados em serviço.<br>"
				end
				if TotalPCERJ > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalPCERJ).. " Policiais Civis</b> conectados em serviço.<br>"
				end
				if TotalPRF > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalPRF).. " Policiais do Rodoviária Federal</b> conectados em serviço.<br>"
				end
				if TotalBOPE > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalBOPE).. " Policiais BOPE</b> conectados em serviço.<br>"
				end
				if TotalRECOM > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalRECOM).. " Policiais do RECOM</b> conectados em serviço.<br>"
				end
				if TotalBPCHQ > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalBPCHQ).. " Policiais do CHOQUE</b> conectados em serviço.<br>"
				end
				if TotalEX > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalEX).. " Soldados do Exército Brasileiro</b> conectados em serviço.<br>"
				end
				if TotalParamedico > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalParamedico) .. " Paramédicos</b> conectados em serviço.<br>"
				end
				if TotalBombeiro > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalBombeiro) .. " Bombeiros</b> conectados em serviço.<br>"
				end
				if TotalMecanico > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalMecanico) .. " Mecânicos East Custom</b> conectados em serviço."
				end
				if TotalMecanico2 > 0 then
					message = message .. "Atualmente <b>" .. parseInt(TotalMecanico2) .. " Mecânicos Red Line</b> conectados em serviço."
				end
				
				TriggerClientEvent("Notify", source, "azul", message, 10000)
			
			elseif Mode == "statsPMERJ" then
				local TotalPMERJ = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "PMERJ") then
						TotalPMERJ = TotalPMERJ + 1
					end
				end
				if TotalPMERJ > 0 then
					TriggerClientEvent("Notify", source, "police", "Existem <b>" .. parseInt(TotalPMERJ) .. "</b> Policia(s) conectados em serviço.", 10000)
				end

			elseif Mode == "statsPCERJ" then
				local TotalPCERJ = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "PCERJ") then
						TotalPCERJ = TotalPCERJ + 1
					end
				end
				if TotalPCERJ > 0 then
					TriggerClientEvent("Notify", source, "police", "Existem <b>" .. parseInt(TotalPCERJ) .. "</b> Policia(s) conectados em serviço.", 10000)
				end

			elseif Mode == "statsPRF" then
				local TotalPRF = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "PRF") then
						TotalPRF = TotalPRF + 1
					end
				end
				if TotalPRF > 0 then
					TriggerClientEvent("Notify", source, "police", "Existem <b>" .. parseInt(TotalPRF) .. "</b> Policia(s) conectados em serviço.", 10000)
				end

			elseif Mode == "statsBOPE" then
				local TotalBOPE = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "BOPE") then
						TotalBOPE = TotalBOPE + 1
					end
				end
				if TotalBOPE > 0 then
					TriggerClientEvent("Notify", source, "police", "Existem <b>" .. parseInt(TotalBOPE) .. "</b> Policia(s) conectados em serviço.", 10000)
				end

			elseif Mode == "statsRECOM" then
				local TotalRECOM = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "RECOM") then
						TotalRECOM = TotalRECOM + 1
					end
				end
				if TotalRECOM > 0 then
					TriggerClientEvent("Notify", source, "police", "Existem <b>" .. parseInt(TotalRECOM) .. "</b> Policia(s) conectados em serviço.", 10000)
				end

			elseif Mode == "statsBPCHQ" then
				local TotalBPCHQ = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "BPCHQ") then
						TotalBPCHQ = TotalBPCHQ + 1
					end
				end
				if TotalBPCHQ > 0 then
					TriggerClientEvent("Notify", source, "police", "Existem <b>" .. parseInt(TotalBPCHQ) .. "</b> Policia(s) conectados em serviço.", 10000)
				end

			elseif Mode == "statsEX" then
				local TotalEX = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "EX") then
						TotalEX = TotalEX + 1
					end
				end
				if TotalEX > 0 then
					TriggerClientEvent("Notify", source, "police", "Existem <b>" .. parseInt(TotalEX) .. "</b> Policia(s) conectados em serviço.", 10000)
				end
			
			elseif Mode == "statsParamedico" then
				local TotalParamedico = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Paramedic") then
						TotalParamedico = TotalParamedico + 1
					end
				end
				if TotalParamedico > 0 then
					TriggerClientEvent("Notify", source, "paramedic", "Existem <b>" .. parseInt(TotalParamedico) .. "</b> paramédicos conectados em serviço.", 10000)
				end

			elseif Mode == "statsBombeiro" then
				local TotalBombeiro = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Bombeiro") then
						TotalBombeiro = TotalBombeiro + 1
					end
				end
				if TotalBombeiro > 0 then
					TriggerClientEvent("Notify", source, "bombeiro", "Existem <b>" .. parseInt(TotalBombeiro) .. "</b> bombeiros conectados em serviço.", 10000)
				end
			
			elseif Mode == "statsMecanico" then
				local TotalMecanico = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Mechanic") then
						TotalMecanico = TotalMecanico + 1
					end
				end
				if TotalMecanico > 0 then
					TriggerClientEvent("Notify", source, "mecanico", "Existem <b>" .. parseInt(TotalMecanico) .. "</b> mecânicos conectados em serviço.", 10000)
				end
			
			elseif Mode == "statsMecanico2" then
				local TotalMecanico2 = 0
				for _, player in ipairs(vRP.Players()) do
					local passport = vRP.Passport(player)
					if vRP.HasService(passport, "Mechanic2") then
						TotalMecanico2 = TotalMecanico2 + 1
					end
				end
				if TotalMecanico2 > 0 then
					TriggerClientEvent("Notify", source, "mecanico", "Existem <b>" .. parseInt(TotalMecanico2) .. "</b> mecânicos conectados em serviço.", 10000)
				end

			end
		else
			TriggerClientEvent("Notify", source, "vermelho", "Precisas de estar em modo <b>/staff</b> para usar este MENU ADMIN.", 5000)
		end
	end
end)