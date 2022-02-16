# This Dockerfile and associated files are adapted from
#
# https://github.com/Tecnativa/docker-socket-proxy
#
FROM haproxy:2.5.1-alpine

EXPOSE 2375

ENV ALLOW_RESTARTS=0 \
    AUTH=0 \
    BUILD=0 \
    COMMIT=0 \
    CONFIGS=0 \
    CONTAINERS=0 \
    DISTRIBUTION=0 \
    EVENTS=1 \
    EXEC=0 \
    IMAGES=0 \
    INFO=0 \
    NETWORKS=0 \
    NODES=0 \
    PING=1 \
    PLUGINS=0 \
    POST=0 \
    SECRETS=0 \
    SERVICES=0 \
    SESSION=0 \
    SWARM=0 \
    SYSTEM=0 \
    TASKS=0 \
    VERSION=1 \
    VOLUMES=0

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

COPY docker-entrypoint.sh /

USER root

RUN apk --no-cache add socat
