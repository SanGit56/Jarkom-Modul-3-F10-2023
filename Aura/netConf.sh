echo 'auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.226.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.226.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.226.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.226.4.1
	netmask 255.255.255.0
' > /etc/network/interfaces
