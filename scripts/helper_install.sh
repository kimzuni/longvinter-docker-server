#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Returns 0 if valid TARGET_COMMIT_ID or is empty
# Returns 1 if Invalid TARGET_COMMIT_ID
IsValidCommitID() {
	local COMMIT_ID="$1"
	local URL="$GIT_REPO_API/commits/$COMMIT_ID"

	if ! curl -sfSL "$URL" > /dev/null 2>&1; then
		return 1
	fi
}

# Returns 0 if game is installed
# Returns 1 if game is not installed
IsInstalled() {
	if [ -d "$GIT_REPO_PATH/.git" ]; then
		return 0
	fi
	return 1
}

# Returns 0 if Update successful
# Returns 1 if Update Failed
InstallSteamapp() {
	LogAction "Checking for new Steamworks SDK Redist updates"

	local CURRENT_MANIFEST LATEST_MANIFEST temp_file http_code

	#check steam for latest version
	temp_file=$(mktemp)
	http_code=$(curl https://api.steamcmd.net/v1/info/1007 --output "$temp_file" --silent --location --write-out "%{http_code}")
	if [ "$http_code" -ne 200 ]; then
		LogError "There was a problem reaching the Steam api. Unable to check for updates!"
		DiscordMessage "Install" "There was a problem reaching the Steam api. Unable to check for updates!" "failure"
		rm "$temp_file"
		return 1
	fi

	# Parse temp file for manifest id
	LATEST_MANIFEST=$(grep -Po '"1006".*"gid": "\d+"' <"$temp_file" | sed -r 's/.*("[0-9]+")$/\1/' | tr -d '"')
	rm "$temp_file"

	if [ -z "$LATEST_MANIFEST" ]; then
		LogError "The server response does not contain the expected BuildID. Unable to check for updates!"
		DiscordMessage "Install" "Steam servers response does not contain the expected BuildID. Unable to check for updates!" "failure"
		return 1
	fi

	# Parse current manifest from steam files
	CURRENT_MANIFEST=$(awk '/manifest/{count++} count==1 {print $2; exit}' "$DATA_DIR/steamapps/appmanifest_1007.acf" | tr -d '"')
	LogInfo "Current Version: $CURRENT_MANIFEST"

	# Checking current version is latest version
	if [ "$CURRENT_MANIFEST" == "$LATEST_MANIFEST" ]; then
		LogSuccess "The server is up to date!"
		return 0
	fi
	LogInfo "An Update Is Available. Latest Version: $LATEST_MANIFEST."

	# Update
	/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +@sSteamCmdForcePlatformBitness 64 +force_install_dir "$DATA_DIR" +login anonymous +app_update 1007 validate +quit
}

# Returns 0 if Update Required
# Returns 1 if Update NOT Required
UpdateRequired() {
	LogAction "Checking for new Longvinter Server updates"

	CURRENT_COMMIT=$(git -C "$GIT_REPO_PATH" log HEAD -1 --format=format:%H)
	LATEST_COMMIT=$(curl -sfSL "$GIT_REPO_API/commits/main" | jq .sha -r)

	LogInfo "Current Version: $CURRENT_COMMIT"

	if [ -n "$TARGET_COMMIT_ID" ]; then
		if [[ "$CURRENT_COMMIT" =~ ^"$TARGET_COMMIT_ID" ]]; then
			LogSuccess "Game is the target version"
			return 1
		else
			LogInfo "Game not at target version. Target Version: ${TARGET_COMMIT_ID}"
			return 0
		fi
	else
		if [ "$CURRENT_COMMIT" == "$LATEST_COMMIT" ]; then
			LogSuccess "The server is up to date!"
			return 1
		else
			LogInfo "An Update Is Available. Latest Version: $LATEST_COMMIT."
			return 0
		fi
	fi
}

BeforeInstall() {
	if [ "$ARCHITECTURE" == "arm64" ] && [ "$PAGESIZE" != "4096" ]; then
		LogWarn "WARNING: Only ARM64 hosts with 4k page size is supported when running steamcmd. Expect server installation to fail."
	fi
}

InstallServer() {
	BeforeInstall

	cd "$GIT_REPO_PATH" || exit
	DiscordMessage "Install" "${DISCORD_PRE_INSTALL_MESSAGE}" "in-progress" "${DISCORD_PRE_INSTALL_MESSAGE_ENABLED}" "${DISCORD_PRE_INSTALL_MESSAGE_URL}"

	git init
	git remote add origin "$GIT_REPO_URL"
	git fetch origin "$GIT_REPO_BRANCH"
	git checkout "${TARGET_COMMIT_ID:-$GIT_REPO_BRANCH}"
	
	DiscordMessage "Install" "${DISCORD_POST_INSTALL_MESSAGE}" "in-progress" "${DISCORD_POST_INSTALL_MESSAGE_ENABLED}" "${DISCORD_POST_INSTALL_MESSAGE_URL}"
}

UpdateServer() {
	BeforeInstall

	cd "$GIT_REPO_PATH" || exit
	DiscordMessage "Update" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE}" "in-progress" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED}" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL}"

	git stash
	if [ -z "$TARGET_COMMIT_ID" ] || ! git log -1 "${TARGET_COMMIT_ID}" > /dev/null 2>&1; then
		git fetch origin "$GIT_REPO_BRANCH"
	fi
	git checkout "${TARGET_COMMIT_ID:-origin/$GIT_REPO_BRANCH}"
	git stash clear

	DiscordMessage "Update" "${DISCORD_POST_UPDATE_BOOT_MESSAGE}" "in-progress" "${DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED}" "${DISCORD_POST_UPDATE_BOOT_MESSAGE_URL}"
}
