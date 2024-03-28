#!/usr/bin/env bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

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

	cd $GIT_REPO_PATH
	git fetch origin main
	local LATEST_VERSION=`git log HEAD..origin/main -1 | tail -1 | awk '{print $2}'`
	if [ -z "$LATEST_VERSION" ]; then
		return 1
	fi
	return 0
}

BeforeInstall() {
	if [ "$architecture" == "arm64" ] && [ "$pagesize" != "4096" ]; then
		LogWarn "WARNING: Only ARM64 hosts with 4k page size is supported when running steamcmd. Expect server installation to fail."
	fi
}

InstallServer() {
	BeforeInstall

	mkdir -p "$GIT_REPO_PATH" && cd "$GIT_REPO_PATH"
	DiscordMessage "Install" "${DISCORD_PRE_INSTALL_MESSAGE}" "in-progress" "${DISCORD_PRE_INSTALL_MESSAGE_ENABLED}" "${DISCORD_PRE_INSTALL_MESSAGE_URL}"

	git init
	git remote add origin $GIT_REPO_URL
	git fetch origin $GIT_REPO_BRANCH
	git checkout -b $GIT_REPO_BRANCH --track origin/$GIT_REPO_BRANCH

	DiscordMessage "Install" "${DISCORD_POST_INSTALL_MESSAGE}" "in-progress" "${DISCORD_POST_INSTALL_MESSAGE_ENABLED}" "${DISCORD_POST_INSTALL_MESSAGE_URL}"
}

UpdateServer() {
	BeforeInstall

	cd "$GIT_REPO_PATH"
	DiscordMessage "Update" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE}" "in-progress" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED}" "${DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL}"

	git stash
	git pull $GIT_REPO_URL $GIT_REPO_BRANCH
	git stash clear

	DiscordMessage "Update" "${DISCORD_POST_UPDATE_BOOT_MESSAGE}" "in-progress" "${DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED}" "${DISCORD_POST_UPDATE_BOOT_MESSAGE_URL}"
}
