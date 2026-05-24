-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module('vrp', 'lib/Tunnel')
local apiServer = Tunnel.getInterface("radio-ui")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local registeredInformation = {}
local playersTalking = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOUI:REMOVESOURCEINFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('radioUi:removeSourceInformation', function(plySource)
    if registeredInformation[plySource] then
        registeredInformation[plySource] = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPLAYERTALKING
-----------------------------------------------------------------------------------------------------------------------------------------
function updatePlayerTalking(plySource, talking)
    playersTalking[plySource] = talking

    local informations = {
        source = plySource
    }

    if talking then
        if not registeredInformation[plySource] then
            registeredInformation[plySource] = apiServer.GetPlayer(plySource)
        end

        informations.name = registeredInformation[plySource]
    end

    SendNUIMessage({
        action = 'update',
        data = {
            talking = talking,
            informations = informations
        }
    })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:UPDATEUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('radio:updateUi', function(plySource, talking)
    updatePlayerTalking(plySource, talking)
end)