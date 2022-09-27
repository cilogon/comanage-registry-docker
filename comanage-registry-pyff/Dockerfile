FROM redis:5.0.14-bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        curl \
        git \ 
        python3-venv \
        redis-tools \
        supervisor \
        virtualenv 

RUN mkdir -p /opt/pyff \
    && adduser --home /opt/pyff --no-create-home --system pyff --group \
    && python3 -m venv /opt/pyff \
    && . /opt/pyff/bin/activate \
    && pip install --upgrade pip \
    && pip install pyff==2.0.0 \
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
