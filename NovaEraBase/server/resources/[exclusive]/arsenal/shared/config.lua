-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
config = {}
config.itemNameList = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG.ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
config.itemsArsenal = {
	["armas de fogo"] = {
		{ item = "WEAPON_GLOCK21", quantidade = 1, compra = 1500, descricao = "GLOCK 21.", img = "glock21" },
		{ item = "WEAPON_CARBINERIFLE", quantidade = 1, compra = 1275, descricao = "M4A1.", img = "m4a1" },
		{ item = "WEAPON_CARBINERIFLE_MK2", quantidade = 1, compra = 2450, descricao = "M4A4.", img = "m4a4" },
		{ item = "WEAPON_BULLPUPRIFLE", quantidade = 1, compra = 1475, descricao = "QBZ-95.", img = "qbz95" },
		{ item = "WEAPON_SMG", quantidade = 1, compra = 1200, descricao = "Heckler & Koch MP5.", img = "mp5" },
		{ item = "WEAPON_SMG_MK2", quantidade = 1, compra = 1200, descricao = "Heckler & Koch MP5.", img = "evo3" },
		{ item = "WEAPON_COMBATPISTOL", quantidade = 1, compra = 975, descricao = "Pistola de Combate.", img = "glock" },
		{ item = "WEAPON_HEAVYPISTOL", quantidade = 1, compra = 1550, descricao = "Pistola Pesada.", img = "atifx45" },
		{ item = "WEAPON_APPISTOL", quantidade = 1, compra = 1200, descricao = "Koch Vp9.", img = "kochvp9" },
		{ item = "WEAPON_PARAFAL", quantidade = 1, compra = 1775, descricao = "PARA-FAL M964A1.", img = "parafal" },
		{ item = "WEAPON_COLTXM177", quantidade = 1, compra = 1375, descricao = "Colt XM177.", img = "coltxm177" },
		{ item = "WEAPON_TACTICALRIFLE", quantidade = 1, compra = 1250, descricao = "M16.", img = "m16" },
		{ item = "WEAPON_HEAVYRIFLE", quantidade = 1, compra = 1950, descricao = "Scar-H.", img = "scarh" },
		{ item = "WEAPON_PUMPSHOTGUN", quantidade = 1, compra = 1875, descricao = "Mossberg 590.", img = "mossberg590" }
	},
	["munições"] = {
		{ item = "WEAPON_PISTOL_AMMO", quantidade = 250, compra = 1500, descricao = "250x Munição.", img = "pistolammo" },
		{ item = "WEAPON_POLICE_AMMO", quantidade = 250, compra = 1500, descricao = "250x Munição.", img = "policeammo" }
	},
	["utilitários"] = {
		{ item = "vest", quantidade = 1, compra = 250, descricao = "Proteção Tática.", img = "vest" },
		{ item = "gsrkit", quantidade = 1, compra = 35, descricao = "Kit Residual.", img = "gsrkit" },
		{ item = "gdtkit", quantidade = 1, compra = 35, descricao = "Kit Químico.", img = "gdtkit" },
		{ item = "barrier", quantidade = 1, compra = 125, descricao = "Barreira Tática.", img = "barrier" },
		{ item = "handcuff", quantidade = 1, compra = 200, descricao = "Algemas de Ferro.", img = "handcuff" },
		{ item = "scuba", quantidade = 1, compra = 480, descricao = "Roupa de Mergulho.", img = "scuba" },
		{ item = "tabletserial", quantidade = 1, compra = 500, descricao = "Tablet Policial.", img = "tabletserial" },
		{ item = "attachsFlashlight", quantidade = 1, compra = 275, descricao = "Lanterna Tática.", img = "attachsFlashlight" },
		{ item = "attachsCrosshair", quantidade = 1, compra = 275, descricao = "Mira Holográfica.", img = "attachsCrosshair" },
		{ item = "attachsSilencer", quantidade = 1, compra = 275, descricao = "Silenciador Tático.", img = "attachsSilencer" },
		{ item = "attachsMagazine", quantidade = 1, compra = 275, descricao = "Pente Estendido.", img = "attachsMagazine" },
		{ item = "attachsGrip", quantidade = 1, compra = 275, descricao = "Empunhadura Tática.", img = "attachsGrip" },
		{ item = "attachsMuzzleFat", quantidade = 1, compra = 275, descricao = "Compensador Pesado.", img = "attachsMuzzleFat" },
		{ item = "attachsBarrel", quantidade = 1, compra = 275, descricao = "Cano Pesado.", img = "attachsBarrel" },
		{ item = "attachsMuzzleHeavy", quantidade = 1, compra = 275, descricao = "Compensador Tático.", img = "attachsMuzzleHeavy" },
		{ item = "WEAPON_STUNGUN", quantidade = 1, compra = 250, descricao = "Tazer.", img = "stungun" },
		{ item = "WEAPON_NIGHTSTICK", quantidade = 1, compra = 250, descricao = "Cassetete.", img = "nightstick" },
		{ item = "WEAPON_FLASHLIGHT", quantidade = 1, compra = 750, descricao = "Lanterna Tática.", img = "flashlight" },
		{ item = "WEAPON_SMOKEGRENADE", quantidade = 1, compra = 475, descricao = "Granada de Fumaça.", img = "smokegrenade" },
		{ item = "radio", quantidade = 1, compra = 875, descricao = "Rádio.", img = "radio" },
		{ item = "spike", quantidade = 1, compra = 875, descricao = "Spike.", img = "spike" },
		{ item = "backpack", quantidade = 1, compra = 875, descricao = "Mochila.", img = "backpack" }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETITEMNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function getItemName(item)
	if config.itemNameList then
		return vRP.itemNameList(item)
	end
	return vRP.getItemName(item)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPAIRS
-----------------------------------------------------------------------------------------------------------------------------------------
for k in pairs(config.itemsArsenal) do
	for i in ipairs(config.itemsArsenal[k]) do
		config.itemsArsenal[k][i].name = getItemName(config.itemsArsenal[k][i].item)
	end
end