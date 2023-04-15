from flask import Blueprint, request, jsonify, make_response
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