# Airflow config and setup
## Plugins 
- Postgres
- StatsD
## Config updates
- Executor - Sequential
- DB Backend - Postgres
- Authenticate - True
- Auth Backend - Password
- SMTP 
- Result Backend - Postgres
- StatsD host - Graphite
- Catchup - false
- Max threads - 1\
*and related configs*
## Supporting Scripts
- entrypoint.sh - Docker entry point
- add_user.py - Insert row to users table in order to enable authentication
## Dockerfile
- Base image - debian:stretch-slim
- Includes python and other packages for the features to work
- Port exposed - 8080
## DAG
- Schedule interval - 10 minutes
- 3 functions
  - get exchange rate - call api endpoint and get the exchange rate
  - db write - write the exchange rate and time to Graphite over udp
  - notify email - callback for the two tasks failure, sends email
  

