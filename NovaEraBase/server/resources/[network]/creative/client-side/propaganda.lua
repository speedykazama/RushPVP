-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPAGANDA ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
if ClothesAdEnabled then
	CreateThread(function()
		while true do
			Wait((ClothesAdSeconds or 1800) * 1000)

			if LocalPlayer["state"]["Active"] then
				TriggerEvent("Notify", "dica", ClothesAdMessage, 10000, ClothesAdTitle or "Roupas")
			end
		end
	end)
end
