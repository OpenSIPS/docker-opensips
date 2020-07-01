#!/bin/bash

HOST_IP=$(ip route get 8.8.8.8 | head -n +1 | tr -s " " | cut -d " " -f 7)

sed -i "s/^listen.*5060/listen = udp:${HOST_IP}:5060/g" /etc/opensips/opensips.cfg

OPENSIPS_ADVERTISED_ADDRESS=$OPENSIPS_ADVERTISED_ADDRESS
if [ ! -z ${OPENSIPS_ADVERTISED_ADDRESS} ] && [ `grep -c advertised_address /etc/opensips/opensips.cfg` -eq 0 ] ; then
    sed -i "/listen = udp/a\advertised_address=${OPENSIPS_ADVERTISED_ADDRESS}" /etc/opensips/opensips.cfg
fi

# skip syslog and run opensips at stderr
/usr/sbin/opensips -FE