#!/bin/bash

MYSQL_ROOT_PASSWORD=MySQL_1234

mysql=( mysql -h127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" )
if
    ! echo "select 1;" | "${mysql[@]}" &> /dev/null
then
    kill -15 $(cat /run/keepalived.pid)
    exit 1
fi

exit 0
