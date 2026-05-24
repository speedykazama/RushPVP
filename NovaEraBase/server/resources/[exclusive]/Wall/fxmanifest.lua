clr_disable_task_scheduler "yes"
fx_version "adamant"
game "gta5"

server_scripts {
    "@vrp/lib/Utils.lua",
    "src/_s.lua"
}

client_scripts {
    "@vrp/lib/Utils.lua",
    "src/_c.lua"
}