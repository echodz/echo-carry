fx_version 'cerulean' -- Change this if you're using another version
game 'gta5'

author 'echo'
description 'Carry Script '
version '1.0.0'

-- Server scripts
server_script 'server.lua'

-- Client scripts
client_scripts {
    'config.lua',  -- Include config first
    'client.lua'   -- Then the client script
}

-- Optional: You can also add other necessary dependencies
dependencies {
    'qb-core',           -- Example, adjust according to your framework
    'qb-menu'            -- If using qb-menu
}