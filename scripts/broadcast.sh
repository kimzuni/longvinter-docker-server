#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Given a message and level this will broadcast in discord

message="$1"
level="$2"

if [ -z "$message" ]; then
    INFO "Usage: ${0} Message [LEVEL]"
else
    DiscordMessage "Broadcast" "$message" "$level" "$DISCORD_BROADCAST_MESSAGE_ENABLE" "$DISCORD_BROADCAST_MESSAGE_URL"
fi
