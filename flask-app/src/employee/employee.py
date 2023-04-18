from flask import Blueprint, request, jsonify, make_response
import json
from src import db, perform_sql_query


employee = Blueprint('employee', __name__)

# Get all the employees in our database
@employee.route('/employees', methods=['GET'])
def get_employees():
    
    query = 'SELECT * FROM Employee'
    return perform_sql_query(query)

#finds a specific employee by their ID
@employee.route('/employees/<employee_id>', methods=['GET'])
def get_employee_by_id(employee_id):
    query = 'select * from employee where Employee.employee_id = {0}'.format(employee_id)
    return perform_sql_query(query)


@employee.route('employee/off_shift', methods = ['DELETE'])
def clock_out():
    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    id = the_data['emp_id']

    query = f'UPDATE Employee SET currently_on_shift = {0} WHERE employee_id = {id}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "


@employee.route('employee/wage', methods = ['PUT'])
def update_wage():
    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    wage = the_data['wage']

    query = f'UPDATE Employee SET hourly_wage_in_dollars = {wage} WHERE employee_id = {id}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "