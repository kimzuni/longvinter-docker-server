#!/bin/bash
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

# Checks if users in the game
# Returns 0 if players exists
# Returns 1 if players not exists
player_check() {
	if ! timeout 1s bash -c "while :; do netstat -an | grep ^udp.*:'$PORT' | awk '{print \$2}'; done" | grep -qv ^0; then
		return 1
	fi
	return 0
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
	local level="${3:-info}"
	local enabled="$4"
	local webhook_url="$5"
	if [ -n "${DISCORD_WEBHOOK_URL}" ]; then
		/home/steam/server/discord.sh "$title" "$message" "$level" "$enabled" "$webhook_url" &
	fi
}

# Given a message and level this will broadcast in discord
broadcast_command() {
	broadcast "$@"
}

# Saves then shutdowns the server
# Returns 0 if it is shutdown
# Returns not 0 if it is not able to be shutdown
shutdown_server() {
	kill -15 "$(pidof LongvinterServer-Linux-Shipping)"
	return $?
}

# Given an amount of time in minutes and a message prefix
# Will skip countdown if no players are in the server, Will only check the mtime if there are players in the server
# Returns 0 on success
# Returns 1 if mtime is empty
# Returns 2 if mtime is not an integer
countdown_message() {
	local mtime="$1"
	local message="$2"
	local return_val=0

	if [[ "${mtime}" =~ ^[0-9]+$ ]]; then
		for ((i = "${mtime}" ; i > 0 ; i--)); do
			# Only do countdown if there are players
			# Checking for players every minute
			player_check || break

			if [ "$mtime" -eq "$i" ] || [[ " $BROADCAST_COUNTDOWN_MTIMES " == *" $i "* ]]; then
				if [ "$i" -eq 1 ]; then
					message="${message//minutes/minute}"
				fi
				broadcast_command "${message//remaining_time/$i}" "warn"
			fi

			sleep 59s
		done

		if [ "$i" -eq 0 ]; then
			sleep 1s
		elif [ "$1" -ne "$mtime" ]; then
			broadcast_command "${BROADCAST_COUNTDOWN_SUSPEND_MESSAGE}" "warn"
		fi
	# If there are players but mtime is empty
	elif [ -z "${mtime}" ]; then
		return_val=1
	# If there are players but mtime is not an integer
	else
		return_val=2
	fi

	return "$return_val"
}

container_version_check() {
	local current_version
	local latest_version

	current_version=$(cat /home/steam/server/GIT_VERSION_TAG)
	latest_version=$(get_latest_version)

	if [ "${current_version}" == "dev" ]; then
		LogWarn "Currently using the dev version."
		LogWarn "Recommended to use the latest version: ${latest_version}"
	elif [ "${current_version}" != "${latest_version}" ]; then
		LogWarn "New version available: ${latest_version}"
	else
		LogSuccess "The container is up to date!"
		return
	fi

	LogWarn "Learn how to update the container:"
	LogWarn " - English : https://github.com/kimzuni/longvinter-docker-server/tree/main/docs/en/#update-the-container"
	LogWarn " - 한국어  : https://github.com/kimzuni/longvinter-docker-server/tree/main/docs/kr/#컨테이너-업데이트-방법"
}

# Get latest release version from kimzuni/longvinter-docker-server repository
# Returns the latest release version
get_latest_version() {
	local latest_version

	latest_version=$(curl https://api.github.com/repos/kimzuni/longvinter-docker-server/releases/latest -s | jq .name -r)

	echo "$latest_version"
}

# Use it when you have to wait for it to be saved automatically because it does not support RCON.
wait_save() {
	local title="$1"
	local message="$2"
	local level="$3"
	local enabled="$4"
	local webhook_url="$5"
	local timestamp livetime

	if ! player_check; then
		livetime="$(date "+%s")"
		timestamp="$(grep "RemovePlayer" "$SERVER_LOG_PATH" | tail -1 | awk -F "\\\[|\\\]" '{printf("%s/%s/%s %s:%s:%s\n", $2, $3, $4, $5, $6, $7)}' | date_to_timestamp)"
		if [ -z "$timestamp" ] || save_check "$((livetime - timestamp))"; then
			return
		fi
	fi

	LogWarn "$message"
	DiscordMessage "$title" "$message" "$level" "$enabled" "$webhook_url"

	while ! save_check; do
		sleep 1s
	done
}

# shellcheck disable=SC2120
# Given a number verify that there is a saved log within that second
# Returns 0 if find save log
# Returns 1 if not find save log
save_check() {
	local spare="${1:-10}"
	local livetime savetime

	livetime="$(date "+%s")"
	savetime=$(
		grep -rE ^"\[[a-zA-Z]{3} [0-9, :]+ [AP]M\] Game saved!" "$SERVER_LOG_DIR" \
		| awk -F "\\\[|\\\]" '{print $2}' \
		| sed "s/Jan/1/g; s/Feb/2/g; s/Mar/3/g; s/Apr/4/g; s/May/5/g; s/Jun/6/g; s/Jul/7/g; s/Aug/8/g; s/Sep/9/g; s/Oct/10/g; s/Nov/11/g; s/Dec/12/g" \
		| awk -F ":| |," '{if (($NF == "PM" && $5 != 12) || ($NF == "AM" && $5 == 12)) $5 = ($5+12)%24; printf("%s/%s/%s %s:%s:%s\n", $4, $1, $2, $5, $6, $7)}' \
		| sort --version-sort | tail -1 | date_to_timestamp
	)

	if [ $((livetime - savetime)) -ge $((spare - 5)) ]; then
		return 1
	fi
	return 0
}

date_to_timestamp() {
	read -r time
	if [ -n "$time" ]; then
		date -d "$time" "+%s" 2> /dev/null
	fi
}

Server_Info() {
	local HTTP URL="$CFG_COMMUNITY_WEBSITE"
	if ! [[ "$URL" =~ ^https?:// ]] && [ -n "$URL" ]; then
		HTTP="http://"
	fi

	echo "Server Name: $CFG_SERVER_NAME"
	if [ "$DISCORD_SERVER_INFO_MESSAGE_WITH_IP" = true ]; then
		echo "Server IP: $(curl -sfSL icanhazip.com)"
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
