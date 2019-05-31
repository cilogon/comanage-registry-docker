FROM debian:stretch

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        python-virtualenv \
        virtualenv 

# Use specific commit from ra21-l2 branch.
ENV PYFF_SRC_URL=git+https://github.com/IdentityPython/pyFF.git@0917ff73181a62e1eb959c67c23db5eb4dfb07ad

RUN mkdir -p /opt/pyff \
    && adduser --home /opt/pyff --no-create-home --system pyff --group \
    && virtualenv /opt/pyff --no-site-packages \
    && . /opt/pyff/bin/activate \
    && pip install ${PYFF_SRC_URL} \
    && mkdir -p /opt/pyff/lib/python2.7/site-packages/pyff/site/static/logos \
    && chown -R pyff:pyff /opt/pyff \
    && apt-get remove -y --purge \
        git \
    && apt-get clean

COPY start.sh /usr/local/sbin/pyff-start.sh

# Copy in local changes that permit different templates to be used
# for different discovery endpoints provided the template is whitelisted.
COPY mdx.py /opt/pyff/lib/python2.7/site-packages/pyff/mdx.py
COPY constants.py /opt/pyff/lib/python2.7/site-packages/pyff/constants.py

WORKDIR /opt/pyff
USER pyff

ENTRYPOINT ["/usr/local/sbin/pyff-start.sh"]
