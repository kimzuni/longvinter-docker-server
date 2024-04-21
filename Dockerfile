FROM cm2network/steamcmd:root as base-amd64
# Ignoring --platform=arm64 as this is required for the multi-arch build to continue to work on amd64 hosts
# hadolint ignore=DL3029
FROM --platform=arm64 sonroyaalmerol/steamcmd-arm64:root-2024-03-10 as base-arm64

ARG TARGETARCH
# Ignoring the lack of a tag here because the tag is defined in the above FROM lines
# and hadolint isn't aware of those.
# hadolint ignore=DL3006
FROM base-${TARGETARCH}

LABEL maintainer="me@kimzuni.com" \
      name="kimzuni/longvinter-docker-server" \
      github="https://github.com/kimzuni/longvinter-docker-server" \
      dockerhub="https://hub.docker.com/r/kimzuni/longvinter-docker-server" \
      org.opencontainers.image.authors="kimzuni" \
      org.opencontainers.image.source="https://github.com/kimzuni/longvinter-docker-server"

# set envs
# SUPERCRONIC: Latest releases available at https://github.com/aptible/supercronic/releases
# NOTICE: edit SUPERCRONIC_SHA1SUM when using binaries of another version or arch.
ARG SUPERCRONIC_SHA1SUM_ARM64="512f6736450c56555e01b363144c3c9d23abed4c"
ARG SUPERCRONIC_SHA1SUM_AMD64="cd48d45c4b10f3f0bfdd3a57d054cd05ac96812b"
ARG SUPERCRONIC_VERSION="0.2.29"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# update and install dependencies
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
      curl \
      net-tools \
      ca-certificates \
      lib32gcc1-amd64-cross \
      procps=2:4.0.2-3 \
      gettext-base=0.21-12 \
      xdg-user-dirs=0.18-1 \
      jo=1.9-1 \
      jq=1.6-2.1 \
 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
 && apt-get --no-install-recommends  --no-install-suggests -y \
      install git git-lfs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN su steam -c "/home/steam/steamcmd/steamcmd.sh +login anonymous +app_update 1007 +quit"

# install supercronic
ARG TARGETARCH
RUN case ${TARGETARCH} in \
        "amd64") SUPERCRONIC_SHA1SUM=${SUPERCRONIC_SHA1SUM_AMD64} ;; \
        "arm64") SUPERCRONIC_SHA1SUM=${SUPERCRONIC_SHA1SUM_ARM64} ;; \
    esac \
    && curl -sfSL https://github.com/aptible/supercronic/releases/download/v${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH} -o supercronic \
    && echo "${SUPERCRONIC_SHA1SUM}" supercronic | sha1sum -c - \
    && chmod +x supercronic \
    && mv supercronic /usr/local/bin/supercronic

# hadolint ignore=DL3044
ENV TZ="UTC" \
    PUID=1000 \
    PGID=1000 \
    PORT=7777 \
    QUERY_PORT=27016 \
    UPDATE_ON_BOOT=true \
    BACKUP_ENABLED=true \
    BACKUP_CRON_EXPRESSION="0 0 * * *" \
    DELETE_OLD_BACKUPS=false \
    OLD_BACKUP_DAYS=30 \
    AUTO_UPDATE_ENABLED=false \
    AUTO_UPDATE_CRON_EXPRESSION="0 * * * *" \
    AUTO_UPDATE_WARN_MINUTES=15 \
    AUTO_REBOOT_ENABLED=false \
    AUTO_REBOOT_CRON_EXPRESSION="0 0 * * *" \
    AUTO_REBOOT_WARN_MINUTES=15 \
    AUTO_REBOOT_EVEN_IF_PLAYERS_ONLINE=false \
    TARGET_COMMIT_ID= \
    DISCORD_WEBHOOK_URL="" \
    DISCORD_SUPPRESS_NOTIFICATIONS=false \
    DISCORD_CONNECT_TIMEOUT=30 \
    DISCORD_MAX_TIMEOUT=30 \
    DISCORD_PRE_INSTALL_MESSAGE="Server is installing..." \
    DISCORD_PRE_INSTALL_MESSAGE_ENABLED=true \
    DISCORD_PRE_INSTALL_MESSAGE_URL="" \
    DISCORD_POST_INSTALL_MESSAGE="Server install complete!" \
    DISCORD_POST_INSTALL_MESSAGE_ENABLED=true \
    DISCORD_POST_INSTALL_MESSAGE_URL="" \
    DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..." \
    DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED=true \
    DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL= \
    DISCORD_POST_UPDATE_BOOT_MESSAGE="Server update complete!" \
    DISCORD_POST_UPDATE_BOOT_MESSAGE_ENABLED=true \
    DISCORD_POST_UPDATE_BOOT_MESSAGE_URL= \
    DISCORD_PRE_START_MESSAGE="Server has been started!" \
    DISCORD_PRE_START_MESSAGE_ENABLED=true \
    DISCORD_PRE_START_MESSAGE_URL="" \
    DISCORD_SERVER_INFO_MESSAGE_ENABLED=true \
    DISCORD_SERVER_INFO_MESSAGE_WITH_IP=false \
    DISCORD_PRE_SHUTDOWN_MESSAGE="Server is shutting down..." \
    DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED=true \
    DISCORD_PRE_SHUTDOWN_MESSAGE_URL="" \
    DISCORD_POST_SHUTDOWN_MESSAGE="Server is stopped!" \
    DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED=true \
    DISCORD_POST_SHUTDOWN_MESSAGE_URL="" \
    DISCORD_PLAYER_JOIN_MESSAGE="player_name has joined!" \
    DISCORD_PLAYER_JOIN_MESSAGE_ENABLE=true \
    DISCORD_PLAYER_JOIN_MESSAGE_URL="" \
    DISCORD_PLAYER_LEAVE_MESSAGE="player_name has left." \
    DISCORD_PLAYER_LEAVE_MESSAGE_ENABLE=true \
    DISCORD_PLAYER_LEAVE_MESSAGE_URL="" \
    DISCORD_PRE_BACKUP_MESSAGE="Creating backup..." \
    DISCORD_PRE_BACKUP_MESSAGE_ENABLED=true \
    DISCORD_PRE_BACKUP_MESSAGE_URL= \
    DISCORD_POST_BACKUP_MESSAGE="Backup created at file_path" \
    DISCORD_POST_BACKUP_MESSAGE_ENABLED=true \
    DISCORD_POST_BACKUP_MESSAGE_URL= \
    DISCORD_PRE_BACKUP_DELETE_MESSAGE="Removing backups older than old_backup_days days" \
    DISCORD_PRE_BACKUP_DELETE_MESSAGE_ENABLED=true \
    DISCORD_PRE_BACKUP_DELETE_MESSAGE_URL= \
    DISCORD_POST_BACKUP_DELETE_MESSAGE="Removed backups older than old_backup_days days" \
    DISCORD_POST_BACKUP_DELETE_MESSAGE_ENABLED=true \
    DISCORD_POST_BACKUP_DELETE_MESSAGE_URL= \
    DISCORD_ERR_BACKUP_DELETE_MESSAGE="Unable to delete old backups, OLD_BACKUP_DAYS is not an integer. OLD_BACKUP_DAYS=old_backup_days" \
    DISCORD_ERR_BACKUP_DELETE_MESSAGE_ENABLED=true \
    DISCORD_ERR_BACKUP_DELETE_MESSAGE_URL= \
    DISCORD_BROADCAST_MESSAGE_ENABLE=true \
    DISCORD_BROADCAST_MESSAGE_URL= \
    BROADCAST_COUNTDOWN_MTIMES="1 5 10 15 30 60" \
    DISABLE_GENERATE_SETTINGS=false \
    ENABLE_PLAYER_LOGGING=true \
    PLAYER_LOGGING_POLL_PERIOD=5 \
    ARM_COMPATIBILITY_MODE=false

# Passed from Github Actions
ARG GIT_VERSION_TAG=unspecified

COPY --chmod=755 ./scripts /home/steam/server
RUN for file in backup.sh update.sh restore.sh broadcast.sh; do \
        mv /home/steam/server/"$file" /usr/local/bin/"${file%.sh}"; \
    done

WORKDIR /home/steam/server

# Make GIT_VERSION_TAG file to be able to check the version
RUN echo $GIT_VERSION_TAG > GIT_VERSION_TAG

RUN touch crontab \
 && rm -rf /tmp/dumps \
 && mkdir -p /home/steam/Steam/package \
 && chmod o+w crontab /home/steam/Steam/package \
 && chown -R steam:steam /home/steam/{server,Steam}

HEALTHCHECK --start-period=5m \
    CMD pidof "LongvinterServer-Linux-Shipping" > /dev/null || exit 1

ENTRYPOINT ["/home/steam/server/init.sh"]
