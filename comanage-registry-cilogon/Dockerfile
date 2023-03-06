ARG COMANAGE_REGISTRY_VERSION=4.1.0
ARG COMANAGE_REGISTRY_BASE_IMAGE_VERSION=1
ARG COMANAGE_REGISTRY_REPOSITORY=public.ecr.aws/cilogon/comanage-registry
FROM ${COMANAGE_REGISTRY_REPOSITORY}:${COMANAGE_REGISTRY_VERSION}-mod_auth_openidc-${COMANAGE_REGISTRY_BASE_IMAGE_VERSION}

# Deploy the CILogon ePPN enroller plugin
ARG CILOGON_EPPN_ENROLLER_PLUGIN_SRC_URL=https://github.com/cilogon/CilogonEppnEnroller/archive/master.tar.gz

RUN mkdir -p "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonEppnEnroller" \
      && wget -O CilogonEppnEnroller.tar.gz $CILOGON_EPPN_ENROLLER_PLUGIN_SRC_URL \
      && tar -zxf CilogonEppnEnroller.tar.gz -C "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonEppnEnroller" --strip-components=1 \
      && rm -f CilogonEppnEnroller.tar.gz \
      && cd "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonEppnEnroller/View/CilogonEppnEnrollers" \
      && ln -s ../../../../View/Standard/edit.ctp edit.ctp

# Deploy Oa4mpClient plugin version 5.4.1
ARG CILOGON_OA4MP_CLIENT_PLUGIN_SRC_URL=https://github.com/cilogon/Oa4mpClient/archive/5.4.1.tar.gz

RUN mkdir -p "$COMANAGE_REGISTRY_DIR/app/Plugin/Oa4mpClient" \
      && wget -O Oa4mpClient.tar.gz $CILOGON_OA4MP_CLIENT_PLUGIN_SRC_URL \
      && tar -zxf Oa4mpClient.tar.gz -C "$COMANAGE_REGISTRY_DIR/app/Plugin/Oa4mpClient" --strip-components=1 \
      && rm -f Oa4mpClient.tar.gz

# Copy customized core.php that sets a session timeout to 8 hours
COPY core.php "$COMANAGE_REGISTRY_DIR/app/Config/"

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

# Allow values for first administrator bootstrapped into the
# platform to be specified at image build time, in addition to
# being injected at run time through the entrypoint script.
ARG COMANAGE_REGISTRY_ADMIN_GIVEN_NAME
ARG COMANAGE_REGISTRY_ADMIN_FAMILY_NAME
ARG COMANAGE_REGISTRY_ADMIN_USERNAME
ARG COMANAGE_REGISTRY_ENABLE_POOLING

# Set simple defaults for first administrator bootstrapped into the
# platform to make simple evaluation of the platform easier.
ENV COMANAGE_REGISTRY_ADMIN_GIVEN_NAME ${COMANAGE_REGISTRY_ADMIN_GIVEN_NAME:-Registry}
ENV COMANAGE_REGISTRY_ADMIN_FAMILY_NAME ${COMANAGE_REGISTRY_ADMIN_FAMILY_NAME:-Admin}
ENV COMANAGE_REGISTRY_ADMIN_USERNAME ${COMANAGE_REGISTRY_ADMIN_USERNAME:-registry.admin}
ENV COMANAGE_REGISTRY_ENABLE_POOLING ${COMANAGE_REGISTRY_ENABLE_POOLING:-No}
