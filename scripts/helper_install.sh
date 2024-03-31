#!/usr/bin/env bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Returns 0 if TARGET_COMMIT_ID has not been declare or is valid
# Returns 1 if Invalid TARGET_COMMIT_ID
CheckCommitID() {
	local COMMIT_ID="$1"
	local URL="$GIT_REPO_API/commits/$COMMIT_ID"
	if [ -n "$COMMIT_ID" ] && ! curl -sfSL "$URL" > /dev/null 2>&1; then
		return 1
	fi
	return 0
}

# Returns 0 if game is installed
# Returns 1 if game is not installed
IsInstalled() {
	if [ -d "$GIT_REPO_PATH/.git" ]; then
		return 0
	fi
	return 1
}

# Returns 0 if Update Required
# Returns 1 if Update NOT Required
UpdateRequired() {
	LogAction "Checking for new update"

	cd "$GIT_REPO_PATH"

	local CURRENT_COMMIT=$(git log HEAD -1 | head -1 | awk '{print $2}')
	local LATEST_COMMIT=$(curl -sfSL "$GIT_REPO_API/commits/main" | grep sha | head -1 | awk -F'"' '{print $4}')

	if [ -n "$TARGET_COMMIT_ID" ]; then
		if [[ "$CURRENT_COMMIT" =~ ^"$TARGET_COMMIT_ID" ]]; then
			return 1
		fi
	else
		if [ "$CURRENT_COMMIT" == "$LATEST_COMMIT" ]; then
			return 1
		fi
	fi
	return 0
}

BeforeInstall() {
	if [ "$ARCHITECTURE" == "arm64" ] && [ "$PAGESIZE" != "4096" ]; then
		LogWarn "WARNING: Only ARM64 hosts with 4k page size is supported when running steamcmd. Expect server installation to fail."
	fi
}

InstallServer() {
	BeforeInstall

	cd "$GIT_REPO_PATH"
	DiscordMessage "Install" "${DISCORD_PRE_INSTALL_MESSAGE}" "in-progress" "${DISCORD_PRE_INSTALL_MESSAGE_ENABLED}" "${DISCORD_PRE_INSTALL_MESSAGE_URL}"

	git init
	git remote add origin $GIT_REPO_URL
	git fetch origin $GIT_REPO_BRANCH
	git checkout ${TARGET_COMMIT_ID:-$GIT_REPO_BRANCH}
	
	DiscordMessage "Install" "${DISCORD_POST_INSTALL_MESSAGE}" "in-progress" "${DISCORD_POST_INSTALL_MESSAGE_ENABLED}" "${DISCORD_POST_INSTALL_MESSAGE_URL}"
}

UpdateServer() {
	BeforeInstall

	cd "$GIT_REPO_PATH"
	DiscordMessage "Update" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE}" "in-progress" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED}" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL}"

	git stash
	if [ -z "$TARGET_COMMIT_ID" ] || ! git log -1 "${TARGET_COMMIT_ID}" > /dev/null 2>&1; then
		git fetch origin $GIT_REPO_BRANCH
	fi
	git checkout "${TARGET_COMMIT_ID:-origin/$GIT_REPO_BRANCH}"
	git stash clear

	DiscordMessage "Update" "${DISCORD_POST_UPDATE_BOOT_MESSAGE}" "in-progress" "${DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED}" "${DISCORD_POST_UPDATE_BOOT_MESSAGE_URL}"
}
