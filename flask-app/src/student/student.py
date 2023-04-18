from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db, perform_sql_query


student = Blueprint('student', __name__)

# Get all the Students in our database
@student.route('/students', methods=['GET'])
def get_students():
    
    query = 'SELECT * FROM Student'
    return perform_sql_query(query)

#finds a specific student by NUID
@student.route('/students/<NUID>', methods=['GET'])
def get_student_by_nuid(NUID):
    query = 'select * from Student where Student.NUID = {0}'.format(NUID)
    return perform_sql_query(query)

@student.route('/students/<NUID>/lock', methods =['GET'])
def get_student_lock(NUID):
    query = 'select lock_used from Student where Student.NUID = {0}'.format(NUID)
    return perform_sql_query(query)

@student.route('/students/<NUID>/health', methods =['GET'])
def get_student_health_info(NUID):
    query = 'select height_in_cm, weight_in_lbs from Student where Student.NUID = {0}'.format(NUID)
    return perform_sql_query(query)


@student.route('/product', methods = ['PUT'])
def update_student_health(NUID):

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    weight = the_data['prod_description']
    
    # construct query
    # query = ' UPDATE Student SET weight_in_lbs = " ' 
    # query += weight '", '
    # query += 'WHERE NUid = '", '
    # query += NUID + ')'

    query = f'UPDATE Student SET weight_in_lbs = "{weight}, WHERE NUId = "{NUID}"'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "

