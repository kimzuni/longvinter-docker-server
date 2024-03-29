#!/usr/bin/env bash

export HOME="/home/steam"
export DATA_DIR="/data"
export GIT_REPO_NAME="longvinter-linux-server"
export GIT_REPO_BRANCH="main"
export GIT_REPO_URL="https://github.com/Uuvana-Studios/$GIT_REPO_NAME.git"
export GIT_REPO_PATH="$DATA_DIR"
export SERVER_CONFIG_PATH="/Longvinter/Saved/Config/LinuxServer/Game.ini"
export SERVER_BACKUP_DIR="$GIT_REPO_PATH/Longvinter/Backup"
export SERVER_LOG_PATH="$GIT_REPO_PATH/Longvinter/Saved/Logs/Longvinter.log"
export CONFIG_FILE_FULL_PATH="$GIT_REPO_PATH/$SERVER_CONFIG_PATH"

architecture=$(dpkg --print-architecture)
pagesize=$(getconf PAGESIZE)
export architecture pagesize



export PORT=${PORT:-7777}
export QUERY_PORT=${QUERY_PORT:-27016}
export CFG_SERVER_NAME=${CFG_SERVER_NAME:-Unnamed Island}
export CFG_MAX_PLAYERS=${CFG_MAX_PLAYERS:-32}
export CFG_SERVER_MOTD=${CFG_SERVER_MOTD:-Welcome to Longvinter Island!}
export CFG_PASSWORD=${CFG_PASSWORD}
export COMMUNITY_URL=${COMMUNITY_URL}
export CFG_COOP_PLAY=${CFG_COOP_PLAY:-false}
export CFG_COOP_SPAWN=${CFG_COOP_SPAWN:-0}
export CFG_SERVER_TAG=${CFG_SERVER_TAG:-none}
export CFG_ADMIN_STEAM_ID=${CFG_ADMIN_STEAM_ID}
export CFG_ENABLE_PVP=${CFG_ENABLE_PVP:-true}
export CFG_TENT_DECAY=${CFG_TENT_DECAY:-true}
export CFG_MAX_TENTS=${CFG_MAX_TENTS:-2}
