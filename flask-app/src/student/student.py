from flask import Blueprint, request, jsonify, make_response
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
