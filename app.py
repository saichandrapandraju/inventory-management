from flask import Flask, render_template, request, redirect, url_for, session, flash,g
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
   if(data):
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
            app.logger.info("I am in the if condition")
            
            session['loggedin'] = True
            session['username'] = tempUseremail
            g.user=tempUseremail
            return redirect(url_for('completeDashboard'))
        else:
            flash("Invalid Email or Password")
            session['username'] = None
            return render_template("login.html")
        
        # return redirect(url_for("index"))
        
    return render_template("login.html")
    
    
@app.route('/completeDashboard')
def completeDashboard():
   
   return render_template('cards.html')

@app.route('/logout')
def logout():
   session.pop('loggedin', None)
   session.pop('username', None)
   g.user=None
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
            return redirect(url_for('login'))
    return render_template("register.html")

@app.route("/dashboard", methods=['POST','GET'])
def index():
    app.logger.info(g.user)
    if g.user:
        # if request.method=="POST":
        #     if request.form['employees']:
        #         return redirect(url_for(''))
            
        return render_template("index.html")
    else:
        return redirect(url_for('login'))


@app.route("/allBrands")
def all_brands():
    if g.user:
        cursor = connection.cursor()
        cursor.callproc("all_brands")
        all_brands = cursor.fetchall()
        app.logger.info("'/allBrands' fetched {} brand(s)".format(cursor.rowcount))
        return render_template("brands.html", data=preprocess_tuples(all_brands))
    else:
        return redirect(url_for('login'))

    
@app.route("/employee", methods=['POST','GET'])
def create_employee():
    app.logger.info(g.user)
    if g.user:
        cursor = connection.cursor()
        if request.method=="POST":
            finame_ = request.form['finame']
            lname_ = request.form['lname']
            add_ = request.form['address']
            type_ = request.form['type']
            phone_ = request.form['phone']
            ssn_ = request.form['ssn']
            email_ = request.form['email']
            cursor.callproc("create_employee", args=[finame_, lname_, add_, type_, phone_, ssn_,email_])
            result = cursor.fetchall()
            connection.commit()
            flash(result[0]['response'])
            app.logger.info(result)
        cursor.callproc("all_employees")
        all_employees = cursor.fetchall()
        print(all_employees)
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
            email_ = request.form['phone']
            cursor.callproc("update_employee", args=[id_, add_, type_, phone_,email_])
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








if __name__=="__main__":
    app.secret_key = '1234567890saichandrapandrajusairamasishmadiraju'
    app.run(host="localhost", port=8080, debug=True)