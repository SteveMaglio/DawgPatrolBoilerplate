from flask import Blueprint, request, jsonify, make_response
import json
from src import db, perform_sql_query


TrainingClass = Blueprint('employee', __name__)

# Get all the classes in our database
@TrainingClass.route('/class', methods=['GET'])
def get_classes():
    query = 'SELECT * FROM Class'
    return perform_sql_query(query)

#finds a specific class by it's ID
@TrainingClass.route('/class/<class_id>', methods=['GET'])
def get_class_by_id(class_id):
    query = 'select * from Class where Class.class_id = {0}'.format(class_id)
    return perform_sql_query(query)
