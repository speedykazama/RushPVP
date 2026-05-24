fx_version "bodacious"
game "gta5"
author "GABEZ"
description "Refeito por Gabez!"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*",
	"cfg/*"
}

server_scripts {
	"@vrp/config/Native.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/lib/Utils.lua",
	"server-side/*",
	"cfg/*"
}

files {
	"web-side/*",
	"web-side/imgs/*",
	"web-side/sounds/*"
}