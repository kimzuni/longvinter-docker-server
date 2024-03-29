#!/usr/bin/env bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

LogAction "Compiling Game.ini"

# Creating the Game.ini file line for line.
# Note that the line directly below this one overwrites the file and its contents (using a single > instead of >>).
echo "[/Game/Blueprints/Server/GI_AdvancedSessions.GI_AdvancedSessions_C]" > $CONFIG_FILE_FULL_PATH
echo "ServerName=\"$CFG_SERVER_NAME\"" >> $CONFIG_FILE_FULL_PATH
echo "MaxPlayers=$CFG_MAX_PLAYERS" >> $CONFIG_FILE_FULL_PATH
echo "ServerMOTD=\"$CFG_SERVER_MOTD\"" >> $CONFIG_FILE_FULL_PATH
echo "Password=\"$CFG_PASSWORD\"" >> $CONFIG_FILE_FULL_PATH
echo "CommunityWebsite=${CFG_COMMUNITY_WEBSITE#http*://}" >> $CONFIG_FILE_FULL_PATH
echo "CoopPlay=$CFG_COOP_PLAY" >> $CONFIG_FILE_FULL_PATH
echo "CoopSpawn=$CFG_COOP_SPAWN" >> $CONFIG_FILE_FULL_PATH
echo "Tag=\"$CFG_SERVER_TAG\"" >> $CONFIG_FILE_FULL_PATH
echo "[/Game/Blueprints/Server/GM_Longvinter.GM_Longvinter_C]" >> $CONFIG_FILE_FULL_PATH
echo "AdminSteamID=$CFG_ADMIN_STEAM_ID" >> $CONFIG_FILE_FULL_PATH
echo "PVP=$CFG_ENABLE_PVP" >> $CONFIG_FILE_FULL_PATH
echo "TentDecay=$CFG_TENT_DECAY" >> $CONFIG_FILE_FULL_PATH
echo "MaxTents=$CFG_MAX_TENTS" >> $CONFIG_FILE_FULL_PATH

if [ "${DEBUG,,}" = true ]; then
        echo "====Debug===="
        cat $CONFIG_FILE_FULL_PATH | egrep -v "^[[:space:]]*(\[.*)?$"
        echo "====Debug===="
fi

LogSuccess "Compiling Game.ini done!"
