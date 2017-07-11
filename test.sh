#!/bin/bash

MYSQL='mysql -ptesting'
DB=galera
TABLE=debug

docker exec galeradebug_node1_1 ${MYSQL} -e "create database if not exists ${DB}"

docker exec galeradebug_node1_1 ${MYSQL} ${DB} -e "create table if not exists ${TABLE} (id int, hostname char(12)); truncate table ${TABLE};"

for i in $(seq 1 5); do
    for N in node1 node2 node3; do
	docker exec galeradebug_${N}_1 ${MYSQL} ${DB} -e "insert into ${TABLE} (id,hostname) values (RAND()*1000, @@hostname);"
    done
done

for N in node1 node2 node3; do
    docker exec galeradebug_${N}_1 ${MYSQL} ${DB} -vv -t -e "select * from ${TABLE};"
done

for N in node1 node2 node3; do
    rm -f ${N}.fifo
    mkfifo ${N}.fifo
    cat ${N}.fifo | docker exec -i galeradebug_${N}_1 ${MYSQL} ${DB} -vv &
done

sleep 1 # wait for mysql (client) processes are ready

echo "delete from ${TABLE} where hostname=@@hostname;" > node3.fifo &
echo "delete from ${TABLE} where hostname=@@hostname;" > node1.fifo &
echo "delete from ${TABLE} where hostname=@@hostname;" > node2.fifo &

sleep 1 # wait for above to finish

for N in node1 node2 node3; do
    docker exec galeradebug_${N}_1 ${MYSQL} ${DB} -vv -t -e "select * from ${TABLE};"
done
