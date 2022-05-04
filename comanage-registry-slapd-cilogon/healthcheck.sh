#!/bin/bash

if [[ -e /tmp/replica_was_healthy_once ]]; then
    HEALTHCHECK_REPLICA_LDAP_BIND_PASSWORD=$(cat ${HEALTHCHECK_REPLICA_BIND_PASSWORD_FILE})

    /usr/bin/ldapsearch -LLL \
        -H ${HEALTHCHECK_REPLICA_LDAP_URL} \
        -D ${HEALTHCHECK_REPLICA_LDAP_BIND_DN} \
        -x \
        -w ${HEALTHCHECK_REPLICA_LDAP_BIND_PASSWORD} \
        -b ${HEALTHCHECK_REPLICA_LDAP_SEARCH_BASE} \
        -s base \
        dn > /dev/null 2>&1 \
        && \
    ldapsearch -LLL \
        -H ldapi:/// \
        -Y EXTERNAL \
        -b cn=config \
        -s base \
        dn > /dev/null 2>&1
else
    # See if Docker Swarm provides an IP address for the
    # healthy replica service.
    /usr/bin/getent hosts tasks.${HEALTHCHECK_REPLICA_LDAP_SERVICE_NAME} > /dev/null 2>&1

    if [[ "$?" -eq 0 ]]; then
        # The replica service has been bootstrapped and is initially healthy
        # so create a file to signal we have made it to this phase.
        /usr/bin/touch /tmp/replica_was_healthy_once
    fi

    ldapsearch -LLL \
        -H ldapi:/// \
        -Y EXTERNAL \
        -b cn=config \
        -s base \
        dn > /dev/null 2>&1
fi
