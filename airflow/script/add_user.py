import psycopg2
connection = psycopg2.connect(user = "airflow",
                                  password = "airflow",
                                  host = "postgres",
                                  port = "5432",
                                  database = "airflow")
cursor = connection.cursor()
cursor.execute("insert into users values (1,'admin',null,'$2b$12$frMsW9Qh4DdGMaToJ70k3.xp.i2baJRsGpAlKI5ecLsRnQS5WUhLy',null)");
connection.commit ()    
print("Record inserted successfully")
connection.close()
print("PostgreSQL connection is closed")
