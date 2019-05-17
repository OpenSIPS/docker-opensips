#!/bin/bash

HOST_IP=$(ip route get 8.8.8.8 | head -n +1 | tr -s " " | cut -d " " -f 7)

sed -i "s/listen=.*/listen=udp:${HOST_IP}:5060/g" /etc/opensips/opensips.cfg
sed -i "s/log_stderror=no/log_stderror=yes/g" /etc/opensips/opensips.cfg

/etc/init.d/opensips start

journalctl -f -u opensips
