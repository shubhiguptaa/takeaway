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

#Create docker  network
docker network list | grep $net
if [ `echo $?` == 0 ];then
     echo "$net docket network already exists"
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
docker run -d  --name graphite --restart=always --net $net -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126  ${im_graphite}
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

#check all containers
echo "\nListing ALL running Container\n"
docker ps
