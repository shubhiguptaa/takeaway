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
* Launch graphana and login (credentials in the email).
```
http://localhost:3000
```
 *You might be prompted to change the password.*
* Import the dashboard [BT-USDExRate.json](https://github.com/shubhiguptaa/takeaway/blob/master/grafana/dashboard/BT-USDExRate.json). 


**_Find more documentation in the respective folders_**

## Other tools
### Graphite
#### Docker -
- Base Image - graphite/statsd
- Port exposed - 2003, 2004, 8125, 8126
_Used docker volumes for persistent storage
### smtp
#### Docker -
- Base Image - bytemark/smtp




