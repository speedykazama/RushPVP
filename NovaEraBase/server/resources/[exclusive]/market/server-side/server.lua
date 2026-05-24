-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")
local resourceName = GetCurrentResourceName()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
SHK = {}
Tunnel.bindInterface(resourceName, SHK)
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
SHKclient = Tunnel.getInterface(resourceName)
vSURVIVAL = Tunnel.getInterface("survival")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAL
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = module(resourceName, "config")
local itemsdb = module("inventory", "config")
local security_control =
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.Prepare("shk/insert_product", "INSERT INTO market_selling (`user_id`,`product`,`amount`,`price`,`category`, `create_at`) VALUES(@user_id, @product, @amount, @price, @category, @create_at)")
vRP.Prepare("shk/select_products_offer", "SELECT id, product, category, COUNT(*) as offers FROM market_selling GROUP BY product ORDER BY product ASC")
vRP.Prepare("shk/select_products", "SELECT * FROM market_selling")
vRP.Prepare("shk/select_products_by_category", "SELECT id, product, amount, price, category, create_at FROM market_selling WHERE category = @category")
vRP.Prepare("shk/select_product_by_id", "SELECT id, user_id, product, amount, price, category, create_at FROM market_selling WHERE id = @id")
vRP.Prepare("shk/update_products_amount_by_id", "UPDATE market_selling SET amount = @amount WHERE id = @id")
vRP.Prepare("shk/select_products_by_item", "SELECT id, user_id, product, amount, price, category, create_at FROM market_selling WHERE product = @product")
vRP.Prepare("shk/max_products_by_item", "SELECT amount FROM market_selling WHERE user_id = @user_id AND product = @product")
vRP.Prepare("shk/select_product_by_user_item", "SELECT id,user_id, product, amount, price, category, create_at FROM market_selling WHERE product = @product and user_id = @user_id")
vRP.Prepare("shk/select_products_by_user", "SELECT id,user_id, product, amount, price, category, create_at FROM market_selling WHERE user_id = @user_id")
vRP.Prepare("shk/delete_product", "DELETE FROM market_selling WHERE id = @id")
vRP.Prepare("shk/update_product_price_and_amount", "UPDATE market_selling SET price = @price, amount = amount + @amount WHERE product = @product AND user_id = @user_id")
vRP.Prepare("shk/update_product_price", "UPDATE market_selling SET price = @price WHERE id = @id AND user_id = @user_id")
vRP.Prepare("shk/insert_product_sold", "INSERT INTO market_sold (`owner_id`, `buyer_id`,`product`,`amount`,`price`,`category`, `sold_at`) VALUES(@owner_id,@buyer_id, @product, @amount, @price, @category, @sold_at)")
vRP.Prepare("shk/select_product_sold_by_owner", "SELECT id, owner_id, buyer_id, product, amount, price, category, sold_at, finally, finally_at FROM market_sold WHERE owner_id = @owner_id ORDER BY finally_at DESC")
vRP.Prepare("shk/select_product_sold_by_id_and_owner", "SELECT id, owner_id, buyer_id, product, amount, price, category, sold_at, finally, finally_at FROM market_sold WHERE id = @id AND owner_id = @owner_id")
vRP.Prepare("shk/select__all_products_sold_by_owner", "SELECT id, owner_id, buyer_id, product, amount, price, category, sold_at, finally, finally_at FROM market_sold WHERE finally = 0 AND owner_id = @owner_id")
vRP.Prepare("shk/update_product_sold_finally", "UPDATE market_sold SET finally = @finally, finally_at = @finally_at WHERE id = @id AND owner_id = @owner_id")
vRP.Prepare("shk/select_product_sold_by_buyer", "SELECT id, owner_id, buyer_id, product, amount, price, category,sold_at FROM market_sold WHERE buyer_id = @buyer_id ORDER BY sold_at DESC")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
  end

local function setSecurityControl(user_id, clear)
	-- if not security_control[user_id] or (security_control[user_id] and security_control[user_id] <= os.time()) then
	-- 	security_control[user_id] = os.time() + 60
	-- end

	-- if clear then
	-- 	if security_control[user_id] then
	-- 		security_control[user_id] = nil
	-- 	end
	-- end
end

local function checkSecurityControl(user_id)
	-- if security_control[user_id] and security_control[user_id] > os.time() then
	-- 	return false
	-- end
	return true
end

local function getUserIdentity(user_id)
	local ident = vRP.Identity(user_id)
	if not ident or ident.name == nil then 
		return ident.name.. " ".. ident.name2
	end	
	return ident.name.. " ".. ident.name2
end

-- RegisterCommand("market", function(source, args)
-- 	local source = source
-- 	local user_id = vRP.Passport(source)
-- 	if user_id then
-- 		if not vSURVIVAL.isInComa(source) then
-- 			if vRP.hasPermission(user_id, "bronze.permissao") or vRP.hasPermission(user_id, "prata.permissao") or vRP.hasPermission(user_id, "ouro.permissao") or vRP.hasPermission(user_id, "platina.permissao") or vRP.hasPermission(user_id, "diamante.permissao") or vRP.hasPermission(user_id, "supremo.permissao") or vRP.hasPermission(user_id, "greencard.permissao") then
-- 				SHKclient.openMarket(source)
-- 			end
-- 		end
-- 	end
-- end)

RegisterCommand("market",function(source)
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		if vRP.HasGroup(user_id,"Admin",4) then
			SHKclient.openMarket(source)
		end
	end
end)

-- function SHK.registerProductMarket(itemname, amount)
-- 	local source = source
-- 	local user_id = vRP.Passport(source)
-- 	if user_id then
-- 		if itemname and (amount and amount > 0) then
-- 			local item = itemdb.itemsList[itemname]
-- 			if item then
-- 				if vRP.getInventoryItemAmount(item.dropname) >= amount then
-- 					if vRP.tryGetInventoryItem(user_id, item.dropname, amount, true) then
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end

function SHK.getOffersByProduct(item)
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		local tb = {}
			local dbd = vRP.Query("shk/select_products_by_item", {product = item})
			local data = dbd
			if Tablelength(data) > 0 then
				for k, v in pairs(data) do
					local cid = v.product .. "-" .. v.id
					if item == v.product then
						local cid = v.product .. "-" .. v.id
						tb[cid] = {
							id = v.id,
							index = itemIndex(item),
							name = itemName(item),
							seller = getUserIdentity(v.user_id),
							amount = v.amount,
							price = v.price,
							category = v.category,
							create = v.create_at
						}
					end
				end
			end
		return tb
	end
end

function SHK.getCategories()
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		local datadb = vRP.Query("shk/select_products_offer")
		local tb = {}
		if #datadb > 0 then
			for k,v in pairs(datadb) do
				local Split = splitString(v.product,"-")
				for k2,v2 in pairs(ItemListGlobal()) do
					if Split[1] == k2 then
						tb[k2] =
						{
							id = v.id,
							name = v.product,
							index = v2.Index,
							offers = v.offers,
							category = v.category
						}
					end
				end
			end	
		end
		return tb
	end
end

function SHK.buyProduct(offerid, amount)
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		if not checkSecurityControl(user_id) then
			return "try"
		end

		-- --setSecurityControl(user_id)

		if offerid and tonumber(amount) > 0 then
			amount = tonumber(amount)
			local productdb = vRP.Query("shk/select_product_by_id", {id = offerid})

			if Tablelength(productdb[1]) > 0 then
				productdb = productdb[1]
				local sellerId = productdb.user_id
				if sellerId ~= user_id then
					if productdb.amount >= amount then
						local fullprice = productdb.price * amount
						local idname = productdb.product

						-- local new_weight = vRP.getInventoryWeight(user_id) + (vRP.getItemWeight(idname) * amount)
						-- if 1 <= vRP.getInventoryMaxWeight(user_id) then
						if (vRP.InventoryWeight(user_id) + itemWeight(idname) * amount) <= vRP.GetWeight(user_id) then
							if vRP.TakeItem(user_id,"dollars",fullprice, true) or vRP.PaymentBank(user_id,fullprice,true) then
							-- if vRP.tryFullPayment(user_id, fullprice) then
								local Split = split(idname, "-")
								if #Split >= 2 then
									local durability = parseInt(os.time() - 200000)
									idname = Split[1].."-"..durability
								end
								vRP.GenerateItem(user_id, idname, amount, true)
								productdb.amount = productdb.amount - amount

								sendLogs(user_id,{ webhook = "mercado", text = "Comprou o item: `"..idname.."`\nQuantidade: `"..amount.."` "    })


								if productdb.amount <= 0 then

									vRP.Query("shk/delete_product", {id = offerid})
								else
									vRP.Query("shk/update_products_amount_by_id", {id = offerid, amount = productdb.amount})
								end
								vRP.Query("shk/insert_product_sold", {owner_id = sellerId, buyer_id = user_id, product = productdb.product, amount = amount, price = productdb.price, category = productdb.category, sold_at = os.time()})
								setSecurityControl(user_id, true)
								return "ok"
							else
								setSecurityControl(user_id, true)
								return "no_money"
							end
							return "ok"
						else
							setSecurityControl(user_id, true)
							return "max_weight"
						end
					else
						setSecurityControl(user_id, true)
						return "no_stock"
					end
				else
					setSecurityControl(user_id, true)
					return "owner_nobuy"
				end
			else
				setSecurityControl(user_id, true)
				return "try"
			end
		end
	end
	return "try"
end

function split(inputstr, sep)
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end



function SHK.getInventoryItems()
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		local items = {}
			local Inventory = {}
			local Inv = vRP.Inventory(user_id)
			for Index,v in pairs(Inv) do
				local Split = split(v.item, "-")
				items[v.item] = {
					name = v.item,
					amount = v.amount,
					index = itemIndex(Split[1]),
					category = "Ferramentas"
				}
			end
		return items
	end
	return false
end

function SHK.newOffer(itemkey, amount, price)
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        if not checkSecurityControl(user_id) or itemkey == "prisionkey" then
            return "try"
        end

        -- Convert values to numbers
        amount = tonumber(amount)
        price = tonumber(price)
        if itemkey and (amount and amount > 0) and (price and price > 0) then
            local itemname = itemkey
            local itemcat = "Ferramentas"
            local itemlimit = 10000

            if itemlimit then
                local db_amount = vRP.Query("shk/max_products_by_item", {user_id = user_id, product = itemname})
                local totalAmount = 0    

                if db_amount[1] and db_amount[1].amount then
                    totalAmount = db_amount[1].amount + amount
                else
                    totalAmount = amount
                end

                if tonumber(totalAmount) > tonumber(itemlimit) then
                    setSecurityControl(user_id, true)
                    return "max_itemlimit"
                end                    
            end        

            local Split = split(itemname, "-")
            if #Split >= 2 then
                if parseInt(Split[2]) <= parseInt(os.time() - 200000) then
                    return "no_itemdurability"
                end
            end

            for k,v in pairs(Config.Blacklist) do
                local Split = split(itemname, "-")
                if itemname == v then
                    return "no_blacklist"
                end
                if #Split >= 2 then
                    if Split[1] == v then
                        return "no_blacklist"
                    end
                end
            end

            if vRP.TakeItem(user_id, itemname, amount, true) then
                sendLogs(user_id, { webhook = "mercado2", text = "Anunciou o item: `"..itemname.."`\nQuantidade: `"..amount.."` " })
                local productdb = vRP.Query("shk/select_product_by_user_item", {product = itemname, user_id = user_id})
                if #productdb > 0 then
                    productdb = productdb[1]
                    vRP.Query("shk/update_product_price_and_amount", {price = price, amount = amount, product = productdb.product, user_id = user_id})
                    setSecurityControl(user_id, true)
                    return "ok"
                else
                    vRP.Query("shk/insert_product", {user_id = user_id, product = itemname, amount = amount, price = price, category = itemcat, create_at = os.time()})
                    setSecurityControl(user_id, true)
                    return "ok"
                end
            else
                -- setSecurityControl(user_id, true)
                return "no_amountitem"
            end
        end
    end
    return "try"
end

function SHK.getMyOffers()
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		local datadb = vRP.Query("shk/select_products_by_user", {user_id = user_id})
		local tb = {}
		if Tablelength(datadb) > 0 then
			
			for item, itemopt in pairs(ItemListGlobal()) do
				for k, v in pairs(datadb) do
					local Split = splitString(v.product,"-")
					if item == Split[1] then
						tb[v.product] = {id = v.id,name = v.product,index = itemopt["Index"], amount = v.amount, oldprice = v.price, category = v.category}
					end
				end
			end
		end
		return tb
	end
end

function SHK.changeProductPrice(key, newprice)
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		if not checkSecurityControl(user_id) then
			return "try"
		end
		--setSecurityControl(user_id)
		if key and (newprice and tonumber(newprice)) > 0 then
			newprice = tonumber(newprice)
			

			-- local item = "Nome Não Encontrado"
			-- for k,v in pairs(itemlist()) do
			-- 	if k == key then
			-- 		item = k
			-- 	end
			-- end


			local item = key
			if item then
				local productdb = vRP.Query("shk/select_product_by_user_item", {product = item, user_id = user_id})
				if Tablelength(productdb) > 0 then
					productdb = productdb[1]
					vRP.Query("shk/update_product_price", {price = newprice, id = productdb.id, user_id = user_id})
					setSecurityControl(user_id, true)
					sendLogs(user_id,{ webhook = "mercado3", text = "Alterou o item: `"..item.."`\nPreço novo: `"..newprice.."` "    })
					return "ok"
				else
					setSecurityControl(user_id, true)
					return "noitem"
				end
			end
		end
	end
	return "try"
end

function SHK.removeMyProductOffer(key)
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		if key then
			local idname = key
			local productdb = vRP.Query("shk/select_product_by_user_item", {product = idname, user_id = user_id})
			if Tablelength(productdb) > 0 then
				productdb = productdb[1]
				if (vRP.InventoryWeight(user_id) + itemWeight(idname) * productdb.amount) <= vRP.GetWeight(user_id) then
					vRP.Query("shk/delete_product", {id = productdb.id})
					vRP.GenerateItem(user_id,idname,productdb.amount,true)
					setSecurityControl(user_id, true)
					sendLogs(user_id,{ webhook = "mercado4", text = "Removeu o item: `"..idname.."`\nQuantidade: `"..productdb.amount.."` "    })
					return "ok"
				else
					setSecurityControl(user_id, true)
					return "weight"
				end
			else
				setSecurityControl(user_id, true)
				return "noitem"
			end
		end
	end
	return "try"
end

function SHK.getMyProductsSolds()
	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		local datadb = vRP.Query("shk/select_product_sold_by_owner", {owner_id = user_id})
		local tb = {}
		if Tablelength(datadb) > 0 then
			for item, itemopt in pairs(ItemListGlobal()) do
				for k, v in pairs(datadb) do
					local Split = splitString(v.product,"-")
					if item == Split[1] then
						local cid = item .. ":" .. v.id
						tb[cid] = {id = v.id, name = itemopt["Index"], amount = v.amount, price = v.price, category = v.category, sold_date = formatDate(v.sold_at), finish = v.finally, finish_date = (formatDate(v.finally_at) or "n.a")}
					end
				end
			end
		end
		return tb
	end
end


function SHK.resgateSoldAllItem(index)

	local source = source
	local user_id = vRP.Passport(source)
	if user_id then
		if index and type(index) == "number" then
			if not checkSecurityControl(user_id) then
				return "try"
			end
			--setSecurityControl(user_id)
			local productdb = vRP.Query("shk/select__all_products_sold_by_owner", { owner_id = user_id})
			if Tablelength(productdb) > 0 then
				local fullprice = 0
					productdb = v
					if productdb.finally == 0 then
						local ok = nil
						ok = vRP.Query("shk/update_product_sold_finally", {finally = 1, finally_at = os.time(), id = v.id, owner_id = user_id})
						while ok == nil do
							Citizen.wait(500)
						end
						fullprice = fullprice + (productdb.price * productdb.amount)
					end
				-- end	

				vRP.GiveBank(user_id,fullprice)
				setSecurityControl(user_id, true)
				sendLogs(user_id,{ webhook = "mercado5", text = "Resgatou o valor: `"..fullprice.."` "    })
				return "ok"
			else
				setSecurityControl(user_id, true)
				return "noitem"
			end
		end
	end
	return "try"
end

function SHK.resgateSoldItem(index)
	local source = source
	local user_id = vRP.Passport(source)

	if user_id then
		if index and type(index) == "number" then
			if not checkSecurityControl(user_id) then
				return "try"
			end
			--setSecurityControl(user_id)
			local productdb = vRP.Query("shk/select_product_sold_by_id_and_owner", {id = index, owner_id = user_id})
			if Tablelength(productdb) > 0 then
				productdb = productdb[1]
				if productdb.finally == 0 then
					local ok = nil
					ok = vRP.Query("shk/update_product_sold_finally", {finally = 1, finally_at = os.time(), id = index, owner_id = user_id})
					while ok == nil do
						Citizen.Await(500)
					end
					local fullprice = (productdb.price * productdb.amount)
					vRP.GiveBank(user_id,fullprice)
					setSecurityControl(user_id, true)
					sendLogs(user_id,{ webhook = "mercado5", text = "Resgatou o valor: `"..fullprice.."` "    })
					return "ok"
				else
					setSecurityControl(user_id, true)
					return "finished"
				end
			else
				setSecurityControl(user_id, true)
				return "noitem"
			end
		end
	end
	return "try"
end

-- Return the number of elements of the table
function Tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function formatDate(timestamp)
	if timestamp then
		local d = os.date("*t", tonumber(timestamp))
		return d.day .. "/" .. d.month .. "/" .. d.year .. " " .. d.hour .. ":" .. d.min .. ":" .. d.sec
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
local function extractDiscord(src)
    local discord = ""

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "discord") then
            discord = id
        end
    end

    return discord
end

function sendLogs(user_id, data)
    local user_id = parseInt(user_id)
    local identity = vRP.Identity(user_id) or { name = "Não registrado", firstname = "Não registrado" }
    local sourceUser = vRP.Source(user_id)
    local infos 

    if not sourceUser then
        infos = 'Sem discord discord:'
    else
        infos = extractDiscord(vRP.Source(user_id))
    end

    local Webhook = Config.Webhook

    PerformHttpRequest(Webhook, function(err, text, headers)
    end, "POST", json.encode({
        embeds = {
            {
                title = "SISTEMA DE LOG",
                description = "Passaporte: " .. user_id .. "\nNome: " .. identity.name .. " " .. identity.name2 .. "\nDiscord: <@" .. infos:gsub("discord:", "") .. ">\n\n" .. data.text .. "\n",
                thumbnail = {
                    url = ""
                },
                footer = {
                    text = '' .. os.date("\n[Data]: %d/%m/%Y | [Hora]: %H:%M:%S"),
                    icon_url = ""
                },
                color = 3092790
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end