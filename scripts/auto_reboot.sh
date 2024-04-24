#!/bin/bash
# shellcheck source=scripts/variables.sh
source "/home/steam/server/variables.sh"

# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

if [ "${AUTO_REBOOT_EVEN_IF_PLAYERS_ONLINE,,}" != true ]; then 
	if player_check; then
		LogWarn "There are players online. Skipping auto reboot."
		exit 0
	fi
fi

countdown_message "${AUTO_REBOOT_WARN_MINUTES}" "Server will reboot"
countdown_exit_code=$?
case "${countdown_exit_code}" in
	0 )
		wait_save
		shutdown_server
		;;
	1 )
		LogError "Unable to auto reboot, the server is not empty and AUTO_REBOOT_WARN_MINUTES is empty."
		exit 1
		;;
	2 )
		LogError "Unable to auto reboot, the server is not empty and AUTO_REBOOT_WARN_MINUTES is not an integer: ${AUTO_REBOOT_WARN_MINUTES}"
		exit 1
		;;
esac
