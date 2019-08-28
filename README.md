# Bitcoin - USD exchange rate
This project facilitates an API call every 10 minutes to get the exchange rate and provisions the infrastruture for scheduling, monitoring and notifying.
## Tech
* Docker - Environment
* Python Scripting - Application Coding
* Graphite - Application Backend
* Airflow - Scheduling
* Postgres - Airflow backend
* StatsD - Send airflow metric aggregates to GraphiteDB
* Grafana - Visualization and Alerting
* Sematext - Infra monitoring
## Email for notifications
```
takeawayt@yandex.com
```
## Architecture
![image](https://github.com/shubhiguptaa/takeaway/blob/master/Architecture.png)
## Setup and install
* Clone the repository.
* [docker_run.sh](https://github.com/shubhiguptaa/takeaway/blob/master/docker_run.sh) in the root of the repository will create a docker network and runs the docker containers for postgres, graphite, smtp, grafana and airflow.
The script takes the local git repo as an argument. Run the script like the following example:
```
./docker_run.sh ~/github/takeaway
```
Once the script has successfully run, the containers must be up and running.
* Launch the airflow on the browser and login (credentials in the email).
```
http://localhost:8080
```
* Turn the 'BT-USD_Exchange' dag On by using the toggle. By default, set to Off.
* Launch grafana and login (credentials in the email).
```
http://localhost:3000
```
 *You might be prompted to change the password.*
* Import the dashboard [BT-USDExRate.json](https://github.com/shubhiguptaa/takeaway/blob/master/grafana/dashboard/BT-USDExRate.json). 
* Login to sematext to see infrastructure metrics.
```
https://apps.sematext.com/ui/login/
Choose Europe
Provide email :takeawayt@yandex.com
Password : (in email)
```

**_Find more documentation in the respective folders_**

## Other tools
### Graphite
#### Docker -
- Base Image - graphite/statsd
- Port exposed - 2003, 2004, 8125, 8126\
_Used docker volumes for persistent storage
### SMTP
#### Docker -
- Base Image - bytemark/smtp
### Sematext
- Managed monitoring 
- Docker base image - sematext/agent:latest

## Scalability and HA options
- A similar setup can be done on Kubernetes for making each component scalable and HA using deployments, services, ingress, PDB, HPA and stateful sets.
- PostgresDB can be setup on managed services like RDS clusters for HA and scalability options and DR.
- Graphite can be deployed as a stateful set on K8s.
- Airflow as deployment can be scaled using Horizontal Pod Autoscalers and Pod Disruption Budget for HA




