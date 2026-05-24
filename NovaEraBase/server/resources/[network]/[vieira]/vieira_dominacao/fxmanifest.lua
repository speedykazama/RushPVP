fx_version "cerulean"

description "Sistema de dominação"
version "1.0.0"
author "Vieira"
lua54 'yes'

games {
  "gta5"
}

dependency "vrp"
dependency "PolyZone"

ui_page 'web/build/index.html'

shared_scripts {
  "@vrp/lib/Utils.lua",
  "config-side/**/*.lua",
  "shared-side/**/*"
}

client_scripts {
  "@PolyZone/client.lua",
  "client-side/utils.lua",
  "client-side/poly_editor.lua",
  "client-side/zone_runtime.lua",
  "client-side/client.lua"
}

server_scripts {
  "server-side/database.lua",
  "server-side/domination_runtime.lua",
  "server-side/server.lua"
}

files {
	'web/build/index.html',
	'web/build/**/*',
}
