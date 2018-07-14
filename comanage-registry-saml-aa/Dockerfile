ARG JETTY_VERSION=latest
FROM jetty:${JETTY_VERSION} AS builder

USER root

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y openjdk-8-jdk

ARG SHIBBOLETH_IDP_SRC_URL=https://shibboleth.net/downloads/identity-provider/latest/shibboleth-identity-provider-3.3.2.tar.gz
ENV SHIBBOLETH_IDP_SRC_URL=${SHIBBOLETH_IDP_SRC_URL}

WORKDIR /tmp/shibidp

COPY idp.installer.properties /tmp/shibidp/idp.installer.properties
COPY idp.merge.properties /tmp/shibidp/idp.merge.properties
COPY ldap.merge.properties /tmp/shibidp/ldap.merge.properties

RUN wget -O idp.tar.gz ${SHIBBOLETH_IDP_SRC_URL} \
    && tar zxf idp.tar.gz -C /tmp/shibidp --strip-components=1 \
    && rm idp.tar.gz

RUN mkdir -p /opt/shibboleth-idp \
        && ./bin/install.sh \
            -noinput \
            -silent \
            -Didp.property.file=idp.installer.properties

FROM jetty:${JETTY_VERSION}

USER root

COPY --from=builder /opt/shibboleth-idp /opt/shibboleth-idp

RUN chown -R jetty:jetty /opt/shibboleth-idp

USER jetty

ARG LOGBACK_VERSION=1.2.3
ENV LOGBACK_VERSION=${LOGBACK_VERSION}
RUN mkdir -p ${JETTY_BASE}/lib/logging \
    && wget https://logback.qos.ch/dist/logback-${LOGBACK_VERSION}.tar.gz \
    && tar zxf logback-${LOGBACK_VERSION}.tar.gz \
    && rm -f logback-${LOGBACK_VERSION}.tar.gz \
    && cp logback-${LOGBACK_VERSION}/logback-access-${LOGBACK_VERSION}.jar ${JETTY_BASE}/lib/logging/ \
    && cp logback-${LOGBACK_VERSION}/logback-classic-${LOGBACK_VERSION}.jar ${JETTY_BASE}/lib/logging/ \
    && cp logback-${LOGBACK_VERSION}/logback-core-${LOGBACK_VERSION}.jar ${JETTY_BASE}/lib/logging/ \
    && rm -rf logback-${LOGBACK_VERSION}

ARG SLF4J_VERSION=1.7.25
ENV SLF4J_VERSION=${SLF4J_VERSION}
RUN mkdir -p ${JETTY_BASE}/lib/logging \
    && wget https://www.slf4j.org/dist/slf4j-${SLF4J_VERSION}.tar.gz \
    && tar zxf slf4j-${SLF4J_VERSION}.tar.gz \
    && rm -f slf4j-${SLF4J_VERSION}.tar.gz \
    && cp slf4j-${SLF4J_VERSION}/slf4j-api-${SLF4J_VERSION}.jar ${JETTY_BASE}/lib/logging/ \
    && rm -rf slf4j-${SLF4J_VERSION}
    
RUN java -jar "${JETTY_HOME}/start.jar" --add-to-startd=annotations
RUN java -jar "${JETTY_HOME}/start.jar" --add-to-startd=servlets
RUN java -jar "${JETTY_HOME}/start.jar" --add-to-startd=plus
RUN java -jar "${JETTY_HOME}/start.jar" --add-to-startd=logging
RUN java -jar "${JETTY_HOME}/start.jar" --add-to-startd=requestlog

WORKDIR ${JETTY_BASE}

COPY --chown=jetty:jetty idp.xml webapps/
COPY --chown=jetty:jetty jetty-requestlog.xml etc/
COPY --chown=jetty:jetty jetty-logback.xml resources/logback.xml
COPY --chown=jetty:jetty logback-access.xml resources/
COPY --chown=jetty:jetty jetty-logging.xml etc/
COPY --chown=jetty:jetty jetty.xml etc/
#COPY --chown=jetty:jetty jetty-http.xml ${JETTY_BASE}/etc/jetty-http.xml

WORKDIR /opt/shibboleth-idp

COPY --chown=jetty:jetty idp.properties conf/
COPY --chown=jetty:jetty logback.xml conf/
COPY --chown=jetty:jetty relying-party.xml conf/
COPY --chown=jetty:jetty subject-c14n.xml conf/c14n/

WORKDIR ${JETTY_BASE}

COPY docker-aa-entrypoint /docker-aa-entrypoint

ENTRYPOINT ["/docker-aa-entrypoint"]
