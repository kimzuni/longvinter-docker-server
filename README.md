# Longvinter Dedicated Server Docker
[English](/README.md) | [한국어](/README-kr.md)

This is a Docker container to help you get started with hosting your own Longvinter dedicated server.

This Docker container has been tested and will work on the following OS:
- Windows 11 AMD64 (WSL 2)
- Ubuntu 22.04 AMD64
- Ubuntu 22.04 ARM64 (Oracle Cloud)

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
version: "3.9"
services:
  longvinter-server:
    container_name: longvinter-server
    image: kimzuni/longvinter-docker-server
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

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called .env file. Modify it to your needs, check out the [environment variables](#environment-variables) section to check the correct values. Modify your [docker-compose.yml](/docker-compose.yml) to this:

```yml
version: "3.9"
services:
  longvinter-server:
    container_name: longvinter-server
    image: longvinter-docker-server
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

As an alternative, you can copy the [.env.example](/.env.example) file to a new file called .env file. Modify it to your needs, check out the [environment variables](#environment-variables) section to check the correct values. Change your docker run command to this:

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
You can use the following values to change the settings of the server on boot. It is highly recommended you set the following environment values before starting the server:
- PORT
- QUERY_PORT

| Variable                                | Info                                                                                                                                                                                                                                          | Default Value                  |
|-----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------|
| TZ                                      | Timezone used for server. (Not applicable to Log)                                                                                                                                                                                             | UTC                            |
| PORT                                    | Game port that the server will expose.                                                                                                                                                                                                        | 7777                           |
| QUERY_PORT                              | Query port used to communicate with Steam servers.                                                                                                                                                                                            | 27016                          |
| PUID                                    | The uid of the user the server should run as.                                                                                                                                                                                                 | 1000                           |
| PGID                                    | The gid of the user the server should run as.                                                                                                                                                                                                 | 1000                           |
| UPDATE_ON_BOOT                          | Update the server when the docker container starts.                                                                                                                                                                                           | true                           |
| DISCORD_WEBHOOK_URL                     | Discord webhook url found after creating a webhook on a discord server.                                                                                                                                                                       | _(empty)_                      |
| DISCORD_SUPPRESS_NOTIFICATIONS          | Enables/Disables `@silent` messages for the server messages.                                                                                                                                                                                  | _(empty)_                      |
| DISCORD_CONNECT_TIMEOUT                 | Discord command initial connection timeout.                                                                                                                                                                                                   | 30                             |
| DISCORD_MAX_TIMEOUT                     | Discord total hook timeout.                                                                                                                                                                                                                   | 30                             |
| DISCORD_PRE_INSTALL_MESSAGE             | Discord message sent when server begins installing.                                                                                                                                                                                           | Server is installing...        |
| DISCORD_PRE_INSTALL_MESSAGE_ENABLED     | If the Discord message is enabled for this message.                                                                                                                                                                                           | true                           |
| DISCORD_PRE_INSTALL_MESSAGE_URL         | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                                                                                                                            | _(empty)_                      |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE         | Discord message sent when server begins updating.                                                                                                                                                                                             | Server is updating...          |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED | If the Discord message is enabled for this message.                                                                                                                                                                                           | true                           |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL     | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                                                                                                                            | _(empty)_                      |
| DISCORD_PRE_START_MESSAGE               | Discord message sent when server begins to start.                                                                                                                                                                                             | Server has been started!       |
| DISCORD_PRE_START_MESSAGE_ENABLED       | If the Discord message is enabled for this message.                                                                                                                                                                                           | true                           |
| DISCORD_PRE_START_MESSAGE_URL           | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                                                                                                                            | _(empty)_                      |
| DISCORD_PRE_SHUTDOWN_MESSAGE            | Discord message sent when server begins to shutdown.                                                                                                                                                                                          | Server is shutting down...     |
| DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED    | If the Discord message is enabled for this message.                                                                                                                                                                                           | true                           |
| DISCORD_PRE_SHUTDOWN_MESSAGE_URL        | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                                                                                                                            | _(empty)_                      |
| DISCORD_POST_SHUTDOWN_MESSAGE           | Discord message sent when server begins to shutdown.                                                                                                                                                                                          | Server is stopped!             |
| DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED   | If the Discord message is enabled for this message.                                                                                                                                                                                           | true                           |
| DISCORD_POST_SHUTDOWN_MESSAGE_URL       | Discord Webhook URL for this message. (if left empty will use DISCORD_WEBHOOK_URL)                                                                                                                                                            | _(empty)_                      |
| DISCORD_SERVER_INFO_MESSAGE_ENABLE      | Send the server settings with DISCORD_PRE_START_MESSAGE.                                                                                                                                                                                      | true                           |
| DISCORD_SERVER_INFO_MESSAGE_WITH_IP     | Send the server IP and Port with server info. This is required for direct connection.                                                                                                                                                         | false                          |
| ARM_COMPATIBILITY_MODE                  | Switches the compatibility layer from Box86 to QEMU when executing steamcmd for server updates. This setting is only applicable for ARM64 hosts.                                                                                              | false                          |

## Configuring the Server Settings
Used with [environment variables](#environment-variables).

| Variable              | Info                                                                                                                                                                                                                                           | Default Value                 |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| CFG_SERVER_NAME       | Setting the server name that is displayed in the server list.                                                                                                                                                                                  | Unnamed Island                |
| CFG_MAX_PLAYERS       | The maximum amount of players the server will allow at the same time.                                                                                                                                                                          | 32                            |
| CFG_SERVER_MOTD       | A Message Of The Day that will be displayed to the player.                                                                                                                                                                                     | Welcome to Longvinter Island! |
| CFG_PASSWORD          | Use this setting to require a password to join the server.                                                                                                                                                                                     | _(empty)_                     |
| CFG_COMMUNITY_WEBSITE | When the server or community has a website, enter it here to display it to the player.                                                                                                                                                         | www.longvinter.com            |
| CFG_COOP_PLAY         | When this setting is set to "true", Co-op Play will be enabled on the server. Set to "false" to disable PvP.                                                                                                                                   | false                         |
| CFG_COOP_SPAWN        | All players will spawn here. (It only works when "CFG_COOP_PLAY" is "true".)                                                                                                                                                                   | 0                             |
| CFG_SERVER_TAG        | Server tag that can be used to search for the server.                                                                                                                                                                                          | None                          |
| CFG_ADMIN_STEAM_ID    | Add the SteamID64 values for the players that have admin rights to this setting. When there are multiple admins, add the SteamID64 values to this setting separated by a space.                                                                | _(empty)_                     |
| CFG_ENABLE_PVP        | When this setting is set to "true", PvP will be enabled on the server. Set to "false" to disable PvP.                                                                                                                                          | true                          |
| CFG_TENT_DECAY        | When this setting is set to "true", tents will decay and be destroyed after 48 hours unless they are upgraded to a house.                                                                                                                      | true                          |
| CFG_MAX_TENTS         | Maximum number of tents/houses each player can have placed in the world at a time.                                                                                                                                                             | 2                             |

**Note**: The value of `CFG_COOP_SPAWN` is expected to be: 0(West), 1(South), 2(East). (I haven't checked it out)

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



# Thanks to!
- [Uuvana-Studios/longvinter-docker-server](https://github.com/Uuvana-Studios/longvinter-docker-server)
- [thijsvanloef/palworld-docker-server](https://github.com/thijsvanloef/palworld-server-docker)

# To do List
- Update
- Backup
- Restore
