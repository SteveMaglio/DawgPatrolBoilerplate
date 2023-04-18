from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db, perform_sql_query


sections = Blueprint('sections', __name__)

# Get all the sections from the database
@sections.route('/sections', methods=['GET'])
def get_products():
    
    query = 'SELECT section_id, section_name, floor_num FROM Section'
    return perform_sql_query(query)

#finds specific section by its SectionID
@sections.route('/sections/<sectionID>', methods=['GET'])
def get_section_by_num(sectionID):
    query = 'select * from Section where Section.section_id = {0}'.format(sectionID)
    return perform_sql_query(query)

#finds sections by which floor they are on
@sections.route('/floor/<floorNum>', methods=['GET'])
def get_sections_by_floor(floorNum):
    query = 'select * from Section where Section.floor_num = {0}'.format(floorNum)
    return perform_sql_query(query)

# find class availability
# CLASS CAPACITY PAGE
@sections.route('/class', methods = ['GET'])
def get_class_capacity(class_id):
    query = 'select class_capacity from Class where class_id = {0}'.format(class_id)
    return perform_sql_query(query)

@sections.route('/emp/<employee_id>', methods = ['PUT'])
def move_employee(employee_id):
    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    section = the_data['section']
    
    # create query
    query = f'UPDATE Employee SET section_assigned_to = "{section}, WHERE employee_id = {0}'.format(employee_id)
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "

# delete a section if closed/not available
@sections.route('/section', methods = ['DELETE'])
def delete_section():

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    id = the_data['section_id']
    
    # create query
    query = f'DELETE FROM Section WHERE section_id = {id}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "

# delete a class if closed/not available
@sections.route('/class', methods = ['DELETE'])
def delete_section():

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    id = the_data['class_id']
    
    # create query
    query = f'DELETE FROM Class WHERE class_id = {id}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "

@sections.route('/sections', methods = ['POST'])
def add_new_section():

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    section_name = the_data['section_name']
    current_app.logger.info(f'section_name: {section_name}')
    
    floor_num = the_data['floor_num']
    current_app.logger.info(f'floor_num: {floor_num}')
    
    section_id = the_data['section_id']
    current_app.logger.info(f'section_id: {section_id}')
    
    # create query
    query = f'Insert into Student (section_name, floor_num, section_id) values ({section_name}, {floor_num}, {section_id})'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "





