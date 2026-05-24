fx_version 'cerulean'
games { 'gta5', 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'CentralCart'
version '3.0.0'

ui_page 'https://centralcart-cfx.pages.dev/'

client_script 'src/loader-client.js'
server_script { 
  'src/loader.js',
  'extensions/**',
}