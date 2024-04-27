#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Given a message and level this will broadcast in discord

message="$1"
level="$2"

DiscordMessage "Broadcast" "$message" "$level" "$DISCORD_BROADCAST_MESSAGE_ENABLE" "$DISCORD_BROADCAST_MESSAGE_URL"
