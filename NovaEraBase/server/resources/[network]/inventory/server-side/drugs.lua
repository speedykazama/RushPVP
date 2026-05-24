-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckDrugs()
	local source = source
	local Passport = vRP.Passport(source)

	for _, group in ipairs(NoSellingDrugs) do
		if vRP.HasGroup(Passport, group) then
			TriggerClientEvent("Notify", source, "vermelho", "Você não pode fazer essa ação.", 5000)
			return false
		end
	end

	if Passport then
		for k,v in pairs(DrugsList) do
			local Amount = math.random(v["Amount"]["Min"],v["Amount"]["Max"])
			local Price = math.random(v["Price"]["Min"],v["Price"]["Max"])

			local Consult = vRP.InventoryItemAmount(Passport,k)
			if Consult[1] >= Amount then
				Drugs[Passport] = { Consult[2],Amount,Price * Amount }
				return true
			end
		end
	end

	TriggerClientEvent("Notify",source,"vermelho","Você não possui drogas suficiente.",10000)
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTDRUGS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PaymentDrugs()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and Drugs[Passport] and vRP.TakeItem(Passport,Drugs[Passport][1],Drugs[Passport][2],true) then
		Active[Passport] = true

		local Valuation = Drugs[Passport][3]
		if Buffs["Dexterity"][Passport] and Buffs["Dexterity"][Passport] > os.time() then
			Valuation = Valuation + (Valuation * 0.1)
		end

		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		for k,v in pairs(DrugsInfluences) do
			local Distance = #(Coords - vec3(v[1],v[2],v[3]))
			if Distance <= v[4] then
				Valuation = Valuation + (Valuation * DrugsInfluencesBonus)
			end
		end

		TriggerClientEvent("player:Residuals",source,"Resíduo Orgânico.")
		vRP.GenerateItem(Passport,DrugsItem,Valuation,true)

		if math.random(100) >= 20 then
			TriggerEvent("Wanted",source,Passport,60)

			local Coords = vRP.GetEntityCoords(source)
			local Service = vRP.NumPermission(DrugsPermission)
			for Passports,Sources in pairs(Service) do
				async(function()
					TriggerClientEvent("sounds:source",Sources,"crime",0.25)
					TriggerClientEvent("NotifyPush",Sources,{ code = 20, title = "Venda de Drogas", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Ligação Anônima", color = 2 })
				end)
			end
		end

		Active[Passport] = nil
		Drugs[Passport] = nil
	end
end