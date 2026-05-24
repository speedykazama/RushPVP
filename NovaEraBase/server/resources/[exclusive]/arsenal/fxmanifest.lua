
fx_version 'bodacious'
game 'gta5'

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/Utils.lua",
	"shared/config.lua",
	"client-side/*"
} 

server_script {
	"@vrp/config/Item.lua",
	"@vrp/lib/Utils.lua",
	"shared/config.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}