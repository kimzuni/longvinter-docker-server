#!/usr/bin/env bash

source "/home/steam/server/helper_functions.sh"
source "/home/steam/server/helper_install.sh"

if [ "$architecture" == "arm64" ] && [ "${ARM_COMPATIBILITY_MODE,,}" = true ]; then
	LogInfo "ARM compatibility mode enabled"
	export DEBUGGER="/usr/bin/qemu-i386-static"

	# Arbitrary number to avoid CPU_MHZ warning due to qemu and steamcmd
	export CPU_MHZ=2000
fi

IsInstalled
ServerInstalled=$?
if [ "$ServerInstalled" == 1 ]; then
	LogInfo "Server installation not detected."
	LogAction "Starting Installation"
	InstallServer
fi

cd $GIT_REPO_PATH || exit 1

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
if [ "$architecture" == "arm64" ]; then
	box64_binary="box64"

	case $pagesize in
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

	sed -i "s|^\(\"\$UE4_PROJECT_ROOT\/Longvinter\/Binaries\/Linux\/LongvinterServer-Linux-Shipping\" Longvinter \"\$@\"\)|LD_LIBRARY_PATH=/home/steam/steamcmd/linux64:\$LD_LIBRARY_PATH $box64_binary \1|" $GIT_REPO_PATH/LongvinterServer.sh
fi
STARTCOMMAND=("$GIT_REPO_PATH/LongvinterServer.sh")
chmod +x $GIT_REPO_PATH/LongvinterServer.sh

# Prepare Arguments
if [ -n "${PORT}" ]; then
	STARTCOMMAND+=("-Port=${PORT}")
fi

if [ -n "${QUERY_PORT}" ]; then
	STARTCOMMAND+=("-QueryPort=${QUERY_PORT}")
fi



LogAction "GENERATING CONFIG"
LogInfo "Using Env vars to create Game.ini"
/home/steam/server/compile-settings.sh



LogAction "Starting Server"
DiscordMessage "Start" "$DISCORD_PRE_START_MESSAGE" "success" "${DISCORD_PRE_START_MESSAGE_ENABLED}" "${DISCORD_PRE_START_MESSAGE_URL}"

echo "${STARTCOMMAND[*]}"
"${STARTCOMMAND[@]}"

DiscordMessage "Stop" "${DISCORD_POST_SHUTDOWN_MESSAGE}" "failure" "${DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED}" "${DISCORD_POST_SHUTDOWN_MESSAGE_URL}"

exit 0
