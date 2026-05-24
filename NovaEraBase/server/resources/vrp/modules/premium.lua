-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMPLATINA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetPremiumPlatina(source)
    if Characters[source] then
        vRP.Query("accounts/setPremiumPlatina",{ license = Characters[source]["license"], premiumplatina = os.time() + 2592000 })
        Characters[source]["premiumplatina"] = parseInt(os.time() + 2592000)
    end
end

function vRP.UpgradePremiumPlatina(source)
    if Characters[source] then
        vRP.Query("accounts/updatePremiumPlatina",{ license = Characters[source]["license"] })
        Characters[source]["premiumplatina"] = Characters[source]["premiumplatina"] + 2592000
    end
end

function vRP.UserPremiumPlatina(Passport)
    local source =  vRP.Source(Passport)
    local HasPermission = vRP.HasPermission(Passport,"PremiumPlatina")

    if Characters[source] then
        if Characters[source]["premiumplatina"] < os.time() then
            if HasPermission then
                vRP.RemovePermission(Passport,"PremiumPlatina")
                TriggerClientEvent("Notify", source, "vermelho", "Seu <b>Premium Platina</b> expirou!", 10000)
            end
            return false
        elseif not HasPermission then
            vRP.SetPermission(Passport,"PremiumPlatina")
        end
        return true
    end
    return false
end

function vRP.LicensePremiumPlatina(License)
    local Account = vRP.Account(License)
    if Account and Account["premiumplatina"] >= os.time() then
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMOURO
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetPremiumOuro(source)
    if Characters[source] then
        vRP.Query("accounts/setPremiumOuro",{ license = Characters[source]["license"], premiumouro = os.time() + 2592000 })
        Characters[source]["premiumouro"] = parseInt(os.time() + 2592000)
    end
end

function vRP.UpgradePremiumOuro(source)
    if Characters[source] then
        vRP.Query("accounts/updatePremiumOuro",{ license = Characters[source]["license"] })
        Characters[source]["premiumouro"] = Characters[source]["premiumouro"] + 2592000
    end
end

function vRP.UserPremiumOuro(Passport)
    local source = vRP.Source(Passport)
    local HasPermission = vRP.HasPermission(Passport,"PremiumOuro")

    if Characters[source] then
        if Characters[source]["premiumouro"] < os.time() then
            if HasPermission then
                vRP.RemovePermission(Passport,"PremiumOuro")
                TriggerClientEvent("Notify", source, "vermelho", "Seu <b>Premium Ouro</b> expirou!", 10000)
            end
            return false
        elseif not HasPermission then
            vRP.SetPermission(Passport,"PremiumOuro",1)
        end
        return true
    end
    return false
end

function vRP.LicensePremiumOuro(License)
    local Account = vRP.Account(License)
    if Account and Account["premiumouro"] >= os.time() then
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUMPRATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetPremiumPrata(source)
    if Characters[source] then
        vRP.Query("accounts/setPremiumPrata",{ license = Characters[source]["license"], premiumprata = os.time() + 2592000 })
        Characters[source]["premiumprata"] = parseInt(os.time() + 2592000)
    end
end

function vRP.UpgradePremiumPrata(source)
    if Characters[source] then
        vRP.Query("accounts/updatePremiumPrata",{ license = Characters[source]["license"] })
        Characters[source]["premiumprata"] = Characters[source]["premiumprata"] + 2592000
    end
end

function vRP.UserPremiumPrata(Passport)
    local source =  vRP.Source(Passport)
    local HasPermission = vRP.HasPermission(Passport,"PremiumPrata")

    if Characters[source] then
        if Characters[source]["premiumprata"] < os.time() then
            if HasPermission then
                vRP.RemovePermission(Passport,"PremiumPrata")
            end
            return false
        elseif not HasPermission then
            vRP.SetPermission(Passport,"PremiumPrata",1)
            TriggerClientEvent("Notify", source, "vermelho", "Seu <b>Premium Prata</b> expirou!", 10000)
        end
        return true
    end
    return false
end

function vRP.LicensePremiumPrata(License)
    local Account = vRP.Account(License)
    if Account and Account["premiumprata"] >= os.time() then
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(10000)
        for source, data in pairs(Characters) do
            if source and Characters[source] then
                local Passport = vRP.Passport(source)
                if Passport then
                    if Characters[source]["premiumplatina"] then
                        vRP.UserPremiumPlatina(Passport)
                    end

                    if Characters[source]["premiumouro"] then
                        vRP.UserPremiumOuro(Passport)
                    end

                    if Characters[source]["premiumprata"] then
                        vRP.UserPremiumPrata(Passport)
                    end
                end
            end
        end
    end
end)