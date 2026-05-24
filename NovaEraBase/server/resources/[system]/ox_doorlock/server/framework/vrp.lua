-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

SetTimeout(0, function()

    GetPlayer = function(src)
        local identity = vRP.Identity(vRP.Passport(src))
        local table = {}
        table[src] = {}
        table[src]["identifier"] = tonumber(vRP.Passport(src))
        table[src]["name"] = identity.name.." "..identity.name2
        table[src]["bank"] = vRP.GetBank(vRP.Passport(src))
        table[src]["money"] = vRP.InventoryItemAmount(vRP.Passport(src), "dollars")[1]
        return table[src]
    end

    function RemoveItem(playerId, item)
        local player = GetPlayer(playerId)

        if player then 
            vRP.TakeItem(tonumber(player.identifier), item, 1, true)
         end
    end

    ---@param player table
    ---@param items string[] | { name: string, remove?: boolean, metadata?: string }[]
    ---@param removeItem? boolean
    ---@return string?
    function DoesPlayerHaveItem(player, items, removeItem)
        for i = 1, #items do
            local item = items[i]
            local itemName = item.name or item
            if vRP.InventoryItemAmount(tonumber(player.identifier),itemName)[1] > 0 then
                if removeItem or item.remove then
                    vRP.TakeItem(tonumber(player.identifier), itemName, 1, true)
                end

                return itemName
            end
        end
    end
end)

function GetCharacterId(player)
    return player.identifier
end

function IsPlayerInGroup(player, filter)
    for k, v in pairs(filter) do
        if vRP.HasPermission(tonumber(player.identifier), k) then
            return true
        end
    end
end

