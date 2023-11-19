#!/bin/bash

cp /etc/nginx/sites-available/default /etc/nginx/sites-available/lb-riegel
ln -s /etc/nginx/sites-available/lb-riegel /etc/nginx/sites-enabled

echo 'upstream backendRiegel {
    server 192.226.4.1; #IP Lawine
    server 192.226.4.2;
    server 192.226.4.3;
}

server {
    listen 81 default_server;
    listen [::]:81 default_server;
    server_name _;

    location / {
        proxy_pass http://backendRiegel;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    Host $http_host;
    }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}' > /etc/nginx/sites-available/lb-riegel

service nginx restart