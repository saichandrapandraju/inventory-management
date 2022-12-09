from flask import Flask, render_template, request, redirect, url_for, session, flash, g
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


@app.before_request
def before_request():
    g.user=None
    if 'username' in session:
        g.user=session['username']
    

@app.route("/", methods=['POST','GET'])
def login():
    cursor = connection.cursor()
    if request.method=="POST":
        
        tempUseremail=request.form['login_email']
        tempPassword=request.form['login_password']
        cursor.callproc("check_user",[tempUseremail,tempPassword])
        temp=cursor.fetchall()
        connection.commit()
        # app.logger.info(temp['response'])
        app.logger.info("Value of respo")

        app.logger.info(temp)

        if(temp[0]['response']=="yes"):
            session['loggedin'] = True
            session['username'] = tempUseremail
            g.user=tempUseremail
            flash("Logged in successfully")
            return redirect(url_for('home'))
        else:
            flash("Invalid Email or Password")
            session['username'] = None
            return render_template("login.html")
        
        # return redirect(url_for("index"))
        
    return render_template("login.html")
    
    
@app.route('/home')
def home():
   
   return render_template('cards.html')

@app.route('/logout')
def logout():
   session.pop('loggedin', None)
   session.pop('username', None)
   g.user=None
   flash("Successfully logged out")
   return redirect(url_for('login'))

@app.route("/register", methods=['POST','GET'])
def register():

    cursor=connection.cursor()
    if request.method=="POST":
        firstName=request.form['register_firstname']
        lastName=request.form['register_lastname']
        email_address=request.form['register_email']
        password=request.form['register_password']
        address=request.form['register_address']
        phone=request.form['register_phone']
        ssn=request.form['register_ssn']

        cursor.callproc("create_user", [firstName,lastName,address,phone,ssn,email_address,password])
        temp=cursor.fetchall()
        connection.commit()
        app.logger.info(temp)
        if(temp[0]['response']==1):
            flash("Successfully registered")
            return redirect(url_for('login'))
        if(temp[0]['response']==0):
            flash("Invalid Details")
            # return redirect(url_for('login'))
    return render_template("register.html")

        


@app.route("/dashboard")
def index():
    if g.user:
        return render_template("index.html")
    else:
        return redirect(url_for('login'))
    

@app.route("/employee", methods=['POST','GET'])
def create_employee():
    if g.user:
        cursor = connection.cursor()
        if request.method=="POST":
            finame_ = request.form['finame']
            lname_ = request.form['lname']
            add_ = request.form['address']
            type_ = request.form['type']
            phone_ = request.form['phone']
            ssn_ = request.form['ssn']
            email = request.form['email']
        
            cursor.callproc("create_employee", args=[finame_, lname_, add_, type_, phone_, ssn_, email])
            result = cursor.fetchall()
            connection.commit()
            flash(result[0]['response'])
            app.logger.info(result)
        cursor.callproc("all_employees")
        all_employees = cursor.fetchall()
        return render_template("employees.html", data=preprocess_tuples(all_employees))
    else:
        return redirect(url_for('login'))
    


@app.route("/employee/delete/<int:id>")
def delete_employee(id):
    if g.user:
        del_cursor = connection.cursor()
        del_cursor.callproc('delete_employee', args=[id])
        result = del_cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        del_cursor.close()
        app.logger.info(result)
        return result[0]
    else:
        return redirect(url_for('login'))

@app.route("/updateEmployee", methods=['POST', 'GET'])
def update_employee():
    if g.user:
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
    else:
        return redirect(url_for('login'))



@app.route("/category", methods=['POST','GET'])
def create_category():
    if g.user:
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
    else:
        return redirect(url_for('login'))


@app.route("/category/delete/<int:id>")
def delete_category(id):
    if g.user:
        del_cursor = connection.cursor()
        del_cursor.callproc('delete_category', args=[id])
        result = del_cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        del_cursor.close()
        app.logger.info(result)
        return result[0]
    else:
        return redirect(url_for('login'))
    

@app.route("/updateCategory", methods=['POST', 'GET'])
def update_category():
    if g.user:
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
    else:
        return redirect(url_for('login'))

@app.route("/brand", methods=['POST','GET'])
def create_brand():
    if g.user:
        cursor = connection.cursor()
        if request.method=="POST":
            name_ = request.form['name']
            cursor.callproc("create_brand", args=[name_])
            result = cursor.fetchall()
            connection.commit()
            flash(result[0]['response'])
            app.logger.info(result)
        cursor.callproc("all_brands")
        all_brands = cursor.fetchall()
        return render_template("brands.html", data=preprocess_tuples(all_brands))
    else:
        return redirect(url_for('login'))

@app.route("/brand/delete/<brand>")
def delete_brand(brand):
    if g.user:
        del_cursor = connection.cursor()
        del_cursor.callproc('delete_brand', args=[brand])
        result = del_cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        del_cursor.close()
        app.logger.info(result)
        return result[0]
    else:
        return redirect(url_for('login'))
    
    
@app.route("/updateBrand", methods=['POST', 'GET'])
def update_brand():
    if g.user:
        cursor = connection.cursor()
        if request.method=="POST":
            oldname_ = request.form['oldname']
            newname_ = request.form['newname']
            cursor.callproc("rename_brand", args=[oldname_, newname_])
            result = cursor.fetchall()
            connection.commit()
            flash(result[0]['response'])
            app.logger.info(result)
        cursor.callproc("all_brands")
        all_brands = cursor.fetchall()
        return render_template("brands.html", data=preprocess_tuples(all_brands))
    else:
        return redirect(url_for('login'))

@app.route("/product", methods=['POST','GET'])
def create_product():
    if g.user:
        cursor = connection.cursor()
        if request.method=="POST":
            name = request.form['name']
            price = request.form['price']
            description = request.form['description']
            quantity = request.form['quantity']
            man_date = request.form['man_date']
            exp_date = request.form['exp_date']
            location = request.form['location']
            brand = request.form['brand']
            category = request.form['category']
            supplier = request.form['supplier']
            cursor.callproc("create_product", args=[name, price, description, quantity, man_date, exp_date, location, brand, category, supplier])
            result = cursor.fetchall()
            connection.commit()
            flash(result[0]['response'])
            app.logger.info(result)
            
        cursor.callproc("all_brands")
        all_brands = cursor.fetchall()
        connection.commit()
        app.logger.info(all_brands)
        
        cursor.callproc("all_categories")
        all_categories = cursor.fetchall()
        connection.commit()
        app.logger.info(all_categories)
        
        cursor.callproc("all_suppliers")
        all_suppliers = cursor.fetchall()
        connection.commit()
        app.logger.info(all_suppliers)
        
        cursor.callproc("all_products")
        all_products = cursor.fetchall()
        connection.commit()
        app.logger.info(all_products)
        return render_template("products.html", data={"all_brands":preprocess_tuples(all_brands), "all_categories":preprocess_tuples(all_categories), "all_suppliers":preprocess_tuples(all_suppliers), "all_products":preprocess_tuples(all_products)})
    else:
        return redirect(url_for('login'))

@app.route("/product/delete/<int:id>")
def delete_product(id):
    if g.user:
        del_cursor = connection.cursor()
        del_cursor.callproc('delete_product', args=[id])
        result = del_cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        del_cursor.close()
        app.logger.info(result)
        return result[0]
    else:
        return redirect(url_for('login'))
    
    
@app.route("/updateProduct", methods=['POST', 'GET'])
def update_product():
    if g.user:
        cursor = connection.cursor()
        if request.method=="POST":
            id_ = request.form['productid']
            name = request.form['name']
            price = request.form['price']
            description = request.form['description']
            quantity = request.form['quantity']
            man_date = request.form['man_date']
            exp_date = request.form['exp_date']
            location = request.form['location']
            brand = request.form['brand']
            category = request.form['category']
            supplier = request.form['supplier']
            cursor.callproc("update_product", args=[int(id_), name, price, description, quantity, man_date, exp_date, location, brand, category, supplier])
            result = cursor.fetchall()
            connection.commit()
            flash(result[0]['response'])
            app.logger.info(result)
            
        cursor.callproc("all_brands")
        all_brands = cursor.fetchall()
        connection.commit()
        app.logger.info(all_brands)
        
        cursor.callproc("all_categories")
        all_categories = cursor.fetchall()
        connection.commit()
        app.logger.info(all_categories)
        
        cursor.callproc("all_suppliers")
        all_suppliers = cursor.fetchall()
        connection.commit()
        app.logger.info(all_suppliers)
        
        cursor.callproc("all_products")
        all_products = cursor.fetchall()
        connection.commit()
        app.logger.info(all_products)
        return render_template("products.html", data={"all_brands":preprocess_tuples(all_brands), "all_categories":preprocess_tuples(all_categories), "all_suppliers":preprocess_tuples(all_suppliers), "all_products":preprocess_tuples(all_products)})
    else:
        return redirect(url_for('login'))



@app.route("/supplier", methods=['POST','GET'])
def create_supplier():
    if g.user:
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
    else:
        return redirect(url_for('login'))

@app.route("/supplier/<int:id>", methods=['POST','GET'])
def detail_supplier(id):
    if g.user:
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
        cursor.callproc("supplier_past_orders", args=[id])
        result_past_orders = cursor.fetchall()
        connection.commit()
        app.logger.info(result_past_orders)
    
        cursor.callproc("supplier_orders_active", args=[id])
        result_active = cursor.fetchall()
        connection.commit()
        app.logger.info(result_active)
        
        cursor.callproc("all_supplier_products", args=[id])
        all_products = cursor.fetchall()
        connection.commit()
        app.logger.info(all_products)
        
        return render_template("supplier_detail.html", data={"sup_id":id,"past_orders":preprocess_tuples(result_past_orders), "pending":preprocess_tuples(result_active), "all_products":preprocess_tuples(all_products)})
    else:
        return redirect(url_for('login'))
    
@app.route("/supplier/delete/<int:id>")
def delete_supplier(id):
    if g.user:
        del_cursor = connection.cursor()
        del_cursor.callproc('delete_supplier', args=[id])
        result = del_cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        del_cursor.close()
        app.logger.info(result)
        return result[0]
    else:
        return redirect(url_for('login'))
    
@app.route("/supplier/settle/<int:id>")
def settle_supplier_order(id):
    if g.user:
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
    else:
        return redirect(url_for('login'))

@app.route("/supplier/cancel/<int:id>")
def cancel_supplier_order(id):
    if g.user:
        cancel_cursor = connection.cursor()
        # if request.method=="POST":
        cancel_cursor.callproc('cancel_order', args=[id])
        result = cancel_cursor.fetchall()
        connection.commit()
        flash(result[0]['response'])
        cancel_cursor.close()
        app.logger.info(result)
        print(result)
        return result[0]
    else:
        return redirect(url_for('login'))
    
@app.route("/updateSupplier", methods=['POST', 'GET'])
def update_supplier():
    if g.user:
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
    else:
        return redirect(url_for('login'))

@app.route('/analytics')
def analytics():
    if g.user:
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
    else:
        return redirect(url_for('login'))

if __name__=="__main__":
    app.secret_key = '1234567890saichandrapandrajusairamasishmadiraju'
    app.run(host="localhost", port=8080, debug=True)