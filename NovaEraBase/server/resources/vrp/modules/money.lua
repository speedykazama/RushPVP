-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveBank(Passport,Amount)
    local Amount = parseInt(Amount)
    local source = vRP.Source(Passport)
    if Amount > 0 then
        vRP.Query("characters/addBank",{ Passport = Passport, amount = Amount })

        if NewBank then
            exports["bank"]:AddTransactions(Passport,"entry",Amount)
        end

        local source = vRP.Source(Passport)
        if source then
            TriggerClientEvent("itensNotify",source,{ "+","dollars",parseFormat(Amount),"Dólares" })
        end

        if Characters[source] then
            Characters[source]["bank"] = Characters[source]["bank"] + Amount
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveBank(Passport,Amount)
    local Amount = parseInt(Amount)
    local source = vRP.Source(Passport)
    if Amount > 0 then
        vRP.Query("characters/remBank",{ Passport = Passport, amount = Amount })
        
        if NewBank then
            exports["bank"]:AddTransactions(Passport,"exit",Amount)
        end

        local source = vRP.Source(Passport)
        if source then
            TriggerClientEvent("itensNotify",source,{ "-","dollars",parseFormat(Amount),"Dólares" })
        end

        if Characters[source] then
            Characters[source]["bank"] = Characters[source]["bank"] - Amount
            if 0 > Characters[source]["bank"] then
                Characters[source]["bank"] = 0
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetBank(source)
    if Characters[source] then
        return Characters[source]["bank"]
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetFine(Passport)
    local result = vRP.Query("fines/List", { Passport = Passport })
    local total = 0

    for _, row in ipairs(result) do
        total = total + parseInt(row.Value)
    end

    return total
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveFine(Passport, Amount, Message)
    Amount = parseInt(Amount)
    local Identity = vRP.Identity(Passport)

    local Date = os.date("%d/%m/%Y")
    local Hour = os.date("%H:%M")

    vRP.Query("fines/Add", {
        Passport = Passport,
        Name = Identity.name .. " " .. Identity.name2,
        Date = Date,
        Hour = Hour,
        Value = Amount,
        Message = Message or ""
    })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEFINE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveFine(Passport, FineId)
    FineId = parseInt(FineId)
    Passport = parseInt(Passport)

    if FineId <= 0 or Passport <= 0 then
        return false
    end

    vRP.Query("fines/Remove", {
        Passport = Passport,
        id = FineId
    })

    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETTAX
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetTax(Passport)
    local result = vRP.Query("taxs/List", { Passport = Passport })
    local total = 0

    for _, row in ipairs(result) do
        total = total + parseInt(row.Value)
    end

    return total
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVETAX
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveTax(Passport, Amount, Message)
    Amount = parseInt(Amount)

    local Identity = vRP.Identity(Passport)

    local Date = os.date("%d/%m/%Y")
    local Hour = os.date("%H:%M")

    vRP.Query("taxs/Add", {
        Passport = Passport,
        Name = Identity.name .. " " .. Identity.name2,
        Date = Date,
        Hour = Hour,
        Value = Amount,
        Message = Message or ""
    })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETAX
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.RemoveTax(Passport, TaxId)
    if not TaxId then
        return
    end

    vRP.Query("taxs/Remove", {Passport = Passport,id = TaxId})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentGems(Passport,Amount)
    local Amount = parseInt(Amount)
    local source = vRP.Source(Passport)
    if Amount > 0 and Characters[source] and Amount <= vRP.UserGemstone(Characters[source]["license"]) then
        vRP.Query("accounts/RemoveGems", { license = Characters[source]["license"], gems = Amount })
        TriggerClientEvent("hud:RemoveGems", source, Amount)
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentBank(Passport,Amount)
    local Amount = parseInt(Amount)
    local source = vRP.Source(Passport)
    if Amount > 0 and Characters[source] and Amount <= Characters[source]["bank"] then
        vRP.RemoveBank(Passport,Amount,(source))
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentMoney(Passport,Amount)
	if parseInt(Amount) > 0 then
		local Amount = parseInt(Amount)
		local Passport = parseInt(Passport)
		if vRP.ConsultItem(Passport,"dollars",Amount) then
            vRP.TakeItem(Passport,"dollars",Amount,true)
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTCREDIT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentCredit(Passport,Amount,Type)
	if parseInt(Amount) > 0 then
		if vRP.Identity(Passport)["cardlimit"] >= parseInt(Amount) then
            vRP.UpgradeSpending(Passport, Amount)
            vRP.DowngradeCardlimit(Passport, Amount)
            vRP.Query('invoices/Add',{ Passport = Passport, Received = "CreditCard", Type = "received", Reason = "Cartão de Crédito", Holder = "Loja: " ..(Type or "Fisica") , Value = parseInt(Amount) })
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PaymentFull(Passport, Amount, Type)
    local Source = vRP.Source(Passport)

    if parseInt(Amount) >= 1 then
        for _, Value in pairs(vRP.Inventory(Passport)) do
            local Item = SplitOne(Value["item"])

            if Item == "debitcard" or Item == "creditcard" then
                local CardPassport = parseInt(SplitTwo(Value["item"]))
                local Identity = vRP.Identity(CardPassport)

                if Passport == CardPassport or (Item == "creditcard") then
                    if Item == "debitcard" then
                        if vRP.PaymentBank(CardPassport, parseInt(Amount)) then
                            return true
                        else
                            TriggerClientEvent("Notify",Source,"vermelho","<b>Saldo Bancário</b> insuficiente.",5000)
                        end
                    else
                        if vRP.PaymentCredit(CardPassport, parseInt(Amount), Type) then
                            return true
                        else
                            TriggerClientEvent("Notify",Source,"vermelho","<b>Limite do Cartão</b> insuficiente.",5000)
                        end
                    end
                end
            end
        end

        if vRP.PaymentMoney(Passport, parseInt(Amount)) then
            return true
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAWCASH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.WithdrawCash(Passport,Amount)
    local Amount = parseInt(Amount)
    local source = vRP.Source(Passport)
    if Amount > 0 and Characters[source] and Amount <= Characters[source]["bank"] then
        vRP.GenerateItem(Passport, "dollars", Amount, true)
        vRP.RemoveBank(Passport, Amount, (source))
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESPENDING
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeSpending(Passport, Amount)
    local Source = vRP.Source(Passport)
    if parseInt(Amount) > 0 then
        vRP.Query("characters/UpgradeSpending", { Passport = Passport, spending = parseInt(Amount) })
        if Characters[Source] then
            Characters[Source].spending = Characters[Source].spending + parseInt(Amount)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESPENDING
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeSpending(Passport, Amount)
    local Source = vRP.Source(Passport)
    if parseInt(Amount) > 0 then
        vRP.Query("characters/DowngradeSpending", { Passport = Passport, spending = parseInt(Amount) })
        if Characters[Source] then
            Characters[Source].spending = Characters[Source].spending - parseInt(Amount)
            if 0 >= Characters[Source].spending then
                Characters[Source].spending = 0
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADECARDLIMIT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeCardlimit(Passport, Amount)
    local Source = vRP.Source(Passport)
    Amount = parseInt(Amount)

    if Amount > 0 then
        vRP.Query("characters/UpgradeCardlimit", {Passport = Passport,cardlimit = Amount})

        if Characters[Source] then
            Characters[Source].cardlimit = Amount
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADECARDLIMIT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DowngradeCardlimit(Passport, Amount)
    local Source = vRP.Source(Passport)
    if parseInt(Amount) > 0 then
        vRP.Query("characters/DowngradeCardlimit", { Passport = Passport, cardlimit = parseInt(Amount) })
        if Characters[Source] then
            Characters[Source].cardlimit = Characters[Source].cardlimit - parseInt(Amount)
            if 0 >= Characters[Source].cardlimit then
                Characters[Source].cardlimit = 0
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETCARDPASSWORD
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetCardPassword(Passport, Password)
    local Source = vRP.Source(Passport)
    local Password = sanitizeString(Password,"0123456789",true)
    if string.len(Password) == 4 then
        if Characters[Source] then
            Characters[Source].cardpassword = Password
        end
        exports.oxmysql:query_async("UPDATE characters SET cardpassword = @Password WHERE id = @Passport",{ Passport = Passport, Password = Password })
        return true
    else
        TriggerClientEvent("Notify",Source,"amarelo","Necessário possuir <b>4</b> números.",5000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "vrp" == Resource then
        Wait(3000)
    end
end)