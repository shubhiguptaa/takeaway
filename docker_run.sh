#!/bin/bash

docker network create takeaway_assignment 
echo $?


docker run --name postgres --net takeaway_assignment -e POSTGRES_PASSWORD=airflow -d postgres
echo $?

sleep 10
#docker run -d --name graphite -p 80:80 -p 2003:2003 -p 2003:2003/udp -p 2004:2004 -p 7002:7002  --net takeaway_assignment  mrlesmithjr/graphite\n
#echo $?

sleep 10
docker run -i -d --name grafana --net takeaway_assignment -p 3000:3000 grafana/grafana
echo $?

sleep 10
docker run -d -p 8080:8080 --net takeaway_assignment --link postgres:postgres -v /Users/shubhigupta/github/takeaway_assignment/airflow/dags/:/usr/local/airflow/dags airflow webserver
echo $?

sleep 10
docker run -d  --name graphite --restart=always --net takeaway_assignment -p 80:80 -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126  graphiteapp/graphite-statsd
echo $?

sleep 10
docker ps

