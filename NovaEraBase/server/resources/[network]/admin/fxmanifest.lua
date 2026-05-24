fx_version "bodacious"
game "gta5"
lua54 "yes"

client_scripts {
    "@vrp/config/Native.lua",
    "@vrp/config/Global.lua",
    "@vrp/lib/Utils.lua",
    "client-side/core.lua"
}

server_scripts {
    "@vrp/config/Global.lua",
    "@vrp/config/Item.lua",
    "@vrp/lib/Utils.lua",
    "server-side/*"
}