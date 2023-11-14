echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

echo 'subnet 192.226.1.0 netmask 255.255.255.0 {
}

subnet 192.226.3.0 netmask 255.255.255.0 {
    range 192.226.3.16 192.226.3.32;
    range 192.226.3.64 192.226.3.80;
    option routers 192.226.3.0;
    option broadcast-address 192.226.3.255;
    option domain-name-servers 192.226.1.1;
    default-lease-time 180;
    max-lease-time 5760;
}

subnet 192.226.4.0 netmask 255.255.255.0 {
    range 192.226.4.12 192.226.4.20;
    range 192.226.4.160 192.226.4.168;
    option routers 192.226.4.0;
    option broadcast-address 192.226.4.255;
    option domain-name-servers 192.226.1.1;
    default-lease-time 720;
    max-lease-time 5760;
}' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart