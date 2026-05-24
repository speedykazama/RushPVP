-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local FinalPrice = 0
local HasCaught = false
local ExtraPrice = true
local EnableBlips = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSPEEDCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999

		local function CheckSpeedArea(Areas, MaxSpeed, DefaultPrice)
			for _, area in ipairs(Areas) do
				local playerCoords = GetEntityCoords(PlayerPedId(), false)
				local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, area.X, area.Y, area.Z)

				if distance <= 22 then
					local Ped = PlayerPedId()
					local Vehicle = GetVehiclePedIsIn(Ped, false)
					local VehiclePlate = GetVehicleNumberPlateText(Vehicle)
					local Speed = GetEntitySpeed(Ped) * 3.6

					if Speed > MaxSpeed and IsPedInAnyVehicle(Ped, false) and GetPedInVehicleSeat(Vehicle, -1) == Ped then
						if not HasCaught then
							local FinalPrice = DefaultPrice
							if ExtraPrice then
								if Speed >= MaxSpeed + 30 then
									FinalPrice = DefaultPrice + ExtraPrice30
								elseif Speed >= MaxSpeed + 20 then
									FinalPrice = DefaultPrice + ExtraPrice20
								elseif Speed >= MaxSpeed + 10 then
									FinalPrice = DefaultPrice + ExtraPrice10
								end
							end

							vSERVER.SpeedCameraFines(FinalPrice, Speed, GetEntityArchetypeName(Vehicle), VehiclePlate)
							HasCaught = true

							CreateThread(function()
								Wait(15000)
								HasCaught = false
							end)
						end
					end
				end
			end
		end

		CheckSpeedArea(Areas60, 60, DefaultPrice60)
		CheckSpeedArea(Areas80, 80, DefaultPrice80)
		CheckSpeedArea(Areas120, 120, DefaultPrice120)

		Wait(TimeDistance)
	end
end)