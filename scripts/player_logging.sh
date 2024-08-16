#!/bin/bash
# shellcheck source=scripts/variables.sh
source "/home/steam/server/variables.sh"

# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

get_eosid() {
	local log="$1"
	# Player EOSIDs are usally 32 hexadecimal digits
	sed -E "s/.*([0-9a-f]{32}).*/\1/g" <<< "$log"
}

eosid_to_playername() {
	local eosid="$1"
	grep "Login request.*$eosid" "$SERVER_LOG_PATH" | tail -1 | awk -F "Name=| userId:" '{print $2}' | tr -d "\r"
}

# Wait until game port is open
while ! port_check; do
	sleep 5s
	LogInfo "Waiting for server start for show player logging..."
done

last_line=0
while true; do
	server_pid=$(pidof LongvinterServer-Linux-Shipping)
	if [ -n "${server_pid}" ]; then
		# Get list of players who have joined and left from the server log
		line_number="$(wc -l < "$SERVER_LOG_PATH")"
		logs="$(head -"$line_number" "$SERVER_LOG_PATH" | tail -n +"$((last_line+1))" | grep -E "Join succeeded|RemovePlayer" | tr -d "\r")"
		last_line="$line_number"

		echo "$logs" | while read -r log; do
			case "$log" in
				# Notify Discord and log all players who have joined
				*"Join succeeded"* )
					player_name="$(awk -F "Join succeeded: " '{print $NF}' <<< "$log")"
					LogInfo "${player_name} has joined"

					# Replace ${player_name} with actual player's name
					DiscordMessage "Player Joined" "${DISCORD_PLAYER_JOIN_MESSAGE//player_name/${player_name}}" "success" "${DISCORD_PLAYER_JOIN_MESSAGE_ENABLED}" "${DISCORD_PLAYER_JOIN_MESSAGE_URL}"
					;;
				# Notify Discord and log all players who have left
				*"RemovePlayer"* )
					eosid="$(get_eosid "$log")"
					player_name="$(eosid_to_playername "$eosid")"
					LogInfo "${player_name} has left"

					# Replace ${player_name} with actual player's name
					DiscordMessage "Player Left" "${DISCORD_PLAYER_LEAVE_MESSAGE//player_name/${player_name}}" "failure" "${DISCORD_PLAYER_LEAVE_MESSAGE_ENABLED}" "${DISCORD_PLAYER_LEAVE_MESSAGE_URL}"
					;;
			esac
		done
	fi
	sleep "${PLAYER_LOGGING_POLL_PERIOD}s"
done
