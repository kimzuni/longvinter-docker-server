#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Helper Functions for installation & updates
# shellcheck source=scripts/helper_install.sh
source "/home/steam/server/helper_install.sh"

dirExists "$DATA_DIR" || exit
isWritable "$DATA_DIR" || exit
isExecutable "$DATA_DIR" || exit

cd "$GIT_REPO_PATH" || exit 1

if [ "$ARCHITECTURE" == "arm64" ] && [ "${ARM_COMPATIBILITY_MODE,,}" = true ]; then
	LogInfo "ARM compatibility mode enabled"
	export DEBUGGER="/usr/bin/qemu-i386-static"

	# Arbitrary number to avoid CPU_MHZ warning due to qemu and steamcmd
	export CPU_MHZ=2000
fi

if ! IsValidCommitID; then
	LogError "Invalid TARGET_COMMIT_ID($TARGET_COMMIT_ID)"
	LogError "Please change the value and restart the server."
	DiscordMessage "Error" "Invalid TARGET_COMMIT_ID($TARGET_COMMIT_ID). Please change the value and restart the server." "failure"
	# This is written because GitHub API can only be used 60 times per hour
	sleep infinity
	exit 1
fi

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
		UpdateServer
	fi
fi

# Check if the architecture is arm64
if [ "$ARCHITECTURE" == "arm64" ]; then
	box64_binary="box64"

	case $PAGESIZE in
		8192)
			LogInfo "Using Box64 for 8k pagesize"
			box64_binary="box64-8k"
			;;
		16384)
			LogInfo "Using Box64 for 16k pagesize"
			box64_binary="box64-16k"
			;;
		65536)
			LogInfo "Using Box64 for 64k pagesize"
			box64_binary="box64-64k"
			;;
	esac

	sed -i "s|^\(\"\$UE4_PROJECT_ROOT\/Longvinter\/Binaries\/Linux\/LongvinterServer-Linux-Shipping\" Longvinter \"\$@\"\)|LD_LIBRARY_PATH=/home/steam/steamcmd/linux64:\$LD_LIBRARY_PATH $box64_binary \1|" "$GIT_REPO_PATH/LongvinterServer.sh"
fi
STARTCOMMAND=("$GIT_REPO_PATH/LongvinterServer.sh")

#Validate Installation
if ! fileExists "${STARTCOMMAND[0]}"; then
	LogError "Server Not Installed Properly"
	exit 1
fi
chmod +x "${STARTCOMMAND[0]}"

isReadable "${STARTCOMMAND[0]}" || exit
isExecutable "${STARTCOMMAND[0]}" || exit

# Prepare Arguments
if [ -n "${PORT}" ]; then
	STARTCOMMAND+=("-Port=${PORT}")
fi

if [ -n "${QUERY_PORT}" ]; then
	STARTCOMMAND+=("-QueryPort=${QUERY_PORT}")
fi

LogAction "Checking for available container updates"
container_version_check

if [ "${DISABLE_GENERATE_SETTINGS,,}" = true ]; then
	LogAction "GENERATING CONFIG"
	LogWarn "Env vars will not be applied due to DISABLE_GENERATE_SETTINGS being set to TRUE!"
	if [ ! -f "$CONFIG_FILE_FULL_PATH" ]; then
		cp "$CONFIG_FILE_FULL_PATH".default "$CONFIG_FILE_FULL_PATH"
	fi
else
	LogAction "GENERATING CONFIG"
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

if { [ "${AUTO_UPDATE_ENABLED,,}" = true ] && [ "${UPDATE_ON_BOOT,,}" = true ]; } || [ "${BACKUP_ENABLED,,}" = true ]; then
	supercronic "/home/steam/server/crontab" &
	LogInfo "Cronjobs started"
else
	LogInfo "No Cronjobs found"
fi



LogAction "Starting Server"
DiscordMessage "Start" "$DISCORD_PRE_START_MESSAGE" "success" "${DISCORD_PRE_START_MESSAGE_ENABLED}" "${DISCORD_PRE_START_MESSAGE_URL}"

echo "${STARTCOMMAND[*]}"
"${STARTCOMMAND[@]}"

DiscordMessage "Stop" "${DISCORD_POST_SHUTDOWN_MESSAGE}" "failure" "${DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED}" "${DISCORD_POST_SHUTDOWN_MESSAGE_URL}"
exit 0
