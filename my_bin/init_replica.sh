#!/bin/bash

MYSQL_ROOT_PASSWORD=MySQL_1234
MYSQL_REPLICA_USER=replica
MYSQL_REPLICA_PASS=MySQL_1234

if [ -z $1 -a -z $2 ]; then
    echo "init_replica.sh <mysql_1_ip> <mysql_2_ip>"
    exit 1
fi

MYSQL_REPLICA_HOSTS=( $2 $1 )
MYSQL_REPLICA_REMOTES=( $1 $2 )

sql_check_user="SELECT user FROM mysql.user WHERE user='${MYSQL_REPLICA_USER}';"
for i in {0..1}; do
    mysql=( mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -h"${MYSQL_REPLICA_HOSTS[i]}" )
    for i in {120..0}; do
        if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
            break
        fi
        echo "MySQL init process in progress..."${MYSQL_REPLICA_HOSTS[i]}
        sleep 1
    done
    if [ "$i" = 0 ]; then
        echo >&2 "MySQL init process failed. "${MYSQL_REPLICA_HOSTS[i]}
        exit 1
    fi
    USER=$(echo $sql_check_user | "${mysql[@]}" 2> /dev/null)
    if [ -z "$USER" ]; then
        "${mysql[@]}" <<-EOSQL &> /dev/null
            grant replication slave on *.* to '${MYSQL_REPLICA_USER}'@'${MYSQL_REPLICA_REMOTES[i]}' identified by '${MYSQL_REPLICA_PASS}';
EOSQL
    fi
done

for i in {0..1}; do
    mysql=( mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -h"${MYSQL_REPLICA_HOSTS[i]}" )
    "${mysql[@]}" <<-EOSQL &> /dev/null
        stop slave;
        change master to master_host='${MYSQL_REPLICA_REMOTES[i]}', master_user='${MYSQL_REPLICA_USER}', master_password='${MYSQL_REPLICA_PASS}', master_auto_position=1;
        start slave;
EOSQL
done

exit 0
