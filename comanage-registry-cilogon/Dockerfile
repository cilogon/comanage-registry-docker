ARG COMANAGE_REGISTRY_VERSION=3.3.3
ARG COMANAGE_REGISTRY_BASE_IMAGE_VERSION=1
FROM sphericalcowgroup/comanage-registry:${COMANAGE_REGISTRY_VERSION}-mod-auth-openidc-${COMANAGE_REGISTRY_BASE_IMAGE_VERSION}

# Enable the remoteip module since we run behind load balancer
COPY remoteip.conf /etc/apache2/mods-available/remoteip.conf
RUN a2enmod remoteip

COPY 000-comanage.conf /etc/apache2/sites-available/000-comanage.conf

# Required for the MediaWiki Provisioner
RUN apt-get update && apt-get install -y \
      libpcre3-dev \
      && wget -O oauth.tar.gz https://github.com/cilogon/pecl-web_services-oauth/archive/null_byte.tar.gz \
      && mkdir -p oauth \
      && tar zxf oauth.tar.gz -C oauth --strip-components=1 \
      && rm oauth.tar.gz \
      && ( \
          cd oauth \
          && phpize \
          && ./configure \
          && make \
          && make install \
          ) \
      && rm -r oauth \
      && docker-php-ext-enable oauth

# Deploy the CILogon ePPN enroller plugin
ARG CILOGON_EPPN_ENROLLER_PLUGIN_SRC_URL=https://github.com/cilogon/CilogonEppnEnroller/archive/master.tar.gz

RUN mkdir -p "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonEppnEnroller" \
      && wget -O CilogonEppnEnroller.tar.gz $CILOGON_EPPN_ENROLLER_PLUGIN_SRC_URL \
      && tar -zxf CilogonEppnEnroller.tar.gz -C "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonEppnEnroller" --strip-components=1 \
      && rm -f CilogonEppnEnroller.tar.gz

# Deploy Oa4mpClient plugin version 3.0.1
ARG CILOGON_OA4MP_CLIENT_PLUGIN_SRC_URL=https://github.com/cilogon/Oa4mpClient/archive/3.0.1.tar.gz

RUN mkdir -p "$COMANAGE_REGISTRY_DIR/app/Plugin/Oa4mpClient" \
      && wget -O Oa4mpClient.tar.gz $CILOGON_OA4MP_CLIENT_PLUGIN_SRC_URL \
      && tar -zxf Oa4mpClient.tar.gz -C "$COMANAGE_REGISTRY_DIR/app/Plugin/Oa4mpClient" --strip-components=1 \
      && rm -f Oa4mpClient.tar.gz

COPY mod-auth-openidc.conf /etc/apache2/conf-enabled/mod-auth-openidc.conf

COPY docker-comanage-entrypoint /usr/local/bin/

# Copy customized core.php that sets a session timeout to 8 hours
COPY core.php "$COMANAGE_REGISTRY_DIR/app/Config/"

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
