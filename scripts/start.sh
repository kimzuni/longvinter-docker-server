#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Helper Functions for installation & updates
# shellcheck source=scripts/helper_install.sh
source "/home/steam/server/helper_install.sh"

dirExists "$DATA_DIR" || exit
isWritable "$DATA_DIR" || exit
isExecutable "$DATA_DIR" || exit

cd "$DATA_DIR" || exit 1

IsInstalled
ServerInstalled=$?
if [ "$ServerInstalled" == 1 ]; then
	LogInfo "Server installation not detected."
	LogAction "Starting Installation"
	InstallServer
fi

# Update Only If Already Installed
if [ "$ServerInstalled" == 0 ] && [ "${UPDATE_ON_BOOT,,}" == true ]; then
	UpdateRequired
	IsUpdateRequired=$?
	if [ "$IsUpdateRequired" == 0 ]; then
		LogAction "Starting Update"
		InstallServer update
	fi
fi

# Check if the architecture is arm64
if [ "$ARCHITECTURE" == "arm64" ]; then
	# create an arm64 version of ./LongvinterServer.sh
	cp ./LongvinterServer.sh ./LongvinterServer-arm64.sh

	sed -i "s|^\(\"\$UE4_PROJECT_ROOT\/Longvinter\/Binaries\/Linux\/LongvinterServer-Linux-Shipping\" Longvinter \"\$@\"\)|LD_LIBRARY_PATH=/home/steam/steamcmd/linux64:\$LD_LIBRARY_PATH /usr/local/bin/box64 \1|" "./LongvinterServer-arm64.sh"
	chmod +x ./LongvinterServer-arm64.sh
	STARTCOMMAND=("./LongvinterServer-arm64.sh")
else
	STARTCOMMAND=("./LongvinterServer.sh")
fi

# Validate Installation
if ! fileExists "${STARTCOMMAND[0]}"; then
	LogError "Server Not Installed Properly"
	exit 1
fi

isReadable "${STARTCOMMAND[0]}" || exit
isExecutable "${STARTCOMMAND[0]}" || exit

# Prepare Arguments
if [ -n "${PORT}" ]; then
	STARTCOMMAND+=("-Port=${PORT}")
fi

LogAction "Checking for available container updates"
container_version_check

LogAction "GENERATING CONFIG"
if [ "${DISABLE_GENERATE_SETTINGS,,}" = true ]; then
	LogWarn "Env vars will not be applied due to DISABLE_GENERATE_SETTINGS being set to TRUE!"
	if [ ! -f "$CONFIG_FILE_FULL_PATH" ]; then
		/home/steam/server/compile-settings.sh || exit
	fi
else
	LogInfo "Using Env vars to create Game.ini"
	/home/steam/server/compile-settings.sh || exit
fi

LogAction "GENERATING CRONTAB"
truncate -s 0  "/home/steam/server/crontab"

if [ "${BACKUP_ENABLED,,}" = true ]; then
	LogInfo "BACKUP_ENABLED=${BACKUP_ENABLED,,}"
	LogInfo "Adding cronjob for auto backups"
	echo "$BACKUP_CRON_EXPRESSION bash /usr/local/bin/backup" >> "/home/steam/server/crontab"
	supercronic -quiet -test "/home/steam/server/crontab" || exit
fi

if [ "${AUTO_UPDATE_ENABLED,,}" = true ] && [ "${UPDATE_ON_BOOT}" = true ]; then
	LogInfo "AUTO_UPDATE_ENABLED=${AUTO_UPDATE_ENABLED,,}"
	LogInfo "Adding cronjob for auto updating"
	echo "$AUTO_UPDATE_CRON_EXPRESSION bash /usr/local/bin/update" >> "/home/steam/server/crontab"
	supercronic -quiet -test "/home/steam/server/crontab" || exit
fi

if [ "${AUTO_REBOOT_ENABLED,,}" = true ]; then
	LogInfo "AUTO_REBOOT_ENABLED=${AUTO_REBOOT_ENABLED,,}"
	LogInfo "Adding cronjob for auto rebooting"
	echo "$AUTO_REBOOT_CRON_EXPRESSION bash /home/steam/server/auto_reboot.sh" >> "/home/steam/server/crontab"
	supercronic -quiet -test "/home/steam/server/crontab" || exit
fi

if [ -s "/home/steam/server/crontab" ]; then
	supercronic -passthrough-logs "/home/steam/server/crontab" &
	LogInfo "Cronjobs started"
else
	LogInfo "No Cronjobs found"
fi

if [ "${ENABLE_PLAYER_LOGGING,,}" = true ] && [[ "${PLAYER_LOGGING_POLL_PERIOD}" =~ ^[0-9]+$ ]]; then
	if [[ "$(id -u)" -eq 0 ]]; then
		su steam -c /home/steam/server/player_logging.sh &
	else
		/home/steam/server/player_logging.sh &
	fi
fi



LogAction "Starting Server"
DiscordMessage "Start" "$DISCORD_PRE_START_MESSAGE" "success" "${DISCORD_PRE_START_MESSAGE_ENABLED}" "${DISCORD_PRE_START_MESSAGE_URL}"

echo "${STARTCOMMAND[*]}"
"${STARTCOMMAND[@]}"

DiscordMessage "Stop" "${DISCORD_POST_SHUTDOWN_MESSAGE}" "failure" "${DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED}" "${DISCORD_POST_SHUTDOWN_MESSAGE_URL}"
exit 0
