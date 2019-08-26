#!/bin/bash
#Description: Run docker containers in sequence

#set base variables
export net=takeaway_assignment
export grafana_conf_vol=~/github/takeaway/graphana/conf/defaults.ini
export dag_app_vol=~/github/takeaway/airflow/dags/

#Pre-built images
im_smtp=bytemark/smtp
im_graphite=graphiteapp/graphite-statsd
im_grafana=grafana/grafana

#Create docker  network
docker network list | grep $net
if [ `echo $?` == 0 ];then
     echo "$net docket network already exists"
else
    docker network create $net 
fi

#Run postgres db
docker run --name postgres --net $net -e POSTGRES_PASSWORD=airflow -d postgres
if [ `echo $?` == 0 ];then
    echo "Postgres running"
    docker ps |grep postgres
    sleep 10
fi

#Run smtp
docker run --restart always --name smtp --net $net -d $im_smtp
if [ `echo $?` == 0 ];then
    echo "smtp running"
    docker ps |grep ${im_smtp}
    sleep 10
fi

#Run grafana
docker run -i -d --name grafana --net $net -v ${grafana_conf_vol}:/usr/share/graphana/conf/defaults.ini -p 3000:3000 ${im_grafana}
if [ `echo $?` == 0 ];then
    echo "grafana running"
    docker ps |grep ${im_grafana}
    sleep 10
fi

#Run GraphiteDB
docker run -d  --name graphite --restart=always --net $net -p 80:80 -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126  ${im_graphite}
if [ `echo $?` == 0 ];then
    echo "Graphite running"
    docker ps |grep ${im_graphite}
    sleep 10
fi

#Run airflow
docker run -d -p 8080:8080 --net $net --link postgres:postgres -v ${dag_app_vol}:/usr/local/airflow/dags airflow webserver
if [ `echo $?` == 0 ];then
    echo "Airflow running"
    docker ps |grep airflow
    sleep 10
fi

#check all containers
echo "\nListing ALL running Container\n"
docker ps
