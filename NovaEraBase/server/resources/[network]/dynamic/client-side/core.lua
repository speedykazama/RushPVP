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
vSERVER = Tunnel.getInterface("dynamic")
vINVENTORY = Tunnel.getInterface("inventory")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Dynamic = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
local HashAnimal = nil
local SpawnAnimal = false
local FollowAnimal = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,id)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = id })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("openMenu",function()
	SendNUIMessage({ show = true })
	SetNuiFocus(true,true)
	Dynamic = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(Data,Callback)
	if Data["trigger"] and Data["trigger"] ~= "" then
		if Data["server"] == "true" then
			TriggerServerEvent(Data["trigger"],Data["param"])
		else
			TriggerEvent(Data["trigger"],Data["param"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)
	Dynamic = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem",function()
	if Dynamic then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		Dynamic = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("globalFunctions",function()
-- 	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Prison"] and not Dynamic and not IsPauseMenuActive() then
-- 		local Ped = PlayerPedId()
-- 		local Coords = GetEntityCoords(Ped)

-- 		if GetEntityHealth(Ped) > 100 then
-- 			if LocalPlayer["state"]["Premium"] or LocalPlayer["state"]["PremiumOuro"] or LocalPlayer["state"]["PremiumPrata"]then
-- 			exports["dynamic"]:AddButton("Vestir Platinum","Vestir-se com as vestimentas guardadas.","player:Outfit","aplicarplatina","wardrobepremium",true)
-- 			exports["dynamic"]:AddButton("Salvar Platinum","Salvar suas vestimentas do corpo.","player:Outfit","salvarplatina","wardrobepremium",true)
-- 			exports["dynamic"]:AddButton("Vestir Ouro","Vestir-se com as vestimentas guardadas.","player:Outfit","aplicarouro","wardrobepremium",true)
-- 			exports["dynamic"]:AddButton("Salvar Ouro","Salvar suas vestimentas do corpo.","player:Outfit","salvarouro","wardrobepremium",true)
-- 			exports["dynamic"]:AddButton("Vestir Prata","Vestir-se com as vestimentas guardadas.","player:Outfit","aplicarprata","wardrobepremium",true)
-- 			exports["dynamic"]:AddButton("Salvar Prata","Salvar suas vestimentas do corpo.","player:Outfit","salvarprata","wardrobepremium",true)
-- 			exports["dynamic"]:AddButton("Remover Roupas","Remover suas vestimentas do corpo.","player:Outfit","remover","wardrobepremium",true)
-- 			exports["dynamic"]:SubMenu("Roupas Premium","Colocar/Retirar roupas.","wardrobepremium")
-- 			--exports["dynamic"]:SubMenu("Roupas Premium Ouro","Colocar/Retirar roupas.","wardrobepremium2")
-- 			--exports["dynamic"]:SubMenu("Roupas Premium Prata","Colocar/Retirar roupas.","wardrobepremium3")
-- 		end

-- 			exports["dynamic"]:AddButton("Vestir","Vestir-se com as vestimentas guardadas.","player:Outfit","aplicar","wardrobe",true)
-- 			exports["dynamic"]:AddButton("Guardar","Salvar suas vestimentas do corpo.","player:Outfit","salvar","wardrobe",true)
-- 			exports["dynamic"]:AddButton("Remover","Remover suas vestimentas do corpo.","player:Outfit","remover","wardrobe",true)
-- 			exports["dynamic"]:SubMenu("Armário","Colocar/Retirar roupas.","wardrobe")

-- 			if HashAnimal ~= nil then
-- 				exports["dynamic"]:AddButton("Seguir", "Seguir o proprietário.", "dynamic:animalFunctions", "follow", "animals", false)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar o animal no veículo.", "dynamic:animalFunctions", "putvehicle", "animals", false)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover o animal no veículo.", "dynamic:animalFunctions", "removevehicle", "animals", false)
-- 				exports["dynamic"]:SubMenu("Domésticos", "Tudo sobre animais domésticos.", "animals")
-- 			end

-- 			exports["dynamic"]:AddButton("Chapéu","Colocar/Retirar o chapéu.","player:Outfit","Hat","clothes",true)
-- 			exports["dynamic"]:AddButton("Máscara","Colocar/Retirar a máscara.","player:Outfit","Mask","clothes",true)
-- 			exports["dynamic"]:AddButton("Óculos","Colocar/Retirar o óculos.","player:Outfit","Glasses","clothes",true)
-- 			exports["dynamic"]:AddButton("Camisa","Colocar/Retirar a camisa.","player:Outfit","Shirt","clothes",true)
-- 			exports["dynamic"]:AddButton("Jaqueta","Colocar/Retirar a jaqueta.","player:Outfit","Torso","clothes",true)
-- 			exports["dynamic"]:AddButton("Mãos","Ajustas as mãos.","player:Outfit","Arms","clothes",true)
-- 			exports["dynamic"]:AddButton("Colete","Colocar/Retirar o colete.","player:Outfit","Vest","clothes",true)
-- 			exports["dynamic"]:AddButton("Calça","Colocar/Retirar a calça.","player:Outfit","Pants","clothes",true)
-- 			exports["dynamic"]:AddButton("Sapatos","Colocar/Retirar o sapato.","player:Outfit","Shoes","clothes",true)
-- 			exports["dynamic"]:AddButton("Acessórios","Colocar/Retirar os acessórios.","player:Outfit","Accessory","clothes",true)
-- 			exports["dynamic"]:SubMenu("Roupas","Colocar/Retirar roupas.","clothes")

-- 			local Vehicle = vRP.ClosestVehicle(7)
-- 			local LastVehicle = GetLastDrivenVehicle()
-- 			if IsEntityAVehicle(Vehicle) then
-- 				if not IsPedInAnyVehicle(Ped) then				
-- 					if GetEntityModel(LastVehicle) == GetHashKey("flatbed") or GetEntityModel(LastVehicle) == GetHashKey("flatbed3") or GetEntityModel(LastVehicle) == GetHashKey("energyrepair") or GetEntityModel(LastVehicle) == GetHashKey("WRflatbed") or GetEntityModel(LastVehicle) == GetHashKey("WRflatbed2") and not IsPedInAnyVehicle(Ped) then
-- 						exports["dynamic"]:AddButton("Rebocar","Colocar o veículo na prancha.","towdriver:invokeTow","","others",false)
-- 					end

-- 					if vRP.ClosestPed(3) then
-- 						exports["dynamic"]:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","closestpeds",true)
-- 						exports["dynamic"]:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","closestpeds",true)

-- 						exports["dynamic"]:SubMenu("Jogador","Pessoa mais próxima de você.","closestpeds")
-- 					end
-- 				else
-- 					exports["dynamic"]:AddButton("Sentar no Motorista","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
-- 					exports["dynamic"]:AddButton("Sentar no Passageiro","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
-- 					exports["dynamic"]:AddButton("Sentar em Outros","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
-- 					exports["dynamic"]:AddButton("Mexer nos Vidros","Levantar/Abaixar os vidros.","player:Windows","","vehicle",false)
-- 					exports["dynamic"]:AddButton("Estatísticas","Informações do veículo.","engine:vehTuning","","vehicle",false)

-- 					exports["dynamic"]:SubMenu("Veículo","Funções do veículo.","vehicle")
-- 				end

-- 				exports["dynamic"]:AddButton("Porta do Motorista","Abrir porta do motorista.","player:Doors","1","doors",true)
-- 				exports["dynamic"]:AddButton("Porta do Passageiro","Abrir porta do passageiro.","player:Doors","2","doors",true)
-- 				exports["dynamic"]:AddButton("Porta Traseira Esquerda","Abrir porta traseira esquerda.","player:Doors","3","doors",true)
-- 				exports["dynamic"]:AddButton("Porta Traseira Direita","Abrir porta traseira direita.","player:Doors","4","doors",true)
-- 				exports["dynamic"]:AddButton("Porta-Malas","Abrir porta-malas.","player:Doors","5","doors",true)
-- 				exports["dynamic"]:AddButton("Capô","Abrir capô.","player:Doors","6","doors",true)

-- 				exports["dynamic"]:SubMenu("Portas","Portas do veículo.","doors")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedades","Marcar/Desmarcar propriedades no mapa.","propertys:Blips","","others",false)    ---player:status
-- 			exports["dynamic"]:AddButton("Armazéns", "Marcar/Desmarcar armazéns no mapa.", "warehouse:Blips", "", "others", false)
-- 			exports["dynamic"]:AddButton("Ferimentos","Verificar ferimentos no corpo.","paramedic:Injuries","","others",false)
-- 			exports["dynamic"]:AddButton("Desbugar","Recarregar o personagem.","player:Debug","","others",true)
-- 			exports["dynamic"]:AddButton("Status da Cidade", "Tudo sobre nossa cidade.", "admin:Dynamic", "stats","others", true)
-- 			exports["dynamic"]:AddButton("Identidade", "informações do seu Personagem.", "Creative:identity", "","others", true)

-- 			exports["dynamic"]:SubMenu("Outros","Todas as funções do personagem.","others")

-- 			exports["dynamic"]:openMenu()
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TENCODEFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("tencodeFunctions", function()
-- 	if LocalPlayer["state"]["PMERJ"] or LocalPlayer["state"]["PCERJ"] or LocalPlayer["state"]["PRF"] or LocalPlayer["state"]["BOPE"] or LocalPlayer["state"]["RECOM"] or LocalPlayer["state"]["BPCHQ"] or LocalPlayer["state"]["EX"] and not IsPauseMenuActive() then
-- 		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and LocalPlayer["state"]["Route"] < 900000 then
-- 			exports["dynamic"]:AddButton("QTI", "Deslocamento.", "dynamic:Tencode", "1", false, true)
-- 			exports["dynamic"]:AddButton("QTH", "Localização.", "dynamic:Tencode", "2", false, true)
-- 			exports["dynamic"]:AddButton("QRR", "Apoio com prioridade.", "dynamic:Tencode", "3", false, true)
-- 			exports["dynamic"]:AddButton("QRT", "Oficial desmaiado/ferido.", "dynamic:Tencode", "4", false, true)
-- 			exports["dynamic"]:openMenu()
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("emergencyFunctions", function()
-- 	if (LocalPlayer["state"]["PMERJ"] or LocalPlayer["state"]["PCERJ"] or LocalPlayer["state"]["PRF"] or LocalPlayer["state"]["BOPE"] or LocalPlayer["state"]["RECOM"] or LocalPlayer["state"]["BPCHQ"] or LocalPlayer["state"]["EX"] or LocalPlayer["state"]["Paramedic"] or LocalPlayer["state"]["Bombeiro"] or LocalPlayer["state"]["Mechanic"] or LocalPlayer["state"]["Mechanic2"]) and not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not LocalPlayer["state"]["Prison"] and not Dynamic then
-- 		local Ped = PlayerPedId()
-- 		if LocalPlayer["state"]["PMERJ"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anuncio para Ação", "Fazer um anúncio para todos os moradores.", "dynamic:PoliceAnuncio", "", false, true)
-- 				exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsPMERJ", false, true)

-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("Recruta", "Fardamento de Recruta.", "player:Preset", "14", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Soldado", "Fardamento de Soldado.", "player:Preset", "15", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Cabo", "Fardamento de Cabo.", "player:Preset", "16", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Sargento", "Fardamento de Sargento.", "player:Preset", "17", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Sub-Tenente", "Fardamento de Sub-Tenente.", "player:Preset", "18", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Sub-Tenente 2", "Fardamento de Sub-Tenente 2.", "player:Preset", "19", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Tenente", "Fardamento de Tenente.", "player:Preset", "20", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Tenente 2", "Fardamento de Tenente 2.", "player:Preset", "21", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Capitão", "Fardamento de Capitão.", "player:Preset", "22", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Capitão 2", "Fardamento de Capitão 2.", "player:Preset", "23", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Major", "Fardamento de Major.", "player:Preset", "24", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Major 2", "Fardamento de Major 2.", "player:Preset", "25", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Coronel", "Fardamento de Coronel.", "player:Preset", "26", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Coronel 2", "Fardamento de Coronel 2.", "player:Preset", "27", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Motorizado", "Fardamento de Motorizado.", "player:Preset", "28", "prePMERJ", true)
-- 				exports["dynamic"]:AddButton("Treinamento", "Fardamento de Treinamento.", "player:Preset", "29", "prePMERJ", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos policiais.", "prePMERJ")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedade", "Invadir Propriedade.", "propertys:invadePoliceEvent", "", false, false)
-- 			exports["dynamic"]:AddButton("Computador", "Computador de bordo policial.", "police:Open", "", false, false)
-- 			exports["dynamic"]:openMenu()
		
-- 		elseif LocalPlayer["state"]["PCERJ"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsPCERJ", false, true)

-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("Delegado", "Fardamento de Delegado.", "player:Preset", "30", "prePCERJ", true)
-- 				exports["dynamic"]:AddButton("Perito", "Fardamento de Perito.", "player:Preset", "31", "prePCERJ", true)
-- 				exports["dynamic"]:AddButton("Investigador", "Fardamento de Investigador.", "player:Preset", "32", "prePCERJ", true)
-- 				exports["dynamic"]:AddButton("Escrivão", "Fardamento de Escrivão.", "player:Preset", "33", "prePCERJ", true)
-- 				exports["dynamic"]:AddButton("Operacional", "Fardamento de Operacional.", "player:Preset", "34", "prePCERJ", true)
-- 				exports["dynamic"]:AddButton("CORE 1", "Fardamento da CORE 1.", "player:Preset", "35", "prePCERJ", true)
-- 				exports["dynamic"]:AddButton("CORE 2", "Fardamento da CORE 2.", "player:Preset", "36", "prePCERJ", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos policiais.", "prePCERJ")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedade", "Invadir Propriedade.", "propertys:invadePoliceEvent", "", false, false)
-- 			exports["dynamic"]:AddButton("Computador", "Computador de bordo policial.", "police:Open", "", false, false)
-- 			exports["dynamic"]:openMenu()

-- 		elseif LocalPlayer["state"]["PRF"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsPRF", false, true)

-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("Uniforme", "Uniforme da PRF.", "player:Preset", "37", "prePRF", true)
-- 				exports["dynamic"]:AddButton("Camuflado", "Camuflado da PRF.", "player:Preset", "38", "prePRF", true)
-- 				exports["dynamic"]:AddButton("Moto", "Fardamento de Moto da PRF.", "player:Preset", "39", "prePRF", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos policiais.", "prePRF")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedade", "Invadir Propriedade.", "propertys:invadePoliceEvent", "", false, false)
-- 			exports["dynamic"]:AddButton("Computador", "Computador de bordo policial.", "police:Open", "", false, false)
-- 			exports["dynamic"]:openMenu()

-- 		elseif LocalPlayer["state"]["BOPE"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsBOPE", false, true)

-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("BOPE 1", "Fardamento da BOPE 1.", "player:Preset", "40", "preBOPE", true)
-- 				exports["dynamic"]:AddButton("BOPE 2", "Fardamento da BOPE 2.", "player:Preset", "41", "preBOPE", true)
-- 				exports["dynamic"]:AddButton("BOPE 3", "Fardamento da BOPE 3.", "player:Preset", "42", "preBOPE", true)
-- 				exports["dynamic"]:AddButton("BOPE 4", "Fardamento da BOPE 4.", "player:Preset", "43", "preBOPE", true)
-- 				exports["dynamic"]:AddButton("Treinamento", "Fardamento de Treinamento da BOPE.", "player:Preset", "44", "preBOPE", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos policiais.", "preBOPE")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedade", "Invadir Propriedade.", "propertys:invadePoliceEvent", "", false, false)
-- 			exports["dynamic"]:AddButton("Computador", "Computador de bordo policial.", "police:Open", "", false, false)
-- 			exports["dynamic"]:openMenu()

-- 		elseif LocalPlayer["state"]["RECOM"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsRECOM", false, true)

-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("RECOM 1", "Fardamento da RECOM 1.", "player:Preset", "45", "preRECOM", true)
-- 				exports["dynamic"]:AddButton("RECOM 2", "Fardamento da RECOM 2.", "player:Preset", "46", "preRECOM", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos policiais.", "preRECOM")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedade", "Invadir Propriedade.", "propertys:invadePoliceEvent", "", false, false)
-- 			exports["dynamic"]:AddButton("Computador", "Computador de bordo policial.", "police:Open", "", false, false)
-- 			exports["dynamic"]:openMenu()

-- 		elseif LocalPlayer["state"]["BPCHQ"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsBPCHQ", false, true)

-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("CHOQUE", "Fardamento do CHOQUE.", "player:Preset", "47", "preBPCHQ", true)
-- 				exports["dynamic"]:AddButton("PATAMO", "Fardamento do Patamo.", "player:Preset", "48", "preBPCHQ", true)
-- 				exports["dynamic"]:AddButton("GETEM", "Fardamento da GETEM.", "player:Preset", "49", "preBPCHQ", true)
-- 				exports["dynamic"]:AddButton("BATEDOR", "Fardamento do BATEDOR.", "player:Preset", "50", "preBPCHQ", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos policiais.", "preBPCHQ")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedade", "Invadir Propriedade.", "propertys:invadePoliceEvent", "", false, false)
-- 			exports["dynamic"]:AddButton("Computador", "Computador de bordo policial.", "police:Open", "", false, false)
-- 			exports["dynamic"]:openMenu()

-- 		elseif LocalPlayer["state"]["EX"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Police", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounce", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsEX", false, true)

-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("EX Polícia", "Uniforme da Polícia do EX.", "player:Preset", "51", "preEX", true)
-- 				exports["dynamic"]:AddButton("EX Força Especial", "Fardamento da Força Especial do EX.", "player:Preset", "52", "preEX", true)
-- 				exports["dynamic"]:AddButton("EX Comando", "Fardamento do Comando do EX.", "player:Preset", "53", "preEX", true)
-- 				exports["dynamic"]:AddButton("EX Selva", "Fardamento Selva do EX.", "player:Preset", "54", "preEX", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos policiais.", "preEX")
-- 			end

-- 			exports["dynamic"]:AddButton("Propriedade", "Invadir Propriedade.", "propertys:invadePoliceEvent", "", false, false)
-- 			exports["dynamic"]:AddButton("Computador", "Computador de bordo policial.", "police:Open", "", false, false)
-- 			exports["dynamic"]:openMenu()
			
-- 		elseif LocalPlayer["state"]["Mechanic"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Mecânico", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounceMechanic", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsMecanico", false, true)
-- 				exports["dynamic"]:AddButton("Mecânico 1", "Fardamento de Mecânico 1", "player:Preset", "10", "preMechanic", true)
-- 				exports["dynamic"]:AddButton("Mecânico 2", "Fardamento de Mecânico 2", "player:Preset", "11", "preMechanic", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos de Mecânicos", "preMechanic")
-- 				exports["dynamic"]:openMenu()
-- 			end
		
-- 		elseif LocalPlayer["state"]["Mechanic2"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anunciar Mecânico", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounceMechanic", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsMecanico2", false, true)
-- 				exports["dynamic"]:AddButton("Mecânico 1", "Fardamento de Mecânico 1", "player:Preset", "12", "preMechanic2", true)
-- 				exports["dynamic"]:AddButton("Mecânico 2", "Fardamento de Mecânico 2", "player:Preset", "13", "preMechanic2", true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos de Mecânicos", "preMechanic2")
-- 				exports["dynamic"]:openMenu()
-- 			end

-- 		elseif LocalPlayer["state"]["Paramedic"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anuncio Paramedico", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounceMedic", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsParamedico", false, true)
-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("Cirurgião","Fardamento de Cirurgião.","player:Preset","1","preMedic",true)
-- 				exports["dynamic"]:AddButton("Doutor","Fardamento de Doutor.","player:Preset","2","preMedic",true)
-- 				exports["dynamic"]:AddButton("Enfermaria","Fardamento da Enfermaria.","player:Preset","3","preMedic",true)
-- 				exports["dynamic"]:AddButton("SAMU","Fardamento de Socorrista SAMU.","player:Preset","4","preMedic",true)
-- 				exports["dynamic"]:AddButton("SAMU 2","Fardamento de Socorrista SAMU 2.","player:Preset","5","preMedic",true)
-- 				exports["dynamic"]:SubMenu("Fardamentos", "Todos os fardamentos médicos.", "preMedic")

-- 				exports["dynamic"]:openMenu()
-- 			end
-- 		elseif LocalPlayer["state"]["Bombeiro"] then
-- 			if GetEntityHealth(Ped) > 100 and not IsPedInAnyVehicle(Ped) then
-- 				exports["dynamic"]:AddButton("Anuncio Bombeiro", "Fazer um anúncio para todos os moradores.", "dynamic:EmergencyAnnounceBombeiro", "", false, true)
-- 				exports["dynamic"]:AddButton("Companheiros", "Verifique seus companheiros em serviço.", "admin:Dynamic","statsBombeiro", false, true)
-- 				exports["dynamic"]:AddButton("Carregar", "Carregar a pessoa mais próxima.", "player:carryPlayer", "", "player", true)
-- 				exports["dynamic"]:AddButton("Colocar no Veículo", "Colocar no veículo mais próximo.", "player:cvFunctions", "cv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover do Veículo", "Remover do veículo mais próximo.", "player:cvFunctions", "rv", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Chapéu", "Remover da pessoa mais próxima.", "skinshop:Remove", "Hat", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Máscara", "Remover da pessoa mais próxima.", "skinshop:Remove", "Mask", "player", true)
-- 				exports["dynamic"]:AddButton("Remover Óculos", "Remover da pessoa mais próxima.", "skinshop:Remove", "Glasses", "player", true)
-- 				exports["dynamic"]:SubMenu("Jogador", "Pessoa mais próxima de você.", "player")

-- 				exports["dynamic"]:AddButton("Incêndio","Fardamento de Incêndio.","player:Preset","6","preBombeiro",true)
-- 				exports["dynamic"]:AddButton("Socorrista 1","Fardamento de Socorrista 1.","player:Preset","7","preBombeiro",true)
-- 				exports["dynamic"]:AddButton("Socorrista 2","Fardamento de Socorrista 2.","player:Preset","8","preBombeiro",true)
-- 				exports["dynamic"]:AddButton("Treino","Fardamento de Treino.","player:Preset","9","preBombeiro",true)
-- 				exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos dos Bombeiros.","preBombeiro")

-- 				exports["dynamic"]:openMenu()
-- 			end
-- 		end
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMINFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("adminFunctions", function()
	if LocalPlayer["state"]["Admin"] and not IsPauseMenuActive() then
		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not Dynamic and MumbleIsConnected() then
			local Ped = PlayerPedId()
			if LocalPlayer["state"]["Admin"] then
				exports["dynamic"]:SubMenu("Gerênciamento🔨", "Clique para mais informações.", "admin")
				exports["dynamic"]:AddButton("Whitelist", "Editar Whitelist de um ID.", "admin:Dynamic", "wl", "admin", true)
				exports["dynamic"]:AddButton("God", "Deixar o ID com tudo 100%.", "admin:Dynamic", "god", "admin", true)
				exports["dynamic"]:AddButton("GodAll", "Deixar Todos com tudo 100%.", "admin:Dynamic", "godall", "admin", true)
				exports["dynamic"]:AddButton("God Área", "Deixar todos ID com tudo 100%.", "admin:Dynamic", "godarea", "admin", true)
				exports["dynamic"]:AddButton("Armour", "Deixar o ID com tudo Colete 100%.", "admin:Dynamic", "armour", "admin", true)
				exports["dynamic"]:AddButton("Commands", "Ativar/Desativar os Comandos por Chat.", "admin:Dynamic", "commands", "admin", true)
				exports["dynamic"]:AddButton("Announce", "Enviar um anúncio para todos.", "admin:Dynamic", "announce", "admin", true)
				exports["dynamic"]:AddButton("Chat Announce", "Enviar anúncio no chat para todos.", "admin:Dynamic", "chatannounce", "admin", true)
				exports["dynamic"]:AddButton("Rename", "Renomeie algum ID.", "admin:Dynamic", "rename", "admin", true)
				exports["dynamic"]:AddButton("Kick", "Expuldar o ID.", "admin:Dynamic", "kick", "admin", true)
				exports["dynamic"]:AddButton("Ban", "Banir o ID.", "admin:Dynamic", "ban", "admin", true)
				exports["dynamic"]:AddButton("Unban", "Desbanir o ID.", "admin:Dynamic", "unban", "admin", true)
				exports["dynamic"]:AddButton("Changework", "Mudar o emprego do ID.", "admin:Dynamic", "changework", "admin", true)
				exports["dynamic"]:AddButton("Prisão", "Limpar serviços.", "admin:Dynamic", "clearprison", "admin", true)

				exports["dynamic"]:SubMenu("Trolls Admins🤣", "Clique para mais informações.", "trolls")
				exports["dynamic"]:AddButton("Neymar", "Derrubar Players", "admin:Dynamic", "ney", "trolls", true)
				exports["dynamic"]:AddButton("Voa Passarinho", "Mandar Players pras Alturas", "admin:Dynamic", "voar", "trolls", true)
				exports["dynamic"]:AddButton("Explodir", "Explodir Players", "admin:Dynamic", "explodir", "trolls", true)
				exports["dynamic"]:AddButton("Foguinho", "Colocar fogo em Players", "admin:Dynamic", "fogo", "trolls", true)
				exports["dynamic"]:AddButton("Congelar", "Congelar Players", "admin:Dynamic", "gelo", "trolls", true)

				exports["dynamic"]:SubMenu("Clima🌞", "Clique para mais informações.", "weather")
				exports["dynamic"]:AddButton("Timeset", "Mudar o Clima do jogo.", "admin:Dynamic", "timeset", "weather", true)
				exports["dynamic"]:AddButton("Temperatureset", "Mudar a Temperatura do jogo.", "admin:Dynamic", "temperatureset", "weather", true)
				exports["dynamic"]:AddButton("Blackoutset", "Ativar/Desativar o Blackout.", "admin:Dynamic", "blackoutset", "weather", true)

				exports["dynamic"]:SubMenu("Grupos📑", "Clique para mais informações.", "groups")
				exports["dynamic"]:AddButton("Ugroups", "Veja quais grupos do ID.", "admin:Dynamic", "ugroups", "groups", true)
				exports["dynamic"]:AddButton("Group", "Dar um grupo para o ID.", "admin:Dynamic", "group", "groups", true)
				exports["dynamic"]:AddButton("Ungroup", "Remover o grupo de um ID.", "admin:Dynamic", "ungroup", "groups", true)

				exports["dynamic"]:SubMenu("Personagens🤝🏼", "Clique para mais informações.", "peds")
				exports["dynamic"]:AddButton("Skin", "Mude a Skin do ID.", "admin:Dynamic", "skin", "peds", true)
				exports["dynamic"]:AddButton("Resetskin", "Resete a Skin do ID.", "admin:Dynamic", "resetskin", "peds", true)
				exports["dynamic"]:AddButton("Delete", "Delete a conta do ID.", "admin:Dynamic", "delete", "peds", true)

				exports["dynamic"]:SubMenu("Veículos🚗", "Clique para mais informações.", "vehicles")
				exports["dynamic"]:AddButton("Tuning", "Tunar o veículo atual.", "admin:Dynamic", "tuning", "vehicles", true)
				exports["dynamic"]:AddButton("Deletar Veiculo", "Deletar o Veiculo mais Proximo.", "admin:Dynamic", "dv", "vehicles", true)
				exports["dynamic"]:AddButton("Fix", "Arrumar o veículo atual.", "admin:Dynamic", "fix", "vehicles", true)
				exports["dynamic"]:AddButton("Fuel", "Defina a Gasolina no veículo atual.", "admin:Dynamic", "fuel", "vehicles", true)
				exports["dynamic"]:AddButton("Hash", "Pegar a Hash do veículo atual.", "admin:Dynamic", "hash", "vehicles", true)
				exports["dynamic"]:AddButton("Setcar", "Envie um veículo para o ID.", "admin:Dynamic", "setcar", "vehicles", true)
				exports["dynamic"]:AddButton("Remcar", "Remove um veículo do ID.", "admin:Dynamic", "remcar", "vehicles", true)
				exports["dynamic"]:AddButton("Changelicense", "Atualize o status da CNH do ID.", "admin:Dynamic", "driverlicense", "vehicles", true)

				exports["dynamic"]:SubMenu("Financeiros💰", "Clique para mais informações.", "wallet")
				exports["dynamic"]:AddButton("Setbank", "Dar dinheiro para o ID.", "admin:Dynamic", "setbank", "wallet", true)
				exports["dynamic"]:AddButton("Rembank", "Remover dinheiro do ID.", "admin:Dynamic", "rembank", "wallet", true)
				exports["dynamic"]:AddButton("Setar Gemstones", "Inserir gemstones no ID.", "admin:Dynamic", "gem", "wallet", true)

				exports["dynamic"]:SubMenu("Spawn Itens⭐", "Clique para mais informações.", "item")
				exports["dynamic"]:AddButton("Clearinv", "Limpe o inventário do ID.", "admin:Dynamic", "clearinv", "item", true)
				exports["dynamic"]:AddButton("Item", "Pegar Itens para você.", "admin:Dynamic", "item", "item", true)
				exports["dynamic"]:AddButton("Item2", "Dar Itens para o ID.", "admin:Dynamic", "item2", "item", true)
				exports["dynamic"]:AddButton("Itemall", "Dar Itens para todos conectados.", "admin:Dynamic", "itemall", "item", true)

				exports["dynamic"]:SubMenu("Comandos Admins🔐", "Clique para mais informações.", "basic")
				exports["dynamic"]:AddButton("Blips", "Ativar/Desativar os Blips.", "admin:Dynamic", "blips", "basic", true)
				exports["dynamic"]:AddButton("Nc", "Ativar/Desativar o NoClip.", "admin:Dynamic", "nc", "basic", true)
				exports["dynamic"]:AddButton("Cds", "Pegue sua coordenada atual.", "admin:Dynamic", "cds", "basic", true)
				exports["dynamic"]:AddButton("Tpcds", "Teletransporte para uma coordenada.", "admin:Dynamic", "tpcds", "basic", true)
				exports["dynamic"]:AddButton("Tptome", "Teletransporte um ID para você.", "admin:Dynamic", "tptome", "basic", true)
				exports["dynamic"]:AddButton("Tpto", "Teletransporte para um ID.", "admin:Dynamic", "tpto", "basic", true)
				exports["dynamic"]:AddButton("Tpway", "Teletransporte para uma marcação no GPS.", "admin:Dynamic", "tpway", "basic", true)
				exports["dynamic"]:AddButton("Limparea", "Limpar a área próxima a você.", "admin:Dynamic", "limparea", "basic", true) 
				exports["dynamic"]:AddButton("Debug", "Ativar/Desativar o Debug.", "admin:Dynamic", "debug", "basic", true)
				exports["dynamic"]:AddButton("Players", "Verifique quantos onlines existem.", "admin:Dynamic", "players", "basic", true)

				exports["dynamic"]:SubMenu("Divertidos ✨", "Clique para mais informações.", "fun")
				exports["dynamic"]:AddButton("Magneto", "Ativar/Desativar o efeito Magneto.", "admin:Dynamic", "magneto", "fun", true)
				exports["dynamic"]:AddButton("Flash", "Ativar/Desativar o efeito Flash.", "admin:Dynamic", "flash", "fun", true)
				exports["dynamic"]:AddButton("Super Pulo", "Ativar/Desativar o super pulo.", "admin:Dynamic", "pulo", "fun", true)
				exports["dynamic"]:AddButton("VehicleSpeed", "Mude a velocidade do veículo.", "admin:Dynamic", "vehiclespeed", "fun", true)
				exports["dynamic"]:AddButton("TyreBurst", "Exploda o pneu do veículo do ID.", "admin:Dynamic", "tyreburst", "fun", true)
				exports["dynamic"]:AddButton("CreateLightning", "Crie diversos raios pela cidade.", "admin:Dynamic", "createlightning", "fun", true)

				exports["dynamic"]:openMenu()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","F9")
-- RegisterKeyMapping("tencodeFunctions","Abrir menu de chamados policiais.","keyboard","F3")
-- RegisterKeyMapping("emergencyFunctions","Abrir menu de emergencial.","keyboard","F10")
RegisterKeyMapping("adminFunctions", "Abrir menu de administração.", "keyboard", "INSERT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalSpawn")
AddEventHandler("dynamic:animalSpawn", function(Model)
	if HashAnimal == nil then
		if not SpawnAnimal then
			SpawnAnimal = true

			local Ped = PlayerPedId()
			local Heading = GetEntityHeading(Ped)
			local Coords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 1.0, 0.0)
			local Object, Network = vRPS.CreatePed(Model, Coords["x"], Coords["y"], Coords["z"], Heading, 28)
			if Object then
				local SpawnAnimal = 0

				HashAnimal = LoadNetwork(Network)
				while not DoesEntityExist(HashAnimal) and SpawnAnimal <= 1000 do
					HashAnimal = LoadNetwork(Network)
					SpawnAnimal = SpawnAnimal + 1
					Wait(1)
				end

				SpawnAnimal = 0
				local PedControl = NetworkRequestControlOfEntity(HashAnimal)
				while not PedControl and SpawnAnimal <= 1000 do
					PedControl = NetworkRequestControlOfEntity(HashAnimal)
					SpawnAnimal = SpawnAnimal + 1
					Wait(1)
				end

				SetPedCanRagdoll(HashAnimal, false)
				SetEntityInvincible(HashAnimal, true)
				SetPedFleeAttributes(HashAnimal, 0, 0)
				SetEntityAsMissionEntity(HashAnimal, true, false)
				SetBlockingOfNonTemporaryEvents(HashAnimal, true)
				SetPedRelationshipGroupHash(HashAnimal, GetHashKey("k9"))
				GiveWeaponToPed(HashAnimal, GetHashKey("WEAPON_ANIMAL"), 200, true, true)

				SetEntityAsNoLongerNeeded(HashAnimal)

				TriggerEvent("dynamic:animalFunctions", "follow")

				vSERVER.RegisterAnimal(Network)
			end

			SpawnAnimal = false
		end
	else
		vSERVER.ClearAnimal()
		FollowAnimal = false
		HashAnimal = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalFunctions")
AddEventHandler("dynamic:animalFunctions", function(Functions)
	if HashAnimal ~= nil then
		local Ped = PlayerPedId()
		if Functions == "follow" then
			if not FollowAnimal then
				TaskFollowToOffsetOfEntity(HashAnimal, Ped, 1.0, 1.0, 0.0, 5.0, -1, 2.5, 1)
				SetPedKeepTask(HashAnimal, true)
				FollowAnimal = true
			else
				SetPedKeepTask(HashAnimal, false)
				ClearPedTasks(HashAnimal)
				FollowAnimal = false
			end
		elseif Functions == "putvehicle" then
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if IsVehicleSeatFree(Vehicle, 0) then
					TaskEnterVehicle(HashAnimal, Vehicle, -1, 0, 2.0, 16, 0)
				end
			end
		elseif Functions == "removevehicle" then
			if IsPedInAnyVehicle(Ped) and not IsPedOnAnyBike(Ped) then
				TaskLeaveVehicle(HashAnimal, GetVehiclePedIsUsing(Ped), 256)
				TriggerEvent("dynamic:animalFunctions", "follow")
			end
		elseif Functions == "destroy" then
			vSERVER.ClearAnimal()
			FollowAnimal = false
			HashAnimal = nil
		end
	end
end)