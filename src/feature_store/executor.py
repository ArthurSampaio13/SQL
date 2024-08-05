import pandas as pd
import sqlite3
import datetime
from tqdm import tqdm
import sqlalchemy

# %%
def table_exists(engine, table):
    with engine.connect() as connection:
        query = "SELECT name FROM sqlite_master WHERE type='table' AND name=:table;"
        df = pd.read_sql(query, connection, params={"table": table})
    return not df.empty

def dates_to_list(dt_start, dt_stop):
    date_start = datetime.datetime.strptime(dt_start, "%Y-%m-%d")
    date_stop = datetime.datetime.strptime(dt_stop, "%Y-%m-%d")
    days = (date_stop - date_start).days
    dates = [(date_start + datetime.timedelta(i)).strftime("%Y-%m-%d") for i in range(days+1)]
    return dates

def process_date(query, date, engine, holder, table):
    with engine.connect() as connection:
        if table_exists(engine, table):
            delete = sqlalchemy.text(f"DELETE FROM {holder} WHERE dtRef = :date")
            connection.execute(delete, {"date": date})
        
        formatted_query = query.format(date=date)
        connection.execute(sqlalchemy.text(formatted_query))

def backfill(query, engine, dt_start, dt_stop, holder, table):
    dates = dates_to_list(dt_start, dt_stop)
    for d in tqdm(dates):
        process_date(query, d, engine, holder, table)

def import_query(path):
    with open(path, "r") as open_file:
        query = open_file.read()
    return query

# %%
engine = sqlalchemy.create_engine("sqlite:///../data/gc (1).db")

dt_start = '2021-11-01'
dt_stop = '2022-02-10'

paths = ['assinatura.sql', 'gameplay.sql', 'medalha.sql']
holders = ['assinatura', 'gameplay', 'medalha']

for path, holder in zip(paths, holders):
    query = import_query(path)
    backfill(query, engine, dt_start, dt_stop, holder, holder)
