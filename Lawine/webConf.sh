cp /etc/nginx/sites-available/default /etc/nginx/sites-available/granz
wget -O '/var/www/granz.channel.f10.com.zip' 'https://drive.usercontent.google.com/download?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1'
unzip /var/www/granz.channel.f10.com.zip -d /var/www
rm /var/www/granz.channel.f10.com.zip

echo 'server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/modul-3;

    index index.html index.htm index.php;

    server_name granz.channel.f10.com;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
    }
}' > /etc/nginx/sites-available/granz

ln -s /etc/nginx/sites-available/granz /etc/nginx/sites-enabled
unlink /etc/nginx/sites-enabled/default

service nginx restart