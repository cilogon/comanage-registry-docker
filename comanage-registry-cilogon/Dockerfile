ARG COMANAGE_REGISTRY_VERSION=3.1.0
FROM sphericalcowgroup/comanage-registry:${COMANAGE_REGISTRY_VERSION}-mod-auth-openidc

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

# Deploy the CILogon LDAP schema plugin
ARG CILOGON_LDAP_SCHEMA_PLUGIN_SRC_URL=https://github.com/cilogon/CilogonLdapSchema/archive/master.tar.gz

RUN mkdir -p "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonLdapSchema" \
      && wget -O CilogonLdapSchema.tar.gz $CILOGON_LDAP_SCHEMA_PLUGIN_SRC_URL \
      && tar -zxf CilogonLdapSchema.tar.gz -C "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonLdapSchema" --strip-components=1 \
      && rm -f CilogonLdapSchema.tar.gz

# Deploy the CILogon ePPN enroller plugin
ARG CILOGON_EPPN_ENROLLER_PLUGIN_SRC_URL=https://github.com/cilogon/CilogonEppnEnroller/archive/master.tar.gz

RUN mkdir -p "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonEppnEnroller" \
      && wget -O CilogonEppnEnroller.tar.gz $CILOGON_EPPN_ENROLLER_PLUGIN_SRC_URL \
      && tar -zxf CilogonEppnEnroller.tar.gz -C "$COMANAGE_REGISTRY_DIR/app/Plugin/CilogonEppnEnroller" --strip-components=1 \
      && rm -f CilogonEppnEnroller.tar.gz

# Deploy the Oa4mpClient plugin
ARG CILOGON_OA4MP_CLIENT_PLUGIN_SRC_URL=https://github.com/cilogon/Oa4mpClient/archive/e0f1afb0983918f8a5cc3caba7e9a39a6594275a.tar.gz

RUN mkdir -p "$COMANAGE_REGISTRY_DIR/app/Plugin/Oa4mpClient" \
      && wget -O Oa4mpClient.tar.gz $CILOGON_OA4MP_CLIENT_PLUGIN_SRC_URL \
      && tar -zxf Oa4mpClient.tar.gz -C "$COMANAGE_REGISTRY_DIR/app/Plugin/Oa4mpClient" --strip-components=1 \
      && rm -f Oa4mpClient.tar.gz

COPY mod-auth-openidc.conf /etc/apache2/conf-enabled/mod-auth-openidc.conf

COPY docker-comanage-entrypoint /usr/local/bin/

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
