-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("target")
vPLAYER = Tunnel.getInterface("player")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Zones = {}
local Models = {}
local Selected = {}
local Sucess = false
local Dismantleds = 1
LocalPlayer["state"]["Target"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	RegisterCommand("+entityTarget",TargetEnable)
	RegisterCommand("-entityTarget",TargetDisable)
	RegisterKeyMapping("+entityTarget","Interação auricular.","keyboard","LMENU")

	AddCircleZone("Electricity", vec3(2101.75, 2322.74, 94.53), 0.5, {
		name = "Electricity",
		heading = 0.0
	}, {
		Distance = 0.75,
		options = {
			{
				event = "inventory:Electricity",
				label = "Sabotar",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("NightMarket",vec3(567.71,-3127.05,18.77),0.5,{
		name = "NightMarket",
		heading = 25.52
	},{
		Distance = 0.75,
		options = {
			{
				event = "Night:openMarket",
				label = "Abrir Mercado",
				tunnel = "client"
			}
		}
	})

	AddCircleZone("systemHacker",vec3(-1079.34,-244.83,44.01),0.5,{
		name = "systemHacker",
		heading = 25.52
	},{
		Distance = 0.75,
		options = {
			{
				--event = "stockade:initHacker",
				event = "stockade:Sucess",
				label = "Hackear Carro Forte",
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Informations01",vec3(-95.33,-2767.89,6.46),0.5,{
		name = "Informations01",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "player:Informations",
				label = "Informações",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("Works01", vec3(-364.62, -249.13, 36.47), 0.5, {
		name = "Works01",
		heading = 0.0
	}, {
		Distance = 1.5,
		options = {
			{
				event = "jobcenter:OpenJobCenter",
				label = "Abrir Central",
				tunnel = "server"
			},{
				event = "jobcenter:Solicitar",
				label = "Solicitar Carteira de Trabalho",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("Works02", vec3(2253.84,5158.36,57.81), 0.5, {
		name = "Works02",
		heading = 0.0
	}, {
		Distance = 1.5,
		options = {
			{
				event = "jobcenter:OpenJobCenter",
				label = "Abrir Central",
				tunnel = "server"
			},{
				event = "jobcenter:Solicitar",
				label = "Solicitar Carteira de Trabalho",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("Prison", vec3(1690.5, 2529.67, 45.56), 0.5, {
		name = "Prison",
		heading = 0.0
	}, {
		Distance = 0.75,
		options = {
			{
				event = "police:Scape",
				label = "Escapar",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("Electricity", vec3(2101.75, 2322.74, 94.53), 0.5, {
		name = "Electricity",
		heading = 0.0
	}, {
		Distance = 0.75,
		options = {
			{
				event = "inventory:Electricity",
				label = "Sabotar",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("CallParamedic",vec3(-430.16,-323.16,34.91),0.5,{
		name = "CallParamedic",
		heading = 3374176,
	},{
		shop = "Paramedic",
		Distance = 2.0,
		options = {
			{
				event = "target:CallWorks",
				label = "Buscar Doadores",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("Medicplan01",vec3(-435.7,-325.47,35.81),0.5,{
		name = "Medicplan01",
		heading = 3374176,
	},{
		Distance = 2.0,
		options = {
			{
				event = "target:Medicplan",
				label = "Plano Medico",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("CallMechanic",vec3(875.77,-2097.42,30.48),0.5,{
		name = "CallMechanic",
		heading = 3374176,
	},{
		shop = "Mechanic",
		Distance = 2.0,
		options = {
			{
				event = "target:CallWorks",
				label = "Buscar Clientes",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("CallMechanic2",vec3(2750.37,3498.44,55.25),0.5,{
		name = "CallMechanic2",
		heading = 3374176,
	},{
		shop = "Mechanic2",
		Distance = 2.0,
		options = {
			{
				event = "target:CallWorks",
				label = "Buscar Clientes",
				tunnel = "server"
			}
		}
	})

	AddTargetModel({ -2007231801,1339433404,1694452750,1933174915,-462817101,-469694731,-164877493,486135101 },{
		options = {
			{
				event = "shops:Fuel",
				label = "Comprar Combustível",
				tunnel = "client"
			}
		},
		Distance = 0.75
	})

	AddCircleZone("makePaper",vec3(-533.18,5292.15,74.17),0.5,{
		name = "makePaper",
		heading = 3374176
	},{
		Distance = 0.75,
		options = {
			{
				event = "inventory:MakeProducts",
				label = "Produzir",
				tunnel = "products",
				service = "paper"
			}
		}
	})

	AddTargetModel({ 654385216,161343630,-430989390,1096374064,-1519644200,-1932041857,207578973,-487222358 },{
		options = {
			{
				event = "slotmachine:Init",
				label = "Caça-Níqueis",
				tunnel = "client"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ -1691644768,-742198632 },{
		options = {
			{
				event = "inventory:MakeProducts",
				label = "Encher",
				tunnel = "products",
				service = "emptybottle"
			},
			{
				event = "inventory:Drink",
				label = "Beber",
				tunnel = "server"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ -935625561 },{
		options = {
			{
				event = "target:BedDeitar",
				label = "Deitar",
				tunnel = "client"
			},{
				event = "target:BedPickup",
				label = "Pegar",
				tunnel = "client"
			},{
				event = "target:BedDestroy",
				label = "Destruir",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 690372739 },{
		options = {
			{
				event = "shops:Coffee",
				label = "Comprar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -654402915,1421582485 },{
		options = {
			{
				event = "shops:Donut",
				label = "Comprar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 992069095,1114264700 },{
		options = {
			{
				event = "shops:Soda",
				label = "Comprar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 1129053052 },{
		options = {
			{
				event = "shops:Burger",
				label = "Comprar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -1581502570 },{
		options = {
			{
				event = "shops:Hotdog",
				label = "Comprar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -272361894 },{
		options = {
			{
				event = "shops:Chihuahua",
				label = "Comprar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 1099892058 },{
		options = {
			{
				event = "shops:Water",
				label = "Comprar",
				tunnel = "client"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 1281992692, 1158960338, 1511539537, -78626473, -429560270 }, {
		options = {
			{
				event = "target:Call",
				label = "Ligar para Delegacia",
				tunnel = "proserver",
				service = "Police"
			}, {
				event = "target:Call",
				label = "Ligar para Hospital",
				tunnel = "proserver",
				service = "Paramedic"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 684586828,577432224,-1587184881,-1426008804,-228596739,1437508529,-1096777189,-468629664,1143474856,-2096124444,-115771139,1329570871,-130812911 },{
		options = {
			{
				event = "inventory:VerifyObjects",
				label = "Vasculhar",
				tunnel = "shop",
				service = "Lixeiro"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ 858993389, 2913180574 }, {
		options = {
			{
				event = "inventory:ObjectsVerify",
				label = "Roubar Frutas",
				tunnel = "shop",
				service = "Fruits"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -1207886863, 568309711, 200010599, 1888301071, 1677473970, 323971301 }, {
		options = {
			{
				event = "inventory:ObjectsVerify",
				label = "Procurar Petróleo",
				tunnel = "shop",
				service = "Pumpjack"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ 1711856655, -1672689514, -1951226014, 382933634 }, {
		options = {
			{
				event = "inventory:ObjectsVerify",
				label = "Vasculhar",
				tunnel = "shop",
				service = "Bricks"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -1940238623, 2108567945 }, {
		options = {
			{
				event = "inventory:ObjectsVerify",
				label = "Vasculhar",
				tunnel = "shop",
				service = "Parkimeter"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ 1898296526, 1069797899, 1434516869, -896997473, -1748303324, -1366478936, 2090224559, -52638650, 591265130, -915224107, -273279397, 322493792, 10106915, 1120812170 }, {
		options = {
			{
				event = "inventory:ObjectsVerify",
				label = "Vasculhar",
				tunnel = "shop",
				service = "CarWreck"
			}
		},
		Distance = 1.00
	})

	AddTargetModel({ -206690185,666561306,218085040,-58485588,1511880420,682791951 },{
		options = {
			{
				event = "inventory:VerifyObjects",
				label = "Vasculhar",
				tunnel = "shop",
				service = "Lixeiro"
			},{
				event = "player:enterTrash",
				label = "Esconder",
				tunnel = "client"
			},{
				event = "player:checkTrash",
				label = "Verificar",
				tunnel = "server"
			},{
				event = "chest:Open",
				label = "Abrir",
				tunnel = "entity",
				service = "Custom"
			}
		},
		Distance = 0.75
	})

	AddCircleZone("Juice01",vec3(-1843.61,-1198.19,14.72),0.5,{
		name = "Juice01",
		heading = 3374176
	},{
		Distance = 1.25,
		options = {
			{
				event = "inventory:MakeProducts",
				label = "Encher Copo",
				tunnel = "products",
				service = "Pearls1"
			}
		}
	})

	AddCircleZone("tabletVehicles01",vec3(-339.48,-1370.03,31.86),1.25,{
		name = "tabletVehicles01",
		heading = 3374176
	},{
		Distance = 2.0,
		options = {
			{
				event = "pdm:Open",
				label = "Abrir",
				tunnel = "shop"
			}
		}
	})

	AddCircleZone("CassinoWheel",vec3(990.4,40.54,71.26),0.5,{
		name = "CassinoWheel",
		heading = 3374176
	},{
		Distance = 1.5,
		options = {
			{
				event = "luckywheel:Target",
				label = "Roda da Fortuna",
				tunnel = "client"
			}
		}
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function TargetEnable()
	if LocalPlayer["state"]["Active"] and not IsPauseMenuActive() then
		local Ped = PlayerPedId()

		if (not LocalPlayer["state"]["Admin"] and LocalPlayer["state"]["Charizard"]) or LocalPlayer["state"]["Camera"] or LocalPlayer["state"]["Freecam"] or LocalPlayer["state"]["Carry"] or not MumbleIsConnected() or LocalPlayer["state"]["Buttons"] or LocalPlayer["state"]["Commands"] or LocalPlayer["state"]["Handcuff"] or Sucess or IsPedArmed(Ped,6) or IsPedInAnyVehicle(Ped) then
			return
		end

		SendNUIMessage({ Action = "Open" })
		LocalPlayer["state"]["Target"] = true

		while LocalPlayer["state"]["Target"] do
			local hitZone,entCoords,Entity = RayCastGamePlayCamera()

			if hitZone == 1 then
				local Coords = GetEntityCoords(Ped)

				for k,v in pairs(Zones) do
					if Zones[k]:isPointInside(entCoords) then
						if #(Coords - Zones[k]["center"]) <= v["targetoptions"]["Distance"] then

							if v["targetoptions"]["shop"] ~= nil then
								Selected = v["targetoptions"]["shop"]
							end

							SendNUIMessage({ Action = "Valid", data = Zones[k]["targetoptions"]["options"] })

							Sucess = true
							while Sucess do
								local Ped = PlayerPedId()
								local Coords = GetEntityCoords(Ped)
								local _,entCoords = RayCastGamePlayCamera()

								if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
								end

								if not Zones[k]:isPointInside(entCoords) or #(Coords - Zones[k]["center"]) > v["targetoptions"]["Distance"] then
									Sucess = false
								end

								Wait(1)
							end

							SendNUIMessage({ Action = "Left" })
						end
					end
				end

				if GetEntityType(Entity) ~= 0 then
					if IsEntityAVehicle(Entity) then
						local Plate = GetVehicleNumberPlateText(Entity)
						if #(Coords - entCoords) <= 1.0 and Plate ~= "PDMSPORT" then
							local Network = nil
							local Combustivel = false
							local vehModel = GetEntityModel(Entity)
							SetEntityAsMissionEntity(Entity,true,true)

							if NetworkGetEntityIsNetworked(Entity) then
								Network = VehToNet(Entity)
							end

							Selected = { Plate,vRP.VehicleModel(Entity),Entity,Network }

							local Menu = {}

							for k,v in pairs(Fuels) do
								local Distance = #(Coords - vec3(v[1],v[2],v[3]))
								if Distance <= 2.5 then
									Combustivel = true
									break
								end
							end

							if not Combustivel then
								if GetSelectedPedWeapon(Ped) == 883325847 then
									Selected[5] = true
									Menu[#Menu + 1] = { event = "engine:Supply", label = "Abastecer", tunnel = "client" }
								else
									if GlobalState["Plates"][Plate] then
										if GetVehicleDoorLockStatus(Entity) == 1 then
											for k,Tyre in pairs(TyreList) do
												local Wheel = GetEntityBoneIndexByName(Entity,k)
												if Wheel ~= -1 then
													local cWheel = GetWorldPositionOfEntityBone(Entity,Wheel)
													local Distance = #(Coords - cWheel)
													if Distance <= 1.3 then
														Selected[5] = Tyre
														Menu[#Menu + 1] = { event = "inventory:RemoveTyres", label = "Retirar Pneu", tunnel = "client" }
													end
												end
											end

											Menu[#Menu + 1] = { event = "trunkchest:openTrunk", label = "Abrir Porta-Malas", tunnel = "server" }
											Menu[#Menu + 1] = { event = "player:checkTrunk", label = "Checar Porta-Malas", tunnel = "server" }
											Menu[#Menu + 1] = { event = "Night_Towing:openTowingMenu", label = "Rebocar Veículo", tunnel = "client" }
										end

										Menu[#Menu + 1] = { event = "garages:Key", label = "Criar Chave Cópia", tunnel = "server" }
										Menu[#Menu + 1] = { event = "inventory:applyPlate", label = "Trocar Placa", tunnel = "server" }
									else
										if Selected[2] == "stockade" then
											Menu[#Menu + 1] = { event = "inventory:Stockade", label = "Carro Forte Roubar", tunnel = "police" }
										end
									end

									if not IsThisModelABike(vehModel) then
										local Rolling = GetEntityRoll(Entity)
										if Rolling > 75.0 or Rolling < -75.0 then
											Menu[#Menu + 1] = { event = "player:RollVehicle", label = "Desvirar", tunnel = "server" }
										else
											if GetEntityBoneIndexByName(Entity,"boot") ~= -1 then
												local Trunk = GetEntityBoneIndexByName(Entity,"boot")
												local cTrunk = GetWorldPositionOfEntityBone(Entity,Trunk)
												local Distance = #(Coords - cTrunk)
												if Distance <= 1.75 then
													if GetVehicleDoorLockStatus(Entity) == 1 then
														Menu[#Menu + 1] = { event = "player:enterTrunk", label = "Entrar no Porta-Malas", tunnel = "client" }
													else
														Menu[#Menu + 1] = { event = "trunkchest:forceTrunk", label = "Forçar Porta-Malas", tunnel = "server" }
													end

													Menu[#Menu + 1] = { event = "inventory:StealTrunk", label = "Arrombar Porta-Malas", tunnel = "client" }
												end
											end
										end
									end

									if LocalPlayer["state"]["PMERJ"] or LocalPlayer["state"]["PCERJ"] or LocalPlayer["state"]["PRF"] or LocalPlayer["state"]["BOPE"] or LocalPlayer["state"]["RECOM"] or LocalPlayer["state"]["BPCHQ"] or LocalPlayer["state"]["EX"] then
										Menu[#Menu + 1] = { event = "police:Plate", label = "Verificar Placa", tunnel = "police" }

										if GlobalState["Plates"][Plate] then
											Menu[#Menu + 1] = { event = "police:ArrestVehicles", label = "Apreender Veículo", tunnel = "police" }
									   end
									else
										for k,v in pairs(Dismantles) do
										    if Plate == "DISM"..(1000 + LocalPlayer["state"]["Passport"]) then
											    local Distance = #(Coords - vec3(v[1],v[2],v[3]))
											    if Distance <= 10 then
												    Menu[#Menu + 1] = { event = "inventory:Dismantle", label = "Desmanchar", tunnel = "client" }
												end
											end
										end

										for k,v in pairs(Tows) do
											local Distance = #(Coords - vec3(v[1],v[2],v[3]))
											if Distance <= 10 then
												if Distance <= 10 then
													Menu[#Menu + 1] = { event = "towdriver:Tow", label = "Rebocar", tunnel = "client" }
											  end
											end
										end
									end
								end
							else
								Selected[5] = false
								Menu[#Menu + 1] = { event = "engine:Supply", label = "Abastecer", tunnel = "client" }
							end

							SendNUIMessage({ Action = "Valid", data = Menu })

							Sucess = true
							while Sucess do
								local Ped = PlayerPedId()
								local Coords = GetEntityCoords(Ped)
								local _,entCoords,Entity = RayCastGamePlayCamera()

								if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
								end

								if GetEntityType(Entity) == 0 or #(Coords - entCoords) > 1.0 then
									Sucess = false
								end

								Wait(1)
							end

							SendNUIMessage({ Action = "Left" })
						end
					elseif IsPedAPlayer(Entity) then
						if #(Coords - entCoords) <= 1.0 then
							local index = NetworkGetPlayerIndexFromPed(Entity)
							local source = GetPlayerServerId(index)
							local Menu = {}

							Selected = { source }

							for k,v in pairs(Adrenaline) do
								local Distance = #(Coords - vec3(v[1],v[2],v[3]))
								if Distance <= 10 then
									Menu[#Menu + 1] = { event = "paramedic:Adrenaline", label = "Reviver", tunnel = "paramedic" }
								end
							end

							if LocalPlayer["state"]["PMERJ"] or LocalPlayer["state"]["PCERJ"] or LocalPlayer["state"]["PRF"] or LocalPlayer["state"]["BOPE"] or LocalPlayer["state"]["RECOM"] or LocalPlayer["state"]["BPCHQ"] or LocalPlayer["state"]["EX"] then
								Menu[#Menu + 1] = { event = "Police:Revive", label = "Reanimar", tunnel = "paramedic" }
								Menu[#Menu + 1] = { event = "police:runInspect", label = "Revistar", tunnel = "police" }
								Menu[#Menu + 1] = { event = "police:ArrestItens", label = "Apreender", tunnel = "paramedic" }
								Menu[#Menu + 1] = { event = "autoschool:SeizeCnh", label = "Apreender CNH", tunnel = "paramedic" }
								Menu[#Menu + 1] = { event = "police:prisonClothes", label = "Uniforme Presidiário", tunnel = "police" }
							elseif LocalPlayer["state"]["Paramedic"] or LocalPlayer["state"]["Bombeiro"] then
								if GetEntityHealth(Entity) <= 100 then
									Menu[#Menu + 1] = { event = "paramedic:Revive", label = "Reanimar", tunnel = "paramedic" }
								else
									Menu[#Menu + 1] = { event = "paramedic:Treatment", label = "Tratamento", tunnel = "paramedic" }
									Menu[#Menu + 1] = { event = "paramedic:Reposed", label = "Colocar de Repouso", tunnel = "paramedic" }
									Menu[#Menu + 1] = { event = "paramedic:Bandage", label = "Passar Ataduras", tunnel = "paramedic" }
									Menu[#Menu + 1] = { event = "paramedic:presetPlaster", label = "Colocar Gesso", tunnel = "paramedic" }
									Menu[#Menu + 1] = { event = "paramedic:extractBlood", label = "Extrair Sangue", tunnel = "paramedic" }
								end

								Menu[#Menu + 1] = { event = "paramedic:Diagnostic", label = "Informações", tunnel = "paramedic" }
								Menu[#Menu + 1] = { event = "paramedic:Bed", label = "Deitar Paciente", tunnel = "paramedic" }
							end

							if IsEntityPlayingAnim(Entity, "random@mugging3", "handsup_standing_base", 3) then
								Menu[#Menu + 1] = { event = "player:runInspect2", label = "Revistar", tunnel = "police" }
								Menu[#Menu + 1] = { event = "player:checkShoes", label = "Roubar Sapatos", tunnel = "paramedic" }
								--Menu[#Menu + 1] = { event = "player:Charge", label = "Cobrança", tunnel = "paramedic" }
							end

							if GetEntityHealth(Entity) <= 100 then
								Menu[#Menu + 1] = { event = "police:runSaquear", label = "Saquear", tunnel = "police" }
							end

							if GetEntityHealth(Entity) > 100 then
								Menu[#Menu + 1] = { event = "player:runInspect", label = "Revistar", tunnel = "police" }
								Menu[#Menu + 1] = { event = "player:checkShoes", label = "Roubar Sapatos", tunnel = "paramedic" }
								Menu[#Menu + 1] = { event = "player:Charge", label = "Cobrança", tunnel = "paramedic" }
								Menu[#Menu + 1] = { event = "target:Jokenpo", label = "Jokenpô", tunnel = "server" }
								
								local Reputation = vPLAYER.GetReputation(source)
								if Reputation then
									Menu[#Menu + 1] = { event = "player:Like", label = "👍 Curtir ["..parseInt(Reputation[1]).."]", tunnel = "paramedic" }
									Menu[#Menu + 1] = { event = "player:UnLike", label = "👎 Descurtir ["..parseInt(Reputation[2]).."]", tunnel = "paramedic" }
								end
							end

							SendNUIMessage({ Action = "Valid", data = Menu })

							Sucess = true
							while Sucess do
								local Ped = PlayerPedId()
								local Coords = GetEntityCoords(Ped)
								local _,entCoords,Entity = RayCastGamePlayCamera()

								if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
								end

								if GetEntityType(Entity) == 0 or #(Coords - entCoords) > 1.0 then
									Sucess = false
								end

								Wait(1)
							end

							SendNUIMessage({ Action = "Left" })
						end
					else
						for k,v in pairs(Models) do
							if DoesEntityExist(Entity) then
								if k == GetEntityModel(Entity) then
									if #(Coords - entCoords) <= Models[k]["Distance"] then
										local objNet = nil
										if NetworkGetEntityIsNetworked(Entity) then
											objNet = ObjToNet(Entity)
										end

										Selected = { Entity,k,objNet,GetEntityCoords(Entity) }

										SendNUIMessage({ Action = "Valid", data = Models[k]["options"] })

										Sucess = true
										while Sucess do
											local Ped = PlayerPedId()
											local Coords = GetEntityCoords(Ped)
											local _,entCoords,Entity = RayCastGamePlayCamera()

											if (IsControlJustReleased(1,24) or IsDisabledControlJustReleased(1,24)) then
												SetCursorLocation(0.5,0.5)
												SetNuiFocus(true,true)
											end

											if GetEntityType(Entity) == 0 or #(Coords - entCoords) > Models[k]["Distance"] then
												Sucess = false
											end

											Wait(1)
										end

										SendNUIMessage({ Action = "Left" })
									end
								end
							end
						end
					end
				end
			end

			Wait(100)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ROLLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:RollVehicle")
AddEventHandler("target:RollVehicle",function(Network)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleOnGroundProperly(Vehicle)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:DISMANTLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Dismantles")
AddEventHandler("target:Dismantles",function()
	Dismantleds = math.random(#Dismantles)
	TriggerEvent("NotifyPush",{ code = 20, title = "Localização do Desmanche", x = Dismantles[Dismantleds][1], y = Dismantles[Dismantleds][2], z = Dismantles[Dismantleds][3], blipColor = 60 })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function TargetDisable()
	if Sucess or not LocalPlayer["state"]["Target"] then
		return
	end

	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Select",function(Data,Callback)
	Sucess = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false

	if Data["tunnel"] == "client" then
		TriggerEvent(Data["event"],Selected)
	elseif Data["tunnel"] == "shop" then
		TriggerEvent(Data["event"],Selected,Data["service"])
	elseif Data["tunnel"] == "entity" then
		TriggerEvent(Data["event"],Selected[1],Data["service"])
	elseif Data["tunnel"] == "products" then
		TriggerEvent(Data["event"],Data["service"])
	elseif Data["tunnel"] == "server" then
		TriggerServerEvent(Data["event"],Selected)
	elseif Data["tunnel"] == "police" then
		TriggerServerEvent(Data["event"],Selected,Data["service"])
	elseif Data["tunnel"] == "paramedic" then
		TriggerServerEvent(Data["event"],Selected[1],Data["service"])
	elseif Data["tunnel"] == "proserver" then
		TriggerServerEvent(Data["event"],Data["service"])
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	Sucess = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Debug")
AddEventHandler("target:Debug",function()
	Sucess = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
	LocalPlayer["state"]["Target"] = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCOORDSFROMCAM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCoordsFromCam(Distance,Coords)
	local Rotation = GetGameplayCamRot()
	local Adjuste = vec3((math.pi / 180) * Rotation["x"],(math.pi / 180) * Rotation["y"],(math.pi / 180) * Rotation["z"])
	local direction = vec3(-math.sin(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.cos(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.sin(Adjuste[1]))

	return vec3(Coords[1] + direction[1] * Distance, Coords[2] + direction[2] * Distance, Coords[3] + direction[3] * Distance)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAYCASTGAMEPLAYCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
function RayCastGamePlayCamera()
	local Ped = PlayerPedId()
	local Cam = GetGameplayCamCoord()
	local Cam2 = GetCoordsFromCam(10.0,Cam)
	local Handle = StartExpensiveSynchronousShapeTestLosProbe(Cam,Cam2,-1,Ped,4)
	local a,Hit,Coords,b,Entity = GetShapeTestResult(Handle)

	return Hit,Coords,Entity
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddCircleZone(Name,Center,Radius,Options,Target)
	Zones[Name] = CircleZone:Create(Center,Radius,Options)
	Zones[Name]["targetoptions"] = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function RemCircleZone(Name)
	if Zones[Name] then
		Zones[Name] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTARGETMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function AddTargetModel(Model,Options)
	for _,v in pairs(Model) do
		Models[v] = Options
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function LabelText(Name,Text)
	if Zones[Name] then
		Zones[Name]["targetoptions"]["options"][1]["label"] = Text
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBOXZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddBoxZone(Name,Center,Length,Width,Options,Target)
    Zones[Name] = BoxZone:Create(Center,Length,Width,Options)
    Zones[Name]["targetoptions"] = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("LabelText",LabelText)
exports("AddBoxZone",AddBoxZone)
exports("RemCircleZone",RemCircleZone)
exports("AddCircleZone",AddCircleZone)
exports("AddTargetModel",AddTargetModel)