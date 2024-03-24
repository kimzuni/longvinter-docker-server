#!/usr/bin/env bash

#
# Log Definitions
#
export LINE='\n'
export RESET='\033[0m'               # Text Reset
export WhiteText='\033[0;37m'        # White

# Bold
export RedBoldText='\033[1;31m'      # Red
export GreenBoldText='\033[1;32m'    # Green
export YellowBoldText='\033[1;33m'   # Yellow
export CyanBoldText='\033[1;36m'     # Cyan

LogInfo() {
	Log "$1" "$WhiteText"
}
LogWarn() {
	Log "$1" "$YellowBoldText"
}
LogError() {
	Log "$1" "$RedBoldText"
}
LogSuccess() {
	Log "$1" "$GreenBoldText"
}
LogAction() {
	Log "$1" "$CyanBoldText" "****" "****"
}
Log() {
	local message="$1"
	local color="$2"
	local prefix="$3"
	local suffix="$4"
	printf "$color%s$RESET$LINE" "$prefix$message$suffix"
}

# Send Discord Message
# Level is optional variable defaulting to info
DiscordMessage() {
	local title="$1"
	local message="$2"
	local level="${3}"
	local enabled="$4"
	local webhook_url="$5"
	if [ -z "$level" ]; then
		level="info"
	fi
	if [ -n "${DISCORD_WEBHOOK_URL}" ]; then
		/home/steam/server/discord.sh "$title" "$message" "$level" "$enabled" "$webhook_url" &
	fi
}

shutdown_server() {
	kill -15 `pidof LongvinterServer-Linux-Shipping`
	return $?
}

# Server_Info | sed -E "s/([^:]+): (.+)/**\1**: \2/g"
Server_Info() {
	if [ "$DISCORD_SERVER_INFO_MESSAGE_WITH_IP" = true ]; then
		echo "Server IP: `curl -sfL icanhazip.com`"
		echo "Server Port: $PORT"
		echo
	fi
	echo "Server Name: $CFG_SERVER_NAME"
	echo "Server Password: $CFG_PASSWORD"
	echo "Message of the Day: $CFG_SERVER_MOTD"
	echo "Community URL: $COMMUNITY_URL"
	echo
	echo "Max Player: $CFG_MAX_PLAYERS"
	echo "PVP: $CFG_ENABLE_PVP"
	echo "Tent Decay: $CFG_TENT_DECAY"
	echo "Max Tent: $CFG_MAX_TENTS"
	echo "Coop Play: $CFG_COOP_PLAY"
	echo "Coop Spawn: $CFG_COOP_SPAWN"
}
