#!/bin/sh
docker build -t mysql-image .
docker run --name=mysql-db-container -p 3306:3306 mysql-image

