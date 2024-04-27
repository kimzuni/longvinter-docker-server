#!/bin/bash
# shellcheck source=scripts/variables.sh
source "/home/steam/server/variables.sh"

# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Helper Functions for installation & updates
# shellcheck source=scripts/helper_install.sh
source "/home/steam/server/helper_install.sh"

UpdateRequired
updateRequired=$?
# Check if Update was actually required
if [ "$updateRequired" != 0 ]; then
	exit 0
fi

if [ "${UPDATE_ON_BOOT,,}" != true ]; then
	LogWarn "An update is available however, UPDATE_ON_BOOT needs to be enabled for auto updating"
	DiscordMessage "Update" "An update is available however, UPDATE_ON_BOOT needs to be enabled for auto updating" "warn"
	exit 1
fi

countdown_message "${AUTO_UPDATE_WARN_MINUTES}" "${AUTO_UPDATE_WARN_MESSAGE}"
countdown_exit_code=$?
case "${countdown_exit_code}" in
	0 )
		wait_save "Update" "Waiting for the server to be saved before update..." "warn" "$DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED" "$DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL"
		LogAction "Updating the server from $CURRENT_COMMIT to ${TARGET_COMMIT_ID:-$LATEST_COMMIT}."
		backup
		shutdown_server
		;;
	1 )
		LogWarn "Unable to auto update, the server is not empty and AUTO_UPDATE_WARN_MINUTES is empty."
		exit 1
		;;
	2 )
		LogWarn "Unable to auto update, the server is not empty and AUTO_UPDATE_WARN_MINUTES is not an integer: ${AUTO_UPDATE_WARN_MINUTES}"
		exit 1
		;;
esac
