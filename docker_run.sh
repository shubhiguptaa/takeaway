#!/bin/bash

docker network create takeaway_assignment 
echo $?

docker run --name postgres --net takeaway_assignment -e POSTGRES_PASSWORD=airflow -d postgres
echo $?

docker run -d --name graphite -p 80:80 -p 2003:2003 -p 2003:2003/udp -p 2004:2004 -p 7002:7002  --net takeaway_assignment  mrlesmithjr/graphite\n
echo $?

docker run -i -d --name grafana --net takeaway_assignment -p 3000:3000 grafana/grafana
echo $?

docker run -d -p 8080:8080 --net takeaway_assignment --link postgres:postgres -v /Users/shubhigupta/github/takeaway_assignment/airflow/dags/:/usr/local/airflow/dags airflow webserver
echo $?

docker ps

