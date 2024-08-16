#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

config_file="$CONFIG_FILE_FULL_PATH"
config_dir=$(dirname "$config_file")

mkdir -p "$config_dir" || exit
# If file exists then check if it is writable
if [ -f "$config_file" ]; then
	if ! isWritable "$config_file"; then
		LogError "Unable to create $config_file"
		exit 1
	fi
# If file does not exist then check if the directory is writable
elif ! isWritable "$config_dir"; then
	# Exiting since the file does not exist and the directory is not writable.
	LogError "Unable to create $config_file"
	exit 1
fi

LogAction "Compiling Game.ini"

CFG_SERVER_REGION_FULL=${CFG_SERVER_REGION:+"ServerRegion=$CFG_SERVER_REGION"}

cat << EOF | grep -Ev ^"[[:space:]]?+"$ | sed "2,\$s/^\[/\n\[/g" > "$config_file"
[/Game/Blueprints/Server/GI_AdvancedSessions.GI_AdvancedSessions_C]
ServerName="$CFG_SERVER_NAME"
ServerMOTD="$CFG_SERVER_MOTD"
MaxPlayers=$CFG_MAX_PLAYERS
Password="$CFG_PASSWORD"
CommunityWebsite="${CFG_COMMUNITY_WEBSITE#http*://}"
Tag="$CFG_TAG"
CoopPlay=$CFG_COOP_PLAY
CoopSpawn=$CFG_COOP_SPAWN
CheckVPN=$CFG_CHECK_VPN
ChestRespawnTime=$CFG_CHEST_RESPAWN_TIME
DisableWanderingTraders=$CFG_DISABLE_WANDERING_TRADERS
$CFG_SERVER_REGION_FULL

[/Game/Blueprints/Server/GM_Longvinter.GM_Longvinter_C]
AdminSteamID="$CFG_ADMIN_STEAM_ID"
PVP=$CFG_PVP
TentDecay=$CFG_TENT_DECAY
MaxTents=$CFG_MAX_TENTS
RestartTime24h=$CFG_RESTART_TIME_24H
SaveBackups=$CFG_SAVE_BACKUPS
Hardcore=$CFG_HARDCORE
MoneyDropMultiplier=$CFG_MONEY_DROP_MULTIPLIER
WeaponDamageMultiplier=$CFG_WEAPON_DAMAGE_MULTIPLIER
EnergyDrainMultiplier=$CFG_ENERGY_DRAIN_MULTIPLIER
PriceFluctuationMultiplier=$CFG_PRICE_FLUCTUATION_MULTIPLIER
EOF

if [ "${DEBUG,,}" = true ]; then
	echo "====Debug===="
	grep -Ev "^[[:space:]]*(\[.*)?$" "$config_file"
	echo "====Debug===="
fi

LogSuccess "Compiling Game.ini done!"
