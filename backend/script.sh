#!/bin/sh
docker build -t node-app-image .
docker network inspect my_network >/dev/null 2>&1 || \
    docker network create --driver bridge my_network
docker run --name=node-app-container -p 3000:3000 --network my_network node-app-image