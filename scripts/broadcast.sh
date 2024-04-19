#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Given a message this will broadcast in discord
# Returns 0 on success
# Returns 1 if not able to broadcast

message="$1"
level="$2"

DiscordMessage "Broadcast" "$message" "$level" "$DISCORD_BROADCAST_MESSAGE_ENABLE" "$DISCORD_BROADCAST_MESSAGE_URL"