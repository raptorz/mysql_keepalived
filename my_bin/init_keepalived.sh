#!/bin/bash

if [ -z $3 -a -z $4 ]; then
    echo "Usage: init_keepalived.sh <network_interface> <virtual_ip> <source_ip> <priority>"
    echo "network_interface: eg. eth0"
    echo "virtual_ip: virtual ip for cluster"
    echo "source_ip: real ip for this server"
    echo "priority: master is 100, backup is 90"
    exit 1
fi

KEEPALIVED_ROUTER_ID=MySQL_HA
KEEPALIVED_INTERFACE=$1
KEEPALIVED_VIRTUAL_IP=$2
KEEPALIVED_SOURCE_IP=$3
KEEPALIVED_PRIORITY=$4
KEEPALIVED_AUTH_PASS="${KEEPALIVED_ROUTER_ID}@${KEEPALIVED_VIRTUAL_IP}"

KEEPALIVED_CONF_TEMP="/opt/mysql/keepalived.conf.template"
KEEPALIVED_CONF_FILE="/etc/keepalived/keepalived.conf"

cp ${KEEPALIVED_CONF_TEMP} $KEEPALIVED_CONF_FILE
sed -i "s|{{ KEEPALIVED_ROUTER_ID }}|$KEEPALIVED_ROUTER_ID|g" $KEEPALIVED_CONF_FILE
sed -i "s|{{ KEEPALIVED_INTERFACE }}|$KEEPALIVED_INTERFACE|g" $KEEPALIVED_CONF_FILE
sed -i "s|{{ KEEPALIVED_VIRTUAL_IP }}|$KEEPALIVED_VIRTUAL_IP|g" $KEEPALIVED_CONF_FILE
sed -i "s|{{ KEEPALIVED_SOURCE_IP }}|$KEEPALIVED_SOURCE_IP|g" $KEEPALIVED_CONF_FILE
sed -i "s|{{ KEEPALIVED_PRIORITY }}|$KEEPALIVED_PRIORITY|g" $KEEPALIVED_CONF_FILE
sed -i "s|{{ KEEPALIVED_AUTH_PASS }}|$KEEPALIVED_AUTH_PASS|g" $KEEPALIVED_CONF_FILE

/usr/sbin/keepalived -f $KEEPALIVED_CONF_FILE -l -D -d

exit 0
