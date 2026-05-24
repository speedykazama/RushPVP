-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Residuals = nil
local ShotDelay = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSOAP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkSoap()
	return Residuals
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RESIDUALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Residuals")
AddEventHandler("player:Residuals",function(Informations)
	if Informations then
		if not Residuals then
			Residuals = {}
		end

		Residuals[Informations] = true
	else
		Residuals = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSHOT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if IsPedArmed(Ped,6) and GetGameTimer() >= ShotDelay then
				TimeDistance = 1

				if IsPedShooting(Ped) then
					ShotDelay = GetGameTimer() + 15000
					TriggerEvent("player:Residuals","Resíduo de Pólvora.")

					local Vehicle = false
					local Coords = GetEntityCoords(Ped)
					if not IsPedCurrentWeaponSilenced(Ped) then
						if (losSantos:isPointInside(Coords) or sandyShores:isPointInside(Coords) or paletoBay:isPointInside(Coords)) and not LocalPlayer["state"]["PMERJ"] and not LocalPlayer["state"]["PCERJ"] and not LocalPlayer["state"]["PRF"] and not LocalPlayer["state"]["BOPE"] and not LocalPlayer["state"]["RECOM"] and not LocalPlayer["state"]["BPCHQ"] and not LocalPlayer["state"]["EX"] then
							TriggerServerEvent("evidence:dropEvidence","blue")

							if IsPedInAnyVehicle(Ped) then
								Vehicle = true
							end

							vSERVER.shotsFired(Vehicle)
						end
					else
						if math.random(100) >= 80 then
							if (losSantos:isPointInside(Coords) or sandyShores:isPointInside(Coords) or paletoBay:isPointInside(Coords)) and not LocalPlayer["state"]["PMERJ"] and not LocalPlayer["state"]["PCERJ"] and not LocalPlayer["state"]["PRF"] and not LocalPlayer["state"]["BOPE"] and not LocalPlayer["state"]["RECOM"] and not LocalPlayer["state"]["BPCHQ"] and not LocalPlayer["state"]["EX"] then
								TriggerServerEvent("evidence:dropEvidence","blue")

								if IsPedInAnyVehicle(Ped) then
									Vehicle = true
								end

								vSERVER.shotsFired(Vehicle)
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)