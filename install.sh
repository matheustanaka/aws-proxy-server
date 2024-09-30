#!/bin/bash

echo "Updading system dependencies"
sudo apt update && sudo apt upgrade
echo

echo "Installing squid proxy"
sudo apt install squid -y
echo 

echo "Editing squid file"
# sudo vim /etc/squid/conf.d/debian.conf
# Replace "src <ip address>" with the IP address of your network provider
sudo bash -c 'cat <<EOF >> /etc/squid/conf.d/debian.conf
acl myhost src 189.68.2.128
http_access allow myhost
EOF'
echo
echo "Restart squid systemctl"
sudo systemctl restart squid
echo

echo "Finished the configuration"
