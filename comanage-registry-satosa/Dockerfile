FROM debian:buster

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        python-virtualenv \
        virtualenv \
        xmlsec1

# Use reference to PR 316 until it is merged.
ENV SATOSA_SRC_URL=git+https://github.com/IdentityPython/SATOSA.git@refs/pull/316/merge

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

# Copy in updated LDAP attribute store code until 
# PR 317 is merged.
COPY ldap_attribute_store.py /opt/satosa/lib/python3.7/site-packages/satosa/micro_services/ldap_attribute_store.py

WORKDIR /opt/satosa
USER satosa

ENTRYPOINT ["/usr/local/sbin/satosa-start.sh"]
