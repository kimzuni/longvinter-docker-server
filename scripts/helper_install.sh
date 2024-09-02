#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Returns 0 if game is installed
# Returns 1 if game is not installed
IsInstalled() {
	if  [ -e "$DATA_DIR/LongvinterServer.sh" ] && [ -e "$MANIFEST_PATH" ]; then
		return 0
	fi
	return 1
}

CreateACFFile() {
	local manifestId="$1"
cat > "$MANIFEST_PATH" << EOL
"AppState" {
	"appid"		"$APPID"
	"Universe"		"1"
	"name"		"Longvinter Dedicated Server"
	"StateFlags"		"4"
	"installdir"		"Longvinter Dedicated Server"
	"StagingSize"		"0"
	"buildid"		"15237642"
	"UpdateResult"		"0"
	"TargetBuildID"		"0"
	"AutoUpdateBehavior"		"0"
	"AllowOtherDownloadsWhileRunning"		"0"
	"ScheduledAutoUpdate"		"0"
	"InstalledDepots"
	{
		"1006"
		{
			"manifest"		"7138471031118904166"
		}
		"$DEPOTID"
		{
			"manifest"		"${manifestId}"
		}
	}
	"UserConfig"
	{
	}
	"MountedConfig"
	{
	}
}
EOL
}

# Returns 0 if Update Required
# Returns 1 if Update NOT Required
# Returns 2 if Check Failed
UpdateRequired() {
	LogAction "Checking for new Longvinter Server updates"

	# define local variables
	local CURRENT_MANIFEST LATEST_MANIFEST temp_file http_code updateAvailable

	# check steam for latest version
	temp_file=$(mktemp)
	http_code=$(curl "https://api.steamcmd.net/v1/info/$APPID" --output "$temp_file" --silent --location --write-out "%{http_code}")

	if [ "$http_code" -ne 200 ]; then
		LogError "There was a problem reaching the Steam api. Unable to check for updates!"
		DiscordMessage "Install" "There was a problem reaching the Steam api. Unable to check for updates!" "failure"
		rm "$temp_file"
		return 2
	fi

	# Parse temp file for manifest id
	LATEST_MANIFEST=$(grep -Po "\"$APPID\""'.*"gid": "\d+"' <"$temp_file" | sed -r 's/.*("[0-9]+")$/\1/' | tr -d '"')
	rm "$temp_file"

	if [ -z "$LATEST_MANIFEST" ]; then
		LogError "The server response does not contain the expected BuildID. Unable to check for updates!"
		DiscordMessage "Install" "Steam servers response does not contain the expected BuildID. Unable to check for updates!" "failure"
		return 2
	fi

	# Parse current manifest from steam files
	CURRENT_MANIFEST=$(awk '/manifest/{count++} count==2 {print $2; exit}' "$MANIFEST_PATH" | tr -d '"')
	LogInfo "Current Version: $CURRENT_MANIFEST"

	# Log any updates available
	local updateAvailable=false
	if [ "$CURRENT_MANIFEST" != "$LATEST_MANIFEST" ]; then
		LogInfo "An Update Is Available. Latest Version: $LATEST_MANIFEST."
		updateAvailable=true
	fi

	# If INSTALL_BETA_VERSION is set to true, install the latest beta version
	if [ "${INSTALL_BETA_VERSION}" == true ]; then
		return 0
	fi

	# No TARGET_MANIFEST_ID env set & update needed
	if [ "$updateAvailable" == true ] && [ -z "${TARGET_MANIFEST_ID}" ]; then
		return 0
	fi

	if [ -n "${TARGET_MANIFEST_ID}" ] && [ "$CURRENT_MANIFEST" != "${TARGET_MANIFEST_ID}" ]; then
		LogInfo "Game not at target version. Target Version: ${TARGET_MANIFEST_ID}"
		return 0
	fi

	# Warn if version is locked
	if [ "$updateAvailable" == false ]; then
		LogSuccess "The server is up to date!"
		return 1
	fi

	if [ -n "${TARGET_MANIFEST_ID}" ]; then
		LogWarn "Unable to update. Locked by TARGET_MANIFEST_ID."
		return 1
	fi
}

InstallServer() {
	local type="${1:-install}"
	local DISCORD_PRE_MESSAGE DISCORD_PRE_MESSAGE_ENABLED DISCORD_PRE_MESSAGE_URL
	local DISCORD_POST_MESSAGE DISCORD_POST_MESSAGE_ENABLED DISCORD_POST_MESSAGE_URL

	if [ "$type" == "update" ]; then
		DISCORD_PRE_MESSAGE="$DISCORD_PRE_UPDATE_BOOT_MESSAGE"
		DISCORD_PRE_MESSAGE_ENABLED="$DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED"
		DISCORD_PRE_MESSAGE_URL="$DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL"
		DISCORD_POST_MESSAGE="$DISCORD_POST_UPDATE_BOOT_MESSAGE"
		DISCORD_POST_MESSAGE_ENABLED="$DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED"
		DISCORD_POST_MESSAGE_URL="$DISCORD_POST_UPDATE_BOOT_MESSAGE_URL"
	else
		DISCORD_PRE_MESSAGE="$DISCORD_PRE_INSTALL_MESSAGE"
		DISCORD_PRE_MESSAGE_ENABLED="$DISCORD_PRE_INSTALL_MESSAGE_ENABLED"
		DISCORD_PRE_MESSAGE_URL="$DISCORD_PRE_INSTALL_MESSAGE_URL"
		DISCORD_POST_MESSAGE="$DISCORD_POST_INSTALL_MESSAGE"
		DISCORD_POST_MESSAGE_ENABLED="$DISCORD_POST_INSTALL_MESSAGE_ENABLED"
		DISCORD_POST_MESSAGE_URL="$DISCORD_POST_INSTALL_MESSAGE_URL"
	fi

	# Check kernel page size for arm64 hosts before running steamcmd
	if [ "$ARCHITECTURE" == "arm64" ] && [ "$PAGESIZE" != "4096" ] && [ "${USE_DEPOT_DOWNLOADER}" != true ]; then
		LogWarn "WARNING: Only ARM64 hosts with 4k page size is supported when running steamcmd. Please set USE_DEPOT_DOWNLOADER to true."
	fi

	if [ -z "${TARGET_MANIFEST_ID}" ]; then
		DiscordMessage "Install" "${DISCORD_PRE_MESSAGE}" "in-progress" "${DISCORD_PRE_MESSAGE_ENABLED}" "${DISCORD_PRE_MESSAGE_URL}"
		# If INSTALL_BETA_VERSION is set to true, install the latest beta version
		if [ "${INSTALL_BETA_VERSION}" == true ]; then
			LogWarn "Installing latest beta version"
			if [ "${USE_DEPOT_DOWNLOADER}" == true ]; then
				LogWarn "Downloading server files using DepotDownloader"
				DepotDownloader -app "$APPID" -osarch 64 -dir "$DATA_DIR" -beta experimental -validate
				DepotDownloader -app "$APPID" -depot "$DEPOTID" -osarch 64 -dir /tmp -beta experimental -manifest-only
			else
				/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +@sSteamCmdForcePlatformBitness 64 +force_install_dir "$DATA_DIR" +login anonymous +app_update "$APPID" -beta experimental validate +quit
			fi
		else
			if [ "${USE_DEPOT_DOWNLOADER}" == true ]; then
				LogWarn "Downloading server files using DepotDownloader"
				DepotDownloader -app "$APPID" -osarch 64 -dir "$DATA_DIR" -validate
				DepotDownloader -app "$APPID" -depot "$DEPOTID" -osarch 64 -dir /tmp -manifest-only
			else
				/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +@sSteamCmdForcePlatformBitness 64 +force_install_dir "$DATA_DIR" +login anonymous +app_update "$APPID" validate +quit
			fi
		fi

		# Create ACF file for DepoDownloader downloads for script compatibility
		if [ "${USE_DEPOT_DOWNLOADER}" == true ]; then
			local manifestFile
			manifestFile=$(find /tmp -type f -name "manifest_${DEPOTID}_*.txt" | head -n 1)

			if [ -z "$manifestFile" ]; then
				echo "DepotDownloader manifest file not found."
			else
				local manifestId
				manifestId=$(grep -oP 'Manifest ID / date\s*:\s*\K[0-9]+' "$manifestFile")
				if [ -z "$manifestId" ]; then
					echo "Manifest ID not found in DepotDownloader manifest file."
				else
					mkdir -p "$DATA_DIR/steamapps"
					CreateACFFile "$manifestId"
				fi

				rm -rf "$manifestFile"
			fi
		fi

		DiscordMessage "Install" "${DISCORD_POST_MESSAGE}" "success" "${DISCORD_POST_MESSAGE_ENABLED}" "${DISCORD_POST_MESSAGE_URL}"
		return
	fi

	local targetManifest
	targetManifest="${TARGET_MANIFEST_ID}"

	LogWarn "Installing Target Version: $targetManifest"
	DiscordMessage "Install" "${DISCORD_PRE_MESSAGE}" "in-progress" "${DISCORD_PRE_MESSAGE_ENABLED}" "${DISCORD_PRE_MESSAGE_URL}"
	if [ "${USE_DEPOT_DOWNLOADER}" == true ]; then
		LogWarn "Downloading server files using DepotDownloader"
		DepotDownloader -app "$APPID" -depot "$DEPOTID" -manifest "$targetManifest" -osarch 64 -dir "$DATA_DIR" -validate
		DepotDownloader -app "$APPID" -depot 1006 -osarch 64 -dir "$DATA_DIR" -validate
	else
		/home/steam/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +@sSteamCmdForcePlatformBitness 64 +force_install_dir "$DATA_DIR" +login anonymous +download_depot "$APPID" "$DEPOTID" "$targetManifest" +quit
		cp -vr "/home/steam/steamcmd/linux32/steamapps/content/app_$APPID/depot_$DEPOTID/Longvinter/Server/." "$DATA_DIR"
	fi
	CreateACFFile "$targetManifest"
	DiscordMessage "Install" "${DISCORD_POST_MESSAGE}" "success" "${DISCORD_POST_MESSAGE_ENABLED}" "${DISCORD_POST_MESSAGE_URL}"
}
