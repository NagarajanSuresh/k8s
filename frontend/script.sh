#!/bin/sh
docker build -t react-app-image .
docker network inspect my_network >/dev/null 2>&1 || \
    docker network create --driver bridge my_network
docker run --name=react-app-container -p 8000:80 --network my_network react-app-image