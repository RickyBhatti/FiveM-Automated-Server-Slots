fx_version "cerulean"
game "gta5"

name "Automated Server Slots"
description "Automatically adjust the server slots based on the player count."
author "ricky"
version "1.0.1"

lua54 "yes"
server_only "yes"

server_script {
    "sv_config.lua",
    "sv_main.lua"
}