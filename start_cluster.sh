#!/bin/bash

# cleanup before we start again...
docker rm -f galeradebug_node1_1 galeradebug_node2_1 galeradebug_node3_1
sudo rm -rf node1-mysqld node2-mysqld node3-mysqld

# initialize cluster on node1
docker-compose up -d node1

# wait for node1 to start up and initialize (seems like we need 2 seconds)
sleep 5

# start node2 and node3 and wait for them to stop
docker-compose up node2 node3

# start node2 and node3
docker-compose up -d node2 node3

# tail logs from all 3 nodes
docker-compose logs --tail 0 -f node1 node2 node3
