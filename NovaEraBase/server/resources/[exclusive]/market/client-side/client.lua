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
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
Tunnel.bindInterface(resourceName, SHK)
SHKserver = Tunnel.getInterface(resourceName)
Config = module(resourceName, "config")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAL
-----------------------------------------------------------------------------------------------------------------------------------------
local onpress = false
local openMarket = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('market:openShop')
AddEventHandler('market:openShop',function()
    onpress = true
end)

RegisterNetEvent("123123123213124554574582151457458431321")
AddEventHandler("123123123213124554574582151457458431321",function()
    TriggerEvent("hudActived", false)
    openMarket = true
    SendNUIMessage({action = "openMarket"})
    SetNuiFocus(true, true)
end)

RegisterNetEvent("Night:openMarket")
AddEventHandler("Night:openMarket", function()
    SHK.openMarket()
end)

function SHK.openMarket()
    TriggerEvent("hudActived", false)
    openMarket = true
    SendNUIMessage({action = "openMarket"})
    SetNuiFocus(true, true)
end

RegisterNUICallback("closeMarket", function(data, cb)
    TriggerEvent("hudActived", true)
    SetNuiFocus(false)
    cb("ok")
    openMarket = false
    onpress = false
end)

RegisterNUICallback("marketGetProducts", function(data, cb)
    local type = nil
    if data.type then type = data.type end
    cb(SHKserver.getProductsByCategories(type))
end)

RegisterNUICallback("marketGetCategories", function(data, cb)
    local type = nil
    if data and data.type then type = data.type end
    cb(SHKserver.getCategories(type))
end)

RegisterNUICallback("marketGetOffers", function(data, cb)
    local type = nil
    if data and data.product then type = data.product end
    cb(SHKserver.getOffersByProduct(type))
end)

RegisterNUICallback("marketBuyProduct", function(data, cb)
    if data.offerid and data.amount and data.amount > 0 then
        cb(SHKserver.buyProduct(data.offerid, data.amount))
    else
        cb("try")
    end
end)

RegisterNUICallback("marketNewOffer", function(data, cb)
    if data.key and (data.amount and tonumber(data.amount) > 0) and
        (data.price and tonumber(data.price) > 0) then
        cb(SHKserver.newOffer(data.key, data.amount, data.price))
    else
        cb("try")
    end
end)

RegisterNUICallback("marketGetMyOffers", function(data, cb) cb(SHKserver.getMyOffers()) end)

RegisterNUICallback("marketGetInventoryItems", function(data, cb) cb(SHKserver.getInventoryItems()) end)

RegisterNUICallback("marketproductPrice", function(data, cb)
    if data.key and (data.price and tonumber(data.price) > 0) then
        cb(SHKserver.changeProductPrice(data.key, data.price))
    else
        cb("try")
    end
end)

RegisterNUICallback("marketRemoveMyOffer", function(data, cb)
    if data.key then
        cb(SHKserver.removeMyProductOffer(data.key))
    else
        cb("try")
    end
end)

RegisterNUICallback("marketGetMySolds", function(data, cb) cb(SHKserver.getMyProductsSolds()) end)

RegisterNUICallback("marketResgateMySoldItem", function(data, cb)
    if data.index then
        cb(SHKserver.resgateSoldItem(tonumber(data.index)))
    else
        cb("try")
    end
end)

RegisterNUICallback("marketResgateMySoldAllItem", function(data, cb)
    cb(SHKserver.resgateSoldAllItem())
end)

function Tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKETCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    for _, v in pairs(Config.Mercados) do
        addBlip(v)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function addBlip(spot)
    if Config.MostrarBlip then
        if not spot.blip or not DoesBlipExist(spot.blip) then
            local blips = AddBlipForCoord(spot[1], spot[2], spot[3])
            SetBlipSprite(blips, Config.Blip.ID)
            SetBlipColour(blips, Config.Blip.COLOR)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Blip.TITLE)
            EndTextCommandSetBlipName(blips)
            SetBlipScale(blips, Config.Blip.SCALE)
            SetBlipAsShortRange(blips, true)
            SetBlipAsMissionCreatorBlip(blips, true)
            spot.blip = blips
        end
    else
        if spot.blip and DoesBlipExist(spot.blip) then
            RemoveBlip(spot.blip)
            spot.blip = nil
        end
    end
end