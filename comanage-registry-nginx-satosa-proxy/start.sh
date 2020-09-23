#!/bin/bash

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
      }
   }
}
EOF

nginx -c /etc/nginx/nginx.conf