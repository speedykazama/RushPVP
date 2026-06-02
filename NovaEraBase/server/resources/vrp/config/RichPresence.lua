-----------------------------------------------------------------------------------------------------------------------------------------
-- vRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
	LocalPlayer["state"]:set("Name",Name,true)
	LocalPlayer["state"]:set("Active",true,true)
	LocalPlayer["state"]:set("Invincible",true,true)
	LocalPlayer["state"]:set("Passport",Passport,true)
	SetDiscordAppId(1511474162957291561)
	SetDiscordRichPresenceAsset("logorush")
	SetRichPresence("#"..Passport.." "..Name)
	SetDiscordRichPresenceAssetSmall("logorush")
	SetDiscordRichPresenceAssetText("Rush PVP")
	SetDiscordRichPresenceAssetSmallText("Rush PVP")
	SetDiscordRichPresenceAction(0,"Entrar na Cidade","https://discord.gg/RXTAF5dVkT")
	SetDiscordRichPresenceAction(1,"Nosso Discord","https://discord.gg/RXTAF5dVkT")

	local Pid = PlayerId()
	local Ped = PlayerPedId()

	ReloadCharacter(Pid,Ped)
	SetEntityInvincible(Ped,true)
	FreezeEntityPosition(Ped,false)
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(Ped,true,false)

	SetTimeout(10000,function()
		SetEntityInvincible(Ped,false)
		LocalPlayer["state"]:set("Invincible",false,false)
	end)
end)