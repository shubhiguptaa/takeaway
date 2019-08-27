#!/bin/bash
#Description: Run docker containers in sequence

#store arguments 
git_repo=$1

#set base variables
export net=takeaway_assignment
export grafana_conf_vol=$1/grafana/conf/defaults.ini
export dag_app_vol=$1/airflow/dags/

echo $grafana_conf_vol
echo $dag_app_vol

#Docker images
im_smtp=shubhiguptaa/smtp
im_graphite=shubhiguptaa/graphite-statsd
im_grafana=shubhiguptaa/grafana
im_airflow=shubhiguptaa/airflow
im_postgres=shubhiguptaa/postgres
im_sematext=shubhiguptaa/sematext

#Create docker  network
docker network list | grep $net
if [ `echo $?` == 0 ];then
     echo "$net docker network already exists"
else
    docker network create $net 
fi

#Run postgres db
docker run --name postgres --net $net -e POSTGRES_PASSWORD=airflow -v pgdata:/var/lib/postgresql/data -d ${im_postgres}
if [ `echo $?` == 0 ];then
    docker ps |grep postgres
    echo "Postgres running"
    sleep 5
fi

#Run smtp
docker run --restart always --name smtp --net $net -d ${im_smtp}
if [ `echo $?` == 0 ];then
    docker ps |grep ${im_smtp}
    echo "smtp running"
    sleep 5
fi

#Run grafana
docker run -i -d --name grafana --net $net -v ${grafana_conf_vol}:/usr/share/grafana/conf/defaults.ini -v grafana-data:/var/lib/grafana -p 3000:3000 ${im_grafana}
if [ `echo $?` == 0 ];then
    docker ps |grep ${im_grafana}
    echo "grafana running"
    sleep 5
fi

#Run GraphiteDB
docker run -d  --name graphite --restart=always --net $net -v graphite-data:/opt/graphite/storage/whisper -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126  ${im_graphite}
if [ `echo $?` == 0 ];then
    docker ps |grep ${im_graphite}
    echo "Graphite running"
    sleep 5
fi

#Run airflow
docker run -d --name airflow -p 8080:8080 --net $net --link postgres:postgres -v ${dag_app_vol}:/usr/local/airflow/dags ${im_airflow}  webserver
if [ `echo $?` == 0 ];then
    docker ps |grep airflow
    echo "Airflow running"
    sleep 5
fi

docker run -d  --restart always --privileged -P --name st-agent -v /:/hostfs:ro -v /etc/passwd:/etc/passwd:ro  -v /etc/group:/etc/group:ro  -v /sys/kernel/debug:/sys/kernel/debug -v /var/run/:/var/run/ -v /proc:/host/proc:ro -v /etc:/host/etc:ro -v /sys:/host/sys:ro -v /usr/lib:/host/usr/lib:ro -e CONTAINER_TOKEN=4f3298d4-d390-45ea-9c22-48b9ce8864b9 -e INFRA_TOKEN=feb27af8-a61b-4275-91d9-f39f52f3ee31 -e REGION=EU -e JOURNAL_DIR=/var/run/st-agent -e LOGGING_WRITE_EVENTS=false -e LOGGING_REQUEST_TRACKING=false -e LOGGING_LEVEL=info -e NODE_NAME="`hostname`" -e CONTAINER_SKIP_BY_IMAGE=sematext ${im_sematext}


#check all containers
echo "\nListing ALL running Container\n"
docker ps
