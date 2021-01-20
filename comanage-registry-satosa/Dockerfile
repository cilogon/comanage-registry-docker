FROM debian:buster

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        python-virtualenv \
        virtualenv \
        xmlsec1

RUN mkdir -p /opt/satosa \
    && adduser --home /opt/satosa --no-create-home --system satosa --group \
    && virtualenv --python=python3.7 /opt/satosa --no-site-packages \
    && . /opt/satosa/bin/activate \
    && pip install ldap3 \
    && pip install pysaml2==6.5.0 \
    && pip install satosa==7.0.2 \
    && chown -R satosa:satosa /opt/satosa \
    && apt-get remove -y --purge \
        git \
    && apt-get clean

COPY start.sh /usr/local/sbin/satosa-start.sh

WORKDIR /opt/satosa
USER satosa

ENTRYPOINT ["/usr/local/sbin/satosa-start.sh"]
