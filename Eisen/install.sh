apt-get update
apt-get install nginx -y
service nginx start
apt-get install rsyslog -y
service rsyslog start
apt-get update
apt-get install apache2-utils -y