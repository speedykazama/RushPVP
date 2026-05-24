fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

shared_scripts {
	"@vrp/config/Vehicle.lua",
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"shared-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}