#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# exit immediately on failure
set -e

# Configuration details that may be injected through environment
# variables or the contents of files.

injectable_config_vars=( 
    PYFF_DIR
    PYFF_HOST
    PYFF_LOGLEVEL
    PYFF_PIDFILE
    PYFF_PIPELINE
    PYFF_PORT
    PYFF_UPDATE_FREQUENCY
)

# Default values.
if [ -z "${PYFF_CACHING}" ]; then
    # Default is no caching done by CherryPy.
    PYFF_CACHING=0
fi

if [ -z "${PYFF_DIR}" ]; then
   PYFF_DIR=/opt/pyff
fi

if [ -z "${PYFF_HOST}" ]; then
    PYFF_HOST=0.0.0.0
fi

if [ -z "${PYFF_LOGLEVEL}" ]; then
    PYFF_LOGLEVEL=INFO
fi

if [ -z "${PYFF_PORT}" ]; then
    PYFF_PORT=8080
fi

if [ -z "${PYFF_PIDFILE}" ]; then
    PYFF_PIDFILE="${PYFF_DIR}/pyff.pid"
fi

if [ -z "${PYFF_UPDATE_FREQUENCY}" ]; then
    PYFF_UPDATE_FREQUENCY=28800
fi

# If the file associated with a configuration variable is present then 
# read the value from it into the appropriate variable. So for example
# if the variable PYFF_LOGLEVEL_FILE exists and its
# value points to a file on the file system then read the contents
# of that file into the variable PYFF_LOGLEVEL.

for config_var in "${injectable_config_vars[@]}"
do
    eval file_name=\$"${config_var}_FILE";

    if [ -e "$file_name" ]; then
        declare "${config_var}"=`cat $file_name`
    fi
done

# Define and create PYFF_DIR if it does not already exist.

if [ ! -d "${PYFF_DIR}" ]; then
   mkdir -p "${PYFF_DIR}"
fi

# Copy metadata signing certificate and associated private key into place.
if [ -n "${PYFF_METADATA_SIGNING_CERT_FILE}" ] && [ -n "${PYFF_METADATA_SIGNING_KEY_FILE}" ]; then
    cp "${PYFF_METADATA_SIGNING_CERT_FILE}" "${PYFF_DIR}/metadata-signer.crt"
    cp "${PYFF_METADATA_SIGNING_KEY_FILE}" "${PYFF_DIR}/metadata-signer.key"
    chmod 644 "${PYFF_DIR}/metadata-signer.crt"
    chmod 600 "${PYFF_DIR}/metadata-signer.key"
fi

cd ${PYFF_DIR}

source ${PYFF_DIR}/bin/activate

if [ "$PYFF_CACHING" -eq 0 ] 
then
    CACHE=-C
else
    CACHE=
fi

exec pyffd \
    -f ${CACHE} \
    --loglevel=${PYFF_LOGLEVEL} \
    --frequency=${PYFF_UPDATE_FREQUENCY} \
    --host=${PYFF_HOST} \
    --port=${PYFF_PORT} \
    -p ${PYFF_PIDFILE} \
    --proxy \
    ${PYFF_PIPELINE}
