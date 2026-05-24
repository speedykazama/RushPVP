fx_version "bodacious"
game "gta5"

ui_page "web-side/index.html"

shared_script {
	"@vrp/config/Native.lua",
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"shared-side/*.lua"
}

client_script {
	"@vrp/config/Native.lua",
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"shared-side/*.lua",
	"client-side/*.lua"
}

server_scripts{ 
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"@vrp/config/Item.lua",
	"@vrp/config/Vehicle.lua",
	"shared-side/*.lua",
	"server-side/*.lua"
}

files {
	"web-side/*",
	"web-side/**",
	"web-side/**/*"
}              