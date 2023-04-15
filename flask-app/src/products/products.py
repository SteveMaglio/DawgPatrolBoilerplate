from flask import Blueprint, request, jsonify, make_response
import json
from src import db, perform_sql_query


products = Blueprint('products', __name__)

# Get all the products from the database
@products.route('/products', methods=['GET'])
def get_products():
    
    query = 'SELECT id, product_code, product_name, list_price FROM products'
    return perform_sql_query(query)

# get the top 5 products from the database
@products.route('/mostExpensive')
def get_most_pop_products():

    query = '''
        SELECT product_code, product_name, list_price, reorder_level
        FROM products
        ORDER BY list_price DESC
        LIMIT 5
    '''
    return perform_sql_query(query)