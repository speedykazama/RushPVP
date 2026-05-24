-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number, v in pairs(Banks) do
		exports["target"]:AddCircleZone("Robberys:Banks:" .. Number, v, 0.5, {
			name = "Robberys:Banks:" .. Number,
			heading = 0.0,
			useZ = true
		}, {
			shop = "banks",
			Distance = 1.25,
			options = {
				{
					event = "inventory:Robberys",
					tunnel = "server",
					label = "Roubar"
				}
			}
		})
	end

	for Number, v in pairs(Barbershop) do
		exports["target"]:AddBoxZone("Robberys:Barbershop:" .. Number, v, 0.9, 0.9, {
			name = "Robberys:Barbershop:" .. Number,
			heading = 0.0,
			minZ = v.z - 0.75,
			maxZ = v.z + 0.75
		}, {
			shop = "barbershop",
			Distance = 1.25,
			options = {
				{
					event = "inventory:Robberys",
					tunnel = "server",
					label = "Roubar"
				}
			}
		})
	end

	for Number, v in pairs(Weaponshop) do
		exports["target"]:AddBoxZone("Robberys:Weaponshop:" .. Number, v, 0.9, 0.9, {
			name = "Robberys:Weaponshop:" .. Number,
			heading = 0.0,
			minZ = v.z - 0.75,
			maxZ = v.z + 0.75
		}, {
			shop = "weaponshop",
			Distance = 1.25,
			options = {
				{
					event = "inventory:Robberys",
					tunnel = "server",
					label = "Roubar"
				}
			}
		})
	end

	for Number, v in pairs(Fleecashop) do
		exports["target"]:AddBoxZone("Robberys:Fleecashop:" .. Number, v, 0.9, 0.9, {
			name = "Robberys:Fleecashop:" .. Number,
			heading = 0.0,
			minZ = v.z - 0.75,
			maxZ = v.z + 0.75
		}, {
			shop = "fleecashop",
			Distance = 1.25,
			options = {
				{
					event = "inventory:Robberys",
					tunnel = "server",
					label = "Roubar"
				}
			}
		})
	end

	for Number, v in pairs(Departmentshop) do
		exports["target"]:AddBoxZone("Robberys:Departmentshop:" .. Number, v, 0.9, 0.9, {
			name = "Robberys:Departmentshop:" .. Number,
			heading = 0.0,
			minZ = v.z - 0.75,
			maxZ = v.z + 0.75
		}, {
			shop = "departmentshop",
			Distance = 1.25,
			options = {
				{
					event = "inventory:Robberys",
					tunnel = "server",
					label = "Roubar"
				}
			}
		})
	end
end)