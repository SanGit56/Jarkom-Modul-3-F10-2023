echo '[www]
user = www-data
group = www-data

listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data

pm = dynamic
pm.max_children = 50
pm.start_servers = 20
pm.min_spare_servers = 10
pm.max_spare_servers = 30' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.0-fpm restart