# 롱빈터 전용 서버 도커

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

[롱빈터](https://store.steampowered.com/app/1635450/Longvinter/)
전용 서버를 호스팅할 수 있는 도커 컨테이너입니다.

이 소스 코드는
[thijsvanloef/palworld-server-docker](https://github.com/thijsvanloef/palworld-server-docker)
저장소를 기반으로
[Uuvana-Studios/longvinter-docker-server](https://github.com/Uuvana-Studios/longvinter-docker-server)
저장소를 참고하여 작성되었습니다.

해당 도커 컨테이너는 아래 운영체제에서 테스트되었습니다.

- Windows 11
- Ubuntu 22.04

또한 `x64`, `ARM64` 두 아키텍처에서 모두 정상적으로 작동하는 것을 확인했습니다.

> [!WARNING]
> 현재 롱빈터에서 RCON을 지원하지 않기 때문에 관련된 모든 기능이 교체 및 제거되었습니다.
>
> 따라서 서버를 저장하지 않은 채로 서버 종료, 복구 등의 작업을 진행할 경우
> 약 5분동안 플레이한 내역이 롤백될 수 있음을 알려드립니다.
> (약 5분마다 자동 저장됩니다.)

## 공식 사이트 및 커뮤니티

- [롱빈터](https://www.longvinter.com/)
  - [위키](https://wiki.longvinter.com)
  - [X(트위터)](https://twitter.com/longvinter)
  - [레딧](https://www.reddit.com/r/Longvinter/)
  - [틱톡](https://www.tiktok.com/@longvinter)
  - [인스타그램](https://www.instagram.com/longvintergame)
  - [서버 가이드 문서](https://docs-server.longvinter.com/)
  - [디스코드](https://discord.gg/longvinter)
- [우바나](https://www.uuvana.com/)
  - [X(트위터)](https://twitter.com/uuvanastudios)
  - [유튜브](https://www.youtube.com/@uuvana)
  - [인스타그램](https://www.instagram.com/uuvanastudios/)
  - [이미지 및 로고](https://longvinter.com/press)
  - [포럼](https://forum.uuvana.com/)
  - ~~[FAQ(자주 묻는 질문)](https://contact.uuvana.com/)~~

## 서버 요구사항

> - OS(운영체제): 최소 64비트
> - RAM(램): 최소 2GB

출처: <https://wiki.longvinter.com/server/docker>

## 사용법

[환경 변수](#환경-변수)를 설정할 수 있습니다.

서버를 실행한 후 `docker log longvinter-server` 명령어로 서버 로그를 확인할 수 있습니다.
실시간으로 확인하려면 마지막에 `-f`를 추가해 주세요.

### Docker Compose

아래는 서버 설정에 필요한 [docker-compose.yml](/docker-compose.yml) 예시 파일에서 TZ(타임존) 값을 한국 시간대로 수정한 내용입니다.
서버를 실행하려면 해당 파일을 먼저 작성한 후 파일이 위치한 디렉토리에서 `docker compose up -d` 명령어를 실행해야 합니다.

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
      - "7777:7777/udp"
    environment:
      TZ: "Asia/Seoul"
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
      CFG_SERVER_TAG: "none"
      CFG_ADMIN_STEAM_ID: ""
      CFG_ENABLE_PVP: true
      CFG_TENT_DECAY: true
      CFG_MAX_TENTS: 2
    volumes:
      - ./data:/data
```

위 방법 대신 [.env.example](/.env.example) 파일을 **.env** 파일로 복사한 후 내용을 수정하여 사용할 수도 있습니다.
[환경 변수](#환경-변수)를 참고하여 해당 파일을 필요에 맞게 설정해 주세요.
이 경우 [docker-compose.yml](/docker-compose.yml) 파일은 아래와 같이 수정해야 합니다.

```yml
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
      - "7777:7777/udp"
    env_file:
      - .env
    volumes:
      - ./data:/data
```

### Docker Run

`docker compose` 대신 `docker run` 명령어를 사용할 수도 있습니다. 아래 명령어 실행 시 바로 서버가 실행됩니다.

```bash
docker run -d \
    --name longvinter-server \
    -p 7777:7777/udp \
    -v ./data:/data/ \
    -e TZ="Asia/Seoul" \
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
    -e CFG_SERVER_TAG="none" \
    -e CFG_ADMIN_STEAM_ID="" \
    -e CFG_ENABLE_PVP=true \
    -e CFG_TENT_DECAY=true \
    -e CFG_MAX_TENTS=2 \
    --restart unless-stopped \
    --stop-timeout 30 \
    kimzuni/longvinter-docker-server:latest
```

위 방법 대신 [.env.example](/.env.example) 파일을 **.env** 파일로 복사한 후 내용을 수정하여 사용할 수도 있습니다.
[환경 변수](#환경-변수)를 참고하여 해당 파일을 필요에 맞게 설정해 주세요.
이 경우 위 명령어 대신 아래 명령어를 실행해야 합니다.

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

### 컨테이너 업데이트 방법

먼저 서버를 실행 중이라면 아래 명령어로 서버를 중지해 주세요.

```bash
docker stop longvinter-server
docker rm longvinter-server
```

그리고 아래 명령어를 실행햐여 설치된 이미지를 제거합니다.

```bash
docker rmi $(docker images | grep -E ^"(ghcr.io\/)?kimzuni/longvinter-docker-server" | awk '{print $3}')
```

마지막으로 `latest` 태그를 이용하여 [Docker Compose](#docker-compose) 또는 [Docker Run](#docker-run)을 실행하면 최신 버전의 컨테이너를 사용할 수 있습니다.

### root 없이 실행하기

고급 유저를 위한 기능입니다.

컨테이너를 실행할 때 해당 이미지의
[기본 사용자를 재정의](https://docs.docker.com/engine/reference/run/#user)할 수 있습니다.

이때 설정한 환경 변수 `PUID` 및 `PGID`의 값은 무시됩니다.

현재 사용자의 UID는 `id -u` 명령어로 확인할 수 있습니다.
현재 사용자의 GID는 `id -g` 명령어로 확인할 수 있습니다.

사용자 및 그룹을 설정하려면 `NUMBERICAL_UID:NUMBERICAL_GID`와 같이 사용해야 합니다.

아래는 UID가 1000, GID가 1001이라고 가정합니다.

- [Docker Run](#docker-run)를 사용할 경우 마지막 줄 위에 `--user 1000:1001`을 추가해야 합니다.
- [Docker Compose](#docker-compose)를 사용할 경우 restart 아래에 `user: 1000:1001`을 추가해야 합니다.

만약 현재 사용자의 UID/GID와 다른 UID/GID 값을 사용하려면 바인딩되는 디렉토리의 소유권을 변경해야 합니다.
`chown UID:GID data/`명령어를 실행하여 소유권을 변경하거나
`chmod o=rwx data/`를 실행하여 모든 사용자가 접근할 수 있도록 해주세요.

## 환경 변수

아래 값들을 사용하여 서버의 설정을 변경할 수 있습니다.
서버를 실행하기 전에 값을 설정해야 적용됩니다.

| 변수명                                      | 설명                                                                                         | 기본값                                                                                               | 설정 가능한 값                                                                                                | 추가된 버전 |
|--------------------------------------------|---------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|-----------|
| TZ                                         | Cron 및 게임 서버에 사용되는 시간대 설정 (로그 파일에는 적용되지 않음)                                   | UTC                                                                                                | [TZ Identifiers](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#Time_Zone_abbreviations) 참고 | 0.1.0     |
| PUID\*                                     | 지정한 값을 가진 UID로 서버 실행                                                                  | 1000                                                                                               | !0                                                                                                         | 0.1.0     |
| PGID\*                                     | 지정한 값을 가진 GID로 서버 실행                                                                  | 1000                                                                                               | !0                                                                                                         | 0.1.0     |
| PORT\*                                     | 서버 게임 포트 번호                                                                             | 7777                                                                                               | 1024-65535                                                                                                 | 0.1.0     |
| UPDATE_ON_BOOT\*\*                         | 서버 시작 시 자동으로 서버 업데이트 진행                                                            | true                                                                                               | true/false                                                                                                 | 0.1.0     |
| BACKUP_ENABLED                             | 자동 백업 할성화                                                                               | true                                                                                               | true/false                                                                                                 | 0.1.1     |
| BACKUP_CRON_EXPRESSION                     | 자동 백업 빈도 설정                                                                             | 0 0 \* \* \*                                                                                       | 크론식 표현 - [Cron으로 자동 백업 설정하는 방법](#cron으로-자동-백업-설정하는-방법) 참고 바람                              | 0.1.1     |
| DELETE_OLD_BACKUPS                         | 자동 백업 시 오래된 백업 파일 자동 삭제                                                             | false                                                                                             | true/false                                                                                                  | 0.1.1     |
| OLD_BACKUP_DAYS                            | 백업 파일 보관 일수                                                                             | 30                                                                                                | !0                                                                                                          | 0.1.1     |
| AUTO_UPDATE_ENABLED                        | 자동 업데이트 활성화                                                                            | false                                                                                             |  true/false                                                                                                 | 0.1.4     |
| AUTO_UPDATE_CRON_EXPRESSION                | 자동 업데이트 빈도 설정                                                                          | 0 \* \* \* \*                                                                                     | 크론식 표현 - [Cron으로 자동 업데이트 설정하는 방법](#cron으로-자동-업데이트-설정하는-방법) 참고 바람                        | 0.1.4     |
| AUTO_UPDATE_WARN_MINUTES                   | 플레이어에게 알림 전송 후 서버를 업데이트할 때까지 기다리는 시간(분)                                      | 15                                                                                                | !0                                                                                                          | 0.1.4     |
| AUTO_UPDATE_WARN_MESSAGE                   | 플레이어에게 남은 시간을 알리기 위해 전송되는 메시지                                                   | Server will update in `remaining_time` minutes.                                                   | "string"                                                                                                    | 0.1.10    |
| AUTO_UPDATE_WARN_REMAINING_TIMES           | 카운트다운 중 남은 시간이 이 값에 포함되어 있을 경우에만 플레이어에게 알림                                 | 1 5 10                                                                                             | !0 and " "(Space)                                                                                          | 0.1.6     |
| AUTO_REBOOT_ENABLED                        | 자동 재부팅 활성화                                                                              | false                                                                                             | true/false                                                                                                 | 0.1.10    |
| AUTO_REBOOT_CRON_EXPRESSION                | 자동 재부팅 빈도 설정                                                                           | 0 0 \* \* \*                                                                                       | 크론식 표현 - [Cron으로 자동 재부팅 설정하는 방법](#cron으로-자동-재부팅-설정하는-방법) 참고 바람                          | 0.1.10    |
| AUTO_REBOOT_WARN_MINUTES                   | 플레이어에게 알림 전송 후 서버를 재부팅할 때까지 기다리는 시간(분)                                       | 15                                                                                                | !0                                                                                                          | 0.1.4     |
| AUTO_REBOOT_WARN_MESSAGE                   | 플레이어에게 남은 시간을 알리기 위해 전송되는 메시지                                                   | Server will update in `remaining_time` minutes.                                                   | "string"                                                                                                    | 0.1.10    |
| AUTO_REBOOT_WARN_REMAINING_TIMES           | 카운트다운 중 남은 시간이 이 값에 포함되어 있을 경우에만 플레이어에게 알림                                 | 1 5 10                                                                                             | !0 and " "(Space)                                                                                          | 0.1.6     |
| AUTO_REBOOT_EVEN_IF_PLAYERS_ONLINE         | 플레이어가 있을 경우에도 자동 재부팅 진행                                                           | false                                                                                              | true/false                                                                                                 | 0.1.10    |
| BROADCAST_COUNTDOWN_SUSPEND_MESSAGE        | 플레이어가 없어 카운트다운이 중단된 경우 브로드캐스트할 메시지                                           | Suspends countdown because there are no players.                                                   | "string"                                                                                                    | 0.1.10    |
| BROADCAST_COUNTDOWN_SUSPEND_MESSAGE_ENABLE | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.10    |
| TARGET_COMMIT_ID                           | 게임 서버를 지정한 Commit ID를 가진 버전으로 설치 및 실행                                            | _(empty)_                                                                                          | [특정 게임 버전으로 고정](#특정-게임-버전으로-고정) 참고                                                               | 0.1.3     |
| DISCORD_WEBHOOK_URL                        | 디스코드 서버에서 생성한 웹훅 URL                                                                 | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.0     |
| DISCORD_SUPPRESS_NOTIFICATIONS             | 디스코드 메시지 전송 시 멤버들에게 알림을 보내지 않음                                                  | false                                                                                              | true/false                                                                                                  | 0.1.0     |
| DISCORD_CONNECT_TIMEOUT                    | 지정한 시간동안 디스코드 웹훅에 연결할 수 없을 경우 연결 취소                                           | 30                                                                                                 | !0                                                                                                         | 0.1.0     |
| DISCORD_MAX_TIMEOUT                        | 지정한 시간동안 디스코드 메시지가 전송되지 않으면 강제 종료                                             | 30                                                                                                 | !0                                                                                                         | 0.1.0     |
| DISCORD_PRE_INSTALL_MESSAGE                | 서버 설치 전 전송되는 디스코드 메시지                                                              | Server is installing...                                                                            | "string"                                                                                                    | 0.1.0     |
| DISCORD_PRE_INSTALL_MESSAGE_ENABLED        | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.0     |
| DISCORD_PRE_INSTALL_MESSAGE_URL            | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                    | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.0     |
| DISCORD_POST_INSTALL_MESSAGE               | 서버 설치 후 전송되는 디스코드 메시지                                                              | Server install complete!                                                                           | "string"                                                                                                    | 0.1.2     |
| DISCORD_POST_INSTALL_MESSAGE_ENABLED       | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.2     |
| DISCORD_POST_INSTALL_MESSAGE_URL           | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                    | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.2     |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE            | 서버 업데이트 전 전송되는 디스코드 메시지                                                           | Server is updating...                                                                              | "string"                                                                                                    | 0.1.0     |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED    | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.0     |
| DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL        | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                    | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.0     |
| DISCORD_POST_UPDATE_BOOT_MESSAGE           | 서버 업데이트 후 전송되는 디스코드 메시지                                                           | Server update complete!                                                                            | "string"                                                                                                    | 0.1.2     |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED   | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.2     |
| DISCORD_POST_UPDATE_BOOT_MESSAGE_URL       | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                    | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.2     |
| DISCORD_PRE_START_MESSAGE                  | 서버 시작 시 전송되는 디스코드 메시지                                                              | Server has been started!                                                                           | "string"                                                                                                    | 0.1.0     |
| DISCORD_PRE_START_MESSAGE_ENABLED          | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.0     |
| DISCORD_PRE_START_MESSAGE_URL              | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                    | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.0     |
| DISCORD_PRE_START_MESSAGE_WITH_SERVER_INFO | 서버 시작 메시지 전송 시 서버 설정 내용을 같이 전송                                                   | true                                                                                               | true/false                                                                                                  | 0.1.1     |
| DISCORD_PRE_START_MESSAGE_WITH_SERVER_IP   | 서버 시작 메시지 전송 시 서버 IP 및 포트 번호를 같이 전송                                             | false                                                                                              | true/false                                                                                                  | 0.1.0     |
| DISCORD_PRE_START_MESSAGE_WITH_DOMAIN      | 서버 시작 메시지 전송 시 도메인 및 포트 번호를 같이 전송 (DISCORD_PRE_START_MESSAGE_WITH_IP 값이 무시됨) | _(empty)_                                                                                          | `example.com`, `http://example.com`, `https://example.com`                                                  | 0.1.11    |
| DISCORD_PRE_SHUTDOWN_MESSAGE               | 서버 종료 전 전송되는 디스코드 메시지                                                              | Server is shutting down...                                                                         | "string"                                                                                                    | 0.1.0     |
| DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED       | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.0     |
| DISCORD_PRE_SHUTDOWN_MESSAGE_URL           | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                    | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.0     |
| DISCORD_POST_SHUTDOWN_MESSAGE              | 서버 종료 후 전송되는 디스코드 메시지                                                              | Server is stopped!                                                                                 | "string"                                                                                                    | 0.1.0     |
| DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED      | 이 값이 `true`인 경우에만 해당 메시지 전송                                                         | true                                                                                               | true/false                                                                                                  | 0.1.0     |
| DISCORD_POST_SHUTDOWN_MESSAGE_URL          | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                    | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.0     |
| DISCORD_PLAYER_JOIN_MESSAGE                | 플레이어가 서버에 접속할 때 전송되는 디스코드 메시지                                                  | `player_name` has joined!                                                                          | "string"                                                                                                    | 0.1.9     |
| DISCORD_PLAYER_JOIN_MESSAGE_ENABLED        | 이 값이 `true`인 경우에만 해당 메시지 전송                                                        | true                                                                                               | true/false                                                                                                  | 0.1.9     |
| DISCORD_PLAYER_JOIN_MESSAGE_URL            | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                   | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.9     |
| DISCORD_PLAYER_LEAVE_MESSAGE               | 플레이어가 서버에서 나갈 때 전송되는 디스코드 메시지                                                  | `player_name` has left.                                                                            | "string"                                                                                                    | 0.1.9     |
| DISCORD_PLAYER_LEAVE_MESSAGE_ENABLED       | 이 값이 `true`인 경우에만 해당 메시지 전송                                                        | true                                                                                               | true/false                                                                                                  | 0.1.9     |
| DISCORD_PLAYER_LEAVE_MESSAGE_URL           | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                   | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.9     |
| DISCORD_PRE_BACKUP_MESSAGE                 | 백업 시작 전 전송되는 메시지                                                                     | Creating backup...                                                                                 | "string"                                                                                                    | 0.1.1     |
| DISCORD_PRE_BACKUP_MESSAGE_ENABLED         | 이 값이 `true`인 경우에만 해당 메시지 전송                                                        | true                                                                                               | true/false                                                                                                  | 0.1.1     |
| DISCORD_PRE_BACKUP_MESSAGE_URL             | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                   | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.1     |
| DISCORD_POST_BACKUP_MESSAGE                | 백업 완료 후 전송되는 메시지                                                                    | Backup created at `file_path`                                                                      | "string"                                                                                                    | 0.1.1     |
| DISCORD_POST_BACKUP_MESSAGE_ENABLED        | 이 값이 `true`인 경우에만 해당 메시지 전송                                                       | true                                                                                               | true/false                                                                                                  | 0.1.1     |
| DISCORD_POST_BACKUP_MESSAGE_URL            | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                  | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.1     |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE          | 오래된 백업 파일 삭제 전 전송되는 메시지                                                          | Removing backups older than `old_backup_days` days                                                 | "string"                                                                                                    | 0.1.1     |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_ENABLED  | 이 값이 `true`인 경우에만 해당 메시지 전송                                                       | true                                                                                               | true/false                                                                                                  | 0.1.1     |
| DISCORD_PRE_BACKUP_DELETE_MESSAGE_URL      | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                  | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.1     |
| DISCORD_POST_BACKUP_DELETE_MESSAGE         | 오래된 백업 파일 삭제 완료 후 전송되는 메시지                                                      | Removed backups older than `old_backup_days` days                                                  | "string"                                                                                                    | 0.1.1     |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_ENABLED | 이 값이 `true`인 경우에만 해당 메시지 전송                                                       | true                                                                                               | true/false                                                                                                  | 0.1.1     |
| DISCORD_POST_BACKUP_DELETE_MESSAGE_URL     | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                  | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.1     |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE          | 오래된 백업 파일 삭제 실패 시 전송되는 메시지                                                      | Unable to delete old backups, OLD_BACKUP_DAYS is not an integer. OLD_BACKUP_DAYS=`old_backup_days` | "string"                                                                                                    | 0.1.1     |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_ENABLED  | 이 값이 `true`인 경우에만 해당 메시지 전송                                                       | true                                                                                               | true/false                                                                                                  | 0.1.1     |
| DISCORD_ERR_BACKUP_DELETE_MESSAGE_URL      | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                  | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.1     |
| DISCORD_BROADCAST_MESSAGE_ENABLE\*\*       | 이 값이 `true`인 경우 브로드캐스트 메시지를 디스코드로 전송                                         | true                                                                                                | true/false                                                                                                  | 0.1.6     |
| DISCORD_BROADCAST_MESSAGE_URL\*            | 해당 메시지를 보낼 디스코드 웹훅 URL (이 값을 비워둘 경우 DISCORD_WEBHOOK_URL 사용)                  | _(empty)_                                                                                          | `https://discord.com/api/webhooks/<webhook_id>`                                                             | 0.1.6     |
| DISABLE_GENERATE_SETTINGS                  | 서버 설정 파일 `Game.ini`에 적용되는 모든 환경 변수 설정 무시 및 기본 값으로 설정                      | false                                                                                               | true/false                                                                                                  | 0.1.1     |
| ENABLE_PLAYER_LOGGING                      | 플레이어가 서버에 접속하거나 나갈 때 알림 활성화 여부                                                | true                                                                                                | true/false                                                                                                  | 0.1.9     |
| PLAYER_LOGGING_POLL_PERIOD                 | 지정한 초마다 플레이어 접속 및 퇴장 체크                                                          | 5                                                                                                   | !0                                                                                                          | 0.1.9     |

\* 설정 권장사항

\*\* 기본 값 사용 권장

### ARM64 전용 환경변수

ARM64 호스트는 아래 변수를 사용하여 서버 설정을 조정할 수 있습니다.
서버 안정성 및 성능 향상을 위한 관련 설정이 포함되어 있습니다.

Box64 구성에 대한 자세한 내용은 해당 공식 문서를 참조해 주세요.

> [!TIP]
> `ARM64_DEVICE`를 장치에 맞게 설정합니다.
> `generic`은 모든 장치에서 작동할 것으로 예상되지만, 장치에 맞는 값으로 변경하면 더 나은 안정성을 얻을 수 있습니다.
> 보다 구체적인 장치의 호환성을 위해
> [기본 이미지 저장소](https://github.com/sonroyaalmerol/steamcmd-arm64)에 Issue를 생성해 주세요.

| 변수명                   | 설명                                                                                                                                      | 기본값    | 설정 가능한 값               | 추가된 버전 |
|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------|---------|---------------------------|-----------|
| BOX64_DYNAREC_STRONGMEM | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_strongmem-)] Strong Memory 모델 시뮬레이션 활성화 여부  | 1       | 0, 1, 2, 3                | 0.3.0     |
| BOX64_DYNAREC_BIGBLOCK  | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_bigblock-)] Box64의 Dynarec 빌딩 BigBlock 활성화 여부 | 1       | 0, 1, 2, 3                | 0.3.0     |
| BOX64_DYNAREC_SAFEFLAGS | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_safeflags-)] CALL/RET 연산자 코드의 플래그 처리         | 1       | 0, 1, 2                   | 0.3.0     |
| BOX64_DYNAREC_FASTROUND | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_fastround-)] 정밀한 x86 반올림 생성 활성화 여부          | 1       | 0, 1                      | 0.3.0     |
| BOX64_DYNAREC_FASTNAN   | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_fastnan-)] -NAN 생성 활성화 여부                      | 1       | 0, 1                      | 0.3.0     |
| BOX64_DYNAREC_X87DOUBLE | [[Box64 config](https://github.com/ptitSeb/box64/blob/main/docs/USAGE.md#box64_dynarec_x87double-)] x87 에뮬레이션용 Double 사용 강제 여부     | 0       | 0, 1                      | 0.3.0     |
| ARM64_DEVICE            | 호스트 디바이스를 기반으로 사용할 Box64 빌드를 지정하십시오. 이 설정은 ARM64 호스트에만 적용 가능합니다.                                                    | generic | generic, m1, rpi5, adlink | 0.3.0     |

### 제거된 환경 변수

<!-- markdownlint-disable-next-line -->
<details><summary>목록 보기</summary>

| 변수명                               | 사용 가능한 버전   | 사유 | 대체된 변수명                                  |
|-------------------------------------|----------------|-----|----------------------------------------------|
| DISCORD_SERVER_INFO_MESSAGE_ENABLE  | 0.1.0          | 오타 | DISCORD_PRE_START_MESSAGE_WITH_GAME_SETTINGS |
| DISCORD_SERVER_INFO_MESSAGE_ENABLED | 0.1.1 ~ 0.1.10 | 수정 | DISCORD_PRE_START_MESSAGE_WITH_GAME_SETTINGS |
| DISCORD_SERVER_INFO_MESSAGE_WITH_IP | 0.1.0 ~ 0.1.10 | 수정 | DISCORD_PRE_START_MESSAGE_WITH_SERVER_IP     |
| BROADCAST_COUNTDOWN_MTIMES          | 0.1.6 ~ 0.1.9  | 수정 | BROADCAST_COUNTDOWN_REMAINING_TIMES          |
| ARM_COMPATIBILITY_MODE              | 0.1.0 ~ 0.2.0  | 제거 |                                              |

</details>

### 게임 포트

| 포트  | 설명           |
|------|---------------|
| 7777 | 게입 포트 (UDP) |

## 브로드캐스트

서버 자동 업데이트/재부팅 전 카운트다운에 사용됩니다.

> [!IMPORTANT]
> 게임 서버에서 RCON을 지원하지 않아 게임 내 메시지를 띄울 수 없기 때문에
> 해당 메시지를 디스코드로 전송합니다.
>
> [브로드캐스트 메시지를 디스코드로 전송](#브로드캐스트-메시지를-디스코드로-전송) 참고 바람

### 수동 브로드캐스트

아래 명령어를 사용하여 수동으로 브로드캐스트가 가능합니다.

```bash
docker exec longvinter-server broadcast "Message" COLOR
```

색상은
$\color{#1132D8}Blue$(기본값),
$\color{#E8D44F}Yellow$,
$\color{#D85311}Orange$,
$\color{#DF0000}Red$,
$\color{#00CC00}Green$
중 선택할 수 있으며, 대/소문자를 구분하지 않습니다.

색상은 메시지를 디스코드로 전송할 때 사용됩니다. [브로드캐스트 메시지를 디스코드로 전송](#브로드캐스트-메시지를-디스코드로-전송) 참고 바람

## 백업 생성

> [!WARNING]
> 마지막 저장이 언제였는지 확인해 주세요.
>
> 백업 실행 시 마지막으로 저장된 시점을 백업합니다.

아래 명령어를 실행하면 백업이 진행됩니다.

```bash
docker exec longvinter-server backup
```

백업 완료 시 `/data/Longvinter/backups/`에 압축 파일이 생성됩니다.

## 백업 파일을 이용한 복원

> [!WARNING]
> 마지막 저장이 언제였는지 확인해 주세요.
>
> 만약 복구에 실패할 경우 마지막 저장 지점으로 롤백됩니다.

아래 명령어를 실행하면 복구가 진행됩니다.

```bash
docker exec -it longvinter-server restore
```

> [!IMPORTANT]
> 도커 재시작 옵션이 `always` 또는 `unless-stopped`로 설정되어 있어야 합니다.
> 그렇지 않으면 서버가 종료된 후 수동으로 서버를 다시 올려야 합니다.
>
> 참고로 [사용법](#사용법)에 기재된 `docker compose` 및 `docker run` 명령어의 예시에는 해당 설정이 적용되어 있습니다.

## 수동 복원

> [!WARNING]
> 마지막 저장이 언제였는지 확인해 주세요.
>
> 서버를 종료할 때 서버가 자동으로 저장되지 않습니다.

먼저 복구할 백업 파일을 `/data/Longvinter/backups/`에서 찾아 압축을 해제합니다.
그리고 복구하기 전 서버를 중지해야 합니다.

```bash
docker compose down
```

`data/Longvinter/Saved/`에 저장된 디렉토리들을 모두 삭제합니다.

위에서 압축을 해제한 `Saved/`에 있는 내 모든 디렉토리를 `data/Longvinter/Saved/`에 복사합니다.

복사가 완료되었으면 서버를 다시 시작합니다.

```bash
docker compose up -d
```

## Cron으로 자동 백업 설정하는 방법

자동 백업을 사용하려면 환경 변수 BACKUP_ENABLED 값이 `true`로 설정되어 있어야 합니다. (기본값: `true`)

BACKUP_CRON_EXPRESSION는 크론식으로, 작업을 실행할 시간 또는 주기를 설정할 수 있습니다.

> [!TIP]
> 이 이미지는 Supercronic으로 Cron을 사용합니다.
> 자세한 설정 방법은 [supercronic](https://github.com/aptible/supercronic#crontab-format)
> 또는
> [Crontab Generator](https://crontab-generator.org)를 참고해 주세요.

만약 BACKUP_CRON_EXPRESSION 값을 `0 2 * * *`로 설정할 경우 매일 오전 2시에 백업이 진행됩니다.
이는 환경 변수 TZ 값의 영향을 받으며, 기본값은 매일 밤 자정에 실행되도록 설정되어 있습니다.

## Cron으로 자동 업데이트 설정하는 방법

자동 업데이트를 사용하려면 아래 환경 변수 모두 true로 설정해야 합니다.

- AUTO_UPDATE_ENABLED (기본값: `false`)
- UPDATE_ON_BOOT (기본값: `true`)

> [!IMPORTANT]
>
> 도커 재시작 옵션이 `always` 또는 `unless-stopped`로 설정되어 있어야 합니다.
> 그렇지 않으면 서버가 종료된 후 수동으로 서버를 다시 올려야 합니다.
>
> 참고로 [사용법](#사용법)에 기재된 `docker compose` 및 `docker run` 명령어의 예시에는 해당 설정이 적용되어 있습니다.

AUTO_UPDATE_CRON_EXPRESSION는 크론식으로, 작업을 실행할 시간 또는 주기를 설정할 수 있습니다.

> [!TIP]
> 이 이미지는 Supercronic으로 Cron을 사용합니다.
> 자세한 설정 방법은 [supercronic](https://github.com/aptible/supercronic#crontab-format)
> 또는
> [Crontab Generator](https://crontab-generator.org)를 참고해 주세요.

만약 AUTO_UPDATE_CRON_EXPRESSION 값을 `0 2 * * *`로 설정할 경우 매일 오전 2시에 업데이트가 진행됩니다.
이는 환경 변수 TZ 값의 영향을 받으며, 기본값은 매 시간 정시에 실행되도록 설정되어 있습니다.

## Cron으로 자동 재부팅 설정하는 방법

자동 백업을 사용하려면 환경 변수 AUTO_REBOOT_ENABLED 값이 `true`로 설정되어 있어야 합니다. (기본값: `false`)

> [!IMPORTANT]
>
> 도커 재시작 옵션이 `always` 또는 `unless-stopped`로 설정되어 있어야 합니다.
> 그렇지 않으면 서버가 종료된 후 수동으로 서버를 다시 올려야 합니다.
>
> 참고로 [사용법](#사용법)에 기재된 `docker compose` 및 `docker run` 명령어의 예시에는 해당 설정이 적용되어 있습니다.

AUTO_REBOOT_CRON_EXPRESSION는 크론식으로, 작업을 실행할 시간 또는 주기를 설정할 수 있습니다.

> [!TIP]
> 이 이미지는 Supercronic으로 Cron을 사용합니다.
> 자세한 설정 방법은 [supercronic](https://github.com/aptible/supercronic#crontab-format)
> 또는
> [Crontab Generator](https://crontab-generator.org)를 참고해 주세요.

만약 AUTO_REBOOT_CRON_EXPRESSION 값을 `0 2 * * *`로 설정할 경우 매일 오전 2시에 재부팅이 진행됩니다.
이는 환경 변수 TZ 값의 영향을 받으며, 기본값은 매일 밤 자정에 실행되도록 설정되어 있습니다.

## 서버 설정 변경

### 서버 관련 환경 변수

> [!IMPORTANT]
>
> 게임이 아직 베타 버전이기 때문에 해당 환경 변수 및 설정은 변경될 수 있습니다.

[환경 변수](#환경-변수)와 함께 사용되는 설정입니다.

| 변수                                | 설명                                                       | 기본값                         | 설정 가능한 값                                                     |
|------------------------------------|-----------------------------------------------------------|-------------------------------|-----------------------------------------------------------------|
| CFG_SERVER_NAME                    | 비공식 서버 목록에 표시할 이름 설정                              | Unnamed Island                | "string"                                                         |
| CFG_SERVER_MOTD                    | 섬 곳곳의 표지판에 표시되는 오늘의 메시지 설정                     | Welcome to Longvinter Island! | "string"                                                         |
| CFG_MAX_PLAYERS                    | 동시에 접속할 수 있는 최대 플레이어 수 설정                       | 32                            | 1~                                                               |
| CFG_PASSWORD                       | 서버 비밀번호 설정                                           | _(empty)_                     | "string"                                                         |
| CFG_COMMUNITY_WEBSITE              | 서버 목록 및 게임 내에서 표시되는 URL                           | www\.longvinter\.com          | `example.com`, `http://example.com`, `https://example.com/path`  |
| CFG_SERVER_TAG                     | 서버 검색을 위한 태그 추가                                    | none                          | "string"                                                         |
| CFG_COOP_PLAY                      | 협동 플레이 활성화 (CFG_ENABLE_PVP가 false로 설정되어 있어야 함) | false                         | true/false                                                       |
| CFG_COOP_SPAWN                     | 협동 플레이 스폰 지점 설정                                    | 0                             | 0(West), 1(South), 2(East). (확인 필요)                            |
| CFG_CHECK_VPN                      | VPN 연결 차단                                              | true                          | true/false                                                       |
| CFG_CHEST_RESPAWN_TIME             | 전리품 상자의 최대 리스폰 시간(초) 설정                         | 600                           | ?~                                                                |
| CFG_DISABLE_WANDERING_TRADERS      | 떠돌이 상인 스폰 비활성화                                     | false                         | true/false                                                       |
| CFG_SERVER_REGION                  | 서버 브라우저 내 지정한 국가 목록에 서버 표시                     | _(empty)_                     | AS, NA, SA, EU, OC, AF, AN or nothing                            |
| CFG_ADMIN_STEAM_ID                 | 해당 EOSID 값을 가진 플레이어를 관리자로 설정 (인게임에서 확인 가능) | _(empty)_                     | 0-9, a-f, " "(Space)                                             |
| CFG_ENABLE_PVP                     | PvP 활성화                                                | true                          | true/false                                                       |
| CFG_TENT_DECAY                     | 텐트 자동 철거 활성화                                        | true                          | true/false                                                       |
| CFG_MAX_TENTS                      | 플레이어가 서버에 설치할 수 있는 최대 텐트 수 설정                 | 2                             | 1~                                                               |
| CFG_HARDCORE                       | 하드코어 모드 활성화                                         | false                         | true/false                                                       |
| CFG_MONEY_DROP_MULTIPLIER\*        | 사망 시 MK 드랍률                                          | 0.0                           | 0.0~1.0                                                          |
| CFG_WEAPON_DAMAGE_MULTIPLIER\*     | 무기 데미지 비율                                           | 1.0                           | 0.0~                                                             |
| CFG_ENERGY_DRAIN_MULTIPLIER\*      | 에너지 소비율                                             | 1.0                           | 0.0~                                                             |
| CFG_PRICE_FLUCTUATION_MULTIPLIER\* | 아이템 가격 변동률                                         | 1.0                           | 0.0~                                                             |

\* 하드코어 모드에서만 적용됨

### 수동 설정

서버가 시작된 후 `<mount_folder>/Longvinter/Saved/Config/LinuxServer/` 폴더 내 `Game.ini` 파일이 생성됩니다.
기본적으로 `Game.ini` 파일은 [위 환경 변수](#서버-관련-환경-변수)들로 구성되지만
DISABLE_GENERATE_SETTINGS 값을 `true`로 설정할 경우에는 직접 파일을 수정하여 설정할 수 있습니다.

> [!IMPORTANT]
> 서버가 중지되어 있을 때만 `Game.ini` 파일을 변경할 수 있습니다.
>
> 서버가 실행 중이라면 중지할 때 해당 파일을 덮어쓰기 때문에 서버를 중지한 후 수정해야 합니다.

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

### 브로드캐스트 메시지를 디스코드로 전송

> [!IMPORTANT]
>
> 게임 서버에서 RCON을 지원하지 않아 게임 내 메시지를 띄울 수 없기 때문에
> 해당 기능 사용을 권장합니다.

브로드캐스트 메시지를 디스코드로 전송하려면 환경 변수 DISCORD_BROADCAST_MESSAGE_ENABLE 값이 `true`로 설정되어 있어야 합니다. (기본값: `true`)

환경 변수 DISCORD_BROADCAST_MESSAGE_URL 값을 설정하여 브로드캐스트 전용 채널을 사용할 수 있으며,
설정하지 않으면 DISCORD_WEBHOOK_URL 값이 사용됩니다.

## 특정 게임 버전으로 고정

> [!WARNING]
> 해당 설정 사용 시 서버를 구버전으로 설치 및 다운그레이드를 진행합니다. 이 설정으로 인해 어떠한 문제가 발생할 지 알 수 없음을 알려드립니다.
>
> **꼭 필요한 경우에만 사용해 주세요!**

환경 변수 **TARGET_COMMIT_ID** 값이 설정된 경우 서버 버전이 해당 커밋의 버전으로 실행됩니다.
Commit ID는 <https://github.com/Uuvana-Studios/longvinter-linux-server/commits/main/> 페이지에서 확인할 수 있는 16진수 값이며,
4자리 이상이 필요합니다.
