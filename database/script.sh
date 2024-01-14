#!/bin/sh
docker build -t mysql-image .
docker network inspect my_network >/dev/null 2>&1 || \
    docker network create --driver bridge my_network
docker run --name=mysql-db-container -p 3306:3306 --network my_network mysql-image

