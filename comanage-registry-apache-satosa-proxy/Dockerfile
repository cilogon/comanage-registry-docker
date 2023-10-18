FROM httpd:2.4.57

COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
        curl
