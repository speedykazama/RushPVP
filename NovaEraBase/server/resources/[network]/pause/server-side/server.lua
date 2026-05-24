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
Tunnel.bindInterface("pause",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local BoxPayment = false
local Rolepass = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCAROUSEL
-----------------------------------------------------------------------------------------------------------------------------------------
local function getCarousel()
	local Carousel = {}
	local Counter = 0
	for Number,v in pairs(ShopItens) do
		if (#Carousel + 1) > 3 then break end

		if v["Discount"] ~= 0 then
			Carousel[#Carousel + 1] = {
				["id"] = Counter,
				["Index"] = Number,
				["Image"] = itemIndex(Number),
				["Name"] = itemName(Number),
				["Amount"] = 1,
				["Price"] = v["Price"],
				["Discount"] = v["Price"] * ((v["Discount"] / 100))
			}

			Counter += 1
		end
	end
    
	return Carousel
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPPING
-----------------------------------------------------------------------------------------------------------------------------------------
local function getShopping()
	local Shopping = {}
	for Number,v in pairs(ShopItens) do
		if (#Shopping + 1) > 5 then break end

		Shopping[#Shopping + 1] = {
			["Image"] = itemIndex(Number),
			["Name"] = itemName(Number),
			["Index"] = Number,
			["Amount"] = 1,
			["Price"] = v["Price"],
			["Discount"] = v["Discount"]
		}
	end

	return Shopping
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETEXPERIENCE
-----------------------------------------------------------------------------------------------------------------------------------------
local function getExperience(Passport)
	local Experience = {}
	for Number,v in pairs(Works) do
		Experience[#Experience + 1] = {
			v,
			vRP.GetExperience(Passport, v) or 0
		}
	end

	return Experience
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOME
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Home()
    local source = source
    local Passport = vRP.Passport(source)
    local Identity = vRP.Identity(Passport)
    if Identity then
		local Experience = {}
		for k, v in pairs(Works) do
			Experience[#Experience + 1] = {
				ClassWork(v),
				parseInt(vRP.GetExperience(Passport, v)) or 0
			}
		end

        local Identities = vRP.Identities(source)
        local Account = vRP.Account(Identities)
		local Sanguine = bloodTypes or "Sem Informação"

		local VIP = {}

		for groupName, vipName in pairs(Vips) do
			if vRP.HasGroup(Passport, groupName) then
				table.insert(VIP, vipName)
			end
		end

		if #VIP == 0 then
			VIP = { "SEM VIP" }
		end

        local Home = {
            ["Information"] = {
                ["Passport"] = Passport,
                ["Name"] = Identity["name"].." "..Identity["name2"],
                ["Bank"] = vRP.GetBank(source),
                ["Sex"] = Identity["sex"],
                ["Blood"] = VIP,
                ["Phone"] = Identity["phone"] or "Não identificado",
                ["Diamonds"] = Account["gems"] or 0,
                ["Medic"] = " "
            },

            ["Premium"] = {["Price"] = BomPremium, ["Value"] = BomPremium},
            ["Carousel"] = getCarousel(),
            ["Shopping"] = getShopping(),
            ["Experience"] = Experience,
            ["Box"] = Boxes[1]
        }
        return Home
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAMONDSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DiamondsList()
	local DiamondsList = {}

	for Number,v in pairs(ShopItens) do
		DiamondsList[#DiamondsList + 1] = {
			["Index"] = Number,
			["Description"] = itemDescription(Number),
			["Image"] = itemIndex(Number),
			["Name"] = itemName(Number),
			["Price"] = v["Price"],
			["Discount"] = v["Discount"]
		}
	end
    
	return DiamondsList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIAMONDSBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DiamondsBuy(Item, Amount)
	local source = source
	local Passport = vRP.Passport(source)
	if ShopItens[Item] then
		local Price = ShopItens[Item]["Price"] * ((100 - ShopItens[Item]["Discount"]) / 100)
		if vRP.PaymentGems(Passport, Amount * Price) then
			vRP.GenerateItem(Passport, Item, Amount, true)
			TriggerEvent("Discord","LojaPause","**[Compra de item]**\n\n**Source:** "..source.."\n**Passaporte:** "..Passport.." - ".. vRP.FullName(Passport).."\n**Comprou:** "..Amount.."x "..itemName(Item).."\n**Por:** "..ShopItens[Item]["Price"] * Amount.." Gemas" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)

			return true
		else
			TriggerClientEvent("Notify", source, "vermelho", "<b>"..itemName("gemstone").."s</b> insuficiente.", 5000)
		end
	end
    
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENBOXES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OpenBoxes(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Number then
		if vRP.PaymentGems(Passport, tonumber(Boxes[Number]["Price"])) then
			BoxPayment = true
			TriggerEvent("Discord","LojaBoxesPause","**[Compra de Box]**\n\n**Passaporte:** "..Passport.." - ".. vRP.FullName(Passport).."\n**Abriu:** "..Boxes[Number]["Name"].." \n**Por:** "..Boxes[Number]["Price"].." Gemas" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			return math.random(#ContentBoxes[Number])
		else
			TriggerClientEvent("Notify", source, "vermelho", "<b>"..itemName("gemstone").."s</b> insuficiente.", 5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBOXES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PaymentBoxes(Number, Index)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not BoxPayment then
			TriggerClientEvent("Notify", source, "vermelho", "Infelizmente a caixa não abriu.",  5000)
			return
		else
			vRP.GenerateItem(Passport, ContentBoxes[Number][Index]["Item"], ContentBoxes[Number][Index]["Amount"], true)
			TriggerEvent("Discord","WonBoxesPauseStore","**[Item ganho na Box]**\n\n**Passaporte:** "..Passport.."\n**Ganhou:** "..ContentBoxes[Number][Index]["Amount"].."x "..itemName(ContentBoxes[Number][Index]["Item"]).." Na Boxes do Pause Menu" .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
			BoxPayment = false
		end

		return "Ok"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETROLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
function GetRolepass(Passport)
    if not Rolepass[Passport] then
        Rolepass[Passport] = vRP.UserData(Passport,"Rolepass")
    end
    return Rolepass[Passport]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAUSE:ADDPOINTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("pause:AddPoints")
AddEventHandler("pause:AddPoints", function(Passport, Amount)
    local Rolepass = GetRolepass(Passport)
    if not Rolepass["Points"] then
        Rolepass["Points"] = 0
    end
    Rolepass["Points"] = Rolepass["Points"] + math.min(Amount, (15000 - Rolepass["Points"]))

    vRP.Query("playerdata/SetData", { Passport = Passport, dkey = "Rolepass", dvalue = json.encode(Rolepass) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
    if Rolepass[Passport] then
        vRP.Query("playerdata/SetData", { Passport = Passport, dkey = "Rolepass", dvalue = json.encode(Rolepass[Passport]) })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Rolepass()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Premium = {}
        for Index,Value in pairs(RoleItens["Premium"]) do
            table.insert(Premium, { 
                id = Index, 
                Name = itemName(Value.Item), 
                Index = Value.Item, 
                Amount = Value.Amount, 
                Image = itemIndex(Value.Item), 
                Description = itemDescription(Value.Item) 
            })
        end

        local Free = {}
        for Index,Value in pairs(RoleItens["Free"]) do
            table.insert(Free, { 
                id = Index, 
                Name = itemName(Value.Item), 
                Index = Value.Item, 
                Amount = Value.Amount, 
                Image = itemIndex(Value.Item), 
                Description = itemDescription(Value.Item) 
            })
        end

        local now = os.time()
        local day, month, year = string.match(RolepassTime, "(%d+)/(%d+)/(%d+)")
        day = tonumber(day)
        month = tonumber(month)
        year = tonumber(year)
        local rolepass_end = os.time({year = year, month = month, day = day, hour = 0, min = 0, sec = 0})
        local Finish = os.difftime(rolepass_end, now)

        local Rolepass = GetRolepass(Passport)

        if not Rolepass["Finish"] or parseInt(Rolepass["Finish"]) <= now then
            Rolepass["Free"] = 0
            Rolepass["Premium"] = 0
            Rolepass["Points"] = 0
            Rolepass["Finish"] = now + Finish
            Rolepass["RolepassBuy"] = false
        end

        return {
            Active = Rolepass["RolepassBuy"],
            Total = parseInt(math.ceil(parseInt(Rolepass["Points"]) / 500) * 500),
            Points = parseInt(Rolepass["Points"]),
            AtualFree = parseInt(Rolepass["Free"]),
            AtualPremium = parseInt(Rolepass["Premium"]),
            Finish = parseInt(Finish),
            Premium = Premium,
            Free = Free,
        }
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESCUE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RolepassRescue(Type,Index)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Item = RoleItens[Type][parseInt(Index)]["Item"]
        local Amount = RoleItens[Type][parseInt(Index)]["Amount"]
        if (vRP.InventoryWeight(Passport) + itemWeight(Item) * Amount) <= vRP.GetWeight(Passport) then
            TriggerClientEvent("sounds:source",source,"finish",0.1)
            Rolepass[Passport][Type] = parseInt(Index)
            Rolepass[Passport]["Points"] = not Rolepass[Passport]["Points"] and 0 or Rolepass[Passport]["Points"] - 500            
            vRP.GenerateItem(Passport,Item,Amount,false) 
            TriggerEvent("Discord","**[Item resgatado]**\n\nReedemItemRolepass","**Passaporte:** "..Passport.."\n**Item:** "..Amount.."x "..itemName(Item) .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
            return true
        else
            TriggerClientEvent("Notify", source, "vermelho", "Mochila cheia.", 5000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RolepassBuy()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if vRP.PaymentGems(Passport,RolepassPrice) then
            local now = os.time()
            local date = os.date("*t", now)
            local Rolepass = GetRolepass(Passport)
            Rolepass["RolepassBuy"] = true
            vRP.Query("playerdata/SetData",{ Passport = Passport, dkey = "Rolepass", dvalue = json.encode(Rolepass) })
            TriggerEvent("Discord","BuyRolepass","**[Compra de Rolepass]**\n\n**Passaporte:** "..Passport .. "\n**Data e Hora:** " .. os.date("%d/%m/%Y - %H:%M:%S"),16777215)
            return true
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEBERXP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ReceberXP(amount)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local xp = amount or XPBonus
        TriggerEvent("pause:AddPoints", Passport, xp)
        TriggerClientEvent("Notify", source, "azul", "Recebeu <b>"..xp.."XP</b> no nosso BattlePass", 5000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Disconnect()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.kick(source, "Você se desconectou.")
	end
end