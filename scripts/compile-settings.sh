#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

LogAction "Compiling Game.ini"

CFG_SERVER_REGION_FULL=${CFG_SERVER_REGION:+"ServerRegion=$CFG_SERVER_REGION"}
CFG_RESTART_TIME_24H_FULL=${CFG_RESTART_TIME_24H:+"RestartTime24h=$CFG_RESTART_TIME_24H"}

cat << EOF > "$CONFIG_FILE_FULL_PATH"
[/Game/Blueprints/Server/GI_AdvancedSessions.GI_AdvancedSessions_C]
ServerName="$CFG_SERVER_NAME"
ServerMOTD="$CFG_SERVER_MOTD"
MaxPlayers=$CFG_MAX_PLAYERS
Password="$CFG_PASSWORD"
CommunityWebsite="${CFG_COMMUNITY_WEBSITE#http*://}"
Tag="$CFG_SERVER_TAG"
CoopPlay=$CFG_COOP_PLAY
CoopSpawn=$CFG_COOP_SPAWN
CheckVPN=$CFG_CHECK_VPN
ChestRespawnTime=$CFG_CHEST_RESPAWN_TIME
DisableWanderingTraders=$CFG_DISABLE_WANDERING_TRADERS
$CFG_SERVER_REGION_FULL

[/Game/Blueprints/Server/GM_Longvinter.GM_Longvinter_C]
AdminSteamID="$CFG_ADMIN_STEAM_ID"
PVP=$CFG_ENABLE_PVP
TentDecay=$CFG_TENT_DECAY
MaxTents=$CFG_MAX_TENTS
$CFG_RESTART_TIME_24H_FULL
SaveBackups=$CFG_SAVE_BACKUPS
Hardcore=$CFG_HARDCORE
MoneyDropMultiplier=$CFG_MONEY_DROP_MULTIPLIER
WeaponDamageMultiplier=$CFG_WEAPON_DAMAGE_MULTIPLIER
EnergyDrainMultiplier=$CFG_ENERGY_DRAIN_MULTIPLIER
PriceFluctuationMultiplier=$CFG_PRICE_FLUCTUATION_MULTIPLIER
EOF

if [ "${DEBUG,,}" = true ]; then
        echo "====Debug===="
        grep -Ev "^[[:space:]]*(\[.*)?$" "$CONFIG_FILE_FULL_PATH"
        echo "====Debug===="
fi

LogSuccess "Compiling Game.ini done!"
