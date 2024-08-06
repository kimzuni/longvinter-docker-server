# Longvinter Dedicated Server Docker

[![Release](https://img.shields.io/github/v/release/kimzuni/longvinter-docker-server)](https://github.com/kimzuni/longvinter-docker-server/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Docker Stars](https://img.shields.io/docker/stars/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Image Size](https://img.shields.io/docker/image-size/kimzuni/longvinter-docker-server/latest)](https://hub.docker.com/r/kimzuni/longvinter-docker-server/tags)

[![Release](https://github.com/kimzuni/longvinter-docker-server/actions/workflows/release.yml/badge.svg)](https://github.com/kimzuni/longvinter-docker-server/actions/workflows/release.yml)
[![Linting](https://github.com/kimzuni/longvinter-docker-server/actions/workflows/linting.yml/badge.svg)](https://github.com/kimzuni/longvinter-docker-server/actions/workflows/linting.yml)
[![Security](https://github.com/kimzuni/longvinter-docker-server/actions/workflows/security.yml/badge.svg)](https://github.com/kimzuni/longvinter-docker-server/actions/workflows/security.yml)

[![Docker Hub](https://img.shields.io/badge/Docker_Hub-longvinter-blue?logo=docker)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![GHCR](https://img.shields.io/badge/GHCR-longvinter-blue?logo=docker)](https://github.com/kimzuni/longvinter-docker-server/pkgs/container/longvinter-docker-server)

[English](/docs/en/README.md) | [한국어](/docs/kr/README.md)

This is a Docker container to help you get started with hosting your own
[Longvinter](https://store.steampowered.com/app/1635450/Longvinter/) dedicated server.

Applying source code
[Uuvana-Studios/longvinter-docker-server](https://github.com/Uuvana-Studios/longvinter-docker-server)
to source code
[thijsvanloef/palworld-server-docker](https://github.com/thijsvanloef/palworld-server-docker)
to generate this image.

This Docker container has been tested and will work on the following OS:

* Windows 11
* Ubuntu 22.04

This container has also been tested and will work on both `x64` and `ARM64` based CPU architecture.

> [!WARNING]
> At the moment, All related features have been replaced and removed because Longvinter does not support RCON/REST API.
>
> As a result, containers don't have the ability to save servers,
> so using some features without saving servers can result
> in a rollback of about 5 minutes of play history.
> (Server is Automatically saved every 5 minutes)

## Official URL

* [Longvinter](https://www.longvinter.com/)
  * [Wiki](https://wiki.longvinter.com)
  * [X(Twitter)](https://twitter.com/longvinter)
  * [Reddit](https://www.reddit.com/r/Longvinter/)
  * [TicTok](https://www.tiktok.com/@longvinter)
  * [Instagram](https://www.instagram.com/longvintergame)
  * [Server Docs](https://docs-server.longvinter.com/)
  * [Discord](https://discord.gg/longvinter)
* [Uuvana](https://www.uuvana.com/)
  * [X(Twitter)](https://twitter.com/uuvanastudios)
  * [Youtube](https://www.youtube.com/@uuvana)
  * [Instagram](https://www.instagram.com/uuvanastudios/)
  * [Media Kit](https://longvinter.com/press)
  * [Forum](https://forum.uuvana.com/)
  * ~~[FAQ(Frequently Asked Questions)](https://contact.uuvana.com/)~~

## Server Requirements

* OS: Min. 64-bit
* RAM: Min. 2GB

from <https://wiki.longvinter.com/server/docker>

## How to use

Keep in mind that you'll need to change the [environment variables](#environment-variables).

After running the server, you can check the server log with the command `docker logs longvinter-server`.
To check in real time, add `-f` at the end.

### Docker Compose

This repository includes an example [docker-compose.yml](/docker-compose.yml) file you can use to set up your server.
To run the server, Write the file first and then execute the command `docker compose up -d` from that directory.

```yml
services:
  longvinter:
    image: kimzuni/longvinter-docker-server:latest
    restart: unless-stopped
    container_name: longvinter-server
    stop_grace_period: 30s # Set to however long you are willing to wait for the container to gracefully stop
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    ports:
      - "7777:7777/udp"
    environment:
      TZ: "UTC"
      PUID: 1000
      PGID: 1000
      PORT: 7777 # Optional but recommended
      CFG_SERVER_NAME: "Unnamed Island"
      CFG_MAX_PLAYERS: 32
      CFG_SERVER_MOTD: "Welcome to Longvinter Island!"
      CFG_PASSWORD: ""
      CFG_COMMUNITY_WEBSITE: "www.longvinter.com"
      CFG_COOP_PLAY: false
      CFG_COOP_SPAWN: 0
      CFG_TAG: "none"
      CFG_ADMIN_STEAM_ID: ""
      CFG_PVP: true
      CFG_TENT_DECAY: true
      CFG_MAX_TENTS: 2
    volumes:
      - ./data:/data
```

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called **.env** file.
Modify it to your needs, check out the [environment variables](#environment-variables) section to check the correct
values. Modify your [docker-compose.yml](/docker-compose.yml) to this:

```yml
services:
  longvinter:
    image: kimzuni/longvinter-docker-server:latest
    restart: unless-stopped
    container_name: longvinter-server
    stop_grace_period: 30s # Set to however long you are willing to wait for the container to gracefully stop
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    ports:
      - "7777:7777/udp"
    env_file:
      - .env
    volumes:
      - ./data:/data
```

### Docker Run

You can also use the command `docker run` instead of `docker compose`.
The container is created as soon as you run the command below.

```bash
docker run -d \
    --name longvinter-server \
    -p 7777:7777/udp \
    -v ./data:/data/ \
    -e TZ="UTC" \
    -e PUID=1000 \
    -e PGID=1000 \
    -e PORT=7777 \
    -e CFG_SERVER_NAME="Unnamed Island" \
    -e CFG_MAX_PLAYERS=32 \
    -e CFG_SERVER_MOTD="Welcome to Longvinter Island!" \
    -e CFG_PASSWORD="" \
    -e CFG_COMMUNITY_WEBSITE="www.longvinter.com" \
    -e CFG_COOP_PLAY=false \
    -e CFG_COOP_SPAWN=0 \
    -e CFG_TAG="none" \
    -e CFG_ADMIN_STEAM_ID="" \
    -e CFG_PVP=true \
    -e CFG_TENT_DECAY=true \
    -e CFG_MAX_TENTS=2 \
    --restart unless-stopped \
    --stop-timeout 30 \
    kimzuni/longvinter-docker-server:latest
```

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called **.env** file.
Modify it to your needs, check out the [environment variables](#environment-variables) section to check the
correct values. Change your docker run command to this:

```bash
docker run -d \
    --name longvinter-server \
    -p 7777:7777/udp \
    -v ./data:/data/ \
    --env-file .env \
    --restart unless-stopped \
    --stop-timeout 30 \
    kimzuni/longvinter-docker-server:latest
```

### Update the Container

To update the container version, stop the container first.

```bash
docker compose down
```

Next, remove the installed image:

```bash
docker rmi $(docker images | grep -E ^"(ghcr.io\/)?kimzuni/longvinter-docker-server" | awk '{print $3}')
```

Finally, run the [Docker Compose](#docker-compose) or [Docker Run](#docker-run) with the `latest` tag.

### Running without root

This is only for advanced users

It is possible to run this container and
[override the default user](https://docs.docker.com/engine/reference/run/#user) which is root in this image.

Because you are specifiying the user and group `PUID` and `PGID` are ignored.

If you want to find your UID: `id -u`
If you want to find your GID: `id -g`

You must set user to `NUMBERICAL_UID:NUMBERICAL_GID`

Below we assume your UID is 1000 and your GID is 1001

* In docker run add `--user 1000:1001 \` above the last line.
* In docker compose add `user: 1000:1001` above ports.

If you wish to run it with a different UID/GID than your own you will need to change the ownership of the directory that
is being bind: `chown UID:GID data/`
or by changing the permissions for all other: `chmod o=rwx data/`

### Environment variables

You can use the following values to change the settings of the container on boot.
It is highly recommended you set the following environment values before starting the container:

* PUID
* PGID
* PORT

| Variable                                      | Info                                                                                                                                          | Default Value                                                                                         | Allowed Values                                                                                                    | Added in Version  |
|-----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|-------------------|
| TZ                                            | Set the timezone in container                                                                                                                 | UTC                                                                                                   | See [TZ Identifiers](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_Zone_abbreviations)        | 0.1.0             |
| PUID*                                         | The uid of the user the server should run as                                                                                                  | 1000                                                                                                  | !0                                                                                                                | 0.1.0             |
| PGID*                                         | The gid of the user the server should run as                                                                                                  | 1000                                                                                                  | !0                                                                                                                | 0.1.0             |
| PORT*                                         | UDP port that the server will expose                                                                                                          | 7777                                                                                                  | 1024-65535                                                                                                        | 0.1.0             |
| UPDATE_ON_BOOT**                              | Update the server when the docker container starts                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.0             |
| BACKUP_ENABLED                                | Enables automatic backups                                                                                                                     | true                                                                                                  | true/false                                                                                                        | 0.1.1             |
| BACKUP_CRON_EXPRESSION                        | Setting affects frequency of automatic backups                                                                                                | 0 0 \* \* \*                                                                                          | Needs a Cron-Expression - See [Configuring Automatic Backups with Cron](#configuring-automatic-backups-with-cron) | 0.1.1             |
| DELETE_OLD_BACKUPS                            | Delete backups after a certain number of days                                                                                                 | false                                                                                                 | true/false                                                                                                        | 0.1.1             |
| OLD_BACKUP_DAYS                               | How many days to keep backups                                                                                                                 | 30                                                                                                    | any positive integer                                                                                              | 0.1.1             |
| AUTO_UPDATE_ENABLED                           | Enables automatic updates                                                                                                                     | false                                                                                                 | true/false                                                                                                        | 0.1.4             |
| AUTO_UPDATE_CRON_EXPRESSION                   | Setting affects frequency of automatic updates                                                                                                | 0 \* \* \* \*                                                                                         | Needs a Cron-Expression - See [Configuring Automatic Updates with Cron](#configuring-automatic-updates-with-cron) | 0.1.4             |
| AUTO_UPDATE_WARN_MINUTES                      | How long to wait to saved and update the server, after the player were informed (This will be ignored, if no Players are connected)           | 15                                                                                                    | Integer                                                                                                           | 0.1.4             |
| AUTO_UPDATE_WARN_MESSAGE                      | Broadcast message sent when countdown for server updates                                                                                      | Server will update in `remaining_time` minutes.                                                       | "string"                                                                                                          | 0.1.10            |
| AUTO_UPDATE_WARN_REMAINING_TIMES              | Time to broadcast countdowns to players for server updates                                                                                    | 1 5 10                                                                                                | Integer, " "(Space)                                                                                               | 0.1.10            |
| AUTO_REBOOT_ENABLED                           | Enables automatic reboots                                                                                                                     | false                                                                                                 | true/false                                                                                                        | 0.1.10            |
| AUTO_REBOOT_CRON_EXPRESSION                   | Setting affects frequency of automatic reboots                                                                                                | 0 0 \* \* \*                                                                                          | Needs a Cron-Expression - See [Configuring Automatic Reboots with Cron](#configuring-automatic-reboots-with-cron) | 0.1.10            |
| AUTO_REBOOT_WARN_MINUTES                      | How long to wait to saved and reboot the server, after the player were informed (This will be ignored, if no Players are connected)           | 15                                                                                                    | Integer                                                                                                           | 0.1.10            |
| AUTO_REBOOT_WARN_MESSAGE                      | Broadcast message sent when countdown for server reboots                                                                                      | Server will reboot in `remaining_time` minutes.                                                       | "string"                                                                                                          | 0.1.10            |
| AUTO_REBOOT_WARN_REMAINING_TIMES              | Time to broadcast countdowns to players for server reboots                                                                                    | 1 5 10                                                                                                | Integer, " "(Space)                                                                                               | 0.1.10            |
| AUTO_REBOOT_EVEN_IF_PLAYERS_ONLINE            | Restart the Server even if there are players online                                                                                           | false                                                                                                 | true/false                                                                                                        | 0.1.10            |
| BROADCAST_COUNTDOWN_SUSPEND_MESSAGE           | Discord message sent when countdown suspended due to no players.                                                                              | Suspends countdown because there are no players.                                                      | "string"                                                                                                          | 0.1.10            |
| BROADCAST_COUNTDOWN_SUSPEND_MESSAGE_ENABLED   | If the Discord message is enabled for this message.                                                                                           | true                                                                                                  | true/false                                                                                                        | 0.1.2             |
| TARGET_MANIFEST_ID                            | Locks game version to corespond with Manifest ID from Steam Download Depot                                                                    | _(empty)_                                                                                             | See [Manifest ID Table](#locking-specific-game-version)                                                           | 1.0.0             |
| DISCORD_WEBHOOK_URL                           | Discord webhook url found after creating a webhook on a discord server                                                                        | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.0             |
| DISCORD_SUPPRESS_NOTIFICATIONS                | Enables/Disables `@silent` messages for the server messages                                                                                   | false                                                                                                 | true/false                                                                                                        | 0.1.0             |
| DISCORD_CONNECT_TIMEOUT                       | Discord command initial connection timeout                                                                                                    | 30                                                                                                    | !0                                                                                                                | 0.1.0             |
| DISCORD_MAX_TIMEOUT                           | Discord total hook timeout                                                                                                                    | 30                                                                                                    | !0                                                                                                                | 0.1.0             |
| DISCORD_PRE_INSTALL_MESSAGE                   | Discord message sent when server begins installing                                                                                            | Server is installing...                                                                               | "string"                                                                                                          | 0.1.0             |
| DISCORD_PRE_INSTALL_MESSAGE_ENABLED           | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.0             |
| DISCORD_PRE_INSTALL_MESSAGE_URL               | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.0             |
| DISCORD_POST_INSTALL_MESSAGE                  | Discord message sent when server completes installing                                                                                         | Server install complete!                                                                              | "string"                                                                                                          | 0.1.2             |
| DISCORD_POST_INSTALL_MESSAGE_ENABLED          | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.2             |
| DISCORD_POST_INSTALL_MESSAGE_URL              | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.2             |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE               | Discord message sent when server begins updating                                                                                              | Server is updating...                                                                                 | "string"                                                                                                          | 0.1.0             |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED       | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.0             |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL           | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.0             |
| DISCORD_POST_UPDATE_BOOT_MESSAGE              | Discord message sent when server completes updating                                                                                           | Server update complete!                                                                               | "string"                                                                                                          | 0.1.2             |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED      | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.2             |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_URL          | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.2             |
| DISCORD_PRE_START_MESSAGE                     | Discord message sent when server begins to start                                                                                              | Server has been started!                                                                              | "string"                                                                                                          | 0.1.0             |
| DISCORD_PRE_START_MESSAGE_ENABLED             | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.0             |
| DISCORD_PRE_START_MESSAGE_URL                 | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.0             |
| DISCORD_PRE_SHUTDOWN_MESSAGE                  | Discord message sent when server begins to shutdown                                                                                           | Server is shutting down...                                                                            | "string"                                                                                                          | 0.1.0             |
| DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED          | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.0             |
| DISCORD_PRE_SHUTDOWN_MESSAGE_URL              | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.0             |
| DISCORD_POST_SHUTDOWN_MESSAGE                 | Discord message sent when server begins to shutdown                                                                                           | Server is stopped!                                                                                    | "string"                                                                                                          | 0.1.0             |
| DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED         | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.0             |
| DISCORD_POST_SHUTDOWN_MESSAGE_URL             | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.0             |
| DISCORD_PLAYER_JOIN_MESSAGE                   | Discord message sent when player joins the server                                                                                             | `player_name` has joined!                                                                             | "string"                                                                                                          | 0.1.9             |
| DISCORD_PLAYER_JOIN_MESSAGE_ENABLED           | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.9             |
| DISCORD_PLAYER_JOIN_MESSAGE_URL               | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.9             |
| DISCORD_PLAYER_LEAVE_MESSAGE                  | Discord message sent when player leaves the server                                                                                            | `player_name` has left.                                                                               | "string"                                                                                                          | 0.1.9             |
| DISCORD_PLAYER_LEAVE_MESSAGE_ENABLED          | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.9             |
| DISCORD_PLAYER_LEAVE_MESSAGE_URL              | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.9             |
| DISCORD_PRE_BACKUP_MESSAGE                    | Discord message when starting to create a backup                                                                                              | Creating backup...                                                                                    | "string"                                                                                                          | 0.1.1             |
| DISCORD_PRE_BACKUP_MESSAGE_ENABLED            | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.1             |
| DISCORD_PRE_BACKUP_MESSAGE_URL                | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.1             |
| DISCORD_POST_BACKUP_MESSAGE                   | Discord message when a backup has been made                                                                                                   | Backup created at `file_path`                                                                         | "string"                                                                                                          | 0.1.1             |
| DISCORD_POST_BACKUP_MESSAGE_ENABLED           | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.1             |
| DISCORD_POST_BACKUP_MESSAGE_URL               | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.1             |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE             | Discord message when starting to remove older backups                                                                                         | Removing backups older than `old_backup_days` days                                                    | "string"                                                                                                          | 0.1.1             |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_ENABLED     | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.1             |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_URL         | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.1             |
| DISCORD_POST_BACKUP_DELETE_MESSAGE            | Discord message when successfully removed older backups                                                                                       | Removed backups older than `old_backup_days` days                                                     | "string"                                                                                                          | 0.1.1             |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_ENABLED    | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.1             |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_URL        | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.1             |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE             | Discord message when there has been an error removing older backups                                                                           | Unable to delete old backups, OLD_BACKUP_DAYS is not an integer. OLD_BACKUP_DAYS=`old_backup_days`    | "string"                                                                                                          | 0.1.1             |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_ENABLED     | If the Discord message is enabled for this message                                                                                            | true                                                                                                  | true/false                                                                                                        | 0.1.1             |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_URL         | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.1             |
| DISCORD_BROADCAST_MESSAGE_ENABLE              | If the Discord message is enabled for broadcast message                                                                                       | true                                                                                                  | true/false                                                                                                        | 0.1.6             |
| DISCORD_BROADCAST_MESSAGE_URL                 | Discord Webhook URL for this message (if left empty will use DISCORD_WEBHOOK_URL)                                                             | _(empty)_                                                                                             | `https://discord.com/api/webhooks/<webhook_id>`                                                                   | 0.1.6             |
| DISABLE_GENERATE_SETTINGS                     | Whether to automatically generate the Game.ini                                                                                                | false                                                                                                 | true/false                                                                                                        | 0.1.1             |
| ENABLE_PLAYER_LOGGING                         | Enables Logging and announcing when players join and leave                                                                                    | true                                                                                                  | true/false                                                                                                        | 0.1.9             |
| PLAYER_LOGGING_POLL_PERIOD                    | Polling period (in seconds) to check for players who have joined or left                                                                      | 5                                                                                                     | !0                                                                                                                | 0.1.9             |
| USE_DEPOT_DOWNLOADER                          | Uses DepotDownloader to download game server files instead of steamcmd. This will help hosts incompatible with steamcmd (e.g. M-series Mac)   | false                                                                                                 | true/false                                                                                                        | 1.0.0             |
  
*highly recommended to set

** Make sure you know what you are doing when running this option enabled

<!-- markdownlint-disable-next-line -->
<details><summary>List of Removed</summary>

| Variable                              | Available Versions    | Change/Similar to                             |
|---------------------------------------|-----------------------|-----------------------------------------------|
| DISCORD_SERVER_INFO_MESSAGE_ENABLE    | 0.1.0                 | DISCORD_PRE_START_MESSAGE_WITH_GAME_SETTINGS  |
| DISCORD_SERVER_INFO_MESSAGE_ENABLED   | 0.1.1 ~ 0.1.10        | DISCORD_PRE_START_MESSAGE_WITH_GAME_SETTINGS  |
| DISCORD_SERVER_INFO_MESSAGE_WITH_IP   | 0.1.0 ~ 0.1.10        | DISCORD_PRE_START_MESSAGE_WITH_SERVER_IP      |
| BROADCAST_COUNTDOWN_MTIMES            | 0.1.6 ~ 0.1.9         | BROADCAST_COUNTDOWN_REMAINING_TIMES           |
| ARM_COMPATIBILITY_MODE                | 0.1.0 ~ 0.2.0         | ARM64_DEVICE                                  |
| TARGET_COMMIT_ID                      | 0.1.3 ~ 0.4.0         | TARGET_MANIFEST_ID                            |

</details>

### ARM64-exclusive environment variables

ARM64 hosts can use the following variables to tweak their server setup. This includes
known relevant Box64 configurations one can modify for better server stability/performance.

For the Box64 configurations, please see the their official documentation for more info.

> [!TIP]
> Set `ARM64_DEVICE` to the most appropriate setting for your device. `generic` is expected
> to work on all devices but better stability can be found with specifying your device.
> For more specific device compatibility, create an issue on the
> [base image repo](https://github.com/sonroyaalmerol/steamcmd-arm64).

| Variable                  | Info                                                                                                                                                      | Default Values    | Allowed Values            | Added in Version  |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------|---------------------------|-------------------|
| BOX64_DYNAREC_STRONGMEM   | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_strongmem-)] Enable/Disable simulation of Strong Memory model      | 1                 | 0, 1, 2, 3                | 0.3.0             |
| BOX64_DYNAREC_BIGBLOCK    | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_bigblock-)] Enables/Disables Box64's Dynarec building BigBlock     | 1                 | 0, 1, 2, 3                | 0.3.0             |
| BOX64_DYNAREC_SAFEFLAGS   | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_safeflags-)] Handling of flags on CALL/RET opcodes                 | 1                 | 0, 1, 2                   | 0.3.0             |
| BOX64_DYNAREC_FASTROUND   | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_fastround-)] Enable/Disable generation of precise x86 rounding     | 1                 | 0, 1                      | 0.3.0             |
| BOX64_DYNAREC_FASTNAN     | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_fastnan-)] Enable/Disable generation of -NAN                       | 1                 | 0, 1                      | 0.3.0             |
| BOX64_DYNAREC_X87DOUBLE   | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_x87double-)] Force the use of Double for x87 emulation             | 0                 | 0, 1                      | 0.3.0             |
| ARM64_DEVICE              | Specify Box64 build to be used based on host device. This setting is only applicable for ARM64 hosts                                                      | generic           | generic, m1, rpi5, adlink | 0.3.0             |

### Game Ports

| Port  | Info              |
|-------|-------------------|
| 7777  | Game Port (UDP)   |

## Send a broadcast

Used for countdown before automatic updating/Rebooting a server.

> [!IMPORTANT]
> This send it to Discord, not server
>
> See [Broadcast on Discord](#broadcast-on-discord)

### Manually send a broadcast

> [!TIP]
> Use Hex to use any color you want!

Broadcast message using the command:

```bash
docker exec longvinter-server broadcast "Message" [COLOR|ALIAS|HEX]
```

Color is used when [sending to Discord](#broadcast-on-discord).
(Case-insensitive)

| Color                     | Alias         | Hex       |
|---------------------------|---------------|-----------|
| $\color{#1132D8}Blue$*    | info          | 1132D8    |
| $\color{#E8D44F}Yellow$   | in-progress   | E8D44F    |
| $\color{#D85311}Orange$   | warn          | D85311    |
| $\color{#DF0000}Red$      | failure       | DF0000    |
| $\color{#00CC00}Green$    | success       | 00CC00    |

*Default

## Creating a backup

> [!WARNING]
> Current point in time is not automatically saved.

To create a backup of the game's last save, use the command:

```bash
docker exec longvinter-server backup
```

This will create a backup at `/data/backups/`

## Restore from a backup

> [!WARNING]
> Current point in time is not automatically saved.
>
> If the recovery fails, it is rolled back to the last save point.

To restore from a backup, use the command:

```bash
docker exec -it longvinter-server restore
```

> [!IMPORTANT]
> If docker restart is not set to policy `always` or `unless-stopped` then the server will shutdown and will need to be
> manually restarted.
>
> The example docker run command and docker compose file in [How to Use](#how-to-use) already uses the needed policy

## Manually restore from a backup

> [!WARNING]
> It is not automatically saved the server when shutdown the server.

Locate the backup you want to restore in `/data/backups/` and decompress it.
Need to stop the server before task.

```bash
docker compose down
```

Delete the old saved data folder located at `data/Longvinter/Saved/SaveGames`.

Copy the contents of the newly decompressed saved data folder `Saved/SaveGames` to `data/Longvinter/Saved/SaveGames`.

Restart the game. (If you are using Docker Compose)

```bash
docker compose up -d
```

## Configuring Automatic Backups with Cron

The server is automatically backed up everynight at midnight according to the timezone set with TZ

Set BACKUP_ENABLED enable or disable automatic backups (Default is enabled)

BACKUP_CRON_EXPRESSION is a cron expression, in a Cron-Expression you define an interval for when to run jobs.

> [!TIP]
> This image uses Supercronic for crons
> see [supercronic](https://github.com/aptible/supercronic#crontab-format)
> or
> [Crontab Generator](https://crontab-generator.org).

Set BACKUP_CRON_EXPRESSION to change the default schedule.
Example Usage: If BACKUP_CRON_EXPRESSION to `0 2 * * *`, the backup script will run every day at 2:00 AM.

## Configuring Automatic Updates with Cron

The server is automatically update everyhour according to the timezone set with TZ
(After countdown is stopped and server is saved, start updates.)

To be able to use automatic Updates with this Server the following environment variables **have** to be set to `true`:

* UPDATE_ON_BOOT

> [!IMPORTANT]
>
> If docker restart is not set to policy `always` or `unless-stopped` then the server will shutdown and will need to be
> manually restarted.
>
> The example docker run command and docker compose file in [How to Use](#how-to-use) already use the needed policy

Set AUTO_UPDATE_ENABLED enable or disable automatic updates (Default is disabled)

AUTO_UPDATE_CRON_EXPRESSION is a cron expression, in a Cron-Expression you define an interval for when to run jobs.

> [!TIP]
> This image uses Supercronic for crons
> see [supercronic](https://github.com/aptible/supercronic#crontab-format)
> or
> [Crontab Generator](https://crontab-generator.org).

Set AUTO_UPDATE_CRON_EXPRESSION to change the default schedule.
Example Usage: If AUTO_UPDATE_CRON_EXPRESSION to `30 * * * *`, the update script will run everyhour at 30 minutes.

## Configuring Automatic Reboots with Cron

> [!TIP]
> With CFG_RESTART_TIME_24H, save the server and reboot it.
> But, must be written on a UTC basis.

The server is automatically reboot everynight at midnight according to the timezone set with TZ
(After countdown is stopped and server is saved, start reboots.)

> [!IMPORTANT]
>
> If docker restart is not set to policy `always` or `unless-stopped` then the server will shutdown and will need to be
> manually restarted.
>
> The example docker run command and docker compose file in [How to Use](#how-to-use) already use the needed policy

Set AUTO_REBOOT_ENABLED enable or disable automatic reboots (Default is disabled)

AUTO_REBOOT_CRON_EXPRESSION is a cron expression, in a Cron-Expression you define an interval for when to run jobs.

> [!TIP]
> This image uses Supercronic for crons
> see [supercronic](https://github.com/aptible/supercronic#crontab-format)
> or
> [Crontab Generator](https://crontab-generator.org).

Set AUTO_REBOOT_CRON_EXPRESSION to change the default schedule.
Example Usage: If AUTO_REBOOT_CRON_EXPRESSION to `0 2 * * *`, the backup script will run every day at 2:00 AM.

## Editing Server Settings

### With Environment Variables

> [!IMPORTANT]
>
> These Environment Variables/Settings are subject to change since the game is still in beta.
> Check out the [official webpage for the supported parameters.](https://wiki.longvinter.com/server/configuration#server-configuration)

Converting server settings to environment variables follow the same principles:

* all capital letters
* split words by inserting an underscore
* add `CFG_` as a prefix.

For example:

* Password -> CFG_PASSWORD
* ServerName -> CFG_SERVER_NAME
* ServerMOTD -> CFG_SERVER_MOTD

| Variable                              | Info                                                                                  | Default Value                 | Allowed Values                                        |
|---------------------------------------|---------------------------------------------------------------------------------------|-------------------------------|-------------------------------------------------------|
| CFG_SERVER_NAME                       | Sets the name that appears in the server browser                                      | Unnamed Island                | String                                                |
| CFG_SERVER_MOTD                       | Sets the Message of the Day displayed on signs around the island                      | Welcome to Longvinter Island! | String                                                |
| CFG_MAX_PLAYERS                       | Sets the maximum number of players that can connect simultaneously                    | 32                            | Integer                                               |
| CFG_PASSWORD                          | Sets a password for the server                                                        | _(empty)_                     | String                                                |
| CFG_COMMUNITY_WEBSITE                 | Promotes a website, displayed with the server message and openable in-game            | www\.longvinter\.com          | String                                                |
| CFG_TAG                               | Adds a tag for easier server searching                                                | None                          | String                                                |
| CFG_COOP_PLAY                         | Enables or disables cooperative play mode(CFG_PVP must be set to false)               | false                         | Boolean                                               |
| CFG_COOP_SPAWN                        | Sets the cooperative spawn point on the island                                        | 0                             | 0~2**                                                 |
| CFG_CHECK_VPN                         | Enables or disables VPN checking for connecting players                               | true                          | Boolean                                               |
| CFG_CHEST_RESPAWN_TIME                | Sets the maximum respawn time (in seconds) for loot chests                            | 600                           | Integer                                               |
| CFG_DISABLE_WANDERING_TRADERS         | Disables wandering traders from spawning                                              | false                         | Boolean                                               |
| CFG_SERVER_REGION                     | Display server in a list of specified country in the server browser                   | _(empty)_                     | `AS`, `NA`, `SA`, `EU`, `OC`, `AF`, `AN` or nothing   |
| CFG_ADMIN_STEAM_ID                    | Assigns admin privileges to specified EOS IDs. You can get EOS ID from game settings  | _(empty)_                     | Hexadecimal, " "(Space)                               |
| CFG_PVP                               | Enables or disables Player versus Player combat                                       | true                          | Boolean                                               |
| CFG_TENT_DECAY                        | Enables or disables tent decay to manage abandoned tents                              | true                          | Boolean                                               |
| CFG_MAX_TENTS                         | Sets the maximum number of tents players can place on the server                      | 2                             | Integer                                               |
| CFG_RESTART_TIME_24H                  | Sets the daily restart time for the server (in 24-hour format)                        | _(empty)_                     | Integer                                               |
| CFG_HARDCORE                          | Enables or disables Hardcore mode                                                     | false                         | Boolean                                               |
| CFG_MONEY_DROP_MULTIPLIER*            | Sets MK drop multiplier on death                                                      | 0.0                           | Float                                                 |
| CFG_WEAPON_DAMAGE_MULTIPLIER*         | Sets weapon damage multiplier                                                         | 1.0                           | Float                                                 |
| CFG_ENERGY_DRAIN_MULTIPLIER*          | Sets energy drain multiplier                                                          | 1.0                           | Float                                                 |
| CFG_PRICE_FLUCTUATION_MULTIPLIER*     | Sets Items price fluctuation multiplier                                               | 1.0                           | Float                                                 |

*Only in hardcore mode

** 0(West), 1(South), 2(East). Not sure

### Manually

When the server starts, a `Game.ini` file will be created in the following location: `<mount_folder>/Longvinter/Saved/Config/LinuxServer/Game.ini`.

Please keep in mind that the ENV variables will always overwrite the changes made to `Game.ini`.
If you want to modify the file directly, set the value DISABLE_GENERATE_SETTINGS to `true`.

> [!IMPORTANT]
> Changes can only be made to `Game.ini` while the server is off.
>
> Any changes made while the server is live will be overwritten when the server stops.

For a more detailed list of server settings go to: [Longvinter Wiki](https://wiki.longvinter.com/server/configuration#server-configuration)

## Using discord webhooks

1. Generate a webhook url for your discord server in your discord's server settings.
2. Set the environment variable with the unique token at the end of the discord webhook url example: `https://discord.com/api/webhooks/1234567890/abcde`

Send discord messages with docker run:

```sh
-e DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1234567890/abcde" \
-e DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..." \
```

Send discord messages with docker compose:

```yml
- DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1234567890/abcde"
- DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..."
```

### Broadcast on Discord

> [!IMPORTANT]
> Since the game server does not support RCON/REST API,
> in-game broadcasting is not possible, send broadcast message to Discord

Set DISCORD_BROADCAST_MESSAGE_ENABLE enable or disable broadcast on Discord (Default is enabled)

## Locking Specific Game Version

> [!WARNING]
> Downgrading to a lower game version is possible, but it is unknown what impact it will have on existing saves.
>
> **Please do so at your own risk!**

If **TARGET_MANIFEST_ID** environment variable is set, will lock server version to specific manifest.
The manifest corresponds to the release date/update versions. Manifests can be found using SteamCMD or websites like [SteamDB](https://steamdb.info/depot/1639882/manifests/).

### Version To Manifest ID Table

| Version   | Manifest ID           |
|-----------|-----------------------|
| 0.10 B    | 7723330886973031108   |
| 0.11 R    | 876347941046873366    |
| 0.12 B    | 7232977979130477635   |
| 0.13 R    | 3287206638975838103   |

## Reporting Issues/Feature Requests

Issues/Feature requests can be submitted by using [this link](https://github.com/kimzuni/longvinter-docker-server/issues/new/choose).
