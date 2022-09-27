FROM debian:bullseye-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libpcre3-dev \
        python3 \
        python3-dev \
        python3-venv \
        xmlsec1

RUN mkdir -p /opt/satosa \
    && adduser --home /opt/satosa --no-create-home --system satosa --group \
    && python3 -m venv /opt/satosa \
    && . /opt/satosa/bin/activate \
    && pip install --upgrade pip \
    && pip install wheel \
    && pip install python-pcre \
    && pip install uwsgi \
    && pip install ldap3 \
    && pip install pysaml2==7.1.2 \
    && pip install satosa==8.0.1 \
    && chown -R satosa:satosa /opt/satosa \
    && apt-get purge -y \
        build-essential \
        libpcre3-dev \
        python3-dev \
    && apt-get clean

# Use version of mdstore.py from thread_safe_mdq branch
# until merged upstream.
COPY mdstore.py.b3754877 /opt/satosa/lib/python3.9/site-packages/saml2/mdstore.py

COPY start.sh /usr/local/sbin/satosa-start.sh

WORKDIR /opt/satosa
USER satosa

ENTRYPOINT ["/usr/local/sbin/satosa-start.sh"]
