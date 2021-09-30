#!/bin/bash

if [ -z $2 -a -z $3 ]; then
    echo "init_slave.sh <network_interface> <virtual_ip> <slave_ip>"
    echo "network_interface: eg. eth0"
    echo "virtual_ip: virtual ip for cluster"
    echo "slave_ip: real ip for this server"
    exit 1
fi

docker exec -uroot mysql_2 /opt/mysql/init_keepalived.sh $1 $2 $3 90

