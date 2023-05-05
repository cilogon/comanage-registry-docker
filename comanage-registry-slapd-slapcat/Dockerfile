ARG COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION=11
FROM comanage-registry-slapd-base:${COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION}

ARG COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION
ENV COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION ${COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION}
LABEL comanage_registry_slapd_base_image_version=${COMANAGE_REGISTRY_SLAPD_BASE_IMAGE_VERSION}

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        busybox-syslogd \
        bzip2 \
        cron \
        gettext-base

# Default root crontab needed by cron.
COPY --chown=root:root root-crontab /etc/crontab

# Default crontab used if one is not otherwise injected
COPY --chown=root:root openldap-crontab /usr/local/etc/openldap-crontab

# Deploy the default crontab. The entrypoint script will deploy
# again at startup in case crontab has been injected.
RUN /usr/bin/crontab -u openldap /usr/local/etc/openldap-crontab \
      && /usr/sbin/usermod --shell /bin/bash openldap \
      && touch /etc/default/locale

# Template for script that runs slapcat.
COPY --chown=root:root ldap_backup.sh.template /usr/local/src/ldap_backup.sh.template

# Defaults for database to backup and where to back it up.
ENV LDIF_BACKUP_DBNUM 2
ENV LDIF_BACKUP_DIR /srv/backups/ldif

RUN mkdir -p ${LDIF_BACKUP_DIR}

COPY cron-entrypoint /usr/local/bin/

ENTRYPOINT ["cron-entrypoint"]

CMD ["/usr/sbin/cron", "-f", "-L", "15"]
