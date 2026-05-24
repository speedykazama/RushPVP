fx_version "adamant"
game "gta5"

ui_page "web-side/index.html"

shared_scripts {
    "@vrp/lib/utils.lua",
    "config.lua"
}

client_scripts {
    "client-side/client.lua"
}

server_scripts {
    "server-side/server.lua"
}

files {
    "web-side/**/*.*"
}           