apt-get update
apt-get install php php-fpm -y
service php7.3-fpm start
apt-get install nginx -y
service nginx start
apt-get install wget unzip -y
apt-get install rsyslog -y
service rsyslog start
apt-get install htop -y