-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("inspect",Creative)
vCLIENT = Tunnel.getInterface("inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local openPlayer = {}
local openSource = {}
local openAdmin = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("inv",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = parseInt(Message[1])
		if vRP.HasGroup(Passport,"Admin",2) and OtherPassport > 0 then
			local OtherSource = vRP.Source(OtherPassport)
			if OtherSource then
				openPlayer[Passport] = OtherPassport
				openAdmin[Passport] = OtherPassport

				TriggerClientEvent("inspect:Open",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:runInspect")
AddEventHandler("police:runInspect", function(Entity)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport and vRP.GetHealth(source) > 100 then
        openSource[Passport] = Entity[1]
        openPlayer[Passport] = vRP.Passport(Entity[1])

        vCLIENT.Attach(source, Entity[1], true)

        vRPC.playAnim(source, false, {"cpdrevistandopolicial@animations", "gndrevistandopolicial_clip"}, true)
        vRPC.playAnim(Entity[1], false, {"cpdanimacaomaonacabeca@animations", "gndanimacaomaonacabeca_clip"}, true)

        TriggerClientEvent("player:playerCarry", Entity[1], source, "handcuff")
        TriggerClientEvent("player:Commands", Entity[1], true)
        TriggerClientEvent("inventory:Close", Entity[1])
        TriggerClientEvent("inspect:Open", source)
		Player(Entity[1])["state"]["Commands"] = true
		Player(Entity[1])["state"]["Buttons"] = true
		Player(Entity[1])["state"]["Cancel"] = true

        TriggerEvent("Discord", "RevistaPolicial", "**[Inspeção Policial]**\n\n**Policial Passaporte:** " .. Passport .. "\n**Jogador Inspecionado Passaporte:** " .. vRP.Passport(Entity[1]) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:runInspect")
AddEventHandler("player:runInspect", function(Entity)
    local source = source
    local Passport = vRP.Passport(source)

    if Passport and vRP.GetHealth(source) > 100 then
        if vRP.Request(Entity[1], "Você está sendo <b>Revistado</b>", "Permitir", "Resistir") then

            openSource[Passport] = Entity[1]
            openPlayer[Passport] = vRP.Passport(Entity[1])

            vCLIENT.Attach(source, Entity[1], true)

            vRPC.playAnim(source, false, {"cpdrevistandopolicial@animations", "gndrevistandopolicial_clip"}, true)
            vRPC.playAnim(Entity[1], false, {"cpdanimacaomaonacabeca@animations", "gndanimacaomaonacabeca_clip"}, true)

            TriggerClientEvent("player:playerCarry", Entity[1], source, "handcuff")
            TriggerClientEvent("player:Commands", Entity[1], true)
            TriggerClientEvent("inventory:Close", Entity[1])
            TriggerClientEvent("inspect:Open", source)
			Player(Entity[1])["state"]["Commands"] = true
			Player(Entity[1])["state"]["Buttons"] = true
			Player(Entity[1])["state"]["Cancel"] = true

            TriggerEvent("Discord", "RevistaJogadores", "**[Inspeção Jogadores]**\n\n**Policial Passaporte:** " .. Passport .. "\n**Jogador Inspecionado Passaporte:** " .. vRP.Passport(Entity[1]) .. "\n**Ação:** Revistado\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)

        else
            TriggerClientEvent("Notify", source, "amarelo", "Ele resistiu à sua revista.", 3000)
            return
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNSAQUEAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:runSaquear")
AddEventHandler("police:runSaquear", function(Entity)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport and vRP.GetHealth(source) > 100 then
        TriggerClientEvent("player:playerCarry", Entity[1], source, "handcuff")
        TriggerClientEvent("player:Commands", Entity[1], true)
        TriggerClientEvent("inventory:Close", Entity[1])
        openSource[Passport] = Entity[1]
        openPlayer[Passport] = vRP.Passport(Entity[1])
        TriggerClientEvent("inspect:Open", source)
		TriggerEvent("Discord", "Saquear", "**[Ação de Saque]**\n\n**Policial Passaporte:** " .. Passport .. "\n**Jogador Saqueado Passaporte:** " .. vRP.Passport(Entity[1]) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:STOPINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:stopInspect")
AddEventHandler("police:stopInspect", function()
    local source = source
    local Passport = vRP.Passport(source)

    if openSource[Passport] then
        local target = openSource[Passport]

        vRPC.stopAnim(source)
        vRPC.stopAnim(target)

        vCLIENT.Attach(source, target, false)

        openSource[Passport] = nil
        openPlayer[Passport] = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.openChest()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local myInventory = {}
		local inventory = vRP.Inventory(Passport)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			v["desc"] = itemDescription(v["item"]) or ""

			if splitName[1] == "driverlicense" and splitName[3] then
				local licenseData = json.decode(splitName[3])
				if licenseData then
					v["desc"] = v["desc"]..
					"<br><legenda>Nome: <r>"..licenseData["name"].."</r> <br>Emissão: <r>"..os.date("%d/%m/%Y", licenseData["issued"]).."</r>"..
					"<br>Validade: <r>"..os.date("%d/%m/%Y", licenseData["expiration"]).."</r>"..
					"<br>Categoria: <r>"..string.gsub(json.encode(licenseData["categories"]), '[^%a,]', '').."</r></legenda>"
				end
			end
			
			if splitName[1] == "dmvdocs" and splitName[2] and splitName[3] and splitName[4] and splitName[5] then
				local identity = vRP.Identity(parseInt(splitName[2]))
				if identity then
					v["desc"] = v["desc"]..
					"<br><legenda>Nome: <r>"..identity["name"].." "..identity["name2"].."</r>"..
					"<br>Prática: <r>"..string.gsub(splitName[5], '[^%a,]', '').."</r>"..
					"<br>Teórica: <r>"..string.gsub(splitName[4], '[^%a,]', '').."</r>"..
					"<br>Categoria: <r>"..string.gsub(splitName[3], '[^%a,]', '').."</r></legenda>"
				end
			end					

			if itemType(splitName[1]) == "Armamento" and splitName[3] then
				local DonoSerial = splitName[3]
				local UserSerial = vRP.UserSerial(DonoSerial)
				if UserSerial then
					local Identity = vRP.Identity(UserSerial["id"])
					if Identity and Identity["serial"] then
						v["desc"] = "<br><description>Serial da Arma: <green>"..Identity["serial"].."</green>.</description>"
					end
				else
					v["desc"] = "<br><description>Serial da Arma: <green> Desconhecido </green>.</description>"
				end
			end

			myInventory[k] = v
		end

		local otherInventory = {}
		local inventory = vRP.Inventory(openPlayer[Passport])
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			v["desc"] = itemDescription(v["item"]) or ""

			if splitName[1] == "driverlicense" and splitName[3] then
				local licenseData = json.decode(splitName[3])
				if licenseData then
					v["desc"] = v["desc"]..
					"<br><legenda>Nome: <r>"..licenseData["name"].."</r> <br>Emissão: <r>"..os.date("%d/%m/%Y", licenseData["issued"]).."</r>"..
					"<br>Validade: <r>"..os.date("%d/%m/%Y", licenseData["expiration"]).."</r>"..
					"<br>Categoria: <r>"..string.gsub(json.encode(licenseData["categories"]), '[^%a,]', '').."</r></legenda>"
				end
			end
			
			if splitName[1] == "dmvdocs" and splitName[2] and splitName[3] and splitName[4] and splitName[5] then
				local identity = vRP.Identity(parseInt(splitName[2]))
				if identity then
					v["desc"] = v["desc"]..
					"<br><legenda>Nome: <r>"..identity["name"].." "..identity["name2"].."</r>"..
					"<br>Prática: <r>"..string.gsub(splitName[5], '[^%a,]', '').."</r>"..
					"<br>Teórica: <r>"..string.gsub(splitName[4], '[^%a,]', '').."</r>"..
					"<br>Categoria: <r>"..string.gsub(splitName[3], '[^%a,]', '').."</r></legenda>"
				end
			end					

			if itemType(splitName[1]) == "Armamento" and splitName[3] then
				local DonoSerial = splitName[3]
				local UserSerial = vRP.UserSerial(DonoSerial)
				if UserSerial then
					local Identity = vRP.Identity(UserSerial["id"])
					if Identity and Identity["serial"] then
						v["desc"] = "<br><description>Serial da Arma: <green>"..Identity["serial"].."</green>.</description>"
					end
				else
					v["desc"] = "<br><description>Serial da Arma: <green> Desconhecido </green>.</description>"
				end
			end

			otherInventory[k] = v
		end

		return myInventory,otherInventory,vRP.InventoryWeight(Passport),vRP.GetWeight(Passport),vRP.InventoryWeight(openPlayer[Passport]),vRP.GetWeight(openPlayer[Passport])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.resetInspect()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			TriggerClientEvent("player:Commands",openSource[Passport],false)
			TriggerClientEvent("player:playerCarry",openSource[Passport],source)
			Player(openSource[Passport])["state"]["Commands"] = false
			Player(openSource[Passport])["state"]["Buttons"] = false
			Player(openSource[Passport])["state"]["Cancel"] = false
			openSource[Passport] = nil
		end

		if openPlayer[Passport] then
			openPlayer[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.storeItem(Item, Slot, Amount, Target)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if openSource[Passport] then
            local Ped = GetPlayerPed(openSource[Passport])
            if DoesEntityExist(Ped) then
                if ExclusiveItens[Item] then
                    TriggerClientEvent("Notify", source, "vermelho", "Você não pode transferir itens exclusivos.", 5000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                    return
                end

                if vRP.MaxItens(openPlayer[Passport], Item, Amount) then
                    TriggerClientEvent("Notify", source, "amarelo", "Limite atingido.", 3000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                    return
                end

                if itemBlock(Item) then
                    TriggerClientEvent("Notify", source, "amarelo", "Não pode manejar esse item.", 3000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                    return
                end

                if (vRP.InventoryWeight(openPlayer[Passport]) + (itemWeight(Item) * Amount)) <= vRP.GetWeight(openPlayer[Passport]) then
                    if vRP.TakeItem(Passport, Item, Amount, false, Slot) then
                        vRP.GiveItem(openPlayer[Passport], Item, Amount, true, Target)
                    end
                else
                    TriggerClientEvent("Notify", source, "vermelho", "Mochila cheia.", 5000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.takeItem(Item, Slot, Target, Amount)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if openSource[Passport] then
            if DoesEntityExist(GetPlayerPed(openSource[Passport])) then
                if ExclusiveItens[Item] then
                    TriggerClientEvent("Notify", source, "vermelho", "Você não pode pegar itens exclusivos.", 5000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                    return
                end

                if vRP.MaxItens(Passport, Item, Amount) then
                    TriggerClientEvent("Notify", source, "amarelo", "Limite atingido.", 3000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                    return
                end

                if itemBlock(Item) then
                    TriggerClientEvent("Notify", source, "amarelo", "Não pode manejar esse item.", 3000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                    return
                end

                if (vRP.InventoryWeight(Passport) + (itemWeight(Item) * Amount)) <= vRP.GetWeight(Passport) then
                    if vRP.TakeItem(openPlayer[Passport], Item, Amount, true, Slot) then
                        vRP.GiveItem(Passport, Item, Amount, false, Target)
                        TriggerClientEvent("inspect:Update", source, "requestChest")
                    end
                else
                    TriggerClientEvent("Notify", source, "vermelho", "Mochila cheia.", 5000)
                    TriggerClientEvent("inspect:Update", source, "requestChest")
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateChest(Slot,Target,Amount)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if openSource[Passport] then
			local Ped = GetPlayerPed(openSource[Passport])
			if DoesEntityExist(Ped) then
				if vRP.invUpdate(openPlayer[Passport],Slot,Target,Amount) then
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end