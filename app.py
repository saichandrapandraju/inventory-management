from flask import Flask, render_template, request, redirect, url_for, session, flash
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
    
@app.route("/employee", methods=['POST','GET'])
def create_employee():
    cursor = connection.cursor()
    if request.method=="POST":
        finame_ = request.form['finame']
        lname_ = request.form['lname']
        add_ = request.form['address']
        type_ = request.form['type']
        phone_ = request.form['phone']
        ssn_ = request.form['ssn']
        cursor.callproc("create_employee", args=[finame_, lname_, add_, type_, phone_, ssn_])
        result = cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        app.logger.info(result)
    cursor.callproc("all_employees")
    all_employees = cursor.fetchall()
    return render_template("employees.html", data=preprocess_tuples(all_employees))


@app.route("/employee/delete/<int:id>")
def delete_employee(id):
    del_cursor = connection.cursor()
    del_cursor.callproc('delete_employee', args=[id])
    result = del_cursor.fetchall()
    connection.commit()
    flash(result[0]['response'])
    del_cursor.close()
    app.logger.info(result)
    return result[0]

@app.route("/updateEmployee", methods=['POST', 'GET'])
def update_employee():
    cursor = connection.cursor()
    if request.method=="POST":
        id_ = request.form['empid']
        add_ = request.form['address']
        type_ = request.form['type']
        phone_ = request.form['phone']
        cursor.callproc("update_employee", args=[id_, add_, type_, phone_])
        result = cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        app.logger.info(result)
    cursor.callproc("all_employees")
    all_employees = cursor.fetchall()
    return render_template("employees.html", data=preprocess_tuples(all_employees))



@app.route("/category", methods=['POST','GET'])
def create_category():
    cursor = connection.cursor()
    if request.method=="POST":
        name_ = request.form['name']
        desc_ = request.form['description']
        cursor.callproc("create_category", args=[name_, desc_])
        result = cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        app.logger.info(result)
    cursor.callproc("all_categories")
    all_categories = cursor.fetchall()
    return render_template("categories.html", data=preprocess_tuples(all_categories))


@app.route("/category/delete/<int:id>")
def delete_category(id):
    del_cursor = connection.cursor()
    del_cursor.callproc('delete_category', args=[id])
    result = del_cursor.fetchall()
    connection.commit()
    flash(result[0]['response'])
    del_cursor.close()
    app.logger.info(result)
    return result[0]

@app.route("/updateCategory", methods=['POST', 'GET'])
def update_category():
    cursor = connection.cursor()
    if request.method=="POST":
        id_ = request.form['catid']
        name_ = request.form['name']
        desc_ = request.form['description']
        cursor.callproc("update_category", args=[id_, name_, desc_])
        result = cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        app.logger.info(result)
    cursor.callproc("all_categories")
    all_categories = cursor.fetchall()
    return render_template("categories.html", data=preprocess_tuples(all_categories))








if __name__=="__main__":
    app.secret_key = '1234567890saichandrapandrajusairamasishmadiraju'
    app.run(host="localhost", port=8080, debug=True)