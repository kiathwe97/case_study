import csv
import pendulum
from airflow import DAG
from airflow.operators.python import PythonOperator
from sqlalchemy import create_engine
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import sessionmaker
from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.ext.declarative import declarative_base
import logging

Base = declarative_base()
logging.basicConfig(
        filename='file.log',
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# Define the table
class Price(Base):
    __tablename__ = 'price'
    __table_args__ = {"schema": "schema_dsad"}

    first_name = Column(String(50), primary_key=True)
    last_name = Column(String(50), primary_key=True)
    price = Column(Integer, primary_key=True)
    above_100 = Column(Boolean, primary_key=False)


def ingest(filename: str) -> None:
    db_engine = create_engine('postgresql+psycopg2://root:root@postgres-storage/mydb')
    connection = db_engine.connect().execution_options(schema_translate_map={None: 'schema_dsad'})
    Session = sessionmaker(bind=connection)
    session = Session()
    data = []
    try:
        with open('../airflow/resources/' + filename, 'r', encoding='utf-8-sig') as f:
            data = list(csv.reader(f, delimiter=','))[1:]

    except FileNotFoundError:
        logging.error(f'file not found')
    except csv.Error as e:
        logging.error(f'CSV error: {e}')
    except Exception as e:
        logging.error(f'An error occured: {e}')

    for row in data:
        if row[0] == '':
            continue
        first_name, last_name = row[0].split()
        price = int(row[1])
        try:
            session.add(Price(first_name=first_name, last_name=last_name, price=price, above_100=price > 100))
            session.commit()
        except IntegrityError as e:
            logging.error(e.orig.args)
            session.rollback()
        except Exception as e:
            logging.error(f'An error occured: {e}')
            session.rollback()


    session.commit()
    session.close()


def output():
    db_engine = create_engine('postgresql+psycopg2://root:root@postgres-storage/mydb')
    connection = db_engine.connect().execution_options(schema_translate_map={None: 'schema_dsad'})
    Session = sessionmaker(bind=connection)
    session = Session()
    result = session.query(Price).all()

    with open('../airflow/resources/output.csv', 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['first_name', 'last_name', 'price', 'above_100'])
        for row in result:
            writer.writerow([row.first_name, row.last_name, row.price, row.above_100])

    session.close()


default_args = {
    'owner': 'kiathwe',
    'start_date': pendulum.datetime(1997, 12, 12, 1, tz="Asia/Singapore")
}

with DAG('user_automation',
         default_args=default_args,
         schedule_interval="0 1 * * *",
         catchup=False) as dag:

    ingest_task_1 = PythonOperator(
        task_id='ingest_dataset_1',
        python_callable=ingest,
        op_args=['dataset1.csv']
    )

    ingest_task_2 = PythonOperator(
        task_id='ingest_dataset_2',
        python_callable=ingest,
        op_args=['dataset2.csv']
    )

    output_task = PythonOperator(
        task_id='output',
        python_callable=output
    )

    [ingest_task_1, ingest_task_2] >> output_task
