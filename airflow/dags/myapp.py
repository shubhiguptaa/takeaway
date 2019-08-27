import json
import os
import requests
from datetime import timedelta,datetime

import airflow
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.utils.email import send_email

args = {
    'owner': 'airflow',
    'start_date': datetime(2019, 8, 25, 7, 40),
}

dag = DAG('BT_USD_exchange',
      schedule_interval='*/10 * * * *',
      default_args = args)

def notify_email(contextDict, **kwargs):
    """Send custom email alerts."""

    # email title.
    title = "Airflow alert: {task_instance} Failed".format(**contextDict)

    # email contents
    body = """
    Hi Everyone, <br>
    <br>
    There's been an error in the {task_instance} job.<br>
    <br>
    Forever yours,<br>
    Airflow bot <br>
    """.format(**contextDict)

    send_email('shubhi.guptaa@gmail.com', title, body)



def get_exchange_rate():
    url = 'https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=USD&apikey=H29AYNMTRXXSOA1C'
    response = requests.get(url)
    dict = response.json()
    er=(dict["Realtime Currency Exchange Rate"]["5. Exchange Rate"])
    return er


t1 = PythonOperator(task_id='task_get_exchange_rate', python_callable=get_exchange_rate, on_failure_callback=notify_email, dag = dag,)


def db_write(**kwargs):
    ti = kwargs['ti']
    value = ti.xcom_pull(task_ids='task_get_exchange_rate')
    command = 'echo ' + '\"local.exchange.rates ' + str(value) + ' `date ' + '+%s`' + '\"' + " | nc -q 1 graphite 2003"
    os.system ( command )
    print (command)
    return (command)

t2 = PythonOperator(task_id='task_db_write', python_callable=db_write, on_failure_callback=notify_email, dag = dag, provide_context=True)

t1>>t2


