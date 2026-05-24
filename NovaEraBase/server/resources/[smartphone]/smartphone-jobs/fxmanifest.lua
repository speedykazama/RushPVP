fx_version 'adamant'
game 'gta5'

shared_script {
  '@vrp/lib/Utils.lua',
  '@vrp/config/Global.lua'
}

server_scripts {
  'server-side/*'
}

client_scripts {
  'client-side/*'
}

files {
  'web-side/**/*',
  'config.json'
}