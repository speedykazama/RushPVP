-----------------------------------------------------------------------------------------------------------------------------------------
-- SETMEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SetMedicPlan(Passport,medicplan)
	local Source = vRP.Source(Passport)
	if Characters[Source] then
		Characters[Source]["medicplan"] = medicplan
	end
    exports["oxmysql"]:executeSync("UPDATE characters SET medicplan = :medicplan WHERE id = :Passport", { Passport = Passport, medicplan = medicplan })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERMEDICPLAN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserMedicPlan(Passport)
	local Source = vRP.Source(Passport)
	if Characters[Source] then
		if Characters[Source]["medicplan"] >= os.time() then
			return true
		end
	else
		local Identity = vRP.Query("characters/Person",{ id = Passport })
		if Identity[1] then
            if Identity[1]["medicplan"] >= os.time() then
                return true
            end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "vrp" == Resource then
        Wait(3000)
    end
end)