-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Registers) do
		exports["target"]:AddCircleZone("Register:"..Number,vec3(v[1],v[2],v[3]),0.75,{
			name = "Register:"..Number,
			heading = v[4]
		},{
			shop = Number,
			Distance = 1.0,
			options = {
				{
					event = "Register:Init",
					label = "Roubar",
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REGISTER:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Register:Init",function(Number)
	if vSERVER.RegistersTimers(Number) then
		SetEntityHeading(ped,Registers[Number][4])
		SetEntityCoords(ped,Registers[Number][1],Registers[Number][2],Registers[Number][3] - 1,1,0,0,0)

		vSERVER.RegistersPay()
	end
end)