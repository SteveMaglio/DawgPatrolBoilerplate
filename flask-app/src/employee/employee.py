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
