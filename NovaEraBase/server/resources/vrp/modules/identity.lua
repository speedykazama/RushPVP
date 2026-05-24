-----------------------------------------------------------------------------------------------------------------------------------------
-- FALSEIDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.FalseIdentity(Passport)
    return vRP.Query("fidentity/Result",{ id = Passport })[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Identity(Passport)
    local source = vRP.Source(Passport)
    if Characters[source] then
        return Characters[source] or false
    else
        return vRP.Query("characters/Person",{ id = Passport })[1] or false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FULLNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.FullName(Passport)
	local source = vRP.Source(Passport)
	if Characters[source] then
		return Characters[source]["name"].." "..Characters[source]["name2"]
	else
		return "NIGHT NETWORK"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetWork(Passport)
	local source = vRP.Source(Passport)
	if Characters[source] then
		return Characters[source]["work"]
	else
		return "Nenhum"
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHANGEWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.ChangeWork(Passport, work)
	local source = vRP.Source(Passport)
	vRP.Query("characters/UpdateWork",{ work = work, Passport = Passport })

	if Characters[source] then
		Characters[source]["work"] = work

		if work == "Nenhum" then
			Player(source)["state"]["work"] = false
			TriggerClientEvent("Notify", source, "verde", "Você se demitiu do seu emprego atual.", 5000)
		else
			Player(source)["state"]["work"] = true
			TriggerClientEvent("Notify", source, "amarelo", "Você se registrou em um novo emprego. "..ClassWork(work), 5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVELIKES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveLikes(Passport,Amount)
	local source = vRP.Source(Passport)
	if parseInt(Amount) > 0 then
		vRP.Query("characters/AddLikes",{ Likes = parseInt(Amount), Passport = Passport })

		if Characters[source] then
			Characters[source]["likes"] = Characters[source]["likes"] + parseInt(Amount)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEUNLIKES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveUnLikes(Passport,Amount)
	local source = vRP.Source(Passport)
	if parseInt(Amount) > 0 then
		vRP.Query("characters/AddUnlikes",{ Unlikes = parseInt(Amount), Passport = Passport })

		if Characters[source] then
			Characters[source]["unlikes"] = Characters[source]["unlikes"] + parseInt(Amount)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETLIKES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetLikes(Passport)
	return vRP.Identity(Passport)["likes"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUNLIKES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetUnLikes(Passport)
	return vRP.Identity(Passport)["unlikes"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSTATS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetStats(Passport)
	return vRP.Identity(Passport)["likes"], vRP.Identity(Passport)["unlikes"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InitPrison(Passport, Amount)
    local source = vRP.Source(Passport)
    if parseInt(Amount) > 0 then
        vRP.Query("characters/InsertPrison", { Passport = Passport, prison = parseInt(Amount) })
        if Characters[source] then
            Characters[source]["prison"] = Characters[source]["prison"] + parseInt(Amount)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdatePrison(Passport,Amount)
    local source = vRP.Source(Passport)
    local ZerarPrison = 0
    if parseInt(Amount) > 0 then
        vRP.Query("characters/removePrison",{ Passport = Passport, prison = parseInt(Amount) })
        if Characters[source] then
            Characters[source]["prison"] = Characters[source]["prison"] - parseInt(Amount)
            if 0 >= Characters[source]["prison"] then
                Characters[source]["prison"] = 0
                vRP.Teleport(source,BackPrison["x"],BackPrison["y"],BackPrison["z"])
                TriggerClientEvent("Notify",source,"verde","Serviços finalizados.",5000)
                Player(source)["state"]["Prison"] = false
                vRP.Query("characters/setPrison",{ Passport = Passport, prison = parseInt(ZerarPrison) })
            else
                TriggerClientEvent("Notify", source,"azul","Restam <b>"..Characters[source]["prison"].." serviços</b>.",5000)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEGUNLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdateGunlicense(Passport, Status)
    local source = vRP.Source(Passport)
    vRP.Query("characters/UpdateGun", { Passport = Passport, gun = Status })
    if Characters[source] then
        Characters[source]["gun"] = Status
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADECHARS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeChars(source)
    if Characters[source] then
        vRP.Query("accounts/infosUpdatechars",{ license = Characters[source]["license"] })
        Characters[source]["chars"] = Characters[source]["chars"] + 1
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserGemstone(License)
    return vRP.Account(License)["gems"] or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeGemstone(Passport,Amount)
    local source = vRP.Source(Passport)
    local License = vRP.Identity(Passport)
    if parseInt(Amount) > 0 and License then
        vRP.Query("accounts/AddGems",{ license = License["license"], gems = parseInt(Amount) })
        if Characters[source] then
            TriggerClientEvent("hud:AddGems", source, (parseInt(Amount)))
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADENAMES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeNames(Passport,Name,Name2)
    local source = vRP.Source(Passport)
    vRP.Query("characters/updateName",{ Passport = Passport, name = Name, name2 = Name2 })
    if Characters[source] then
        Characters[source]["name2"] = Name2
        Characters[source]["name"] = Name
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradePhone(Passport,Phone)
    local source = vRP.Source(Passport)
    vRP.Query("characters/updatePhone",{ id = Passport, phone = Phone })
    if Characters[source] then
        Characters[source]["phone"] = Phone
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORTPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PassportPlate(Plate)
	return vRP.Query("vehicles/plateVehicles",{ plate = Plate })[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserPhone(Phone)
    return vRP.Query("characters/getPhone",{ phone = Phone })[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATESTRING
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateString(Format)
    local Number = ""
    for i = 1, #Format do
        if string.sub(Format, i,i) == "D" then
            Number = Number..string.char(string.byte("0") + math.random(0,9))
        elseif "L" == string.sub(Format,i,i) then
            Number = Number..string.char(string.byte("A") + math.random(0,25))
        else
            Number = Number..string.sub(Format,i,i)
        end
    end
    return Number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GeneratePlate()
    local Passport = nil
    local Serial = ""
    repeat
        Passport = vRP.PassportPlate((vRP.GenerateString("DDLLLDDD")))
        Serial = vRP.GenerateString("DDLLLDDD")
    until not Passport
    return Serial
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GeneratePhone()
    local Passport = nil
    local Phone = ""
    repeat
        Passport = vRP.UserPhone((vRP.GenerateString("DDD-DDD")))
        Phone = vRP.GenerateString("DDD-DDD")
    until not Passport
    return Phone
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETDRIVERLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GetDriverLicense(Passport)
    local source = vRP.Source(Passport)
    local Driverlicense = vRP.UserData(Passport, "Driverlicense")
    
    if Driverlicense then
        return Driverlicense
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDRIVERLICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdateDriverLicense(Passport, driver)
	local source = vRP.Source(Passport)
	vRP.Query("characters/UpdateDriver",{ driver = parseInt(driver), Passport = Passport })

	if Characters[source] then
		Characters[source]["driver"] = parseInt(driver)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "vrp" == Resource then
        Wait(3000)
    end
end)