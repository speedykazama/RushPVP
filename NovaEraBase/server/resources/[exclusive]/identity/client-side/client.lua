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
Tunnel.bindInterface("identity",Creative)
vSERVER = Tunnel.getInterface("identity")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function(data)
	SendNUIMessage({ action = "closeSystem" })
	SetNuiFocus(false,false)
	vRP.Destroy()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateName')
AddEventHandler('updateName', function(identity)
  SendNUIMessage({
    action = "updateName",
    identity = identity
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateAge')
AddEventHandler('updateAge', function(age)
  SendNUIMessage({
    action = "updateAge",
    age = age
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateId')
AddEventHandler('updateId', function(userid)
  SendNUIMessage({
    action = "updateId",
    userid = userid
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updatePhone')
AddEventHandler('updatePhone', function(phone)
  SendNUIMessage({
    action = "updatePhone",
    phone = phone
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateRg')
AddEventHandler('updateRg', function(rg)
  SendNUIMessage({
    action = "updateRg",
    rg = rg
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateBank')
AddEventHandler('updateBank', function(bank)
  SendNUIMessage({
    action = "updateBank",
    bank = bank
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateCash')
AddEventHandler('updateCash', function(cash)
  SendNUIMessage({
    action = "updateCash",
    cash = cash
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateGroup')
AddEventHandler('updateGroup', function(group)
  SendNUIMessage({
    action = "updateGroup",
    group = group
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateVip')
AddEventHandler('updateVip', function(vip)
  SendNUIMessage({
    action = "updateVip",
    vip = vip
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:NUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('updateAdmin')
AddEventHandler('updateAdmin', function(admin)
  SendNUIMessage({
    action = "updateAdmin",
    admin = admin
  })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--EVENTS:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
local nuiVisible = false
--RegisterCommand("openIdentity",function()
RegisterNetEvent("openIdentity")
AddEventHandler("openIdentity", function()
    local ped = PlayerPedId()
    if not IsPedSwimming(ped) then
        nuiVisible = not nuiVisible
        if nuiVisible then
            SendNUIMessage({ action = "openIdentity" })
            TriggerEvent("dynamic:closeSystem")
            SetNuiFocus(false, false)

            if not IsPedInAnyVehicle(ped) then
                vRP.Destroy()
                vRP.CreateObjects("cellphone@", "cellphone_horizontal_intro", "prop_police_phone", 50, 28422)
            end
        else
            SendNUIMessage({ action = "closeSystem" })
            SetNuiFocus(false, false)
            vRP.Destroy()

        end
    end
end)
--------------------------------------------------------------------------------------------------------------
-- SENDINFO
--------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("sendInfo")
        Citizen.Wait(1000)
    end
end)
--------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
--------------------------------------------------------------------------------------------------------------
--RegisterKeyMapping('openIdentity', 'Abrir ou Fechar Identidade', 'keyboard', 'F11')