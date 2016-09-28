#!/bin/bash

HOST_IP=$(ip route get 8.8.8.8 | head -n +1 | tr -s " " | cut -d " " -f 7)

sed -i "s/listen=.*/listen=udp:${HOST_IP}:5060/g" /usr/local/etc/opensips/opensips.cfg

service rsyslog start

/usr/local/sbin/opensipsctl start

tail -f /var/log/opensips.log
