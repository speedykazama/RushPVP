-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Objects = {}
local Active = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if Active and Components[Active] then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			if #(Coords - Components[Active]["1"][1]["xyz"]) <= 3000 then
				TimeDistance = 1

				if #(Coords - Components[Active]["1"][1]["xyz"]) <= 300 then
					if DrawMarkerHelicrash then
						local Crashed = Components[Active]["1"][1]["xyz"]
						DrawMarker(28, Crashed.x, Crashed.y, Crashed.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 150.0, 150.0, 1000.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)	
					end			
				end

				for Number, v in pairs(Components[Active]) do
					if not Objects[Number] and LoadModel(v[2]) then
						Objects[Number] = CreateObjectNoOffset(v[2], v[1]["xyz"], false, false, false)
						SetEntityHeading(Objects[Number], v[1]["w"])
						SetEntityLodDist(Objects[Number], 0xFFFF)
						FreezeEntityPosition(Objects[Number], true)
						PlaceObjectOnGroundProperly(Objects[Number])

						if Number ~= "1" then
							exports["target"]:AddBoxZone("Helicrash:" .. Number, v[1]["xyz"], 1.25, 2.0, {
								name = "Helicrash:" .. Number,
								heading = v[1]["w"],
								minZ = v[1]["z"] - 1.00,
								maxZ = v[1]["z"] + 0.75
							}, {
								shop = "Helicrash:" .. Number,
								Distance = 2.0,
								options = {
									{
										event = "chest:Open",
										label = "Abrir",
										tunnel = "shop",
										service = "Custom"
									}
								}
							})
						end
					end
				end
			else
				if Objects["1"] then
					for Number, v in pairs(Objects) do
						if Number ~= "1" then
							exports["target"]:RemCircleZone("Helicrash:" .. Number)
						end

						if DoesEntityExist(Objects[Number]) then
							DeleteEntity(Objects[Number])
						end

						Objects[Number] = nil
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Helicrash",nil,function(Name,Key,Value)
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end

	Active = Value

	if not Value then
		if Objects["1"] then
			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) <= 100 then
				exports["survival"]:Revive(110)
			end

			TriggerEvent("Notify","azul","Todos os suprimentos foram saqueados.",30000)

			for Number,_ in pairs(Objects) do
				if Number ~= "1" then
					exports["target"]:RemCircleZone("Helicrash:"..Number)
				end

				if DoesEntityExist(Objects[Number]) then
					DeleteEntity(Objects[Number])
				end

				Objects[Number] = nil
			end
		end
	else
		HeliBlip(Active)

		if Objects["1"] then
			for Number,v in pairs(Objects) do
				if Number ~= "1" then
					exports["target"]:RemCircleZone("Helicrash:"..Number)
				end

				if DoesEntityExist(Objects[Number]) then
					DeleteEntity(Objects[Number])
				end

				Objects[Number] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if GlobalState["Helicrash"] then
		Active = GlobalState["Helicrash"]
		HeliBlip(Active)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HELIBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function HeliBlip(Number)
	-- if Components[Number] then
	-- 	Blip = AddBlipForCoord(Components[Number]["1"][1]["x"],Components[Number]["1"][1]["y"],Components[Number]["1"][1]["z"])
	-- 	SetBlipSprite(Blip,43)
	-- 	SetBlipDisplay(Blip,4)
	-- 	SetBlipAsShortRange(Blip,true)
	-- 	SetBlipColour(Blip,5)
	-- 	SetBlipScale(Blip,0.8)
	-- 	BeginTextCommandSetBlipName("STRING")
	-- 	AddTextComponentString("Helicrash")
	-- 	EndTextCommandSetBlipName(Blip)
	-- end
end