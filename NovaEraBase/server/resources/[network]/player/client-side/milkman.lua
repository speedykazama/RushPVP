-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(Cows) do
		exports["target"]:AddCircleZone("Cows:"..Index,vec3(v[1],v[2],v[3]),0.5,{
			name = "Cows:"..Index,
			heading = 3374176
		},{
			Distance = 1.25,
			options = {
				{
					event = "inventory:MakeProducts",
					label = "Retirar Leite",
					tunnel = "products",
					service = "milkBottle"
				}
			}
		})
	end
end)