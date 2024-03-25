# Longvinter Dedicated Server Docker

[![Release](https://img.shields.io/github/v/release/kimzuni/longvinter-docker-server)](https://github.com/kimzuni/longvinter-docker-server/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Docker Stars](https://img.shields.io/docker/stars/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Image Size](https://img.shields.io/docker/image-size/kimzuni/longvinter-docker-server/latest)](https://hub.docker.com/r/kimzuni/longvinter-docker-server/tags)

[![Docker Hub](https://img.shields.io/badge/Docker_Hub-longvinter-blue?logo=docker)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![GHCR](https://img.shields.io/badge/GHCR-longvinter-blue?logo=docker)](https://github.com/kimzuni/longvinter-docker-server/pkgs/container/longvinter-docker-server)

[English](/README.md) | [한국어](/docs/kr/README.md)

This is a Docker container to help you get started with hosting your own [Longvinter](https://store.steampowered.com/app/1635450/Longvinter/) dedicated server.

The source code started with applying [Uuvana-Studios/longvinter-docker-server](https://github.com/Uuvana-Studios/longvinter-docker-server) to [thijsvanloef/palworld-docker-server](https://github.com/thijsvanloef/palworld-server-docker).

This Docker images has been tested and will work on the following OS:
- Windows 11
- Ubuntu 22.04

## Official URL
- [\[Uuvana\] FAQ(Frequently Asked Questions)](https://contact.uuvana.com/)
- [\[Uuvana\] Contact](https://contact.uuvana.com/)
- [\[Uuvana\] Youtube](https://www.youtube.com/@uuvana)
- [\[Longvinter\] Server Docs](https://docs-server.longvinter.com/)
- [\[Longvinter\] Discord](https://discord.gg/longvinter)

## Server Requirements
> - OS: Min. 64-bit
> - RAM: Min. 2GB

from https://docs-server.longvinter.com

## How to Use
Keep in mind that you'll need to change the [environment variables](#environment-variables).

### Docker Compose
This repository includes an example [docker-compose.yml](/docker-compose.yml) file you can use to set up your server.

```yaml
services:
  longvinter-server:
    container_name: longvinter-server
    image: kimzuni/longvinter-docker-server:latest
    restart: unless-stopped
    stop_grace_period: 30s # Set to however long you are willing to wait for the container to gracefully stop
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    ports:
      - "7777:7777/tcp"
      - "7777:7777/udp"
      - "27016:27016/tcp"
      - "27016:27016/udp"
    environment:
      TZ: "UTC"
      PUID: 1000
      PGID: 1000
      PORT: 7777 # Optional but recommended
      QUERY_PORT: 27016 # Optional but recommended
      CFG_SERVER_NAME: "Unnamed Island"
      CFG_MAX_PLAYERS: 32
      CFG_SERVER_MOTD: "Welcome to Longvinter Island!"
      CFG_PASSWORD: ""
      CFG_COMMUNITY_WEBSITE: "www.longvinter.com"
      CFG_COOP_PLAY: false
      CFG_COOP_SPAWN: 0
      CFG_SERVER_TAG: "none"
      CFG_ADMIN_STEAM_ID: ""
      CFG_ENABLE_PVP: true
      CFG_TENT_DECAY: true
      CFG_MAX_TENTS: 2
    volumes:
      - ./data:/data
```

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called `.env` file. It doesn't matter if the file name is not `.env`. Modify your [docker-compose.yml](/docker-compose.yml) to this:

```yml
services:
  longvinter-server:
    container_name: longvinter-server
    image: kimzuni/longvinter-docker-server:latest
    restart: unless-stopped
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    ports:
      - "7777:7777/tcp"
      - "7777:7777/udp"
      - "27016:27016/tcp"
      - "27016:27016/udp"
    env_file:
      - .env
    volumes:
      - ./data:/data
```

After you finish setting up, you must run the `docker compose up -d` command where the `docker-compose.yml` file is located.

### Docker Run
Change every <> to your own configuration.

```bash
docker run -d \
    --name longvinter-server \
    -p 7777:7777/tcp \
    -p 7777:7777/tcp \
    -p 27016:27016/udp \
    -p 27016:27016/udp \
    -v ./data:/data/ \
    -e TZ="UTC" \
    -e PUID=1000 \
    -e PGID=1000 \
    -e PORT=7777 \
    -e QUERY_PORT=27016 \
    -e CFG_SERVER_NAME="Unnamed Island" \
    -e CFG_MAX_PLAYERS=32 \
    -e CFG_SERVER_MOTD="Welcome to Longvinter Island!" \
    -e CFG_PASSWORD="" \
    -e CFG_COMMUNITY_WEBSITE="www.longvinter.com" \
    -e CFG_COOP_PLAY=false \
    -e CFG_COOP_SPAWN=0 \
    -e CFG_SERVER_TAG="none" \
    -e CFG_ADMIN_STEAM_ID="" \
    -e CFG_ENABLE_PVP=true \
    -e CFG_TENT_DECAY=true \
    -e CFG_MAX_TENTS=2 \
    --restart unless-stopped \
    --stop-timeout 30 \
    kimzuni/longvinter-docker-server:latest
```

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called .env file. Change your docker run command to this:

```bash
docker run -d \
    --name longvinter-server \
    -p 7777:7777/tcp \
    -p 7777:7777/tcp \
    -p 27016:27016/udp \
    -p 27016:27016/udp \
    -v ./data:/data/ \
    --env-file .env \
    --restart unless-stopped \
    --stop-timeout 30 \
    kimzuni/longvinter-docker-server:latest
```

## Environment variables
List of available environment variables:

| Variable                                   | Info                                                                                                                                             | Default Value                                                                                      | Allowed Values                                                                                                    |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| TZ                                         | Timezone used for server. (Not applicable to Log)                                                                                                | UTC                                                                                                | See [TZ Identifiers](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_Zone_abbreviations)        |
| PUID\*                                     | The uid of the user the server should run as.                                                                                                    | 1000                                                                                               | !0                                                                                                                |
| PGID\*                                     | The gid of the user the server should run as.                                                                                                    | 1000                                                                                               | !0                                                                                                                |
| PORT\*                                     | Game port that the server will expose.                                                                                                           | 7777                                                                                               | 1024-65535                                                                                                        |
| QUERY_PORT                                 | Query port used to communicate with Steam servers.                                                                                               | 27016                                                                                              | 1024-65535                                                                                                        |
| UPDATE_ON_BOOT\*\*                         | Update the server when the docker container starts.                                                                                              | true                                                                                               | true/false                                                                                                        |
| BACKUP_ENABLED                             | Enables automatic backups.                                                                                                                       | true                                                                                               | true/false                                                                                                        |
| BACKUP_CRON_EXPRESSION                     | Setting affects frequency of automatic backups.                                                                                                  | 0 0 * * *                                                                                          | Needs a Cron-Expression - See [Configuring Automatic Backups with Cron](#configuring-automatic-backups-with-cron) |
| DELETE_OLD_BACKUPS                         | Delete backups after a certain number of days.                                                                                                   | false                                                                                              | true/false                                                                                                        |
| OLD_BACKUP_DAYS                            | How many days to keep backups.                                                                                                                   | 30                                                                                                 | any positive integer                                                                                              |
| DISCORD_WEBHOOK_URL                        | Discord webhook url found after creating a webhook on a discord server.                                                                          | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_SUPPRESS_NOTIFICATIONS             | Enables/Disables `@silent` messages for the server messages.                                                                                     | false                                                                                              | true/false                                                                                                        |
| DISCORD_CONNECT_TIMEOUT                    | Discord command initial connection timeout.                                                                                                      | 30                                                                                                 | !0                                                                                                                |
| DISCORD_MAX_TIMEOUT                        | Discord total hook timeout.                                                                                                                      | 30                                                                                                 | !0                                                                                                                |
| DISCORD_PRE_INSTALL_MESSAGE                | Discord message sent when server begins installing.                                                                                              | Server is installing...                                                                            | "string"                                                                                                          |
| DISCORD_PRE_INSTALL_MESSAGE_ENABLED        | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_INSTALL_MESSAGE_URL            | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE            | Discord message sent when server begins updating.                                                                                                | Server is updating...                                                                              | "string"                                                                                                          |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED    | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL        | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_PRE_START_MESSAGE                  | Discord message sent when server begins to start.                                                                                                | Server has been started!                                                                           | "string"                                                                                                          |
| DISCORD_PRE_START_MESSAGE_ENABLED          | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_START_MESSAGE_URL              | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_SERVER_INFO_MESSAGE_ENABLE         | Send the server settings with DISCORD_PRE_START_MESSAGE.                                                                                         | true                                                                                               | true/false                                                                                                        |
| DISCORD_SERVER_INFO_MESSAGE_WITH_IP        | Send the server IP and Port with server info.                                                                                                    | false                                                                                              | true/false                                                                                                        |
| DISCORD_PRE_SHUTDOWN_MESSAGE               | Discord message sent when server begins to shutdown.                                                                                             | Server is shutting down...                                                                         | "string"                                                                                                          |
| DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED       | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_SHUTDOWN_MESSAGE_URL           | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_POST_SHUTDOWN_MESSAGE              | Discord message sent when server begins to shutdown.                                                                                             | Server is stopped!                                                                                 | "string"                                                                                                          |
| DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED      | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_POST_SHUTDOWN_MESSAGE_URL          | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_PRE_BACKUP_MESSAGE                 | Discord message when starting to create a backup.                                                                                                | Creating backup...                                                                                 | "string"                                                                                                          |
| DISCORD_PRE_BACKUP_MESSAGE_ENABLED         | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_BACKUP_MESSAGE_URL             | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_POST_BACKUP_MESSAGE                | Discord message when a backup has been made.                                                                                                     | Backup created at `file_path`                                                                      | "string"                                                                                                          |
| DISCORD_POST_BACKUP_MESSAGE_ENABLED        | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_POST_BACKUP_MESSAGE_URL            | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE          | Discord message when starting to remove older backups.                                                                                           | Removing backups older than `old_backup_days` days                                                 | "string"                                                                                                          |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_ENABLED  | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_URL      | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_POST_BACKUP_DELETE_MESSAGE         | Discord message when successfully removed older backups.                                                                                         | Removed backups older than `old_backup_days` days                                                  | "string"                                                                                                          |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_ENABLED | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_URL     | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE          | Discord message when there has been an error removing older backups.                                                                             | Unable to delete old backups, OLD_BACKUP_DAYS is not an integer. OLD_BACKUP_DAYS=`old_backup_days` | "string"                                                                                                          |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_ENABLED  | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_URL      | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISABLE_GENERATE_SETTINGS                  | Whether to automatically generate the Game.ini                                                                                                   | false                                                                                              | true/false                                                                                                        |
| ARM_COMPATIBILITY_MODE                     | Switches the compatibility layer from Box86 to QEMU when executing steamcmd for server updates. This setting is only applicable for ARM64 hosts. | false                                                                                              | true/false                                                                                                        |

\* highly recommended to set

\*\* Make sure you know what you are doing when running this option enabled

## Configuring the Server Settings
Used with [environment variables](#environment-variables).

| Variable              | Info                                                                                                                                                                            | Default Value                 | Allowed Values                                                   |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|------------------------------------------------------------------|
| CFG_SERVER_NAME       | Setting the server name that is displayed in the server list.                                                                                                                   | Unnamed Island                | "string"                                                         |
| CFG_MAX_PLAYERS       | The maximum amount of players the server will allow at the same time.                                                                                                           | 32                            | 1-?                                                              |
| CFG_SERVER_MOTD       | A Message Of The Day that will be displayed to the player.                                                                                                                      | Welcome to Longvinter Island! | "string"                                                         |
| CFG_PASSWORD          | Use this setting to require a password to join the server.                                                                                                                      | _(empty)_                     | "string"                                                         |
| CFG_COMMUNITY_WEBSITE | When the server or community has a website, enter it here to display it to the player.                                                                                          | www.longvinter.com            | `<example.com>`, `http://<example.com>`, `https://<example.com>` |
| CFG_COOP_PLAY         | When this setting is set to "true", Co-op Play will be enabled on the server. Set to "false" to disable PvP.                                                                    | false                         | true/false                                                       |
| CFG_COOP_SPAWN        | All players will spawn here. (It only works when "CFG_COOP_PLAY" is "true".)                                                                                                    | 0                             | 0(West), 1(South), 2(East). (I haven't checked it out)           |
| CFG_SERVER_TAG        | Server tag that can be used to search for the server.                                                                                                                           | None                          | "string"                                                         |
| CFG_ADMIN_STEAM_ID    | Add the SteamID64 values for the players that have admin rights to this setting. When there are multiple admins, add the SteamID64 values to this setting separated by a space. | _(empty)_                     | 0-9, a-f, " "(Space)                                             |
| CFG_ENABLE_PVP        | When this setting is set to "true", PvP will be enabled on the server. Set to "false" to disable PvP.                                                                           | true                          | true/false                                                       |
| CFG_TENT_DECAY        | When this setting is set to "true", tents will decay and be destroyed after 48 hours unless they are upgraded to a house.                                                       | true                          | true/false                                                       |
| CFG_MAX_TENTS         | Maximum number of tents/houses each player can have placed in the world at a time.                                                                                              | 2                             | 1~?                                                              |

## Using discord webhooks
1. Generate a webhook url for your discord server in your discord's server settings.
2. Set the environment variable with the unique token at the end of the discord webhook url example: `https://discord.com/api/webhooks/1234567890/abcde`

Send discord messages with docker run:
```bash
-e DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1234567890/abcde" \
-e DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..." \
```

Send discord messages with docker compose:
```yml
- DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/1234567890/abcde
- DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..."
```



# To do List
- Update
- Restore
