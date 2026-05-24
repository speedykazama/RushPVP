-----------------------------------------------------------------------------------------------------------------------------------------
-- ERRO DE TANKAR HS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local Wait = 100
        SetPedSuffersCriticalHits(PlayerPedId(-1), true)
        Citizen.Wait(Wait)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESATIVA O MODO FURTIVO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(5)
        local ped = PlayerPedId()
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            if not IsPauseMenuActive() then
                DisableControlAction(0, 36, true)
            end
        end
    end
end)