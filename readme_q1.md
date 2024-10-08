# Question 1 

NOTE: env file not used here, although it should be in real development

## Setting up Airflow server
1) in terminal, run ```docker compose up --build```
2) once containers are up, airflow server is initialised and ready for use


## Navigating airflow server
1) Access [webserver](localhost:8080) via localhost:8080
2) login credentials
   1) username: admin
   2) password: admin
3) trigger the DAG
4) get output.csv from /opt/airflow/resources of the scheduler container or resources folder of this project (kept volumes there for ease of extracting output.csv)