from flask import Blueprint, request, jsonify, make_response
import json
from src import db


customers = Blueprint('customers', __name__)

# Get all customers from the DB
@customers.route('/customers', methods=['GET'])
def get_customers():
    query = '''select company, last_name,
        first_name, job_title, business_phone from customers'''
    return perform_sql_query(query)

# Get customer detail for customer with particular userID
@customers.route('/customers/<userID>', methods=['GET'])
def get_customer(userID):

    query = 'select * from customers where customers.id = {0}'.format(userID)
    return perform_sql_query(query)

def perform_sql_query(query: str):
    cursor = db.get_db().cursor()
    cursor.execute(query)
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response