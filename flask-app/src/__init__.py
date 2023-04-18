# Some set up for the application 

from flask import Flask
from flaskext.mysql import MySQL
from flask import Blueprint, request, jsonify, make_response
import json

# create a MySQL object that we will use in other parts of the API
db = MySQL()



def perform_sql_query(query:str):
    
    try:
            # get a cursor object from the database
        cursor = db.get_db().cursor()

        # use cursor to query the database for a list of products
        cursor.execute(query)

        # grab the column headers from the returned data
        column_headers = [x[0] for x in cursor.description]

        # create an empty dictionary object to use in 
        # putting column headers together with data
        json_data = []

        # fetch all the data from the cursor
        theData = cursor.fetchall()

        # for each of the rows, zip the data elements together with
        # the column headers. 
        for row in theData:
            json_data.append(dict(zip(column_headers, row)))

        return jsonify(json_data)
    except Exception as e:
        return e.with_traceback

def create_app():
    app = Flask(__name__)
    
    # secret key that will be used for securely signing the session 
    # cookie and can be used for any other security related needs by 
    # extensions or your application
    app.config['SECRET_KEY'] = 'someCrazyS3cR3T!Key.!'

    # these are for the DB object to be able to connect to MySQL. 
    app.config['MYSQL_DATABASE_USER'] = 'root'
    app.config['MYSQL_DATABASE_PASSWORD'] = open('/secrets/db_password.txt').readline()
    app.config['MYSQL_DATABASE_HOST'] = 'db'
    app.config['MYSQL_DATABASE_PORT'] = 3306
    app.config['MYSQL_DATABASE_DB'] = 'DawgPatrol'  # Change this to your DB name

    # Initialize the database object with the settings above. 
    db.init_app(app)
    
    # Add a default route
    @app.route("/")
    def welcome():
        return "<h1>Welcome to the DawgPatrol boilerplate app</h1>"

    # Import the various routes
    from src.views import views
    from src.sections.sections  import sections
    from src.machines.machines  import machines
    from src.student.student  import student
    from src.employee.employee  import employee
    from src.locker_room.locker_room  import locker_room
    # from src.trainingclass.trainingclass  import TrainingClass

    # Register the routes that we just imported so they can be properly handled
    app.register_blueprint(views,       url_prefix='/v')
    app.register_blueprint(sections,    url_prefix='/s')
    app.register_blueprint(machines,    url_prefix='/m')
    app.register_blueprint(student,     url_prefix = '/stu')
    app.register_blueprint(employee,    url_prefix = '/emp')
    app.register_blueprint(locker_room,    url_prefix = '/lr')
    # app.register_blueprint(TrainingClass,    url_prefix = '/c')


    return app