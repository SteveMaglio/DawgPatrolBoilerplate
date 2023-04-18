from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db, perform_sql_query


locker_room = Blueprint('locker_room', __name__)

# Get all the locker rooms in our database
@locker_room.route('/locker_room', methods=['GET'])
def get_locker_rooms():
    
    query = 'SELECT * FROM LockerRoom'
    return perform_sql_query(query)

#finds a specific locker room by sex
@locker_room.route('/locker_room/<sex>', methods=['GET'])
def get_locker_room_by_sex(sex):
    query = 'select * from LockerRoom where LockerRoom.locker_room_sex = {0}'.format(sex)
    return perform_sql_query(query)


#finds a the percentage full a locker room is by
@locker_room.route('/locker_room/percentage/<sex>', methods=['GET'])
def get_locker_room_percentage_by_sex(sex):
    female_predicate = ""
    if sex[0].lower() == 'm':
        sex = 'Male'
    elif sex[0].lower() == 'f':
        female_predicate = 'not'
        sex = 'Female'
    else:
        raise ValueError(f'improper sex given: {sex}')
    query = f'''
    select 100*((select count(*) from Student join ComboLock CL on Student.lock_used = CL.lock_id where {female_predicate} Student.is_male)
    /
    (select count(*) from
        Locker join LockerRoom LR on LR.locker_room_sex = Locker.locker_room_name where locker_room_sex = '{sex}')) as percentageFull'''
    return perform_sql_query(query)


# Get all the locker rooms in our database
@locker_room.route('/lockers', methods=['GET'])
def get_lockers():
    query = 'SELECT * FROM Locker'
    return perform_sql_query(query)

# Get all the locker rooms in our database by sex
@locker_room.route('/lockers/<sex>', methods=['GET'])
def get_lockers_by_sex(sex):
    if sex[0].lower() == 'm':
        query = "select count(*) from Locker join LockerRoom LR on LR.locker_room_sex = Locker.locker_room_name where locker_room_sex = 'Male'"
    elif sex[0].lower() == 'f':
        query = "select count(*) from Locker join LockerRoom LR on LR.locker_room_sex = Locker.locker_room_name where locker_room_sex = 'Female'"
    else: 
        raise ValueError(f'improper sex given: {sex}')
    return perform_sql_query(query)