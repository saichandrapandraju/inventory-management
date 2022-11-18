from flask import Flask, render_template, request, redirect, url_for, session
from logging.config import dictConfig
import re, json
from pymysql import connect, cursors

dictConfig({
    'version': 1,
    'formatters': {'default': {
        'format': '[%(asctime)s] %(levelname)s in %(module)s: %(message)s',
    }},
    'handlers': {'wsgi': {
        'class': 'logging.StreamHandler',
        'stream': 'ext://flask.logging.wsgi_errors_stream',
        'formatter': 'default'
    }},
    'root': {
        'level': 'INFO',
        'handlers': ['wsgi']
    }
})

def preprocess_tuples(data: list):
    header = list(data[0].keys())
    rows = list(map(lambda x:list(x.values()), data))
    return {"header":header, "rows":rows}

app = Flask(__name__)

db_creds_path = "db_creds.json"
with open(db_creds_path) as db_creds_file:
    db_creds = json.load(db_creds_file)

try:
    connection = connect(
        host=db_creds.get("host"),
        user=db_creds.get("user"),
        password=db_creds.get("password"),
        database=db_creds.get("database"),
        charset="utf8mb4",
        cursorclass=cursors.DictCursor
    )
    app.logger.info("Successfully connected to '{}' database".format(db_creds.get("database")))
except Exception as e:
    app.logger.exception(e)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/allBrands")
def all_brands():
    cursor = connection.cursor()
    cursor.callproc("all_brands")
    all_brands = cursor.fetchall()
    app.logger.info("'/allBrands' fetched {} brand(s)".format(cursor.rowcount))
    return render_template("brands.html", data=preprocess_tuples(all_brands))
    
@app.route("/allEmployees")
def all_employees():
    cursor = connection.cursor()
    cursor.callproc("all_employees")
    all_employees = cursor.fetchall()
    app.logger.info("'/allEmployees' fetched {} employee(s)".format(cursor.rowcount))
    return render_template("employees.html", data=preprocess_tuples(all_employees))
















if __name__=="__main__":
    app.run(host="localhost", port=8080, debug=True)