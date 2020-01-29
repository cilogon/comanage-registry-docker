FROM httpd:2.4.41

RUN apt-get update && apt-get install -y --no-install-recommends \
        busybox-syslogd \
        ca-certificates \
        coreutils \
        cron  \
        curl \
        dnsutils \
        gawk \
        grep \
        openssl \
        sed \
        ssl-cert \
        supervisor \
    && cp /etc/ssl/certs/ssl-cert-snakeoil.pem /usr/local/apache2/conf/server.crt \
    && cp /etc/ssl/private/ssl-cert-snakeoil.key /usr/local/apache2/conf/server.key

COPY httpd.conf /usr/local/apache2/conf/httpd.conf

ENV GETSSL_SRC_URL=https://raw.githubusercontent.com/srvrco/getssl/master/getssl
ENV GETSSL_EXEC=/usr/local/bin/getssl
ENV GETSSL_WORKDIR=/opt/getssl

RUN curl --silent ${GETSSL_SRC_URL} > ${GETSSL_EXEC} \
    && chmod 700 ${GETSSL_EXEC} \
    && mkdir -p ${GETSSL_WORKDIR} \
    && mkdir -p /usr/local/apache2/htdocs/.well-known/acme-challenge

COPY --chown=root:root root-crontab /etc/crontab

RUN touch /etc/default/locale

COPY supervisord.conf /usr/local/etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/usr/local/etc/supervisord.conf"]
