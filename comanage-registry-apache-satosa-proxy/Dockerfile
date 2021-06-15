FROM httpd:2.4.48

COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl
