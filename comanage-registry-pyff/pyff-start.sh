#!/usr/bin/env bash

# Configuration details that may be injected through environment
# variables or the contents of files.

injectable_config_vars=( 
    PYFF_GUNICORN_BIND
    PYFF_GUNICORN_LOG_CONFIG
    PYFF_GUNICORN_THREADS
    PYFF_PIPELINE
    PYFF_PUBLIC_URL
    PYFF_SCHEDULER_JOB_STORE
    PYFF_STORE_CLASS
    PYFF_UPDATE_FREQUENCY
)

# Default values.
if [ -z "${PYFF_GUNICORN_BIND}" ]; then
    PYFF_GUNICORN_BIND=0.0.0.0:8080
fi

if [ -z "${PYFF_GUNICORN_LOG_CONFIG}" ]; then
    PYFF_GUNICORN_LOG_CONFIG=logger.ini
fi

if [ -z "${PYFF_GUNICORN_THREADS}" ]; then
    PYFF_GUNICORN_THREADS=4
fi

if [ -z "${PYFF_STORE_CLASS}" ]; then
    PYFF_STORE_CLASS=pyff.store:RedisWhooshStore
fi

if [ -z "${PYFF_SCHEDULER_JOB_STORE}" ]; then
    PYFF_SCHEDULER_JOB_STORE=redis
fi

if [ -z "${PYFF_UPDATE_FREQUENCY}" ]; then
    PYFF_UPDATE_FREQUENCY=3600
fi

# If the file associated with a configuration variable is present then 
# read the value from it into the appropriate variable. So for example
# if the variable PYFF_STORE_CLASS_FILE exists and its
# value points to a file on the file system then read the contents
# of that file into the variable PYFF_STORE_CLASS.

for config_var in "${injectable_config_vars[@]}"
do
    eval file_name=\$"${config_var}_FILE";

    if [ -e "$file_name" ]; then
        declare "${config_var}"=`cat $file_name`
    fi
done

# Cannot start without a pipeline.
if [ -z "${PYFF_PIPELINE}" ]; then
    echo "PYFF_PIPELINE environment variable must be defined"
    exit 1
fi

# Copy metadata signing certificate and associated private key into place.
metadata_signing_crt=/opt/pyff/metadata-signer.crt
metadata_signing_key=/opt/pyff/metadata-signer.key

if [ -n "${PYFF_METADATA_SIGNING_CERT_FILE}" ] && [ -n "${PYFF_METADATA_SIGNING_KEY_FILE}" ]; then
    cp "${PYFF_METADATA_SIGNING_CERT_FILE}" $metadata_signing_crt
    cp "${PYFF_METADATA_SIGNING_KEY_FILE}"  $metadata_signing_key
    chmod 644 $metadata_signing_crt
    chmod 600 $metadata_signing_key
    chown pyff:pyff $metadata_signing_crt
    chown pyff:pyff $metadata_signing_key
fi

cd /opt/pyff
source /opt/pyff/bin/activate

# Wait until Redis server is up.
until /usr/bin/redis-cli ping; do
    echo "Redis is unavailable - sleeping"
    sleep 1
done

exec gunicorn \
    --log-config ${PYFF_GUNICORN_LOG_CONFIG} \
    --bind ${PYFF_GUNICORN_BIND} \
    --timeout 600 \
    -e PYFF_PIPELINE=${PYFF_PIPELINE} \
    -e PYFF_UPDATE_FREQUENCY=${PYFF_UPDATE_FREQUENCY} \
    -e PYFF_PUBLIC_URL=http://127.0.0.1:8080 \
    -e PYFF_STORE_CLASS=${PYFF_STORE_CLASS} \
    -e PYFF_SCHEDULER_JOB_STORE=${PYFF_SCHEDULER_JOB_STORE} \
    --workers 1 \
    --worker-class=gthread \
    --threads ${PYFF_GUNICORN_THREADS} \
    --worker-tmp-dir=/dev/shm \
    pyff.wsgi:app
