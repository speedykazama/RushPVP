fx_version "bodacious"
game "gta5"
lua54 "yes"

server_scripts {
	"@vrp/config/Item.lua",
	"@vrp/config/Vehicle.lua",
	"@vrp/lib/Utils.lua",
	"server-side/*"
}   

client_scripts {
	"@vrp/config/Global.lua",
	"@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
	"client-side/*"
}

files {
	'plates/**/*'
}