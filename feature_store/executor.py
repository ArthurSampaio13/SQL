# %%
import pandas as pd
import sqlite3
import datetime
from tqdm import tqdm
import sqlalchemy
# %%
def table_exits(table):
    conn = sqlite3.connect("../data/gc (1).db")
    query = "SELECT name FROM sqlite_master WHERE type='table' AND name=?;"
    df = pd.read_sql(query, conn, params=(table,))
    conn.close()    

    return not df.empty

def dates_to_list(dt_start, dt_stop):
    date_start = datetime.datetime.strptime(dt_start, "%Y-%m-%d")
    date_stop = datetime.datetime.strptime(dt_stop, "%Y-%m-%d")
    days = (date_stop - date_start).days
    dates = [(date_start + datetime.timedelta(i)).strftime("%Y-%m-%d") for i in range(days+1)]
    return dates

def process_date(query, date, engine, holder, table):
    with engine.connect() as connection:
        if table_exits(table):
            delete = sqlalchemy.text(f"DELETE FROM {holder} WHERE dtRef = {date}")
            connection.execute(delete, {"date": date})
        
        query = query.format(date=date)
        connection.execute(sqlalchemy.text(query))

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

dt_start = '2021-12-01'
dt_stop = '2021-12-15'

paths = ['assinatura.sql', 'gameplay.sql', 'medalhas.sql']
holders = ['assinatura', 'gameplay', 'medalhas']

for path, holder in zip(paths, holders):
    query = import_query(path)
    backfill(query, engine, dt_start, dt_stop, holder, holder)
# %%
