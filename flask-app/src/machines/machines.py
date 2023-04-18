from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db, perform_sql_query


machines = Blueprint('machines', __name__)

# Get all the machines from the database
@machines.route('/machines', methods=['GET'])
def get_products():
    
    query = 'SELECT machine_id, machine_name, floor_num FROM machine'
    return perform_sql_query(query)

#finds specific machine by its machineID
@machines.route('/machines/<machineID>', methods=['GET'])
def get_machine_by_num(machineID):
    query = 'select * from machine where machine.machine_id = {0}'.format(machineID)
    return perform_sql_query(query)

#finds machines by which section they are in
@machines.route('/section/<floorNum>', methods=['GET'])
def get_machines_by_floor(floorNum):
    query = 'select * from machine where machine.floor_num = {0}'.format(floorNum)
    return perform_sql_query(query)

@machines.route('/machines', methods = ['POST'])
def add_new_machine():

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    id = the_data['machine_id']
    current_app.logger.info(f'id: {id}')
    name = the_data['machine_name']
    current_app.logger.info(f'name: {name}')
    max_weight = the_data['max_weight']
    current_app.logger.info(f'max_weight: {max_weight}')
    section = the_data['machine_section']
    current_app.logger.info(f'section: {section}')
    wait_time = the_data['machine_wait_time']
    current_app.logger.info(f'wait_time: {wait_time}')
    
    query = f'Insert into Machine (machine_id, machine_name, max_weight, section, wait_time_in_minutes) values ({id}, "{name}", {max_weight}, "{str(section)}", {str(wait_time)})'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "