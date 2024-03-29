#!/usr/bin/env bash
# This file contains functions which can be used in multiple scripts

# Checks if a given path is a directory
# Returns 0 if the path is a directory
# Returns 1 if the path is not a directory or does not exists and produces an output message
dirExists() {
	local path="$1"
	local return_val=0
	if ! [ -d "${path}" ]; then
		echo "${path} does not exist."
		return_val=1
	fi
	return "$return_val"
}

# Checks if a given path is a regular file
# Returns 0 if the path is a regular file
# Returns 1 if the path is not a regular file or does not exists and produces an output message
fileExists() {
	local path="$1"
	local return_val=0
	if ! [ -f "${path}" ]; then
		echo "${path} does not exist."
		return_val=1
	fi
	return "$return_val"
}

# Checks if a given path exists and is readable
# Returns 0 if the path exists and is readable
# Returns 1 if the path is not readable or does not exists and produces an output message
isReadable() {
	local path="$1"
	local return_val=0
	if ! [ -e "${path}" ]; then
		echo "${path} is not readable."
		return_val=1
	fi
	return "$return_val"
}

# Checks if a given path is writable
# Returns 0 if the path is writable
# Returns 1 if the path is not writable or does not exists and produces an output message
isWritable() {
	local path="$1"
	local return_val=0
	# Directories may be writable but not deletable causing -w to return false
	if [ -d "${path}" ]; then
		temp_file=$(mktemp -q -p "${path}")
		if [ -n "${temp_file}" ]; then
			rm -f "${temp_file}"
		else
			echo "${path} is not writable."
			return_val=1
		fi
	# If it is a file it must be writable
	elif ! [ -w "${path}" ]; then
		echo "${path} is not writable."
		return_val=1
	fi
	return "$return_val"
}

# Checks if a given path is executable
# Returns 0 if the path is executable
# Returns 1 if the path is not executable or does not exists and produces an output message
isExecutable() {
	local path="$1"
	local return_val=0
	if ! [ -x "${path}" ]; then
		echo "${path} is not executable."
		return_val=1
	fi
	return "$return_val"
}

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

# Saves then shutdowns the server
# Returns 0 if it is shutdown
# Returns not 0 if it is not able to be shutdown
shutdown_server() {
	local return_val=0

	kill -15 `pidof LongvinterServer-Linux-Shipping`
	return $?
}

Server_Info() {
	local HTTP URL="$CFG_COMMUNITY_WEBSITE"
	if ! [[ "$URL" =~ ^https?:// ]] && [ -n "$URL" ]; then
		HTTP="http://"
	fi

	echo "Server Name: $CFG_SERVER_NAME"
	if [ "$DISCORD_SERVER_INFO_MESSAGE_WITH_IP" = true ]; then
		echo "Server IP: `curl -sfL icanhazip.com`"
		echo "Server Port: $PORT"
	fi
	echo "Server Password: $CFG_PASSWORD"
	echo
	echo "Message of the Day: $CFG_SERVER_MOTD"
	echo "Community URL: $HTTP${URL:-None}"
	echo "Max Player: $CFG_MAX_PLAYERS"
	echo "PVP: $CFG_ENABLE_PVP"
	echo "Tent Decay: $CFG_TENT_DECAY"
	echo "Max Tent: $CFG_MAX_TENTS"
	echo "Coop Play: $CFG_COOP_PLAY"
	echo "Coop Spawn: $CFG_COOP_SPAWN"
}
