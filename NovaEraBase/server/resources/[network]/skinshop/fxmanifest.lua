fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

shared_script {
	"@vrp/config/Global.lua",
	"shared-side/*"
}

client_scripts {
	"@vrp/config/Global.lua",
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/config/Global.lua",
	"@vrp/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}              