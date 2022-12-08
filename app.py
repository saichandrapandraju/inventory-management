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
    if data:
        header = list(data[0].keys())
        rows = list(map(lambda x:list(x.values()), data))
        return {"header":header, "rows":rows}
    return {"header":[], "rows":[]}

def preprocess_analytics_tuples(data: list):
    if data:
        labels = list(map(lambda x:list(x.values())[0], data))
        values = list(map(lambda x:list(x.values())[1], data))
        return {"labels":labels, "values":values}
    return {"labels":[], "values":[]}

def preprocess_analytics_date_tuples(data: list):
    if data:
        labels = []
        labels_ = list(map(lambda x:list(x.values())[0], data))
        for i in labels_:
            labels.append(i.strftime('%Y-%m-%d'))
        values = list(map(lambda x:list(x.values())[1], data))
        print(labels)
        return {"labels":labels, "values":values}
    return {"labels":[], "values":[]}

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


@app.route("/supplier", methods=['POST','GET'])
def create_supplier():
    cursor = connection.cursor()
    if request.method=="POST":
        name_ = request.form['name']
        phone_ = request.form['phone']
        address_ = request.form['address']
        cursor.callproc("create_supplier", args=[name_, phone_, address_])
        result = cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        app.logger.info(result)
    cursor.callproc("all_suppliers")
    all_suppliers = cursor.fetchall()
    return render_template("supplier.html", data=preprocess_tuples(all_suppliers))

@app.route("/supplier/<int:id>", methods=['POST','GET'])
def detail_supplier(id):
    cursor = connection.cursor()
    if request.method=="POST":
        pid_ = request.form['product']
        qty_ = request.form['quantity']
        emp_id = 1 # TODO: take from session storage
        cursor.callproc("order_new_product", args=[emp_id, id, pid_, qty_])
        result = cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        app.logger.info(result)
    cursor.callproc("supplier_orders_settled", args=[id])
    result_settled = cursor.fetchall()
    connection.commit()
    app.logger.info(result_settled)
    
    cursor.callproc("supplier_orders_active", args=[id])
    result_active = cursor.fetchall()
    connection.commit()
    app.logger.info(result_active)
    
    cursor.callproc("all_supplier_products", args=[id])
    all_products = cursor.fetchall()
    connection.commit()
    app.logger.info(all_products)
    
    return render_template("supplier_detail.html", data={"sup_id":id,"settled":preprocess_tuples(result_settled), "pending":preprocess_tuples(result_active), "all_products":preprocess_tuples(all_products)})

@app.route("/supplier/delete/<int:id>")
def delete_supplier(id):
    del_cursor = connection.cursor()
    del_cursor.callproc('delete_supplier', args=[id])
    result = del_cursor.fetchall()
    connection.commit()
    flash(result[0]['response'])
    del_cursor.close()
    app.logger.info(result)
    return result[0]

@app.route("/supplier/settle/<int:id>")
def settle_supplier_order(id):
    settle_cursor = connection.cursor()
    # if request.method=="POST":
    settle_cursor.callproc('settle_order', args=[id])
    result = settle_cursor.fetchall()
    connection.commit()
    flash(result[0]['response'])
    settle_cursor.close()
    app.logger.info(result)
    print(result)
    return result[0]

@app.route("/updateSupplier", methods=['POST', 'GET'])
def update_supplier():
    cursor = connection.cursor()
    if request.method=="POST":
        id_ = request.form['supid']
        name_ = request.form['name']
        phone_ = request.form['phone']
        address_ = request.form['address']
        cursor.callproc("update_supplier", args=[id_, name_, phone_, address_])
        result = cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        app.logger.info(result)
    cursor.callproc("all_suppliers")
    all_suppliers = cursor.fetchall()
    return render_template("supplier.html", data=preprocess_tuples(all_suppliers))

@app.route('/analytics')
def analytics():
    cursor = connection.cursor()
    cursor.callproc("high_sale_products")
    high_sales = cursor.fetchall()
    connection.commit()
    app.logger.info(high_sales)
    
    cursor = connection.cursor()
    cursor.callproc("low_sale_products")
    low_sales = cursor.fetchall()
    connection.commit()
    app.logger.info(low_sales)
    
    cursor = connection.cursor()
    cursor.callproc("low_stock_products")
    low_stock_products = cursor.fetchall()
    connection.commit()
    app.logger.info(low_stock_products)
    
    cursor = connection.cursor()
    cursor.callproc("high_sale_product_trend")
    high_sale_product_trend = cursor.fetchall()
    connection.commit()
    app.logger.info(high_sale_product_trend)
    
    return render_template('analysis.html', data = {"high_sales":preprocess_analytics_tuples(high_sales),
                                                    "low_sales":preprocess_analytics_tuples(low_sales),
                                                    "low_stock_products":preprocess_analytics_tuples(low_stock_products),
                                                    "high_sale_product_trend":preprocess_analytics_date_tuples(high_sale_product_trend)
                                                    }
                           )

if __name__=="__main__":
    app.secret_key = '1234567890saichandrapandrajusairamasishmadiraju'
    app.run(host="localhost", port=8080, debug=True)