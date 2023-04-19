from flask import Blueprint, request, jsonify, make_response, current_app
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
    query = f'select * from Employee where employee_id = {employee_id}'
    return perform_sql_query(query)

@employee.route('/off_shift', methods = ['DELETE'])
def clock_out():
    # collect data
    the_data = request.json
    current_app.logger.info(the_data)
    

    # extract the variables
    employee_id = the_data['emp_id']
    current_app.logger.info(f'DELETING EMPLOYEE ID {employee_id}')

    query = f'UPDATE Employee SET currently_on_shift = 0 WHERE employee_id = {employee_id}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "


# allow employee to add song to queue
@employee.route('/music', methods = ['POST'])
def play_song():

    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variable
    song_name = the_data['song_name']
    current_app.logger.info(f'song_name: {song_name}')
    employee_player_id = the_data['employee_player_id']
    current_app.logger.info(f'employee_player_id: {employee_player_id}')
    artist = the_data['artist']
    current_app.logger.info(f'artist: {artist}')
    genre = the_data['genre']
    current_app.logger.info(f'genre: {genre}')
    song_id = the_data['song_id']
    current_app.logger.info(f'song_id: {song_id}')
    
    # create query
    #query = f'Insert into Music (song_name, employee_player_id, artist, genre, song_id) values ({song_name}, {employee_player_id}, {artist}, {genre}, {song_id})'
    query = f"Insert into Music (song_id, song_name, employee_player_id, artist, genre) values ({int(song_id)}, '{song_name}', {int(employee_player_id)}, '{artist}', '{genre}')"
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "

# move employee to new section
@employee.route('/employee', methods = ['PUT'])
def move_employee():
    # collect data
    the_data = request.json
    current_app.logger.info(the_data)

    # extract the variables
    section = the_data['section']
    employee_id = the_data['employee_id']
    
    # create query
    query = f'UPDATE Employee SET section_assigned_to = {section} WHERE employee_id = {employee_id}'
    current_app.logger.info(query)

    # execute and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()

    return "Success!   "

# Get all the section ids from the database
@employee.route('/sections', methods=['GET'])
def get_sections():
    
    query = 'SELECT section_id as label, section_id as value from Section'
    return perform_sql_query(query)

@employee.route('/wait_time/<machine_id>', methods = ['GET'])
def get_machine_time(machine_id):
    # create query
    query = f'select machine_id, machine_name, wait_time_in_minutes from Machine where Machine.machine_id = {machine_id}'
    return perform_sql_query(query)

# Get all the machines from the database
@employee.route('/machines', methods=['GET'])
def get_products():
    
    query = 'SELECT machine_id, machine_name, section FROM Machine'
    return perform_sql_query(query)


# display top genres
@employee.route('/top_3_genres', methods = ['GET'])
def get_genre():
    cursor = db.get_db().cursor()
    query = '''
        SELECT  count(genre), genre
        FROM Music
        Group by genre
        ORDER BY count(genre) DESC
        LIMIT 3
    '''
    return perform_sql_query(query)

