#!/bin/bash
# shellcheck source=scripts/variables.sh
source "/home/steam/server/variables.sh"

# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"



if ! dirExists "$DATA_DIR"; then
	LogError "$DATA_DIR is not mounted."
	exit 1
fi
mkdir -p "$BACKUP_DIRECTORY_PATH"
if [ ! -s "/home/steam/$GIT_REPO_NAME" ]; then
	rm -rf "/home/steam/$GIT_REPO_NAME"
	ln -s "$GIT_REPO_PATH" "/home/steam/$GIT_REPO_NAME"
fi

if [[ "$(id -u)" -eq 0 ]] && [[ "$(id -g)" -eq 0 ]]; then
	if [[ "${PUID}" -ne 0 ]] && [[ "${PGID}" -ne 0 ]]; then
		LogAction "EXECUTING USERMOD"
		usermod -o -u "${PUID}" steam
		groupmod -o -g "${PGID}" steam
		chown -R steam:steam "$DATA_DIR" /home/steam
	else
		LogError "Running as root is not supported, please fix your PUID and PGID!"
		exit 1
	fi
elif [[ "$(id -u)" -eq 0 ]] || [[ "$(id -g)" -eq 0 ]]; then
	LogError "Running as root is not supported, please fix your user!"
	exit 1
fi



term_handler() {
	DiscordMessage "Shutdown" "${DISCORD_PRE_SHUTDOWN_MESSAGE}" "in-progress" "${DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED}" "${DISCORD_PRE_SHUTDOWN_MESSAGE_URL}"

	if ! shutdown_server; then
		LogWarn "Unable to shutdown the server for unknown reasons."
		DiscordMessage "Shutdown" "Unable to shutdown the server for unknown reasons." "failure" "${DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED}" "${DISCORD_PRE_SHUTDOWN_MESSAGE_URL}"
		return 1
	fi

	tail --pid="$killpid" -f 2>/dev/null
}
trap 'term_handler' SIGTERM



if [[ "$(id -u)" -eq 0 ]]; then
	su steam -c ./start.sh &
else
	./start.sh &
fi

# Process ID of su
killpid="$!"
wait "$killpid"



mapfile -t backup_pids < <(pgrep backup)
if [ "${#backup_pids[@]}" -ne 0 ]; then
	LogInfo "Waiting for backup to finish"
	for pid in "${backup_pids[@]}"; do
		tail --pid="$pid" -f 2>/dev/null
	done
fi

mapfile -t restore_pids < <(pgrep restore)
if [ "${#restore_pids[@]}" -ne 0 ]; then
	LogInfo "Waiting for restore to finish"
	for pid in "${restore_pids[@]}"; do
		tail --pid="$pid" -f 2>/dev/null
	done
fi