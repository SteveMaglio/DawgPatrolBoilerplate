from flask import Blueprint, request, jsonify, make_response
import json
from src import db


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



def perform_sql_query(query:str):
        # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute(query)

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)