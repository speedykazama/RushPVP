fx_version "bodacious"
game "gta5"
lua54 "yes"
version "1.0"
author "NIGHT STORE"
creator "yes"

client_scripts {
	"config/*",
	"lib/Utils.lua",
	"client/*"
}

server_scripts {
	"config/*",
	"lib/Utils.lua",
	"modules/vrp.lua",
	"modules/base.lua",
	"modules/drugs.lua",
	"modules/groups.lua",
	"modules/identity.lua",
	"modules/inventory.lua",
	"modules/medic.lua",
	"modules/money.lua",
	"modules/party.lua",
	"modules/player.lua",
	"modules/premium.lua",
	"modules/prepare.lua",
	"modules/queue.lua",
	"modules/salary.lua",
	"modules/serial.lua"
}

files {
	"lib/*",
	"config/*",
	"config/**/*"
}