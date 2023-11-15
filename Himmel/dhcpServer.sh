echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

echo 'subnet 192.226.1.0 netmask 255.255.255.0 {
    option routers 192.226.1.0;
    option broadcast-address 192.226.1.255;
    option domain-name-servers 192.226.1.1;
}

subnet 192.226.2.0 netmask 255.255.255.0 {
    option routers 192.226.2.0;
    option broadcast-address 192.226.2.255;
    option domain-name-servers 192.226.1.1;
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
}

host Heiter {
    hardware ethernet 42:32:8f:22:d8:58;
    fixed-address 192.226.1.1;
}

host Denken {
    hardware ethernet ba:63:50:e2:03:de;
    fixed-address 192.226.2.1;
}

host Elsen {
    hardware ethernet de:9f:53:b6:76:68;
    fixed-address 192.226.2.2;
}

host Lawine {
    hardware ethernet 9e:5e:1f:e6:c1:67;
    fixed-address 192.226.3.1;
}

host Linie {
    hardware ethernet c2:66:cc:96:7f:8e;
    fixed-address 192.226.3.2;
}

host Lugner {
    hardware ethernet 02:7e:1b:31:ee:b7;
    fixed-address 192.226.3.3;
}

host Frieren {
    hardware ethernet 7a:a1:96:37:78:73;
    fixed-address 192.226.4.1;
}

host Flamme {
    hardware ethernet ce:d5:27:47:88:2c;
    fixed-address 192.226.4.2;
}

host Fern {
    hardware ethernet f2:94:c1:5b:15:fb;
    fixed-address 192.226.4.3;
}' > /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart