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
Tunnel.bindInterface("player",Creative)
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Debug = {}
local playerCarry = {}
local UniqueShoes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MASCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('mascara', function(source, args, rawCommand)
    local Passport = vRP.Passport(source)

    if vRP.GetHealth(source) <= 100 then
        TriggerClientEvent('Notify', source, 'vermelho', 'Você não pode fazer isso em coma.', 7500)
        return
    end

    if not Player(source)["state"]["Handcuff"] then
        if Passport then
            TriggerClientEvent("setmascara", source, args[1], args[2])
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkRoupas()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.ConsultItem(Passport,"mask",1) or vRP.HasPermission(Passport,"Admin") or vRP.HasPermission(Passport,"PremiumOuro") or vRP.HasPermission(Passport,"Premium") or vRP.HasPermission(Passport,"PremiumPrata") then
			return true 
		else
			TriggerClientEvent("Notify",source,'vermelho',"Você não possui o item <b>ROUPAS</b>.",7500) 
			return false
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Stress")
AddEventHandler("player:Stress",function(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.DowngradeStress(Passport,Number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("me",function(source,Message,History)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] then
		local message = string.sub(History:sub(4),1,100)

		local Players = vRPC.Players(source)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("showme:pressMe",v,source,message,10)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if Message[2] == "friend" then
			local ClosestPed = vRPC.ClosestPed(source,2)
			if ClosestPed then
				if vRP.GetHealth(ClosestPed) > 100 and not Player(ClosestPed)["state"]["Handcuff"] then
					local Identity = vRP.Identity(Passport)
					if vRP.Request(ClosestPed,"Pedido de <b>"..Identity["name"].."</b> da animação <b>"..Message[1].."</b>?","Sim, iniciar animação","Não, sai fora") then
						TriggerClientEvent("emotes",ClosestPed,Message[1])
						TriggerClientEvent("emotes",source,Message[1])
					end
				end
			end
		else
			TriggerClientEvent("emotes",source,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e2",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		local ClosestPed = vRPC.ClosestPed(source,2)
		if ClosestPed then
			if vRP.HasService(Passport,"Emergencia") or vRP.HasPermission(Passport,"Admin") then
				TriggerClientEvent("emotes",ClosestPed,Message[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E3
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e3",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if vRP.HasGroup(Passport,"Admin",1) then
			local Players = vRPC.ClosestPeds(source,50)
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("emotes",v,Message[1])
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Doors")
AddEventHandler("player:Doors",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicle,Network = vRPC.VehicleList(source,5)
		if Vehicle then
			local Players = vRPC.Players(source)
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("player:syncDoors",v,Network,Number)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.shotsFired(Vehicle)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if Vehicle then
			Vehicle = "Disparos de um veículo"
		else
			Vehicle = "Disparos com arma de fogo"
		end

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Service = vRP.NumPermission("Policia")
		for Passports,Sources in pairs(Service) do
			async(function()
				TriggerClientEvent("NotifyPush",Sources,{ code = "QRU", title = Vehicle, x = Coords["x"], y = Coords["y"], z = Coords["z"], color = 1 })
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARRYPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CarryPlayer()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasService(Passport,"Policia") or vRP.HasService(Passport,"Emergencia") or vRP.HasService(Passport,"Mecanica") or vRP.HasService(Passport,"Admin") then
			if not vRP.InsideVehicle(source) then
				if playerCarry[Passport] then
					TriggerClientEvent("player:playerCarry",playerCarry[Passport],source)
					TriggerClientEvent("player:Commands",playerCarry[Passport],false)
					playerCarry[Passport] = nil
				else
					local ClosestPed = vRPC.ClosestPed(source,2)
					if ClosestPed then
						playerCarry[Passport] = ClosestPed

						TriggerClientEvent("player:playerCarry",playerCarry[Passport],source)
						TriggerClientEvent("player:Commands",playerCarry[Passport],true)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CARRYPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:carryPlayer")
AddEventHandler("player:carryPlayer",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not vRP.InsideVehicle(source) then
			if playerCarry[Passport] then
				TriggerClientEvent("player:playerCarry",playerCarry[Passport],source)
				TriggerClientEvent("player:Commands",playerCarry[Passport],false)
				playerCarry[Passport] = nil
			else
				local ClosestPed = vRPC.ClosestPed(source,2)
				if ClosestPed then
					playerCarry[Passport] = ClosestPed

					TriggerClientEvent("player:playerCarry",playerCarry[Passport],source)
					TriggerClientEvent("player:Commands",playerCarry[Passport],true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CVFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:cvFunctions")
AddEventHandler("player:cvFunctions",function(Mode)
	local Distance = 1
	local source = source

	if Mode == "rv" then
		Distance = 10
	end

	local ClosestPed = vRPC.ClosestPed(source,Distance)
	if ClosestPed then
		local Passport = vRP.Passport(source)
		local Consult = vRP.InventoryItemAmount(Passport,"rope")
		if vRP.HasService(Passport,"Policia") or vRP.HasService(Passport,"Emergencia") or vRP.HasService(Passport,"Mecanica") or Consult[1] >= 1 then
			local Vehicle,Network = vRPC.VehicleList(source,5)
			if Vehicle then
				local Networked = NetworkGetEntityFromNetworkId(Network)
				local Door = GetVehicleDoorLockStatus(Networked)

				if parseInt(Door) <= 1 then
					if Mode == "rv" then
						vCLIENT.removeVehicle(ClosestPed)
					elseif Mode == "cv" then
						vCLIENT.putVehicle(ClosestPed,Network)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source,2)
	if ClosestPed then
		TriggerClientEvent("player:checkTrunk",ClosestPed)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source,2)
	if ClosestPed then
		TriggerClientEvent("player:checkTrash",ClosestPed)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkShoes")
AddEventHandler("player:checkShoes",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not UniqueShoes[Entity] then
			UniqueShoes[Entity] = os.time()
		end

		if os.time() >= UniqueShoes[Entity] then
			if vSKINSHOP.checkShoes(Entity) then
				vRP.GenerateItem(Passport,"WEAPON_SHOES",2,true)
				UniqueShoes[Entity] = os.time() + 300
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Preset")
AddEventHandler("player:Preset", function(Number)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport then
        if vRP.HasService(Passport, "Policia") or vRP.HasGroup(Passport,"Emergencia") or vRP.HasGroup(Passport,"Mecanica") then
            local Model = vRP.ModelPlayer(source)
            vRPC.playAnim(source, true, {"clothingshirt", "try_shirt_positive_d"}, true)

            if Model == "mp_m_freemode_01" or Model == "mp_f_freemode_01" then
                SetTimeout(5000, function()
                    TriggerClientEvent("skinshop:Apply", source, preset[Number][Model])
                    vRPC.stopAnim(source, true)
                end)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:OUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Outfit")
AddEventHandler("player:Outfit", function(Mode)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport and not exports["hud"]:Reposed(Passport) and not exports["hud"]:Wanted(Passport) then
        if Mode == "aplicar" then
            local result = vRP.GetSrvData("Outfit:" .. Passport)
            if result and result["pants"] ~= nil then
				vRPC.playAnim(source, true, {"clothingshirt", "try_shirt_positive_d"}, true)
            	Wait(5000)
                TriggerClientEvent("skinshop:Apply", source, result)
				vRPC.stopAnim(source,true)
                TriggerClientEvent("Notify", source, "verde", "Roupas aplicadas.", 3000)
            else
                TriggerClientEvent("Notify", source, "amarelo", "Roupas não encontradas.", 3000)
            end
        elseif Mode == "salvar" then
            local custom = vSKINSHOP.Customization(source)
            if custom then
                vRP.SetSrvData("Outfit:" .. Passport, custom)
                TriggerClientEvent("Notify", source, "verde", "Roupas salvas.", 3000)
            end
        elseif Mode == "aplicarplatina" then
            if vRP.HasPermission(Passport, "Premium", 1) then
                local Result = vRP.GetSrvData("PremiumPlatinum:" .. Passport, true)
                if Result and Result["pants"] then
                    vRPC.playAnim(source, true, {"clothingshirt", "try_shirt_positive_d"}, true)
            		Wait(5000)
                    TriggerClientEvent("skinshop:Apply", source, Result)
					vRPC.stopAnim(source,true)
                    TriggerClientEvent("Notify", source, "verde", "Roupas Platinum aplicadas.", 5000)
                else
                    TriggerClientEvent("Notify", source, "amarelo", "Roupas Platinum não encontradas.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para aplicar roupas Platinum.", 5000)
            end
        elseif Mode == "salvarplatina" then
            if vRP.HasPermission(Passport, "Premium", 1) then
                local Custom = vSKINSHOP.Customization(source)
                if Custom then
                    vRP.SetSrvData("PremiumPlatinum:" .. Passport, Custom, true)
                    TriggerClientEvent("Notify", source, "verde", "Roupas Platinum salvas.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para salvar roupas Platinum.", 5000)
            end
        elseif Mode == "aplicarouro" then
            if vRP.HasPermission(Passport, "Premium", 1) or vRP.HasPermission(Passport, "PremiumOuro", 1) then
                local Result = vRP.GetSrvData("PremiumOuro:" .. Passport, true)
                if Result and Result["pants"] then
                    vRPC.playAnim(source, true, {"clothingshirt", "try_shirt_positive_d"}, true)
            		Wait(5000)
                    TriggerClientEvent("skinshop:Apply", source, Result)
					vRPC.stopAnim(source,true)
                    TriggerClientEvent("Notify", source, "verde", "Roupas Ouro aplicadas.", 5000)
                else
                    TriggerClientEvent("Notify", source, "amarelo", "Roupas Ouro não encontradas.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para aplicar roupas Ouro.", 5000)
            end
        elseif Mode == "salvarouro" then
            if vRP.HasPermission(Passport, "Premium", 1) or vRP.HasPermission(Passport, "PremiumOuro", 1) then
                local Custom = vSKINSHOP.Customization(source)
                if Custom then
                    vRP.SetSrvData("PremiumOuro:" .. Passport, Custom, true)
                    TriggerClientEvent("Notify", source, "verde", "Roupas Ouro salvas.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para salvar roupas Ouro.", 5000)
            end
		elseif Mode == "aplicarprata" then
            if vRP.HasPermission(Passport, "Premium", 1) or vRP.HasPermission(Passport, "PremiumOuro", 1) or vRP.HasPermission(Passport, "PremiumPrata", 1) then
                local Result = vRP.GetSrvData("PremiumPrata:" .. Passport, true)
                if Result and Result["pants"] then
					vRPC.playAnim(source, true, {"clothingshirt", "try_shirt_positive_d"}, true)
            		Wait(5000)
                    TriggerClientEvent("skinshop:Apply", source, Result)
					vRPC.stopAnim(source,true)
                    TriggerClientEvent("Notify", source, "verde", "Roupas Prata aplicadas.", 5000)
                else
                    TriggerClientEvent("Notify", source, "amarelo", "Roupas Prata não encontradas.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para aplicar roupas Prata.", 5000)
            end
        elseif Mode == "salvarprata" then
            if vRP.HasPermission(Passport, "Premium", 1) or vRP.HasPermission(Passport, "PremiumOuro", 1) or vRP.HasPermission(Passport, "PremiumPrata", 1) then
                local Custom = vSKINSHOP.Customization(source)
                if Custom then
                    vRP.SetSrvData("PremiumPrata:" .. Passport, Custom, true)
                    TriggerClientEvent("Notify", source, "verde", "Roupas Prata salvas.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para salvar roupas Prata.", 5000)
            end
        elseif Mode == "remover" then
            local Model = vRP.ModelPlayer(source)
            if Model == "mp_m_freemode_01" then
                TriggerClientEvent("skinshop:Apply", source, removeFit["homem"])
                TriggerClientEvent("Notify", source, "verde", "Roupas Removidas", 3000)
            elseif Model == "mp_f_freemode_01" then
                TriggerClientEvent("skinshop:Apply", source, removeFit["mulher"])
                TriggerClientEvent("Notify", source, "verde", "Roupas Removidas", 3000)
            end
        else
            TriggerClientEvent("skinshop:set" .. Mode, source)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Debug")
AddEventHandler("player:Debug",function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and not Debug[Passport] or os.time() > Debug[Passport] then
        TriggerClientEvent("Notify", source, "verde", "Você refrescou o seu personagem.", 5000)
        TriggerClientEvent("target:Debug",source)
        TriggerEvent("DebugObjects",Passport)
        vRPC.stopAnim(source,false)
        Debug[Passport] = os.time() + 300
        vRPC.ReloadCharacter(source)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Death")
AddEventHandler("player:Death",function(nsource)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and source ~= nsource then
		local OtherPassport = vRP.Passport(nsource)
		if OtherPassport then
			if GetPlayerRoutingBucket(source) < 1 then
				TriggerEvent("Discord", "Deaths", "**[Registro de Mortes]**\n\n**Assassino:** " .. Passport .. "\n**Vítima:** " .. OtherPassport, 16777215)
			else
				local Name = "Individuo Indigente"
				local Name2 = "Individuo Indigente"
				local Identity = vRP.Identity(Passport)
				local nIdentity = vRP.Identity(OtherPassport)

				if Identity and nIdentity then
					Name = Identity["name"].." "..Identity["name2"]
					Name2 = nIdentity["name"].." "..nIdentity["name2"]

					TriggerClientEvent("Notify",source,"amarelo","<b>"..Name.."</b> matou <b>"..Name2.."</b>",10000)
					TriggerClientEvent("Notify",nsource,"amarelo","<b>"..Name.."</b> matou <b>"..Name2.."</b>",10000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Charge")
AddEventHandler("player:Charge", function(Entity)
    local source = source
    local Passport = vRP.Passport(source)

    local consultItem = vRP.InventoryItemAmount(Passport, "maquinadecartao")
    if consultItem[1] >= 1 then
        TriggerClientEvent("maquininha:open", source, {"open"})
    else
        TriggerClientEvent("Notify", source, "vermelho", "Você não possui uma <b>máquina de cartão</b>.", 5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTAURANTE:CHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("restaurante:Charge")
AddEventHandler("restaurante:Charge", function(source, Keyboard)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Keyboard then
		if vRP.HasPermission(Passport, 'Pearls',3) then
			local Keyboard = vKEYBOARD.keyDouble(source, "Passaporte do Alvo:", "Valor da Cobrança:")
			if Keyboard then
				local TargetPassport = parseInt(Keyboard[1])
				local Amount = parseInt(Keyboard[2])
				local Identity = vRP.Identity(TargetPassport)
				if Identity then
					if vRP.Request(TargetPassport, "Aceitar a cobrança de <b>$" .. Amount .. "</b> feita por <b>" .. vRP.FullName(Passport) .. "</b>?") then
						if vRP.GetBank(TargetPassport) >= Amount then
							vRP.RemoveBank(TargetPassport, Amount)
							vRP.GiveBank(Passport, Amount)
						else
							TriggerClientEvent("Notify", TargetPassport, "vermelho", "<b>Saldo</b> insuficiente.", 5000)
							TriggerClientEvent("Notify", source, "vermelho", "<b>" .. vRP.FullName(TargetPassport) .. "</b> não possui saldo suficiente.", 5000)
						end
					end
				else
					TriggerClientEvent("Notify", source, "vermelho", "Passaporte alvo inválido.", 5000)
				end
			end
		else
			TriggerClientEvent("Notify", source, "vermelho", "Você não tem permissão para realizar esta ação.", 5000)
		end
	else
		TriggerClientEvent("Notify", source, "vermelho", "Erro ao obter seu passaporte.", 5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:LIKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Like")
AddEventHandler("player:Like",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.Passport(Entity)
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			if vRP.TakeItem(Passport,"dollars",100,true) then
				vRP.GiveLikes(OtherPassport,1)
			else
				TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>100x "..itemName("dollars").."</b>.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:UNLIKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:UnLike")
AddEventHandler("player:UnLike",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.Passport(Entity)
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			if vRP.TakeItem(Passport,"dollars",100,true) then
				vRP.GiveUnLikes(OtherPassport,1)
			else
				TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>100x "..itemName("dollars").."</b>.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETREPUTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GetReputation(source)
	local Passport = vRP.Passport(source)
	if Passport then
		local Reputation = {
			[1] = vRP.GetLikes(Passport),
			[2] = vRP.GetUnLikes(Passport)
		}

		return Reputation
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:GETSCRATCHCARD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:GetScratchCard")
AddEventHandler("player:GetScratchCard",function()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.MaxItens(Passport,"scratchcard",1) then
            TriggerClientEvent("Notify",source,"vermelho","Limite atingido.",5000)
        else
            if vRP.Request(source,"Deseja comprar <b>1x "..itemName("scratchcard").."</b> por <b>$100</b> dólares?") then
                if vRP.PaymentBank(Passport,100) then
                    vRP.GenerateItem(Passport,"scratchcard",1,true)
                else
                    TriggerClientEvent("Notify",source,"vermelho","<b>Saldo</b> insuficiente.",5000)
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if playerCarry[Passport] then
		TriggerClientEvent("player:Commands",playerCarry[Passport],false)
		playerCarry[Passport] = nil
	end
end)