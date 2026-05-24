fx_version "bodacious"
game "gta5"
description "Mercadão"

ui_page_preload "yes"
ui_page "html/ui.html"

client_scripts {
  "@vrp/lib/utils.lua",
  "client-side/*",
  "config.lua",
}

server_scripts {
  "@vrp/config/Item.lua",
  "@vrp/lib/utils.lua",
  "server-side/*",
  "config.lua",
}

files {
  "html/ui.html",
  "html/*",
  "html/css/*",
  "html/js/*",  
  "html/js/plugins/*",  
}                                                                                                                     