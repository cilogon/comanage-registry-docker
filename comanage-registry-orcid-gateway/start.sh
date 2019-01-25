#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# exit immediately on failure
set -e

# Configuration details that may be injected through environment
# variables or the contents of files.

injectable_config_vars=( 
    OIDC_CLIENT_ID
    OIDC_CLIENT_SECRET
    SATOSA_DIR
    SATOSA_GUNICORN_HOST
    SATOSA_GUNICORN_PORT
    SATOSA_PROXY_BASE
    SATOSA_SAML_FRONTEND_ATTRIBUTE_SCOPE
    SATOSA_SAML_FRONTEND_ENTITYID
    SATOSA_STATE_ENCRYPTION_KEY
)

# If the file associated with a configuration variable is present then 
# read the value from it into the appropriate variable. So for example
# if the variable OIDC_CLIENT_SECRET_FILE exists and its
# value points to a file on the file system then read the contents
# of that file into the variable OIDC_CLIENT_SECRET.

for config_var in "${injectable_config_vars[@]}"
do
    eval file_name=\$"${config_var}_FILE";

    if [ -e "$file_name" ]; then
        declare "${config_var}"=`cat $file_name`
    fi
done

# Export SATOSA sensitive environment variables.
if [[ -n "${SATOSA_STATE_ENCRYPTION_KEY}" ]]; then
    export SATOSA_STATE_ENCRYPTION_KEY
fi

# Set SATOSA directory.
if [[ -z "${SATOSA_DIR}" ]]; then
    SATOSA_DIR="/opt/satosa"
fi

# Copy SAML certificates and associated private key into place.
if [[ -n "${SATOSA_SAML_FRONTEND_CERT_FILE}" && -n "${SATOSA_SAML_FRONTEND_KEY_FILE}" ]]; then
    certfile="${SATOSA_DIR}/frontend.crt"
    keyfile="${SATOSA_DIR}/frontend.key"
    cp "${SATOSA_SAML_FRONTEND_CERT_FILE}" "${certfile}"
    cp "${SATOSA_SAML_FRONTEND_KEY_FILE}" "${keyfile}"
    chmod 644 "${certfile}"
    chmod 600 "${keyfile}"

    saml_frontend_file="${SATOSA_DIR}/plugins/saml2_frontend.yaml"
    sed -i -e 's+%%SATOSA_SAML_FRONTEND_CERT_FILE%%+'"${certfile}"'+' "${saml_frontend_file}"
    sed -i -e 's+%%SATOSA_SAML_FRONTEND_KEY_FILE%%+'"${keyfile}"'+' "${saml_frontend_file}"
fi

# Inject SATOSA proxy server base.
if [[ -n "${SATOSA_PROXY_BASE}" ]]; then
    sed -i -e 's+%%SATOSA_PROXY_BASE%%+'"${SATOSA_PROXY_BASE}"'+' "${SATOSA_DIR}/proxy_conf.yaml"
fi

# Inject OIDC client ID and secret if defined.
if [[ -n "${OIDC_CLIENT_ID}" ]]; then
    sed -i -e 's/%%OIDC_CLIENT_ID%%/'"${OIDC_CLIENT_ID}"'/' "${SATOSA_DIR}/plugins/orcid_backend.yaml"
fi

if [[ -n "${OIDC_CLIENT_SECRET}" ]]; then
    sed -i -e 's/%%OIDC_CLIENT_SECRET%%/'"${OIDC_CLIENT_SECRET}"'/' "${SATOSA_DIR}/plugins/orcid_backend.yaml"
fi

# Inject other SAML frontend details.
saml_frontend_file="${SATOSA_DIR}/plugins/saml2_frontend.yaml"

if [[ -z "${SATOSA_SAML_FRONTEND_METADATA_FILE}" ]]; then
    SATOSA_SAML_FRONTEND_METADATA_FILE="${SATOSA_DIR}/sp-metadata.xml"
fi

sed -i -e 's+%%SATOSA_SAML_FRONTEND_METADATA_FILE%%+'"${SATOSA_SAML_FRONTEND_METADATA_FILE}"'+' "${saml_frontend_file}"

if [[ -n "${SATOSA_SAML_FRONTEND_ENTITYID}" ]]; then
    sed -i -e 's+%%SATOSA_SAML_FRONTEND_ENTITYID%%+'"${SATOSA_SAML_FRONTEND_ENTITYID}"'+' "${saml_frontend_file}"
fi

# Configure the ePPN scope.
eppn_plugin_file="${SATOSA_DIR}/plugins/generate_eppn.yaml"

if [[ -n "${SATOSA_SAML_FRONTEND_ATTRIBUTE_SCOPE}" ]]; then
    sed -i -e 's/%%SATOSA_SAML_FRONTEND_ATTRIBUTE_SCOPE%%/'"${SATOSA_SAML_FRONTEND_ATTRIBUTE_SCOPE}"'/' "${eppn_plugin_file}"
fi

cd "${SATOSA_DIR}"

exec ${SATOSA_DIR}/bin/gunicorn \
    -b${SATOSA_GUNICORN_HOST:-0.0.0.0}:${SATOSA_GUNICORN_PORT:-8000} \
    --forwarded-allow-ips='*' \
    satosa.wsgi:app
