fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}

shared_scripts {
	"shared-side/*"
}

escrow_ignore {
	"shared-side/shared.lua"
}