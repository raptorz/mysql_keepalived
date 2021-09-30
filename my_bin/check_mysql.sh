#!/bin/bash

MYSQL_ROOT_PASSWORD=MySQL_1234

mysql=( mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" )
if
    ! echo "select 1;" | "${mysql[@]}" >/dev/null 2>&1
then
    echo "mysql is not running"
    exit 1
fi

exit 0
