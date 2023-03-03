ARG COMANAGE_REGISTRY_VERSION=4.1.0
ARG COMANAGE_REGISTRY_CRON_BASE_IMAGE_VERSION=1
ARG COMANAGE_REGISTRY_CRON_REPOSITORY=public.ecr.aws/cilogon/comanage-registry-cron
FROM ${COMANAGE_REGISTRY_CRON_REPOSITORY}:${COMANAGE_REGISTRY_VERSION}-${COMANAGE_REGISTRY_CRON_BASE_IMAGE_VERSION}

# Install MIT Kerberos runtime libraries and development files.
RUN apt-get update && apt-get install -y \
        libkrb5-3 \
        libkrb5-dev

# Default PECL krb5 version but may be overriden using a build argument.
ARG PECL_KRB5_VERSION=1.1.4
ENV PECL_KRB5_VERSION ${PECL_KRB5_VERSION}

# Use the helper functions from the upstream php Docker image
# to build, install, and enable the PECL krb5 module. After
# build is complete purge the development libraries and source.
RUN docker-php-source extract \
        && pecl bundle -d /usr/src/php/ext krb5-${PECL_KRB5_VERSION} \
        && docker-php-ext-configure krb5 --with-krb5kadm \
        && docker-php-ext-install krb5 \
        && docker-php-ext-enable krb5 \
        && docker-php-source delete \
        && apt-get purge -y libkrb5-dev \
        && apt-get clean
