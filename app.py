from flask import Flask, render_template, request, redirect, url_for, session
import re, json
from pymysql import connect, cursors

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
except Exception as e:
    print(e)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/allBrands")
def all_brands():
    all_brands = [{"name":""}]
    cursor = connection.cursor()
    cursor.callproc("all_brands")
    all_brands = cursor.fetchall()
    return render_template("brands.html", data=all_brands)
    

















if __name__=="__main__":
    app.run(host="localhost", port=8080, debug=True)