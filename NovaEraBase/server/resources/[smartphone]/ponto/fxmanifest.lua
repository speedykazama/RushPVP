fx_version 'adamant'
game 'gta5'

files {
  '**/**/*'
}

client_scripts {
	"@vrp/lib/utils.lua",
  'client/cl_core.lua',
}

server_scripts {
	"@vrp/lib/utils.lua",
  'shared/shared.lua',
  'server/sv_core.lua'
}              