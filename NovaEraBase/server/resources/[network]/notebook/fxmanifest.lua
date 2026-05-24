fx_version "bodacious"
game "gta5"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"shared-side/*",
	"client-side/*",
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"shared-side/*",
	"server-side/*"
}

files {
    "web-side/*",
    "web-side/**/*",
    "web-side/**/**/*"
}              