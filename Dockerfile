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

# update and install dependencies
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
      git \
      git-lfs \
      wget \
      ca-certificates \
      lib32gcc1-amd64-cross \
      xdg-user-dirs jo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
RUN su steam -c "/home/steam/steamcmd/steamcmd.sh +login anonymous +app_update 1007 +quit"

# hadolint ignore=DL3044
ENV TZ="UTC" \
    PUID=1000 \
    PGID=1000 \
    PORT=7777 \
    QUERY_PORT=27016 \
    UPDATE_ON_BOOT=true \
    DISCORD_WEBHOOK_URL="" \
    DISCORD_SUPPRESS_NOTIFICATIONS=false \
    DISCORD_CONNECT_TIMEOUT=30 \
    DISCORD_MAX_TIMEOUT=30 \
    DISCORD_PRE_INSTALL_MESSAGE="Server is installing..." \
    DISCORD_PRE_INSTALL_MESSAGE_ENABLED=true \
    DISCORD_PRE_INSTALL_MESSAGE_URL="" \
    DISCORD_PRE_UPDATE_BOOT_MESSAGE="Server is updating..." \
    DISCORD_PRE_UPDATE_BOOT_MESSAGE_ENABLED=true \
    DISCORD_PRE_UPDATE_BOOT_MESSAGE_URL= \
    DISCORD_PRE_START_MESSAGE="Server has been started!" \
    DISCORD_PRE_START_MESSAGE_ENABLED=true \
    DISCORD_PRE_START_MESSAGE_URL="" \
    DISCORD_PRE_SHUTDOWN_MESSAGE="Server is shutting down..." \
    DISCORD_PRE_SHUTDOWN_MESSAGE_ENABLED=true \
    DISCORD_PRE_SHUTDOWN_MESSAGE_URL="" \
    DISCORD_POST_SHUTDOWN_MESSAGE="Server is stopped!" \
    DISCORD_POST_SHUTDOWN_MESSAGE_ENABLED=true \
    DISCORD_POST_SHUTDOWN_MESSAGE_URL="" \
    DISCORD_SERVER_INFO_MESSAGE_ENABLE=true \
    DISCORD_SERVER_INFO_MESSAGE_WITH_IP=false \
    ARM_COMPATIBILITY_MODE=false

COPY --chmod=755 ./scripts /home/steam/server

WORKDIR /home/steam/server

HEALTHCHECK --start-period=3m \
    CMD pidof "LongvinterServer-Linux-Shipping" > /dev/null || exit 1

EXPOSE $PORT $QUERY_PORT
ENTRYPOINT ["/home/steam/server/init.sh"]
