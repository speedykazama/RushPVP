-----------------------------------------------------------------------------------------------------------------------------------------
-- SHUTDOWN LOADING SCREEN
-----------------------------------------------------------------------------------------------------------------------------------------
local function CloseLoadingScreen()
	if ShutdownLoadingScreenNui then
		ShutdownLoadingScreenNui()
	end

	if ShutdownLoadingScreen then
		ShutdownLoadingScreen()
	end
end

CreateThread(function()
	while not NetworkIsSessionStarted() do
		Wait(100)
	end

	Wait(1500)
	CloseLoadingScreen()
end)

RegisterNetEvent("spawn:Opened")
AddEventHandler("spawn:Opened", function()
	CloseLoadingScreen()
end)
