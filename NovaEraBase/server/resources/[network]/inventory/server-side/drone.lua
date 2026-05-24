-----------------------------------------------------------------------------------------------------------------------------------------
-- DRONES:DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Drones:Disconnect")
AddEventHandler('Drones:Disconnect', function(drone, drone_data, pos)
    TriggerClientEvent('Drones:DropDrone', source, drone, drone_data, pos)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRONES:BACK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("Drones:Back")
AddEventHandler('Drones:Back', function(drone_data)
	local source = source
	local Passport = vRP.Passport(source)
    if Passport then
        vRP.GenerateItem(Passport,drone_data.name,1,true)
    end
end)