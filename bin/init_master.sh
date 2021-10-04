#!/bin/bash

if [ -z $3 -a -z $4 ]; then
    echo "init_master.sh <network_interface> <virtual_ip> <master_ip> <slave_ip>"
    echo "network_interface: eg. eth0"
    echo "virtual_ip: virtual ip for cluster"
    echo "master_ip: real ip for this server"
    echo "slave_ip: real ip for another server"
    exit 1
fi

docker exec mysql_1 /opt/mysql/init_replica.sh $4 $3
docker exec -uroot mysql_1 /opt/mysql/init_keepalived.sh $1 $2 100 
