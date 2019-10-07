FROM redis:5.0.5-buster

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        python-virtualenv \
        redis-tools \
        supervisor \
        virtualenv 

# Use specific commit from pyFF repostory.
ENV PYFF_SRC_URL=git+https://github.com/IdentityPython/pyFF.git@479cca3eb57c5fde7ef8e0c8cf5384bf301fb305

RUN mkdir -p /opt/pyff \
    && adduser --home /opt/pyff --no-create-home --system pyff --group \
    && virtualenv /opt/pyff --no-site-packages --python=python3 \
    && . /opt/pyff/bin/activate \
    && pip install --upgrade pip \
    && pip install ${PYFF_SRC_URL} \
    && chown -R pyff:pyff /opt/pyff \
    && apt-get remove -y --purge \
        git \
    && apt-get clean

COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY logger.ini /opt/pyff/logger.ini
COPY pyff-start.sh /usr/local/bin/pyff-start.sh
COPY gunicorn_sighup.py /opt/pyff/gunicorn_sighup.py
COPY gunicorn_sighup_logger.yaml /opt/pyff/gunicorn_sighup_logger.yaml

WORKDIR /opt/pyff

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/usr/local/etc/supervisord.conf"]
