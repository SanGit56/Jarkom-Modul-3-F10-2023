#!/bin/bash

zone="zone \"riegel.canyon.f10.com\" {
	type master;
	file \"/etc/bind/jarkom/riegel.canyon.f10.com\";
};

zone \"granz.channel.f10.com\" {
	type master;
	file \"/etc/bind/jarkom/granz.channel.f10.com\";
};"

echo "$zone" > /etc/bind/named.conf.local

mkdir /etc/bind/jarkom
cp /etc/bind/db.local /etc/bind/jarkom/riegel.canyon.f10.com

conf_riegel=';
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	riegel.canyon.f10.com. root.riegel.canyon.f10.com. (
			2022100601		; Serial
			604800		; Refresh
			86400			; Retry
			2419200		; Expire
			604800 )		; Negative Cache TTL
;
@	IN	NS		riegel.canyon.f10.com.
@	IN	A		192.226.4.1		; IP Frieren worker laravel
@	IN	AAAA		::1'

echo "$conf_riegel" > /etc/bind/jarkom/riegel.canyon.f10.com

cp /etc/bind/db.local /etc/bind/jarkom/granz.channel.f10.com

conf_granz=';
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	granz.channel.f10.com. root.granz.channel.f10.com. (
			2022100601		; Serial
			604800		; Refresh
			86400			; Retry
			2419200		; Expire
			604800 )		; Negative Cache TTL
;
@	IN	NS		granz.channel.f10.com.
@	IN	A		192.226.3.1		; IP Lawine worker php
@	IN	AAAA		::1'

echo "$conf_granz" > /etc/bind/jarkom/granz.channel.f10.com

service bind9 restart