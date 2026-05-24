fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/dist/index.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"config.lua",
	"server-side/*"
}

files {
	"web-side/dist/*",
	"web-side/dist/**/*"
}