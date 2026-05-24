-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Yoga = false
local YogaPoints = 0
local YogaTimer = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    for Number, v in pairs(YogaList) do
        exports["target"]:AddCircleZone("Yoga:"..Number, vec3(v[1], v[2], v[3]), 0.75, {
            name = "Yoga:"..Number,
        }, {
            shop = Number,
            Distance = 1.0,
            options = {
                {
                    event = "target:Yoga",
                    label = "Yoga",
                    tunnel = "client"
                }
            }
        })
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:YOGA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Yoga")
AddEventHandler("target:Yoga",function()
	if not Yoga then
		Yoga = true
		YogaPoints = 0
		TriggerEvent("Notify","amarelo","Yoga iniciado, para finalizar pressione <b>E</b>.",5000)

		while Yoga do
			if GetGameTimer() >= YogaTimer then
				YogaTimer = GetGameTimer() + 1000
				YogaPoints = YogaPoints + 1

				if YogaPoints >= 5 then
					TriggerServerEvent("target:Stress",1)
					YogaPoints = 0
				end
			end

			local Ped = PlayerPedId()
			if not IsEntityPlayingAnim(Ped,"amb@world_human_yoga@male@base","base_a",3) then
				vRP.playAnim(false,{"amb@world_human_yoga@male@base","base_a"},true)
			end

			if IsControlJustPressed(1,38) then
				vRP.Destroy()
				Yoga = false
				break
			end

			Wait(1)
		end
	end
end)