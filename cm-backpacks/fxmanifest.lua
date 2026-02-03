fx_version 'cerulean'
game 'gta5'

name 'cm-backpacks'
description 'backpack system with modular inventory support for QBCore/QBox/ESX'
version '1.0.0'
author 'Copeman'
repository ''

lua54 'yes'

shared_scripts {
    'config.lua',
    'shared/*.lua'
}

client_scripts {
    'bridge/client.lua',
    'client/main.lua',
    'client/inventory_compat.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/inventories/*.lua',  
    'bridge/server.lua',         
    'server/database.lua',
    'server/main.lua'
}

dependencies {
    'oxmysql'
}
