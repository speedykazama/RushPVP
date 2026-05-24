fx_version "bodacious"
game "gta5"
lua54 "yes"

dependency "party"

shared_scripts {
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"shared-side/*"
}

server_scripts {
	"@vrp/lib/Utils.lua",
	"server-side/core.lua"
}

client_scripts {
	"@PolyZone/client.lua",
	"@vrp/lib/Utils.lua",
	"client-side/core.lua"
}
