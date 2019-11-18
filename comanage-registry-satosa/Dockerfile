FROM debian:buster

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        python-virtualenv \
        virtualenv \
        xmlsec1

# Use specific commit from HEAD of SATOSA
ENV SATOSA_SRC_URL=git+https://github.com/IdentityPython/SATOSA.git@22053f9f5928c4d04210f70a64b9f3300d2b200d

RUN mkdir -p /opt/satosa \
    && adduser --home /opt/satosa --no-create-home --system satosa --group \
    && virtualenv --python=python3.7 /opt/satosa --no-site-packages \
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
