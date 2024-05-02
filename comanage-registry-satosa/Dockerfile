FROM debian:bookworm-slim

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
    && pip install pysaml2==7.5.0 \
    && pip install satosa==8.4.0 \
    && chown -R satosa:satosa /opt/satosa \
    && apt-get purge -y \
        build-essential \
        libpcre3-dev \
        python3-dev \
    && apt-get clean

# Use version of mdstore.py from thread_safe_mdq branch
# until merged upstream.
RUN curl -L \
  -o /opt/satosa/lib/python3.11/site-packages/saml2/mdstore.py \
  https://raw.githubusercontent.com/cilogon/pysaml2/256ca0129aa9ee9b652fff3812a3f9b8182a5902/src/saml2/mdstore.py

# Use updated ldap_attribute_store.py from ldap_server_mode branch
# until merged upstream.
RUN curl -L \
  -o /opt/satosa/lib/python3.11/site-packages/satosa/micro_services/ldap_attribute_store.py \
  https://raw.githubusercontent.com/cilogon/SATOSA/ef0d51beed75b8a30dbe011cd48e3e3b83d37a14/src/satosa/micro_services/ldap_attribute_store.py

COPY start.sh /usr/local/sbin/satosa-start.sh

WORKDIR /opt/satosa
USER satosa

ENTRYPOINT ["/usr/local/sbin/satosa-start.sh"]
