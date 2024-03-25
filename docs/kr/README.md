# 롱빈터 전용 서버 도커

[![Release](https://img.shields.io/github/v/release/kimzuni/longvinter-docker-server)](https://github.com/kimzuni/longvinter-docker-server/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Docker Stars](https://img.shields.io/docker/stars/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Image Size](https://img.shields.io/docker/image-size/kimzuni/longvinter-docker-server/latest)](https://hub.docker.com/r/kimzuni/longvinter-docker-server/tags)

[![Docker Hub](https://img.shields.io/badge/Docker_Hub-longvinter-blue?logo=docker)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![GHCR](https://img.shields.io/badge/GHCR-longvinter-blue?logo=docker)](https://github.com/kimzuni/longvinter-docker-server/pkgs/container/longvinter-docker-server)

[English](/README.md) | [한국어](/docs/kr/README.md)

도커에 [롱빈터](https://store.steampowered.com/app/1635450/Longvinter/) 전용 서버를 올릴 수 있습니다.

소스 코드는 [thijsvanloef/palworld-docker-server](https://github.com/thijsvanloef/palworld-server-docker)에 [Uuvana-Studios/longvinter-docker-server](https://github.com/Uuvana-Studios/longvinter-docker-server)를 적용하는 것부터 시작되었습니다.


도커 이미지는 아래 운영체제에서 테스트되었습니다.
- Windows 11
- Ubuntu 22.04

## 공식 사이트 및 커뮤니티
- [\[우바나\] FAQ(자주 묻는 질문)](https://contact.uuvana.com/)
- [\[우바나\] 포럼](https://forum.uuvana.com/)
- [\[우바나\] 유튜브](https://www.youtube.com/@uuvana)
- [\[롱빈터\] 서버 가이드 문서](https://docs-server.longvinter.com/)
- [\[롱빈터\] 디스코드](https://discord.gg/longvinter)

## 서버 요구사항
> - OS(운영체제): 최소 64비트
> - RAM(램): 최소 2GB

출처: https://docs-server.longvinter.com

## 사용법
[환경 변수](#환경-변수)를 상황에 맞게 설정한 후 실행해 주세요.

### Docker Compose
아래는 서버 설정에 필요한 [docker-compose.yml](/docker-compose.yml) 예시 파일 내용입니다.

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

위 방법 대신 [.env.example](/.env.example) 파일을 `.env` 파일로 복사한 후 내용을 수정하여 사용할 수도 있습니다. 이 경우 [docker-compose.yml](/docker-compose.yml) 파일은 아래와 같이 수정해야 합니다. 파일명은 꼭 `.env`가 아니여도 상관없습니다.

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

설정을 마친 후 `docker-compose.yml` 파일이 있는 곳에서 `docker compose up -d` 명령어를 실행해야 서버가 도커에 올라갑니다.

### Docker Run
`docker compose` 대신 `docker run`을 사용할 수 있습니다.

```bash
docker run -d \
    --name longvinter-server \
    -p 7777:7777/tcp \
    -p 7777:7777/tcp \
    -p 27016:27016/udp \
    -p 27016:27016/udp \
    -v ./data:/data/ \
    -e TZ="Asia/Seoul" \
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

위 방법 대신 [.env.example](/.env.example) 파일을 `.env` 파일로 복사한 후 내용을 수정하여 사용할 수도 있습니다. 이 경우 아래 명령어를 실행하여 롱빈터 서버를 도커에 올릴 수 있습니다.

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

## 환경 변수
아래는 사용 가능한 환경 변수 목록입니다.

| 변수명                                  | 정보                                                                                                                       | 기본값                          | 설정 가능한 값                                                                                   |
|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------------|--------------------------------|--------------------------------------------------------------------------------------------------|
| TZ                                      | 서버 시간대 설정 (로그 파일에는 적용되지 않음)                                                                                | UTC                            | [참고 바람](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_Zone_abbreviations) |
| PUID\*                                  | 서버가 해당 값을 가진 UID로 실행됩니다.                                                                                       | 1000                           | !0                                                                                               |
| PGID\*                                  | 서버가 해당 값을 가진 GID로 실행됩니다.                                                                                       | 1000                           | !0                                                                                               |
| PORT\*                                  | 서버 개임 포트 번호                                                                                                         | 7777                           | 1024-65535                                                                                        |
| QUERY_PORT                              | 스팀 서버와 통신하기 위한 쿼리 포트 번호                                                                                      | 27016                          | 1024-65535                                                                                        |
| UPDATE_ON_BOOT\*\*                      | 이 설정 값이 `true`인 경우 서버가 시작될 때마다 업데이트를 자동으로 진행합니다.                                                  | true                           | true/false                                                                                       |
| DISCORD_WEBHOOK_URL                     | 디스코드 서버에서 생성한 웹훅 URL                                                                                            | _(empty)_                      | `https://discord.com/api/webhooks/<webhook_id>`                                                   |
| DISCORD_SUPPRESS_NOTIFICATIONS          | 서버 메시지에 대해 `@silent` 메시지를 활성화 및 비활성화합니다.                                                                | false                          | true/false                                                                                        |
| DISCORD_CONNECT_TIMEOUT                 | 지정된 시간동안 디스코드 웹훅에 연결할 수 없을 경우 연결을 취소합니다.                                                          | 30                             | !0                                                                                                |
| DISCORD_MAX_TIMEOUT                     | 지정된 시간동안 작업이 끝나지 않으면 강제로 종료합니다.                                                                        | 30                             | !0                                                                                                |
| DISCORD_PRE_INSTALL_MESSAGE             | 서버 설치를 시작할 때 전송되는 메시지                                                                                         | Server is installing...        | "string"                                                                                          |
| DISCORD_PRE_INSTALL_MESSAGE_ENABLED     | 이 설정 값이 `true`인 경우에만 해당 메시지를 전송합니다.                                                                       | true                           | true/false                                                                                        |
| DISCORD_PRE_INSTALL_MESSAGE_URL         | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 값이 사용됩니다)                                  | _(empty)_                      | `https://discord.com/api/webhooks/<webhook_id>`                                                   |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE         | 서버가 업데이트될 때 전송되는 메시지                                                                                          | Server is updating...          | "string"                                                                                          |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED | 이 설정 값이 `true`인 경우에만 해당 메시지를 전송합니다.                                                                       | true                           | true/false                                                                                        |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL     | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 값이 사용됩니다)                                   | _(empty)_                      | `https://discord.com/api/webhooks/<webhook_id>`                                                  |
| DISCORD_PRE_START_MESSAGE               | 서버가 시작될 때 전송되는 메시지                                                                                              | Server has been started!       | "string"                                                                                         |
| DISCORD_PRE_START_MESSAGE_ENABLED       | 이 설정 값이 `true`인 경우에만 해당 메시지를 전송합니다.                                                                       | true                           | true/false                                                                                       |
| DISCORD_PRE_START_MESSAGE_URL           | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 값이 사용됩니다)                                   | _(empty)_                      | `https://discord.com/api/webhooks/<webhook_id>`                                                  |
| DISCORD_PRE_SHUTDOWN_MESSAGE            | 서버가 종료되기 전에 전송되는 메시지                                                                                           | Server is shutting down...     | "string"                                                                                         |
| DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED    | 이 설정 값이 `true`인 경우에만 해당 메시지를 전송합니다.                                                                        | true                           | true/false                                                                                       |
| DISCORD_PRE_SHUTDOWN_MESSAGE_URL        | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 값이 사용됩니다)                                    | _(empty)_                      | `https://discord.com/api/webhooks/<webhook_id>`                                                 |
| DISCORD_POST_SHUTDOWN_MESSAGE           | 서버가 종료된 후 전송되는 메시지                                                                                               | Server is stopped!             | "string"                                                                                        |
| DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED   | 이 설정 값이 `true`인 경우에만 해당 메시지를 전송합니다.                                                                        | true                           | true/false                                                                                      |
| DISCORD_POST_SHUTDOWN_MESSAGE_URL       | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 값이 사용됩니다)                                   | _(empty)_                      | `https://discord.com/api/webhooks/<webhook_id>`                                                 |
| DISCORD_SERVER_INFO_MESSAGE_ENABLE      | 이 설정 값이 `true`인 경우 시작 메시지(DISCORD_PRE_START_MESSAGE)와 함께 서버 설정 내용을 전송합니다.                            | true                           | true/false                                                                                      |
| DISCORD_SERVER_INFO_MESSAGE_WITH_IP     | 이 설정 값이 `true`인 경우 서버 IP 및 포트 번호를 서버 설정 내용과 함께 전송합니다.                                              | false                          | true/false                                                                                      |
| ARM_COMPATIBILITY_MODE                  | 서버 업데이트를 위해 steamcmd를 실행할 때 Box86에서 QEMU로 호환성 계층을 전환합니다. 이 설정은 ARM64 호스트에만 적용 가능합니다.    | false                          | true/false                                                                                      |

\* 권장사항

\*\* 이 옵션이 어떠한 기능을 하는지 확실히 알고 사용해 주세요.

## 서버 설정 내용
[환경 변수](#환경-변수)와 함께 사용합니다.

| 변수                  | 정보                                                                                                      | 기본값                         | 설정 가능한 값                                                   |
|-----------------------|-----------------------------------------------------------------------------------------------------------|-------------------------------|------------------------------------------------------------------|
| CFG_SERVER_NAME       | 서버 목록에 표시되는 서버명                                                                                 | Unnamed Island                | "string"                                                         |
| CFG_MAX_PLAYERS       | 서버 동시 접속 최대 인원                                                                                    | 32                            | 1-?                                                              |
| CFG_SERVER_MOTD       | 플레이어에게 표시되는 오늘의 메시지(Message of the Day)                                                      | Welcome to Longvinter Island! | "string"                                                         |
| CFG_PASSWORD          | 서버 접속을 위한 비밀번호                                                                                   | _(empty)_                     | "string"                                                         |
| CFG_COMMUNITY_WEBSITE | 서버에서 운영하는 커뮤니티 및 웹사이트 URL                                                                   | www.longvinter.com            | `<example.com>`, `http://<example.com>`, `https://<example.com>` |
| CFG_COOP_PLAY         | 협동 플레이 여부 (PvP를 활성화한 경우 이 설정은 무시됩니다)                                                   | false                         | true/false                                                       |
| CFG_COOP_SPAWN        | 협동 플레이 시 스폰 장소 지정 (CFG_COOP_PLAY 값이 true일 때만 동작합니다)                                     | 0                             | 0(West), 1(South), 2(East). (확인 필요)                           |
| CFG_SERVER_TAG        | 서버 검색에 사용되는 태그                                                                                   | none                          | "string"                                                         |
| CFG_ADMIN_STEAM_ID    | 관리자 권한을 부여할 플레이어의 EOSID(SteamID64) 값을 넣어주세요. 여러명일 경우 공백으로 구분하여 입력해 주세요. | _(empty)_                     | 0-9, a-f, " "(Space)                                             |
| CFG_ENABLE_PVP        | 이 값이 `true`인 경우 PvP를 활성화합니다.                                                                   | true                          | true/false                                                       |
| CFG_TENT_DECAY        | 이 값이 `true`인 경우 텐트를 48시간 내 집으로 업그레이드하지 않으면 파괴됩니다.                                | true                          | true/false                                                       |
| CFG_MAX_TENTS         | 플레이어당 최대로 설치할 수 있는 텐트 및 집의 개수를 설정합니다.                                              | 2                             | 1~?                                                               |

## 디스코드 웹훅 사용법
1. 디스코드 서버 설정에서 웹훅 URL을 생성합니다.
2. 생성한 디스코드 웹훅 URL을 `https://discord.com/api/webhooks/1234567890/abcde`로 가정합니다.

Docker Run 실행 시 사용하는 방법:
```bash
-e DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1234567890/abcde" \
-e DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..." \
```

Docker Compose로 사용하는 방법
```yml
- DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/1234567890/abcde
- DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..."
```



# To do List
- Update
- Backup
- Restore
