FROM debian:stretch

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        python-virtualenv \
        virtualenv \
        xmlsec1

# Use specific commit from HEAD of SATOSA
ENV SATOSA_SRC_URL=git+https://github.com/IdentityPython/SATOSA.git@86537fbbc40dc4533430ae35c9ce5dcef4fb4c80

RUN mkdir -p /opt/satosa \
    && adduser --home /opt/satosa --no-create-home --system satosa --group \
    && virtualenv --python=python3.5 /opt/satosa --no-site-packages \
    && . /opt/satosa/bin/activate \
    && pip install ldap3 \
    && pip install ${SATOSA_SRC_URL} \
    && chown -R satosa:satosa /opt/satosa \
    && apt-get remove -y --purge \
        git \
    && apt-get clean

COPY start.sh /usr/local/sbin/satosa-start.sh

WORKDIR /opt/satosa
USER satosa

ENTRYPOINT ["/usr/local/sbin/satosa-start.sh"]
