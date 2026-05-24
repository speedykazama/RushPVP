-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Previous = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index in pairs(Chairs) do
		exports["target"]:AddTargetModel({Index}, {
			options = {
				{
					event = "target:Chair",
					label = "Sentar",
					tunnel = "client"
				}
			},
			Distance = 1.0
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPCHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:UpChair")
AddEventHandler("target:UpChair",function()
	if Previous then
		local Ped = PlayerPedId()
		SetEntityCoords(Ped,Previous["x"],Previous["y"],Previous["z"] - 1,false,false,false,false)
		FreezeEntityPosition(Ped,false)
		Previous = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:CHAIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Chair")
AddEventHandler("target:Chair",function(Vars)
	local Model = Vars[2]
	local Entitys = Vars[1]
	local Ped = PlayerPedId()

	if Chairs[Model] then
		FreezeEntityPosition(Ped,false)
		FreezeEntityPosition(Entitys,true)

		Previous = GetEntityCoords(Ped)
		SetEntityCoords(Ped,Vars[4]["x"],Vars[4]["y"],Vars[4]["z"] + 0.5)
		SetEntityHeading(Ped,GetEntityHeading(Entitys) - Chairs[Model]["Heading"])

		TaskStartScenarioAtPosition(Ped,"PROP_HUMAN_SEAT_CHAIR_UPRIGHT",Vars[4]["x"] + Chairs[Model]["OffsetX"],Vars[4]["y"] + Chairs[Model]["OffsetY"],Vars[4]["z"] + Chairs[Model]["OffsetZ"],GetEntityHeading(Entitys) - Chairs[Model]["Heading"],0,true,true)
	end
end)