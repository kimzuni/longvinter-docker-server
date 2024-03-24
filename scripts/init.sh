#!/usr/bin/env bash
source "/home/steam/server/variables.sh"
source "/home/steam/server/helper_functions.sh"

if [[ "$(id -u)" -eq 0 ]] && [[ "$(id -g)" -eq 0 ]]; then
	if [[ "${PUID}" -ne 0 ]] && [[ "${PGID}" -ne 0 ]]; then
		LogAction "EXECUTING USERMOD"
		usermod -o -u "${PUID}" steam
		groupmod -o -g "${PGID}" steam
		chown -R steam:steam $DATA_DIR /home/steam
	else
		LogError "Running as root is not supported, please fix your PUID and PGID!"
		exit 1
	fi
elif [[ "$(id -u)" -eq 0 ]] || [[ "$(id -g)" -eq 0 ]]; then
	LogError "Running as root is not supported, please fix your user!"
	exit 1
fi

if ! [ -w "$DATA_DIR" ]; then
	LogError "$DATA_DIR is not writable."
	exit 1
fi



term_handler() {
	DiscordMessage "Shutdown" "${DISCORD_PRE_SHUTDOWN_MESSAGE}" "in-progress" "${DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED}" "${DISCORD_PRE_SHUTDOWN_MESSAGE_URL}"

	if shutdown_server; then
		tail --pid="$killpid" -f 2>/dev/null
	fi
}
trap 'term_handler' SIGTERM



if [[ "$(id -u)" -eq 0 ]]; then
	su steam -c ./start.sh &
else
	./start.sh &
fi

killpid="$!"
wait "$killpid"
