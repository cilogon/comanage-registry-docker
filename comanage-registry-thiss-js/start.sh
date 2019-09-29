#!/bin/bash

mdq_host_port=`dirname ${MDQ_URL}`

cat>/etc/nginx/nginx.conf<<EOF
daemon off;

user  nginx;
worker_processes  1;

error_log /dev/stdout info;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log /dev/stdout main;

    keepalive_timeout  65;

    server {
      listen 80;

      location / {
         root /usr/share/nginx/html;
         try_files \$uri \$uri/index.html \$uri.html @mdq;
      }

      location @mdq {
         proxy_pass ${mdq_host_port};
      }
   }

}
EOF

cd /dist
for f in `find . -printf '%P\n'`; do
   if [ "x$f" != "x" -a -f $f ]; then
      d=`dirname $f`
      mkdir -p /usr/share/nginx/html/$d
      envsubst '${BASE_URL} ${PERSISTENCE_URL} ${MDQ_URL} ${SEARCH_URL} ${DEFAULT_CONTEXT}' < $f > /usr/share/nginx/html/$f
   fi
done

nginx -c /etc/nginx/nginx.conf
