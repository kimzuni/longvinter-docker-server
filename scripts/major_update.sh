#!/bin/bash
# Temporary scripts to fix incompatible issues caused by version updates

# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"



if [ -n "$QUERY_PORT" ]; then
	LogWarn "QUERY_PORT is no longer supported."
fi
if [ -n "$DISCORD_PRE_START_MESSAGE_WITH_GAME_SETTINGS" ] || [ -n "$DISCORD_PRE_START_MESSAGE_WITH_SERVER_IP" ] || [ -n "$DISCORD_PRE_START_MESSAGE_WITH_DOMAIN" ]; then
	LogWarn "All variables starting with DISCORD_PRE_START_MESSAGE_WITH_ are no longer supported."
fi
if [ -n "$CFG_SERVER_TAG" ]; then
	LogWarn "CFG_SERVER_TAG will be removed soon. Please use CFG_TAG"
    export CFG_TAG="$CFG_SERVER_TAG"
fi
if [ -n "$CFG_ENABLE_PVP" ]; then
	LogWarn "CFG_ENABLE_PVP will be removed soon. Please use CFG_PVP"
    export CFG_PVP="$CFG_ENABLE_PVP"
fi
if [ -n "$TARGET_COMMIT_ID" ] || ! [[ "$TARGET_MANIFEST_ID" =~ ^[0-9]?+$ ]]; then
    LogError "TARGET_COMMIT_ID is no longer used."
    LogError "See https://github.com/kimzuni/longvinter-docker-server#locking-specific-game-version"
    exit 1
fi



if dirExists "$DATA_DIR/.git" > /dev/null; then
	OLD_BACKUP_DIR="$DATA_DIR/Longvinter/Backup"
	if dirExists "$OLD_BACKUP_DIR" > /dev/null; then
		mkdir -p "$BACKUP_DIR"
		mapfile -t backup_files < <(ls -A "$OLD_BACKUP_DIR")
		for file in "${backup_files[@]}"; do
			rename="$file"
			if [[ "$file" =~ ^Saved-Backup-[0-9]+\.tar\.gz$ ]]; then
				timestamp="$(grep -Eo "[0-9]+" <<< "$file")"
				date=$(date -d "@$timestamp" +"%Y-%m-%d_%H-%M-%S")
				rename="${file/$timestamp/$date}"
			fi
			mv "$OLD_BACKUP_DIR/$file" "$BACKUP_DIR/$rename"
		done
		rmdir "$OLD_BACKUP_DIR"
	fi

	LogWarn "Server will be reinstall because container version update."
	find "$DATA_DIR/steamapps" -name "*1007*" -exec rm -rf {} \; 2> /dev/null
	rm -rf "$DATA_DIR/Steam" "$DATA_DIR"/.git*
fi
if dirExists "$BACKUP_DIR" > /dev/null; then
	mapfile -t backup_files < <(ls -A "$BACKUP_DIR")
	for file in "${backup_files[@]}"; do
		rename="$file"
		if [[ "$file" =~ ^Saved-Backup-.+\.tar\.gz$ ]]; then
			mv "$BACKUP_DIR/$file" "$BACKUP_DIR/${file/Saved-Backup/longvinter-save}"
		fi
	done
fi
