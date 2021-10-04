#!/bin/bash

MYSQL_ROOT_PASSWORD=MySQL_1234
MYSQL_DATA_ROOT="/var/lib"
MYSQL_LOG_ROOT="/var/log"
MYSQL_CONF_ROOT="$(dirname $( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P ))"

if [ -z $1 ]; then
    echo "Usage: start_mysql.sh <server_id>"
    echo "server_id: 1 or 2"
    exit 1
fi

MYSQL_SERVER_ID=$1
MYSQL_DATA_PATH="${MYSQL_DATA_ROOT}/mysql_${MYSQL_SERVER_ID}"
MYSQL_LOG_PATH="${MYSQL_LOG_ROOT}/mysql_${MYSQL_SERVER_ID}"
MYSQL_CONF_PATH="${MYSQL_CONF_ROOT}/my.cnf.d"
MYSQL_NAME="mysql_${MYSQL_SERVER_ID}"

if [ ! -d $MYSQL_DATA_PATH ]; then
    sudo mkdir ${MYSQL_DATA_PATH}
    sudo chown 1001:1001 ${MYSQL_DATA_PATH}
fi
if [ ! -d $MYSQL_LOG_PATH ]; then
    sudo mkdir ${MYSQL_LOG_PATH}
    sudo chown 1001:1001 ${MYSQL_LOG_PATH}
fi

sed "s|{{ SERVER_ID }}|$MYSQL_SERVER_ID|g" ${MYSQL_CONF_PATH}/my.cnf.template > ${MYSQL_CONF_PATH}/my.cnf

docker run -d -p3306:3306 \
    -v ${MYSQL_DATA_PATH}:/var/lib/mysql \
    -v ${MYSQL_LOG_PATH}:/var/log/mysql \
    -v ${MYSQL_CONF_PATH}:/etc/my.cnf.d \
    -v ${MYSQL_CONF_ROOT}/my_bin:/opt/mysql \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    --name ${MYSQL_NAME} \
    mysql_keepalived
