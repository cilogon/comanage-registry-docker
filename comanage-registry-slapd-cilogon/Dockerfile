ARG COMANAGE_REGISTRY_SLAPD_IMAGE_VERSION=10
FROM comanage-registry-slapd:${COMANAGE_REGISTRY_SLAPD_IMAGE_VERSION}

COPY --chown=root:root healthcheck.sh /usr/local/bin/

RUN chmod 0755 /usr/local/bin/healthcheck.sh
