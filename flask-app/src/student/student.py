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


#finds a specific student by NUID
@student.route('/students/locks_used/<sex>', methods=['GET'])
def get_num_locks_used(sex):
    #male, Male, m, M, MALE, etc
    if sex[0].lower() == 'm':
        query = 'select count(*) from Student where lock_used is not null and is_male'
    elif sex[0].lower() == 'f':
        #all other sexes (ie female)
        query = 'select count(*) from Student where lock_used is not null and not is_male'  
    else:
        raise ValueError(f'improper sex {sex} given to the route')  
    
    return perform_sql_query(query)


@student.route('/gymcrush/post', methods = ['POST'])
def add_new_crush():

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    crush_on = the_data['CrushInput']
    current_app.logger.info(f'crush_id: {crush_on}')
    crusher = the_data['NUid']
    current_app.logger.info(f'crusher_id: {crusher}')
    
    query = f'Insert into GymCrushInfo (crusher_id, crush_id) values ({crusher}, {crush_on})'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success! Woohoo   "


@student.route('student/inactive', methods = ['DELETE'])
def delete_student():
    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    NUID = the_data['NUID']

    query = f'UPDATE Student SET currently_in_gym = {0} WHERE NUId = {NUID}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "


@student.route('/wait_time/<machine_id>', methods = ['PUT'])
def update_machine_time(machine_id):

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    time = the_data['wait_time_in_minutes']
    
    # create query
    query = f'UPDATE Machine SET wait_time_in_minutes = {time} WHERE machine_id = {machine_id}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "

# Get all the locker rooms in our database
@student.route('/locker_room', methods=['GET'])
def get_locker_rooms():
    
    query = 'SELECT * FROM LockerRoom'
    return perform_sql_query(query)

#finds a specific locker room by sex
@student.route('/locker_room/<sex>', methods=['GET'])
def get_locker_room_by_sex(sex):
    query = "select * from LockerRoom where locker_room_sex = '{0}'".format(sex)
    return perform_sql_query(query)


#finds a specific locker room by sex
@student.route('/locker_room/towel_count/<sex>', methods=['GET'])
def get_locker_room_num_towels_by_sex(sex):
    if sex[0].lower() == 'm':
        sex = 'Male'
    elif sex[0].lower() == 'f':
        sex = 'Female'
    else:
        raise ValueError(f'improper sex given: {sex}')
    query = "select towels from LockerRoom where locker_room_sex = '{0}'".format(sex)
    return perform_sql_query(query)


#finds a the percentage full a locker room is by
@student.route('/locker_room/percentage/<sex>', methods=['GET'])
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
@student.route('/lockers', methods=['GET'])
def get_lockers():
    query = 'SELECT * FROM Locker'
    return perform_sql_query(query)

# Get all the locker rooms in our database by sex
@student.route('/lockers/<sex>', methods=['GET'])
def get_lockers_by_sex(sex):
    if sex[0].lower() == 'm':
        query = "select count(*) from Locker join LockerRoom LR on LR.locker_room_sex = Locker.locker_room_name where locker_room_sex = 'Male'"
    elif sex[0].lower() == 'f':
        query = "select count(*) from Locker join LockerRoom LR on LR.locker_room_sex = Locker.locker_room_name where locker_room_sex = 'Female'"
    else: 
        raise ValueError(f'improper sex given: {sex}')
    return perform_sql_query(query)

# CLASS CAPACITY PAGE
@student.route('/class/<class_id>', methods = ['GET'])
def get_class_capacity(class_id):
    query = 'select class_capacity from Class where class_id = {0}'.format(class_id)
    return perform_sql_query(query)




@student.route('/10_shortest_waits', methods = ['GET'])
def get_shortest_time():
    cursor = db.get_db().cursor()
    query = '''
        SELECT machine_id, machine_name, wait_time_in_minutes
        FROM Machine
        ORDER BY wait_time_in_minutes ASC
        LIMIT 10
    '''
    return perform_sql_query(query)



# gets class information
@student.route('/get_classes', methods = ['GET'])
def get_classes():
    cursor = db.get_db().cursor()
    query = '''
    SELECT class_name AS label, class_id AS value
    FROM Class
    '''
    return perform_sql_query(query)


# gets class time info
@student.route('/get_class_info', methods = ['GET'])
def get_class_info():
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables

    cursor = db.get_db().cursor()
    query = f'''
    SELECT start_datetime, duration_in_minutes
    FROM Class
    WHERE class_id = ({the_data} - 1)
    '''
    return perform_sql_query(query)


# gets class capacity
@student.route('/class_cap', methods = ['GET'])
def class_cap():
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables

    cursor = db.get_db().cursor()
    query = f'''
    SELECT 100 * (
    SELECT count(*) 
    FROM Student
    WHERE class_being_used = ({the_data} - 1))
    / (SELECT class_capacity
       FROM Class
       WHERE class_id = ({the_data} - 1)) as capacityPercentage
    '''
    return perform_sql_query(query)
