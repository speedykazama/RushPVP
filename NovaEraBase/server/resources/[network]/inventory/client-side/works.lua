---------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:GARBAGEMAN
---------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	exports["target"]:AddCircleZone("Garbageman",InitWorkGarbageman,1.5,{
		name = "Garbageman",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "preset:garbageman",
				label = "Traje Lixeiro",
				tunnel = "server"
			},{
				event = "shops:Recycle",
				label = "Vender Materiais",
				tunnel = "client"
			}
		}
	})
end)
---------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:FISHERMAN
---------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	exports["target"]:AddCircleZone("Fisherman",InitWorkFisherman,1.5,{
		name = "Fisherman",
		heading = 3374176
	},{
		Distance = 1.0,
		options = {
			{
				event = "shops:Fishing2",
				label = "Comprar Acessórios",
				tunnel = "client"
			},{
                event = "preset:fisherman",
				label = "Traje Pescador",
				tunnel = "server"
            },{    
				event = "shops:Fishing",
				label = "Vender Peixes",
				tunnel = "client"
            }
		}
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    for _, AnimalsHash in pairs(AnimalsHunting) do
        exports["target"]:AddTargetModel({AnimalsHash}, {
            options = {
                {
                    event = "inventory:Animals",
                    label = "Esfolar",
                    tunnel = "client"
                }
            },
            Distance = 1.50
        })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	exports["target"]:AddCircleZone("Hunting", InitWorkHunting, 1.5, {
		name = "Hunting",
		heading = 3374176
	}, {
		Distance = 2.0,
		options = {
			{
				event = "shops:Hunting",
				label = "Comprar Ferramentas",
				tunnel = "client"
			},{
				event = "preset:hunting",
				label = "Traje Caçador",
				tunnel = "server"
			},{
				event = "shops:Hunting2",
				label = "Vender Carnes",
				tunnel = "client"
			}
		}
	})
end)