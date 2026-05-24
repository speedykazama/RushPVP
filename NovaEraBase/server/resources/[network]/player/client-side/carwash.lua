-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local WashProgress = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCARWASH
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) and not WashProgress then
			local Coords = GetEntityCoords(Ped)
			local Vehicle = GetVehiclePedIsUsing(Ped)
			if GetPedInVehicleSeat(Vehicle,-1) == Ped then
				for _,v in pairs(Wash) do
					local Distance = #(Coords - vec3(v[1],v[2],v[3]))
					if Distance <= 2.5 then
						TimeDistance = 1

						if IsControlJustPressed(1,38) then
							WashProgress = true

							FreezeEntityPosition(Vehicle,true)

							UseParticleFxAssetNextCall("core")
							local Particle01 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v[1],v[2],v[3],0.0,0.0,0.0,1.0,false,false,false,false)

							UseParticleFxAssetNextCall("core")
							local Particle02 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",v[1] + 2.5,v[2],v[3],0.0,0.0,0.0,1.0,false,false,false,false)

							SetTimeout(15000,function()
								TriggerServerEvent("CleanVehicle",VehToNet(Vehicle))

								FreezeEntityPosition(Vehicle,false)
								StopParticleFxLooped(Particle01,0)
								StopParticleFxLooped(Particle02,0)
								WashProgress = false
							end)
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)