FROM nginx:1.17.8

COPY start.sh /usr/local/bin/nginx-start.sh

RUN chmod 0700 /usr/local/bin/nginx-start.sh

ENTRYPOINT ["/usr/local/bin/nginx-start.sh"]
