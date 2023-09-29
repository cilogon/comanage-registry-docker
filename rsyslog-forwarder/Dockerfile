FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        ca-certificates \
        rsyslog \
        rsyslog-gnutls

COPY rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT ["/usr/sbin/rsyslogd", "-n"]
