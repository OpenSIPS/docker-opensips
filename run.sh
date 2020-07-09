#!/bin/bash

sed -i "s/RUN_OPENSIPS=no/RUN_OPENSIPS=yes/g" /etc/default/opensips
sed -i "s/DAEMON=\/sbin\/opensips/DAEMON=\/usr\/sbin\/opensips/g" /etc/init.d/opensips

HOST_IP=$(ip route get 8.8.8.8 | head -n +1 | tr -s " " | cut -d " " -f 7)
sed -i "s/listen=.*/listen=udp:${HOST_IP}:5060/g" /etc/opensips/opensips.cfg

# skip syslog and run opensips at stderr
/usr/sbin/opensips -FE
