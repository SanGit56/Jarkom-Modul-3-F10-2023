echo 'upstream backend  {
    server 192.226.3.1 weight=4; #IP Lawine
    server 192.226.3.2 weight=2; #IP Linie
    server 192.226.3.3 weight=1; #IP Lugner
}


server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;


    location / {
        proxy_pass http://backend;
        proxy_set_header    X-Real-IP $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    Host $http_host;


        auth_basic "Administrators Area";
        auth_basic_user_file /etc/nginx/rahasisakita/.htpasswd;
    }


    location ~ /\.ht {
        deny all;
    }

    location ~ /its {
        proxy_pass https://www.its.ac.id;
    }

    error_log /var/log/nginx/lb_error.log;
    access_log /var/log/nginx/lb_access.log;
}' > /etc/nginx/sites-available/lb-granz


service nginx restart