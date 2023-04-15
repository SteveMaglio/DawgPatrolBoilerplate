from flask import Blueprint, request, jsonify, make_response
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
