fx_version 'bodacious'
game 'gta5'

ui_page 'web/build/index.html'

shared_scripts {
    '@vrp/lib/utils.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
    'server.lua'
}

files {
    'web/build/index.html',
    'web/build/**/*'
}   