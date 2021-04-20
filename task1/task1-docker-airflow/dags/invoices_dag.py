import json
import os
from datetime import datetime, timedelta

from sqlalchemy import create_engine

import pandas as pd
from airflow import DAG
from airflow.contrib.sensors.file_sensor import FileSensor
from airflow.hooks.base_hook import BaseHook
from airflow.operators.postgres_operator import PostgresOperator
from airflow.operators.python_operator import PythonOperator

default_args = {
    "owner": "airflow",
    "start_date": datetime(2021, 4, 1),
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "email": "sasongkobgn@gmail.com",
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

data_path = f'{json.loads(BaseHook.get_connection("data_path").get_extra()).get("path")}/data_efishery.csv'
transformed_path = f'{os.path.splitext(data_path)[0]}-transformed.csv'


def transform_data(*args, **kwargs):
    invoices_data = pd.read_csv(filepath_or_buffer=data_path,
                                sep=',',
                                header=0,
                                usecols=[
                                    "invoice_date_id","payment_date_id","customer_id","order_number","invoice_number","payment_number","total_order_quantity","total_order_usd_amount","order_to_invoice_lag_days","invoice_to_payment_lag_days"],
                                parse_dates=['invoice_date_id'],
                                index_col=0)
    invoices_data.to_csv(path_or_buf=transformed_path)

# store the data into databases
def store_in_db(*args, **kwargs):
    transformed_invoices = pd.read_csv(transformed_path)
    transformed_invoices.columns = [c.lower() for c in
                                    transformed_invoices.columns]

    transformed_invoices.dropna(axis=0, how='any', inplace=True)
    engine = create_engine(
        'postgresql://airflow:airflow@postgres/airflow_db')

    transformed_invoices.to_sql("invoices",
                                engine,
                                if_exists='append',
                                chunksize=500,
                                index=False
                                )


with DAG(dag_id="invoices_dag",
         schedule_interval='0 7 * * *',
         default_args=default_args,
         template_searchpath=[f"{os.environ['AIRFLOW_HOME']}"],
         catchup=False) as dag:
    # This file could come in S3 from our ecommerce application
    is_new_data_available = FileSensor(
        task_id="is_new_data_available",
        fs_conn_id="data_path",
        filepath="data_efishery.csv",
        poke_interval=5,
        timeout=20
    )

    transform_data = PythonOperator(
        task_id="transform_data",
        python_callable=transform_data
    )

    create_table = PostgresOperator(
        task_id="create_table",
        sql='''CREATE TABLE IF NOT EXISTS fact_order_accumulating (
                order_date_id" int,
                invoice_date_id int,
                payment_date_id int,
                customer_id int,
                order_number varchar,
                invoice_number varchar,
                payment_number varchar,
                total_order_quantity int,
                total_order_usd_amount decimal,
                order_to_invoice_lag_days int,
                invoice_to_payment_lag_days int
                );''',
        postgres_conn_id='postgres',
        database='airflow_db'
    )

    save_into_db = PythonOperator(
        task_id='save_into_db',
        python_callable=store_in_db
    )

    # Now could come an upload to S3 of the model or a deploy step

    is_new_data_available >> transform_data
    transform_data >> create_table >> save_into_db
