fx_version 'cerulean'
game 'gta5'

ui_page 'web-side/index.html'

client_scripts {
    '@vrp/lib/Utils.lua',
    'shared-side/*.lua',
    'client-side/*.lua'
}

server_scripts {
    '@vrp/lib/Utils.lua',
    'shared-side/*.lua',
    'server-side/*.lua'
}

files {
    'web-side/index.html',
    'web-side/style.css',
    'web-side/script.js'
}