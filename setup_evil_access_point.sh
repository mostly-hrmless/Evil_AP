#!/bin/bash

apt-get install hostapd isc-dhcp-server -y

echo "interface=wlan0
driver=nl80211
ssid=YOUR_STATION
hw_mode=g
channel=11
wpa=1
wpa_passphrase=SECRETPASSWORD
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP CCMP
wpa_ptk_rekey=600
macaddr_acl=0" >> /etc/hostapd/hostapd.conf

mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bak

echo "subnet 172.16.120.0 netmask 255.255.255.0 {
range 172.16.120.10 172.16.120.100;
option domain-name-servers 8.8.4.4;
option routers 172.16.120.1;
interface wlan0;
}" >> /etc/dhcp/dhcpd.conf

ifconfig wlan0 172.16.120.1    #bring up the interface
/etc/init.d/isc-dhcp-server restart #restart the DHCP server
echo "1" > /proc/sys/net/ipv4/ip_forward #turn on IP forwarding
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE #add a routing rule.
hostapd -d /etc/hostapd/hostapd.conf



