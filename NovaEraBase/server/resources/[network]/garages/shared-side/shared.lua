-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Anim = "machinic_loop_mechandplayer"
Dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERCENTAGES
-----------------------------------------------------------------------------------------------------------------------------------------
PercetageSelling = 0.5 -- Porcentagem a receber ao vender o veículo
PercentageArrest = 0.1 -- Porcentagem a cobrar para liberar o veículo apreendido
PercetageTax = 0.1 -- Porcentagem da taxa cobrado em cima do valor do veículo
PercentageSpawn = 0.01 -- Porcentagem da taxa cobrada em cima do valor do veículo para spawnar
PercetageTaxGemstoneInitial = 0.05 -- Porcentagem para aluguel inicial de veículos com gemas
PercetageTaxGemstoneRenew = 0.10   -- Porcentagem para renovação do aluguel vencido de veículos com gemas
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
CarPermission = "Admin" -- Permissão para utilizar o comando /car
DvPermission = "Admin" -- Permissão para utilizar o comando /dv
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHICLESDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
StoreVehiclesDistance = 5.0 -- Metros para conseguir guardar o veículo na garagem
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNINSIDEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
SpawnInsideVehicle = true -- Spawnar dentro do carro
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNVEHICLELOCKED
-----------------------------------------------------------------------------------------------------------------------------------------
SpawnVehicleLocked = true -- Spawnar veículo trancado
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROHIBITEDCLASSES
-----------------------------------------------------------------------------------------------------------------------------------------
ProhibitedClasses = {   -- Classes de veículos que são proibidas vender ou transferir
    "Rental", "Work"
}