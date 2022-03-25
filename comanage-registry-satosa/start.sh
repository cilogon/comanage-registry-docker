#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# exit immediately on failure
set -e

# Configuration details that may be injected through environment
# variables or the contents of files.

injectable_config_vars=( 
    SATOSA_STATE_ENCRYPTION_KEY
)

# If the file associated with a configuration variable is present then 
# read the value from it into the appropriate variable. So for example
# if the variable SATOSA_LDAP_BIND_PASSWORD_FILE exists and its
# value points to a file on the file system then read the contents
# of that file into the variable SATOSA_LDAP_BIND_PASSWORD.

for config_var in "${injectable_config_vars[@]}"
do
    eval file_name=\$"${config_var}_FILE";

    if [ -e "$file_name" ]; then
        declare "${config_var}"=`cat $file_name`
    fi
done

# Define and create DATA_DIR if it does not already exist.
if [[ -z "${DATA_DIR}" ]]; then
   DATA_DIR=/opt/satosa
fi

if [[ ! -d "${DATA_DIR}" ]]; then
   mkdir -p "${DATA_DIR}"
fi

# Export SATOSA sensitive environment variables.
if [[ -n "${SATOSA_STATE_ENCRYPTION_KEY}" ]]; then
    export SATOSA_STATE_ENCRYPTION_KEY
fi

# Copy SAML certificates and associated private keys into place.
if [[ -n "${SATOSA_FRONTEND_CERT_FILE}" &&
      -n "${SATOSA_FRONTEND_PRIVKEY_FILE}" ]]; then
    cp "${SATOSA_FRONTEND_CERT_FILE}" "${DATA_DIR}/frontend.crt"
    cp "${SATOSA_FRONTEND_PRIVKEY_FILE}" "${DATA_DIR}/frontend.key"
    chmod 644 "${DATA_DIR}/frontend.crt"
    chmod 600 "${DATA_DIR}/frontend.key"
fi

if [[ -n "${SATOSA_BACKEND_CERT_FILE}" &&
      -n "${SATOSA_BACKEND_PRIVKEY_FILE}" ]]; then
    cp "${SATOSA_BACKEND_CERT_FILE}" "${DATA_DIR}/backend.crt"
    cp "${SATOSA_BACKEND_PRIVKEY_FILE}" "${DATA_DIR}/backend.key"
    chmod 644 "${DATA_DIR}/backend.crt"
    chmod 600 "${DATA_DIR}/backend.key"
fi

if [[ -z "${PROXY_PORT}" ]]; then
   PROXY_PORT="8080"
fi

if [[ -z "${METADATA_DIR}" ]]; then
   METADATA_DIR="${DATA_DIR}"
fi

cd ${DATA_DIR}

mkdir -p ${METADATA_DIR}

uwsgi=(/opt/satosa/bin/uwsgi)
uwsgi+=(--master)
uwsgi+=(--strict)
uwsgi+=(--lazy-apps)
uwsgi+=(--single-interpreter)
uwsgi+=(--die-on-term)
uwsgi+=(--need-app)
uwsgi+=(--disable-logging)
uwsgi+=(--log-4xx)
uwsgi+=(--log-5xx)
uwsgi+=(--wsgi satosa.wsgi)
uwsgi+=(--callable app)
uwsgi+=(-b 65535)
uwsgi+=(--http-socket 0.0.0.0:${PROXY_PORT})
uwsgi+=(--processes ${UWSGI_WORKERS:-2})
uwsgi+=(--enable-threads)
uwsgi+=(--threads ${UWSGI_THREADS:-4})
uwsgi+=(--reload-on-rss ${UWSGI_MAX_RSS_MB:-512})

exec "${uwsgi[@]}"
