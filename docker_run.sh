#!/bin/bash

docker network create takeaway_assignment 
echo $?


docker run --name postgres --net takeaway_assignment -e POSTGRES_PASSWORD=airflow -d postgres
echo $?
sleep 10

docker run --restart always --name smtp -d bytemark/smtp
exho $?

sleep 10
docker run -i -d --name grafana --net takeaway_assignment -v /Users/shubhigupta/github/takeaway/graphana/conf/defaults.ini:/usr/share/graphana/conf/defaults.ini -p 3000:3000 grafana/grafana
echo $?

sleep 10
docker run -d -p 8080:8080 --net takeaway_assignment --link postgres:postgres -v /Users/shubhigupta/github/takeaway/airflow/dags/:/usr/local/airflow/dags airflow webserver
echo $?

sleep 10
docker run -d  --name graphite --restart=always --net takeaway_assignment -p 80:80 -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126  graphiteapp/graphite-statsd
echo $?

sleep 10
docker ps

