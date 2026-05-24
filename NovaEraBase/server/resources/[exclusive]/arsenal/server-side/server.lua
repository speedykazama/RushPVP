-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("arsenal", Creative)
vCLIENT = Tunnel.getInterface("arsenal")
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.requestPolice()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.HasService(Passport, "Policia") then
            return true
        else
            TriggerClientEvent("Notify", source, "police", "Você não tem permissão para acessar o arsenal malandro(a).", 5000)
            return false
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.buyItem(item)
	local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local price
        for k, v in pairs(config.itemsArsenal) do
            for i, b in pairs(v) do
                if b.item == item then
                    quantidade = b.quantidade
                    price = b.compra
                    break
                end
            end
        end

		if not vRP.MaxItens(Passport, item, quantidade) then
            if (vRP.InventoryWeight(Passport) + itemWeight(item) * quantidade) <= vRP.GetWeight(Passport) then
                if price and vRP.PaymentBank(Passport, price) then
                    vRP.GenerateItem(Passport, item, quantidade,true)
                    TriggerClientEvent("Notify", source, "verde", "Você comprou " .. quantidade .. "x <b>" .. itemName(item) .. "</b> por <b>$" .. price .. "</b>.", 5000)
                    TriggerEvent("Discord", "LojaPolicia", "**[Compra de Item]**\n\n" .. "**IP:** " .. GetPlayerEndpoint(source) .. "\n" .. "**Passaporte:** " .. Passport .. "\n" .. "**Item Comprado:** " .. itemName(item) .. "\n" .. "**Quantidade:** " .. quantidade .. "\n" .. "**Preço Total:** $" .. price .. "\n" .. "**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"), 16777215)
                else
                    TriggerClientEvent("Notify", source, "amarelo", "Dinheiro insuficiente.", 5000)
                end
            else
                TriggerClientEvent("Notify", source, "amarelo", "Espaço insuficiente.", 5000)
            end
        else
            TriggerClientEvent("Notify", source, "amarelo", "Limite de compra atingido.", 5000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.getItems()
    local items = {}
    for k, v in pairs(config.itemsArsenal) do
        items[k] = {}
        for i, b in pairs(v) do
			if itemBody(b.item) then
				table.insert(items[k], { item = b.item, name = b.name, quantidade = b.quantidade, compra = b.compra, descricao = b.descricao, img = b.img })
			end
        end
    end
    return items
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.getMoney()
    local Passport = vRP.Passport(source)
    if Passport then
        return vRP.GetBank(Passport)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPAIRS
-----------------------------------------------------------------------------------------------------------------------------------------
for k, v in pairs(config.itemsArsenal) do
    for i, b in pairs(v) do
		if itemBody(b.item) then
			b.name = itemName(b.item)
		end
    end
end