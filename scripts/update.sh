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

if [[ "${AUTO_UPDATE_WARN_MINUTES}" =~ ^[0-9]+$ ]]; then
	DiscordMessage "Update" "Server will update in ${AUTO_UPDATE_WARN_MINUTES} minutes" "warn"
fi

sleep "${AUTO_UPDATE_WARN_MINUTES}m"

LogAction "Updating the server from $CURRENT_MANIFEST to $TARGET_MANIFEST."

backup
shutdown_server
