#!/bin/bash

MYSQL_CONF_ROOT="$(dirname $( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P ))"

docker run -d --privileged --network=host -uroot \
    -v ${MYSQL_CONF_ROOT}/my_bin:/opt/mysql \
    --name keepalived \
    mysql_keepalived \
    /opt/mysql/debug_keepalived.sh $1 $2 $3
