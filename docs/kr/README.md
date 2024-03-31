# 롱빈터 전용 서버 도커

[![Release](https://img.shields.io/github/v/release/kimzuni/longvinter-docker-server)](https://github.com/kimzuni/longvinter-docker-server/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Docker Stars](https://img.shields.io/docker/stars/kimzuni/longvinter-docker-server)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![Image Size](https://img.shields.io/docker/image-size/kimzuni/longvinter-docker-server/latest)](https://hub.docker.com/r/kimzuni/longvinter-docker-server/tags)

[![Docker Hub](https://img.shields.io/badge/Docker_Hub-longvinter-blue?logo=docker)](https://hub.docker.com/r/kimzuni/longvinter-docker-server)
[![GHCR](https://img.shields.io/badge/GHCR-longvinter-blue?logo=docker)](https://github.com/kimzuni/longvinter-docker-server/pkgs/container/longvinter-docker-server)

[English](/README.md) | [한국어](/docs/kr/README.md)

도커에 [롱빈터](https://store.steampowered.com/app/1635450/Longvinter/) 전용 서버를 올릴 수 있습니다.

이 소스 코드는 [thijsvanloef/palworld-server-docker](https://github.com/thijsvanloef/palworld-server-docker) 저장소를 기반으로 [Uuvana-Studios/longvinter-docker-server](https://github.com/Uuvana-Studios/longvinter-docker-server) 저장소를 참고하여 작성되었습니다.

빌드된 이미지는 아래 운영체제에서 테스트되었습니다.
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

서버를 실행한 후 `docker log longvinter-server` 명령어로 서버 로그를 확인할 수 있습니다. 실시간으로 확인하려면 마지막에 `-f`를 추가해 주세요.

### Docker Compose
아래는 서버 설정에 필요한 [docker-compose.yml](/docker-compose.yml) 예시 파일에서 TZ 값을 수정한 내용입니다.

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

설정을 마친 후 `docker-compose.yml` 파일이 있는 곳에서 `docker compose up -d` 명령어를 실행해면 서버가 실행됩니다.

### Docker Run
`docker compose` 대신 `docker run` 명령어를 사용할 수도 있습니다. 아래 명령어 실행 시 바로 서버가 실행됩니다.

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

위 방법 대신 [.env.example](/.env.example) 파일을 `.env` 파일로 복사한 후 내용을 수정하여 사용할 수도 있습니다. 이 경우 위 명령어 대신 아래 명령어를 실행해야 합니다.

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

| 변수명                                      | 정보                                                                                                            | 기본값                                                                                              | 설정 가능한 값                                                                                                |
|--------------------------------------------|----------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| TZ                                         | Cron 및 게임 서버에 사용되는 시간대 설정 (로그 파일에는 적용되지 않음)                                                      | UTC                                                                                                | [TZ Identifiers](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_Zone_abbreviations) 참고 |
| PUID\*                                     | 지정한 값을 가진 UID로 서버 실행                                                                                     | 1000                                                                                               | !0                                                                                                         |
| PGID\*                                     | 지정한 값을 가진 GID로 서버 실행                                                                                     | 1000                                                                                               | !0                                                                                                         |
| PORT\*                                     | 서버 게임 포트 번호                                                                                                | 7777                                                                                               | 1024-65535                                                                                                 |
| QUERY_PORT                                 | 스팀 서버와 통신하기 위한 쿼리 포트 번호                                                                               | 27016                                                                                              | 1024-65535                                                                                                 |
| UPDATE_ON_BOOT\*\*                         | 서버 시작 시 자동으로 서버 업데이트 진행                                                                               | true                                                                                               | true/false                                                                                                 |
| BACKUP_ENABLED                             | 일정 시간마다 자동으로 서버 백업 진행                                                                                  | true                                                                                               | true/false                                                                                                 |
| BACKUP_CRON_EXPRESSION                     | 자동 백업 빈도 설정                                                                                                | 0 0 * * *                                                                                         | 크론식 표현 - [Cron으로 자동 백업 설정하는 방법](#cron으로-자동-백업-설정하는-방법) 참고 바람                              |
| DELETE_OLD_BACKUPS                         | 자동 백업 설정 시 오래된 백업 파일 자동 삭제                                                                            | false                                                                                             | true/false                                                                                                 |
| OLD_BACKUP_DAYS                            | 지정한 일수가 지난 백업 파일만 삭제                                                                                    | 30                                                                                                | !0                                                                                                         |
| AUTO_UPDATE_ENABLED                        | 일정 시간마다 자동으로 서버 업데이트 진행                                                                               | false                                                                                              |  true/false                                                                                                |
| AUTO_UPDATE_CRON_EXPRESSION                | 자동 업데이트 빈도 설정                                                                                             | 0 0 * * *                                                                                         | 크론식 표현 - [Cron으로 자동 업데이트 설정하는 방법](#cron으로-자동-업데이트-설정하는-방법) 참고 바람                        |
| AUTO_UPDATE_WARN_MINUTES                   | 지정한 시간(분)이 지난 후 서버 업데이트 진행                                                                           | 30                                                                                                | !0                                                                                                          |
| TARGET_COMMIT_ID                           | 게임 서버를 지정한 Commit ID를 가진 버전으로 설치 및 실행                                                               | _(empty)_                                                                                         | [Target Commit ID](#target-commit-id) 참고                                                                   |
| DISCORD_WEBHOOK_URL                        | 디스코드 서버에서 생성한 웹훅 URL                                                                                    | _(empty)_                                                                                         | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_SUPPRESS_NOTIFICATIONS             | 디스코드 메시지 전송 시 멤버들에게 알림을 보내지 않음                                                                     | false                                                                                             | true/false                                                                                                  |
| DISCORD_CONNECT_TIMEOUT                    | 지정한 시간동안 디스코드 웹훅에 연결할 수 없을 경우 연결 취소                                                              | 30                                                                                                | !0                                                                                                          |
| DISCORD_MAX_TIMEOUT                        | 지정한 시간동안 디스코드 메시지가 전송되지 않으면 강제 종료                                                                | 30                                                                                                | !0                                                                                                          |
| DISCORD_PRE_INSTALL_MESSAGE                | 서버 설치 전 전송되는 메시지                                                                                         | Server is installing...                                                                           | "string"                                                                                                    |
| DISCORD_PRE_INSTALL_MESSAGE_ENABLED        | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                            | true                                                                                              | true/false                                                                                                  |
| DISCORD_PRE_INSTALL_MESSAGE_URL            | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                       | _(empty)_                                                                                         | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_POST_INSTALL_MESSAGE               | 서버 설치 후 전송되는 메시지                                                                                        | Server install complete!                                                                          | "string"                                                                                                    |
| DISCORD_POST_INSTALL_MESSAGE_ENABLED       | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                            | true                                                                                              | true/false                                                                                                  |
| DISCORD_POST_INSTALL_MESSAGE_URL           | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                       | _(empty)_                                                                                         | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE            | 서버 업데이트 전 전송되는 메시지                                                                                     | Server is updating...                                                                             | "string"                                                                                                    |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED    | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                           | true                                                                                              | true/false                                                                                                  |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL        | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                      | _(empty)_                                                                                         | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_POST_UPDATE_BOOT_MESSAGE           | 서버 업데이트 후 전송되는 메시지                                                                                    | Server update complete!                                                                           | "string"                                                                                                    |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED   | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                           | true                                                                                              | true/false                                                                                                  |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_URL       | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                      | _(empty)_                                                                                         | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_PRE_START_MESSAGE                  | 서버 시작 시 전송되는 메시지                                                                                        | Server has been started!                                                                          | "string"                                                                                                    |
| DISCORD_PRE_START_MESSAGE_ENABLED          | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                           | true                                                                                              | true/false                                                                                                  |
| DISCORD_PRE_START_MESSAGE_URL              | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                      | _(empty)_                                                                                         | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_SERVER_INFO_MESSAGE_ENABLED        | 서버 시작 메시지 전송 시 서버 설정 내용을 같이 전송                                                                     | true                                                                                               | true/false                                                                                                  |
| DISCORD_SERVER_INFO_MESSAGE_WITH_IP        | 서버 설정 내용 전송 시 서버 IP 및 포트 번호를 같이 전송                                                                 | false                                                                                              | true/false                                                                                                  |
| DISCORD_PRE_SHUTDOWN_MESSAGE               | 서버 종료 전 전송되는 메시지                                                                                        | Server is shutting down...                                                                         | "string"                                                                                                    |
| DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED       | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                           | true                                                                                               | true/false                                                                                                  |
| DISCORD_PRE_SHUTDOWN_MESSAGE_URL           | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                      | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_POST_SHUTDOWN_MESSAGE              | 서버 종료 후 전송되는 메시지                                                                                        | Server is stopped!                                                                                 | "string"                                                                                                    |
| DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED      | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                           | true                                                                                               | true/false                                                                                                  |
| DISCORD_POST_SHUTDOWN_MESSAGE_URL          | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                      | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_PRE_BACKUP_MESSAGE                 | 백업 시작 전 전송되는 메시지                                                                                       | Creating backup...                                                                                 | "string"                                                                                                    |
| DISCORD_PRE_BACKUP_MESSAGE_ENABLED         | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                           | true                                                                                               | true/false                                                                                                  |
| DISCORD_PRE_BACKUP_MESSAGE_URL             | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                      | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_POST_BACKUP_MESSAGE                | 백업 완료 후 전송되는 메시지                                                                                       | Backup created at `file_path`                                                                      | "string"                                                                                                    |
| DISCORD_POST_BACKUP_MESSAGE_ENABLED        | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                          | true                                                                                               | true/false                                                                                                  |
| DISCORD_POST_BACKUP_MESSAGE_URL            | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                     | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE          | 오래된 백업 파일 삭제 전 전송되는 메시지                                                                             | Removing backups older than `old_backup_days` days                                                 | "string"                                                                                                    |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_ENABLED  | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                          | true                                                                                               | true/false                                                                                                  |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_URL      | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                     | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_POST_BACKUP_DELETE_MESSAGE         | 오래된 백업 파일 삭제 완료 후 전송되는 메시지                                                                         | Removed backups older than `old_backup_days` days                                                  | "string"                                                                                                    |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_ENABLED | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                          | true                                                                                               | true/false                                                                                                  |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_URL     | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                     | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE          | 오래된 백업 파일 삭제 실패 시 전송되는 메시지                                                                         | Unable to delete old backups, OLD_BACKUP_DAYS is not an integer. OLD_BACKUP_DAYS=`old_backup_days` | "string"                                                                                                     |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_ENABLED  | 이 값이 `true`인 경우에만 해당 메시지 전송                                                                          | true                                                                                               | true/false                                                                                                   |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_URL      | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                                     | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                              |
| DISABLE_GENERATE_SETTINGS                  | 서버 설정 파일 `Game.ini`에 적용되는 모든 환경변수 설정 무시 및 기본 값으로 설정                                          | false                                                                                              | true/false                                                                                                   |
| ARM_COMPATIBILITY_MODE                     | 서버 업데이트를 위해 steamcmd를 실행할 때 Box86에서 QEMU로 호환성 계층을 전환합니다. 이 설정은 ARM64 호스트에만 적용 가능합니다. | false                                                                                               | true/false                                                                                                   |

\* 설정 권장사항

\*\* 기본 값 사용을 권장

## Cron으로 자동 백업 설정하는 방법
자동 백업을 사용하려면 환경 변수 BACKUP_ENABLED 값을 `true`로 설정되어 있어야 합니다. (기본값)

> [!TIP]
> 이 이미지는 Supercronic으로 Cron을 사용합니다. 자세한 설정 방법은 [supercronic](https://github.com/aptible/supercronic#crontab-format)
> 또는 [Crontab Generator](https://crontab-generator.org)를 참고해 주세요.

BACKUP_CRON_EXPRESSION 값을 변경하여 원하는 시간 및 주기마다 자동 백업을 진행할 수 있습니다. 기본 값은 매일 밤 자정이며, 환경 변수 TZ 값의 영향을 받습니다.

## Cron으로 자동 업데이트 설정하는 방법
자동 업데이트를 사용하려면 아래 환경 변수 모두 true로 설정해야 합니다.
- AUTO_UPDATE_ENABLED
- UPDATE_ON_BOOT

> [!IMPORTANT]
>
> 자동 업데이트 진행 시 서버가 종료되기 때문에 도커 재시작 옵션이 `always` 또는 `unless-stopped`로 설정되어 있어야 합니다. 그렇지 않으면 수동으로 서버를 다시 올려야 합니다.
>
> 참고로 [사용법](#사용법)에 기재된 `docker compose` 및 `docker run` 예시는 이미 해당 설정이 적용되어 있습니다.

> [!TIP]
> 이 이미지는 Supercronic으로 Cron을 사용합니다. 자세한 설정 방법은 [supercronic](https://github.com/aptible/supercronic#crontab-format)
> 또는 [Crontab Generator](https://crontab-generator.org)를 참고해 주세요.

AUTO_UPDATE_CRON_EXPRESSION 값을 변경하여 원하는 시간 및 주기마다 업데이트를 진행할 수 있습니다. 기본 값은 매일 밤 자정이며, 환경 변수 TZ 값의 영향을 받습니다.

## 서버 설정 내용
[환경 변수](#환경-변수)와 함께 사용할 수 있습니다.

| 변수                   | 정보                                                                            | 기본값                         | 설정 가능한 값                                                     |
|-----------------------|--------------------------------------------------------------------------------|-------------------------------|-----------------------------------------------------------------|
| CFG_SERVER_NAME       | 비공식 서버 목록에 표시되는 서버명                                                    | Unnamed Island                | "string"                                                         |
| CFG_MAX_PLAYERS       | 동시 접속 최대 인원                                                                | 32                            | 1-?                                                              |
| CFG_SERVER_MOTD       | 플레이어가 스폰되는 항구 앞 표지판에 표시되는 오늘의 메시지(Message of the Day)            | Welcome to Longvinter Island! | "string"                                                         |
| CFG_PASSWORD          | 서버 접속을 위한 비밀번호                                                           | _(empty)_                     | "string"                                                         |
| CFG_COMMUNITY_WEBSITE | 게임 내 서버 정보에 표시되는 커뮤니티 및 웹사이트 URL                                    | www.longvinter.com            | `<example.com>`, `http://<example.com>`, `https://<example.com>` |
| CFG_COOP_PLAY         | 협동 플레이 여부 (PvP를 활성화한 경우 이 설정은 무시)                                   | false                         | true/false                                                       |
| CFG_COOP_SPAWN        | 협동 플레이 활성화 시 스폰 장소 지정 (모두 같은 곳에서 스폰)                              | 0                             | 0(West), 1(South), 2(East). (확인 필요)                            |
| CFG_SERVER_TAG        | 서버 검색에 사용되는 태그                                                           | none                          | "string"                                                         |
| CFG_ADMIN_STEAM_ID    | 해당 EOSID(SteamID64) 값을 가진 플레이어를 관리자로 설정 (공백으로 구분하여 여러명 설정 가능) | _(empty)_                     | 0-9, a-f, " "(Space)                                             |
| CFG_ENABLE_PVP        | PvP 활성화 여부                                                                  | true                          | true/false                                                       |
| CFG_TENT_DECAY        | 텐트 자동 철거 활성화 여부                                                          | true                          | true/false                                                       |
| CFG_MAX_TENTS         | 플레이어당 최대로 설치할 수 있는 텐트 및 집의 개수 설정                                   | 2                             | 1~?                                                              |

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

## Target Commit ID
> [!WARNING]
> 해당 설정 사용 시 서버를 구버전으로 설치 및 다운그레이드를 진행합니다. 이 설정으로 인해 어떠한 문제가 발생할 지 알 수 없음을 알려드립니다.
>
> **꼭 필요한 경우에만 사용해 주세요!**

환경 변수 TARGET_COMMIT_ID 값에 특정 버전의 Commit ID을 지정하여 서버를 해당 버전으로 설치 및 다운그레이드하여 실행할 수 있습니다.

Commit ID는 https://github.com/Uuvana-Studios/longvinter-linux-server/commits/main/ 페이지에서 확인할 수 있습니다. (0~9, a~f로 이루어진 16진수 7자리)


# To do List
- Restore
