#!/bin/bash

if [ -z $1 -a -z $2 ]; then
    echo "init_slave.sh <network_interface> <virtual_ip>"
    echo "network_interface: eg. eth0"
    echo "virtual_ip: virtual ip for cluster"
    exit 1
fi

docker exec -uroot mysql_2 /opt/mysql/init_keepalived.sh $1 $2 90

