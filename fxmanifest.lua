-- Resource Metadata
fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'JHN'
description 'FiveM ESX Scrap Job'
version '1.0.0'
shared_scripts {
	'locales/*.lua'
}
-- What to run
client_scripts {
    'config.lua',
    'locales/*.lua',
    'client.lua'
}
server_scripts {
    'server.lua', 
    'locales/*.lua',
    'config.lua'
}
shared_script '@es_extended/imports.lua'