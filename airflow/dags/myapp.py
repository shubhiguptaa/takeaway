import json
import os
import requests
from datetime import timedelta,datetime

import airflow
from airflow import DAG
from airflow.operators.python_operator import PythonOperator


args = {
    'owner': 'airflow',
    'start_date': datetime(2019, 8, 25, 7, 40),
#    'provide_context': True,
}

dag = DAG('final_dag',
      schedule_interval='*/3 * * * *',
      default_args = args)

def get_exchange_rate():
    url = 'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=USD&apikey=H29AYNMTRXXSOA1C'
    response = requests.get(url)
    dict = response.json()
    er=(dict["Realtime Currency Exchange Rate"]["5. Exchange Rate"])
#    task_instance = context['task_instance']
#    task_instance.xcom_push(self.xcom_task_id_key,er)
    return er


t1 = PythonOperator(task_id='task1', python_callable=get_exchange_rate, dag = dag,)


#def db_write():
def db_write(**kwargs):
    ti = kwargs['ti']
    value = ti.xcom_pull(task_ids='task1')
    command = 'echo ' + '\"local.exchange.rates ' + str(value) + ' `date ' + '+%s`' + '\"' + " | nc -q 1 graphite 2003"
    os.system ( command )
    print (command)
    return (command)

t2 = PythonOperator(task_id='task2', python_callable=db_write, dag = dag, 
     provide_context=True
)

t1>>t2
