-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("identity",Creative)
vCLIENT = Tunnel.getInterface("identity")

-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getItemAmount(Passport, Item)
    if vRP.Source(Passport) then
        local Inventory = vRP.Inventory(Passport)
        for k, v in pairs(Inventory) do
            if splitString(Item, "-")[1] == splitString(v["item"], "-")[1] then
                return { "R$"..v["amount"] }
            end
        end
    end
    
    return { 0 }
end
--------------------------------------------------------------------------------------------------------------
-- ENVIARINFO
--------------------------------------------------------------------------------------------------------------
RegisterNetEvent("sendInfo")
AddEventHandler("sendInfo", function()
    local source = source 
    local user_id = vRP.Passport(source)
    if user_id then
        local identity = vRP.Identity(user_id)
        local age = identity.sex or "Não encontrada"
        local phone = identity.phone or "Não encontrada"
        local License = identity.license
        local rg = vRP.UserGemstone(License) or "Não encontrada"
        local bank = identity.bank or "Não encontrada"
        local cash = vRP.ItemAmount(user_id, "dollars") or "Não encontrada"
        local VIP = {}

        local isAdmin, groupName, groupHierarchy = false, "", ""
        if vRP.HasGroup(user_id, "Admin") then
            isAdmin = true
            groupName = "Admin"
            groupHierarchy = vRP.Hierarchy("Admin")
        end

        if vRP.HasGroup(user_id, "Premium") then
            table.insert(VIP, "Platina")
        end
        if vRP.HasGroup(user_id, "PremiumOuro") then
            table.insert(VIP, "Ouro")
        end
        if vRP.HasGroup(user_id, "PremiumPrata") then
            table.insert(VIP, "Prata")
        end
        if #VIP == 0 then
            table.insert(VIP, "Sem Vip Ativos")
        end
        local VIPString = table.concat(VIP, " , ")

        local function formatNumber(value)
            local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
            return left .. (num:reverse():gsub('(%d%d%d)', '%1.'):reverse()) .. right
        end
        local groups = { "PMERJ", "PCERJ", "PRF", "BOPE", "RECOM",
        "BPCHQ","EX","Paramedic", "Bombeiro", "Mechanic","Mechanic2",
        "Maonegra","Distrito","P77","Mare","Milicia", "Favela6",
        "Chernobyl","Bairro13","Dz7","Labirinto","Medellín","Crateva",
        "Setor13", "Crips", "Grota" }
        local playerGroups = {}

        for _, group in ipairs(groups) do
            if vRP.HasGroup(user_id, group) then
                table.insert(playerGroups, group)
            end
        end
        if #playerGroups == 0 then
            table.insert(playerGroups, "Sem Grupos Ativos")
        end
        local groupString = table.concat(playerGroups, " , ")

        if identity then
            TriggerClientEvent('updateName', source, identity.name .." ".. identity.name2)
            TriggerClientEvent('updateId', source, user_id)
            TriggerClientEvent('updateAge', source, age)
            TriggerClientEvent('updatePhone', source, phone)
            TriggerClientEvent('updateRg', source, rg)
            TriggerClientEvent('updateBank', source, "R$"..formatNumber(tostring(bank)))
            TriggerClientEvent('updateCash', source, formatNumber(tostring(cash)))
            TriggerClientEvent('updateVip', source, VIPString)
            TriggerClientEvent('updateGroup', source, groupString)
            TriggerClientEvent('updateAdmin', source, groupName )
        else
            print("Erro: identity é nil. Por favor verifique a sua função ou verifique com o suporte.")
        end
    end
end)