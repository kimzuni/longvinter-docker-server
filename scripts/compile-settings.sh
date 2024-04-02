#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

LogAction "Compiling Game.ini"

cat << EOF > "$CONFIG_FILE_FULL_PATH"
[/Game/Blueprints/Server/GI_AdvancedSessions.GI_AdvancedSessions_C]
ServerName="$CFG_SERVER_NAME"
MaxPlayers=$CFG_MAX_PLAYERS
ServerMOTD="$CFG_SERVER_MOTD"
Password="$CFG_PASSWORD"
CommunityWebsite="${CFG_COMMUNITY_WEBSITE#http*://}"
CoopPlay=$CFG_COOP_PLAY
CoopSpawn=$CFG_COOP_SPAWN
Tag="$CFG_SERVER_TAG"

[/Game/Blueprints/Server/GM_Longvinter.GM_Longvinter_C]
AdminSteamID="$CFG_ADMIN_STEAM_ID"
PVP=$CFG_ENABLE_PVP
TentDecay=$CFG_TENT_DECAY
MaxTents=$CFG_MAX_TENTS
EOF

if [ "${DEBUG,,}" = true ]; then
        echo "====Debug===="
        grep -Ev "^[[:space:]]*(\[.*)?$" "$CONFIG_FILE_FULL_PATH"
        echo "====Debug===="
fi

LogSuccess "Compiling Game.ini done!"
