echo 'auto eth0
iface eth0 inet static
	address 192.226.1.2
	netmask 255.255.255.0
	gateway 192.226.1.0
' > /etc/network/interfaces