# Longvinter Dedicated Server Docker

[![Release](https://img.shields.io/github/v/release/kimzuni/longvinter-docker-server)](https://github.com/kimzuni/longvinter-docker-server/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Docker Stars](https://img.shields.io/docker/stars/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Image Size](https://img.shields.io/docker/image-size/kimzuni/longvinter-docker-server/latest)](https://hub.docker.com/r/kimzuni/longvinter-docker-server/tags)

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

- Windows 11
- Ubuntu 22.04

This container has also been tested and will work on both `x64` and `ARM64` based CPU architecture.

> [!WARNING]
> At the moment, All related features have been replaced and removed because Longvinter does not support RCON.
>
> Therefore, we would like to inform you that if you do not save the server and proceed
> with server shutdown, update, and backup recovery, the history of your play for up to 12 minutes may be rolled back.
> (Server is Automatically saved every 12 minutes.)

## Official URL

- [\[Uuvana\] FAQ(Frequently Asked Questions)](https://contact.uuvana.com/)
- [\[Uuvana\] Contact](https://contact.uuvana.com/)
- [\[Uuvana\] Youtube](https://www.youtube.com/@uuvana)
- [\[Longvinter\] Server Docs](https://docs-server.longvinter.com/)
- [\[Longvinter\] Discord](https://discord.gg/longvinter)

## Server Requirements

> - OS: Min. 64-bit
> - RAM: Min. 2GB

from: <https://docs-server.longvinter.com>

## How to Use

Keep in mind that you'll need to change the [environment variables](#environment-variables).

After running the server, you can check the server log with the command `docker log longvinter-server`.
To check in real time, add `-f` at the end.

### Docker Compose

This repository includes an example [docker-compose.yml](/docker-compose.yml) file you can use to set up your server.
Write the file first and then execute the command `docker compose up -d` from that directory.

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

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called **.env** file.
Modify it to your needs, check out the [environment variables](#environment-variables) section to check the correct values.
Modify your [docker-compose.yml](docker-compose.yml) to this:

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

### Docker Run

You can also use the command `docker run` instead of `docker compose`. the server runs as soon as you run the command below.

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

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called **.env** file.
Modify it to your needs, check out the [environment variables](#environment-variables) section to check the correct values.
Change your docker run command to this:

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

### Running without root

This is only for advanced users.

It is possible to run this container and
[override the default user](https://docs.docker.com/engine/reference/run/#user) which is root in this image.

Because you are specifiying the user and group `PUID` and `PGID` are ignored.

If you want to find your UID: `id -u`,
If you want to find your GID: `id -g`.

You must set user to `NUMBERICAL_UID:NUMBERICAL_GID`.

Below we assume your UID is 1000 and your GID is 1001.

- In [Docker Run](#docker-run) add `--user 1000:1001 \` above the last line.
- In [Docker Compose](#docker-compose) add `user: 1000:1001` above ports.

If you wish to run it with a different UID/GID than your own you will need to change the ownership of the directory that
is being bind: `chown UID:GID data/`
or by changing the permissions for all other: `chmod o=rwx data/`

## Environment variables

You can use the following values to change the settings of the server on boot.
It is highly recommended you set the following environment values before starting the server:

| Variable                                   | Info                                                                                                                                             | Default Value                                                                                      | Allowed Values                                                                                                    |
|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| TZ                                         | Timezone used for Cron and Game server. (Not applicable to Log)                                                                                  | UTC                                                                                                | See [TZ Identifiers](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_Zone_abbreviations)        |
| PUID\*                                     | The uid of the user the server should run as.                                                                                                    | 1000                                                                                               | !0                                                                                                                |
| PGID\*                                     | The gid of the user the server should run as.                                                                                                    | 1000                                                                                               | !0                                                                                                                |
| PORT\*                                     | Game port that the server will expose.                                                                                                           | 7777                                                                                               | 1024-65535                                                                                                        |
| QUERY_PORT                                 | Query port used to communicate with Steam servers.                                                                                               | 27016                                                                                              | 1024-65535                                                                                                        |
| UPDATE_ON_BOOT\*\*                         | Update the server when the docker container starts.                                                                                              | true                                                                                               | true/false                                                                                                        |
| BACKUP_ENABLED                             | Enables automatic backups.                                                                                                                       | true                                                                                               | true/false                                                                                                        |
| BACKUP_CRON_EXPRESSION                     | Setting affects frequency of automatic backups.                                                                                                  | 0 0 \* \* \*                                                                                       | Needs a Cron-Expression - See [Configuring Automatic Backups with Cron](#configuring-automatic-backups-with-cron) |
| DELETE_OLD_BACKUPS                         | Delete backups after a certain number of days.                                                                                                   | false                                                                                              | true/false                                                                                                        |
| OLD_BACKUP_DAYS                            | How many days to keep backups.                                                                                                                   | 30                                                                                                 | any positive integer                                                                                              |
| AUTO_UPDATE_ENABLED                        | Enables automatic updates.                                                                                                                       | false                                                                                              | true/false                                                                                                        |
| AUTO_UPDATE_CRON_EXPRESSION                | Setting affects frequency of automatic updates.                                                                                                  | 0 0 \* \* \*                                                                                       | Needs a Cron-Expression - See [Configuring Automatic Updates with Cron](#configuring-automatic-updates-with-cron) |
| AUTO_UPDATE_WARN_MINUTES                   | How long to wait to update the server, after the player were informed.                                                                           | 30                                                                                                 | !0                                                                                                                |
| TARGET_COMMIT_ID                           | Install and run the game server at the specified version.                                                                                        | _(empty)_                                                                                          | See [Locking Specific Game Version](#locking-specific-game-version)(#target-commit-id)                            |
| DISCORD_WEBHOOK_URL                        | Discord webhook url found after creating a webhook on a discord server.                                                                          | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_SUPPRESS_NOTIFICATIONS             | Enables/Disables `@silent` messages for the server messages.                                                                                     | false                                                                                              | true/false                                                                                                        |
| DISCORD_CONNECT_TIMEOUT                    | Discord command initial connection timeout.                                                                                                      | 30                                                                                                 | !0                                                                                                                |
| DISCORD_MAX_TIMEOUT                        | Discord total hook timeout.                                                                                                                      | 30                                                                                                 | !0                                                                                                                |
| DISCORD_PRE_INSTALL_MESSAGE                | Discord message sent when server begins installing.                                                                                              | Server is installing...                                                                            | "string"                                                                                                          |
| DISCORD_PRE_INSTALL_MESSAGE_ENABLED        | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_INSTALL_MESSAGE_URL            | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_POST_INSTALL_MESSAGE               | Discord message sent when server completes installing.                                                                                           | Server install complete!                                                                           | "string"                                                                                                          |
| DISCORD_POST_INSTALL_MESSAGE_ENABLED       | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_POST_INSTALL_MESSAGE_URL           | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE            | Discord message sent when server begins updating.                                                                                                | Server is updating...                                                                              | "string"                                                                                                          |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED    | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL        | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
| DISCORD_POST_UPDATE_BOOT_MESSAGE           | Discord message sent when server completes updating.                                                                                             | Server update complete!                                                                            | "string"                                                                                                          |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED   | If the Discord message is enabled for this message.                                                                                              | true                                                                                               | true/false                                                                                                        |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_URL       | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                               | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                                   |
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

\*\* Make sure you know what you are doing when running this option enabled.

### Game Ports

| Port  | Info                 |
|-------|----------------------|
| 7777  | Game Port (TCP/UDP)  |
| 27016 | Query Port (TCP/UDP) |

## Creating a backup

> [!WARNING]
> Please confirm when your last save was.
>
> The server will backup the last saved.

To create a backup of the game's last save, use the command:

```bash
docker exec longvinter-server backup
```

This will create a backup at `/data/Longvinter/backups/`

## Restore from a backup

> [!WARNING]
> Please confirm when your last save was.
>
> If the recovery fails, it is rolled back to the last storage point.

To restore from a backup, use the command:

```bash
docker exec -it longvinter-server restore
```

> [!IMPORTANT]
> If docker restart is not set to policy `always` or `unless-stopped` then the server will shutdown and will need to be
> manually restarted.
>
> The example docker run command and docker compose file in [How to Use](#how-to-use) already uses the needed policy.

## Manually restore from a backup

> [!WARNING]
> Please confirm when your last save was.
>
> It is not automatically saved when you shut down the server.

Locate the backup you want to restore in `/data/Longvinter/backups/` and decompress it.
Need to stop the server before task.

```bash
docker compose down
```

Delete the old saved data folder located at `data/Longvinter/Saved/`.

Copy the contents of the newly decompressed saved data folder `Saved/` to `data/Longvinter/Saved/`.

Restart the game. (If you are using Docker Compose)

```bash
docker compose up -d
```

## Configuring Automatic Backups with Cron

Set BACKUP_ENABLED enable or disable automatic backups (Default is enabled)

BACKUP_CRON_EXPRESSION is a cron expression, in a Cron-Expression you define an interval for when to run jobs.
This is affected by the environment variable TZ value.

> [!TIP]
> This image uses Supercronic for crons
> see [supercronic](https://github.com/aptible/supercronic#crontab-format)
> or
> [Crontab Generator](https://crontab-generator.org).

Example Usage: If BACKUP_CRON_EXPRESSION to `0 2 * * *`, the backup script will run every day at 2:00 AM.
The default is set to run at midnight every night.

## Configuring Automatic Updates with Cron

To be able to use automatic Updates with this Server the following environment variables have to be set to `true`:

- AUTO_UPDATE_ENABLED
- UPDATE_ON_BOOT (default is enabled)

> [!IMPORTANT]
>
> If docker restart is not set to policy `always` or `unless-stopped` then the server will shutdown and will need to be
> manually restarted.
>
> The example docker run command and docker compose file in [How to Use](#how-to-use) already uses the needed policy.

AUTO_UPDATE_CRON_EXPRESSION is a cron expression, in a Cron-Expression you define an interval for when to run jobs.

> [!TIP]
> This image uses Supercronic for crons
> see [supercronic](https://github.com/aptible/supercronic#crontab-format)
> or
> [Crontab Generator](https://crontab-generator.org).

Set AUTO_UPDATE_CRON_EXPRESSION to change the default schedule.

## Editing Server Settings

### With Environment Variables

> [!IMPORTANT]
>
> These Environment Variables/Settings are subject to change since the game is still in beta.

Used with [environment variables](#environment-variables).

| Variable              | Info                                                                                                                                                                            | Default Value                 | Allowed Values                                                   |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|------------------------------------------------------------------|
| CFG_SERVER_NAME       | Setting the server name that is displayed in the server list.                                                                                                                   | Unnamed Island                | "string"                                                         |
| CFG_MAX_PLAYERS       | The maximum amount of players the server will allow at the same time.                                                                                                           | 32                            | 1-?                                                              |
| CFG_SERVER_MOTD       | A Message Of The Day that will be displayed to the player.                                                                                                                      | Welcome to Longvinter Island! | "string"                                                         |
| CFG_PASSWORD          | Use this setting to require a password to join the server.                                                                                                                      | _(empty)_                     | "string"                                                         |
| CFG_COMMUNITY_WEBSITE | When the server or community has a website, enter it here to display it to the player.                                                                                          | www\.longvinter\.com          | `<example.com>`, `http://<example.com>`, `https://<example.com>` |
| CFG_COOP_PLAY         | When this setting is set to "true", Co-op Play will be enabled on the server. Set to "false" to disable PvP.                                                                    | false                         | true/false                                                       |
| CFG_COOP_SPAWN        | All players will spawn here. (It only works when "CFG_COOP_PLAY" is "true".)                                                                                                    | 0                             | 0(West), 1(South), 2(East). (I haven't checked it out)           |
| CFG_SERVER_TAG        | Server tag that can be used to search for the server.                                                                                                                           | None                          | "string"                                                         |
| CFG_ADMIN_STEAM_ID    | Add the SteamID64 values for the players that have admin rights to this setting. When there are multiple admins, add the SteamID64 values to this setting separated by a space. | _(empty)_                     | 0-9, a-f, " "(Space)                                             |
| CFG_ENABLE_PVP        | When this setting is set to "true", PvP will be enabled on the server. Set to "false" to disable PvP.                                                                           | true                          | true/false                                                       |
| CFG_TENT_DECAY        | When this setting is set to "true", tents will decay and be destroyed after 48 hours unless they are upgraded to a house.                                                       | true                          | true/false                                                       |
| CFG_MAX_TENTS         | Maximum number of tents/houses each player can have placed in the world at a time.                                                                                              | 2                             | 1~?                                                              |

### Manually

When the server starts, a `Game.ini` file will be created in the following location: `<mount_folder>/Longvinter/Saved/Config/LinuxServer/Game.ini`

s
But if the DISABLE_GENERATE_SETTINGS value is set to 'true', the file can be modified and set directly.

> [!IMPORTANT]
> Changes can only be made to `Game.ini` while the server is off.
>
> Any changes made while the server is live will be overwritten when the server stops.

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

## Locking Specific Game Version

> [!WARNING]
> Downgrading to a lower game version is possible, but it is unknown what impact it will have on existing saves.
>
> **Please do so at your own risk!**

If **TARGET_COMMIT_ID** environment variable is set, will lock server version to specific commit.
The Commit ID is a hexadecimal value found on page <https://github.com/Uuvana-Studios/longvinter-linux-server/commits/main/>
and must be set to at least 4 digits.
