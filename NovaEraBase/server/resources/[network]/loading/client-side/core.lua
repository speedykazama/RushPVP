-----------------------------------------------------------------------------------------------------------------------------------------
-- SHUTDOWN LOADING SCREEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(100)
	end

	Wait(500)

	ShutdownLoadingScreenNui()
	ShutdownLoadingScreen()
end)

RegisterNetEvent("spawn:Opened")
AddEventHandler("spawn:Opened", function()
	ShutdownLoadingScreenNui()
	ShutdownLoadingScreen()
end)
