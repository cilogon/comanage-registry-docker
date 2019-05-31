#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# exit immediately on failure
set -e

# Configuration details that may be injected through environment
# variables or the contents of files.

injectable_config_vars=( 
    SATOSA_LDAP_BIND_PASSWORD
    SATOSA_STATE_ENCRYPTION_KEY
    SATOSA_USER_ID_HASH_SALT
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
if [ -z "${DATA_DIR}" ]; then
   DATA_DIR=/opt/satosa
fi

if [ ! -d "${DATA_DIR}" ]; then
   mkdir -p "${DATA_DIR}"
fi

# Export SATOSA sensitive environment variables.
if [ -n "${SATOSA_STATE_ENCRYPTION_KEY}" ]; then
    export SATOSA_STATE_ENCRYPTION_KEY
fi

if [ -n "${SATOSA_USER_ID_HASH_SALT}" ]; then
    export SATOSA_USER_ID_HASH_SALT
fi

# Inject secrets into yaml configurations.
if [ -f "${DATA_DIR}/plugins/ldap_attribute_store.yaml" ]; then
    sed -i -e s@%%SATOSA_LDAP_BIND_PASSWORD%%@"${SATOSA_LDAP_BIND_PASSWORD}"@ "${DATA_DIR}/plugins/ldap_attribute_store.yaml"
fi

# Copy SAML certificates and associated private keys into place.
if [ -n "${SATOSA_FRONTEND_CERT_FILE}" ] && [ -n "${SATOSA_FRONTEND_PRIVKEY_FILE}" ]; then
    cp "${SATOSA_FRONTEND_CERT_FILE}" "${DATA_DIR}/frontend.crt"
    cp "${SATOSA_FRONTEND_PRIVKEY_FILE}" "${DATA_DIR}/frontend.key"
    chmod 644 "${DATA_DIR}/frontend.crt"
    chmod 600 "${DATA_DIR}/frontend.key"
fi

if [ -n "${SATOSA_BACKEND_CERT_FILE}" ] && [ -n "${SATOSA_BACKEND_PRIVKEY_FILE}" ]; then
    cp "${SATOSA_BACKEND_CERT_FILE}" "${DATA_DIR}/backend.crt"
    cp "${SATOSA_BACKEND_PRIVKEY_FILE}" "${DATA_DIR}/backend.key"
    chmod 644 "${DATA_DIR}/backend.crt"
    chmod 600 "${DATA_DIR}/backend.key"
fi

# Copy HTTPS certificate and key into place.
if [ -n "${SATOSA_HTTPS_CERT_FILE}" ] && [ -n "${SATOSA_HTTPS_KEY_FILE}" ]; then
    cp "${SATOSA_HTTPS_CERT_FILE}" "${DATA_DIR}/https.crt"
    cp "${SATOSA_HTTPS_KEY_FILE}" "${DATA_DIR}/https.key"
    chmod 644 "${DATA_DIR}/https.crt"
    chmod 600 "${DATA_DIR}/https.key"
fi

if [ -z "${PROXY_PORT}" ]; then
   PROXY_PORT="8080"
fi

if [ -z "${METADATA_DIR}" ]; then
   METADATA_DIR="${DATA_DIR}"
fi

cd ${DATA_DIR}

mkdir -p ${METADATA_DIR}

# start the proxy
if [[ -f https.key && -f https.crt ]]; then # if HTTPS cert is available, use it
  exec /opt/satosa/bin/gunicorn -b0.0.0.0:${PROXY_PORT} --keyfile https.key --certfile https.crt satosa.wsgi:app
else
  exec /opt/satosa/bin/gunicorn -b0.0.0.0:${PROXY_PORT} --forwarded-allow-ips='*' satosa.wsgi:app
fi
