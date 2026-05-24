-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Discords = {
	-- Default
	["Connect"] = "",
	["Disconnect"] = "",
	["Airport"] = "",
	["Deaths"] = "",
	-- Garages
	["GaragesVenda"] = "",
	["GaragesCar"] = "",
	["GaragesDv"] = "",
	-- Propertys
	["Bau-Casas"] = "",
	["Bau-Hotel"] = "",
	-- Chest
    ["Chest-Paramedic"] = "",
    ["Chest-Mechanic"] = "",
    ["Chest-Mechanic2"] = "",
    ["Chest-Policia"] = "",
    ["Chest-Barragem"] = "",
    ["Chest-Cachoeira"] = "",
    ["Chest-Capoeira"] = "",
    ["Chest-FortZancudo"] = "",
    ["Chest-MonteChiliad"] = "",
    ["Chest-Origami"] = "",
    ["Chest-Observatorio"] = "",
    ["Chest-Paleto"] = "",
    ["Chest-Ponte"] = "",
    ["Chest-Sapo"] = "",
    ["Chest-Franca"] = "",
    ["Chest-Igreja"] = "",
    ["Chest-AnjosBeach"] = "",
    ["Chest-Hornys"] = "",
	-- Robberys
	["RobberysBanks"] = "",
	["RobberysBarbershop"] = "",
	["RobberysWeaponshop"] = "",
	["RobberysFleecashop"] = "",
	["RobberysDepartmentshop"] = "",
	["RobberysRegisters"] = "",
	["RobberysC4"] = "",
	-- Notify
	["Aviso-policia"] = "",
	["Aviso-paramedic"] = "",
	["Aviso-mecanica"] = "",
	["Aviso-admin"] = "",
	-- Inventory
	["InventoryDrops"] = "",
	["InventoryPegou"] = "",
	["InventoryEnviou"] = "",
	["InventoryLixo"] = "",
	-- Inspect
	["RevistaPolicial"] = "",
	["RevistaJogadores"] = "",
	["Saquear"] = "",
	-- Crafting
	["Craftou"] = "",
	-- Luckywheel
	["Cassino"] = "",
	-- Pause
	["LojaPause"] = "",
	["LojaBoxesPause"] = "",
	["WonBoxesPauseStore"] = "",
	["ReedemItemRolepass"] = "",
	["BuyRolepass"] = "",
	-- Painel
	["Convite"] = "",
	["Demitido"] = "",
	["Promovido"] = "",
	["PainelDeposito"] = "",
	["PainelSaque"] = "",
	["Blacklist"] = "",
	-- Bank
	["BankDeposito"] = "",
	["BankSaque"] = "",
	-- PDM
	["BuyRentalVehicle"] = "",
	["BuyVehicle"] = "",
	-- Shops
	["LojaPolicia"] = "",
	["LojaVip"] = "",
	["LojasGerais"] = "",
	["LojasVendas"] = "",
	-- Trunkchest
	["Trunkchest"] = "",
	-- Helicrash
	["Helicrash"] = "",
	-- Police
	["Prender"] = "",
	["Multar"] = "",
	["Procurados"] = "",
	["Portes"] = "",
	["Boletins"] = "",
	-- Admin
	["Tpto"] = "",
	["Tptome"] = "",
	["Tpway"] = "",
	["Tpcds"] = "",
	["cds"] = "",
	["Spectate"] = "",
	["Fix"] = "",
	["Blips"] = "",
	["God"] = "",
	["Kill"] = "",
	["Ban"] = "",
	["Unban"] = "",
	["Kick"] = "",
	["KickAll"] = "",
	["Item"] = "",
	["Itemall"] = "",
	["Item2"] = "",
	["Group"] = "",
	["Ungroup"] = "",
	["Clearchest"] = "",
	["Clearinv"] = "",
	["Gemstone"] = "",
	["SetBank"] = "",
	["RemoveBank"] = "",
	["Addcar"] = "",
	["Remcar"] = "",
	["DeleteAll"] = "",
	["LimparArea"] = "",
	["Mundo"] = "",
	["Addback"] = "",
	["Remback"] = "",
	["Algemar"] = "",
	["wl"] = "",
	["unwl"] = "",
	["Noclip"] = "",
	["Tuning"] = "",
	-- Extras
	["Wall"] = ""
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Discord",function(Hook,Message,Color)
	PerformHttpRequest(Discords[Hook],function(err,text,headers) end,"POST",json.encode({
		username = ServerName,
		embeds = { { color = Color, description = Message } }
	}),{ ["Content-Type"] = "application/json" })
end)