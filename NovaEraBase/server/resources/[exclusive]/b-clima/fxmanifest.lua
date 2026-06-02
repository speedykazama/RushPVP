fx_version 'cerulean'
game 'gta5'

ui_page 'web-side/index.html'

files {
    'web-side/index.html',
    'web-side/style.css',
    'web-side/script.js',
    'web-side/nui/*',
    'web-side/fonts/*.ttf'
}

client_scripts {
	"client-side/client.lua"
}

server_scripts {
    "@vrp/config/Global.lua",
    "@vrp/config/Native.lua",
	"@vrp/lib/Utils.lua",
    "server-side/server.lua"
}