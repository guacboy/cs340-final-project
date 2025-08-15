# Citation for the following function:
# Date: 8/2/2025
# Copied from /OR/ Adapted from /OR/ Based on:
# Source URL: https://canvas.oregonstate.edu/courses/2007765/assignments/10118865

from flask import Flask, jsonify, request, send_from_directory
from flask_mysqldb import MySQL
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)

# Database configuration remains the same
app.config['MYSQL_HOST'] = os.getenv('DB_HOST')
app.config['MYSQL_USER'] = os.getenv('DB_USER')
app.config['MYSQL_PASSWORD'] = os.getenv('DB_PASS')
app.config['MYSQL_DB'] = os.getenv('DB_NAME')
app.config['MYSQL_CURSORCLASS'] = "DictCursor"
app.config['MYSQL_AUTOCOMMIT'] = True

mysql = MySQL(app)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
FRONTEND_DIST = os.path.join(BASE_DIR, '../frontend/dist')

# Date: 8/2/2025
# Prompts used to generate API endpoints.
# Given the code: [pl.sql file], write a template for all CRUD operations.
# AI Source URL: https://chat.deepseek.com

# ===========================================================================
# PRODUCTS ROUTES
# ===========================================================================
@app.route('/api/products', methods=['GET'])
def get_products():
    """Fetch all products from database"""
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Products")
    products = cursor.fetchall()
    return jsonify(products)

@app.route('/api/products', methods=['POST'])
def create_product():
    """Create new product using stored procedure"""
    data = request.json
    cursor = mysql.connection.cursor()
    # Call stored procedure with parameters
    cursor.execute('CALL CreateProduct(%s, %s)', (data['name'], data['price']))
    result = cursor.fetchone()
    productID = result['id']
    # Clear remaining result sets
    while cursor.nextset():
        pass
    mysql.connection.commit()
    cursor.close()
    return jsonify({"message": "Product created", "productID": productID}), 201

@app.route('/api/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    """Get single product by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('GetProduct', [product_id])
    product = cursor.fetchone()
    return jsonify(product)

@app.route('/api/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    """Update existing product details"""
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateProduct', [product_id, data['name'], data['price']])
    mysql.connection.commit()
    return jsonify({"message": "Product updated"})

@app.route('/api/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    """Delete product by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteProduct', [product_id])
    mysql.connection.commit()
    return jsonify({"message": "Product deleted"})

# ===========================================================================
# INGREDIENTS ROUTES
# ===========================================================================
@app.route('/api/ingredients', methods=['GET'])
def get_ingredients():
    """Fetch all ingredients"""
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Ingredients")
    ingredients = cursor.fetchall()
    return jsonify(ingredients)

@app.route('/api/ingredients', methods=['POST'])
def create_ingredient():
    """Create new ingredient"""
    data = request.json
    cursor = mysql.connection.cursor()
    # Call stored procedure with all required fields
    cursor.callproc('CreateIngredient', [
        data['name'], 
        data['unit'], 
        data['costPerUnit'], 
        data['stock'], 
        data['supplierID']
    ])
    mysql.connection.commit()
    return jsonify({"message": "Ingredient created"}), 201

@app.route('/api/ingredients/<int:ingredient_id>', methods=['GET'])
def get_ingredient(ingredient_id):
    """Get single ingredient by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('GetIngredient', [ingredient_id])
    ingredient = cursor.fetchone()
    return jsonify(ingredient)

@app.route('/api/ingredients/<int:ingredient_id>', methods=['PUT'])
def update_ingredient(ingredient_id):
    """Update existing ingredient"""
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateIngredient', [
        ingredient_id,
        data['name'],
        data['unit'],
        data['costPerUnit'],
        data['stock'],
        data['supplierID']
    ])
    mysql.connection.commit()
    return jsonify({"message": "Ingredient updated"})

@app.route('/api/ingredients/<int:ingredient_id>', methods=['DELETE'])
def delete_ingredient(ingredient_id):
    """Delete ingredient by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteIngredient', [ingredient_id])
    mysql.connection.commit()
    return jsonify({"message": "Ingredient deleted"})

# ===========================================================================
# SUPPLIERS ROUTES
# ===========================================================================
@app.route('/api/suppliers', methods=['GET'])
def get_suppliers():
    """Fetch all suppliers"""
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Suppliers")
    suppliers = cursor.fetchall()
    return jsonify(suppliers)

@app.route('/api/suppliers', methods=['POST'])
def create_supplier():
    """Create new supplier"""
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateSupplier', [data['name'], data['phone'], data['email']])
    mysql.connection.commit()
    return jsonify({"message": "Supplier created"}), 201

@app.route('/api/suppliers/<int:supplier_id>', methods=['GET'])
def get_supplier(supplier_id):
    """Get single supplier by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('GetSupplier', [supplier_id])
    supplier = cursor.fetchone()
    return jsonify(supplier)

@app.route('/api/suppliers/<int:supplier_id>', methods=['PUT'])
def update_supplier(supplier_id):
    """Update supplier details"""
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateSupplier', [supplier_id, data['name'], data['phone'], data['email']])
    mysql.connection.commit()
    return jsonify({"message": "Supplier updated"})

@app.route('/api/suppliers/<int:supplier_id>', methods=['DELETE'])
def delete_supplier(supplier_id):
    """Delete supplier by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteSupplier', [supplier_id])
    mysql.connection.commit()
    return jsonify({"message": "Supplier deleted"})

# ===========================================================================
# SALES ROUTES
# ===========================================================================
@app.route('/api/sales', methods=['GET'])
def get_sales():
    """Fetch all sales records"""
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Sales")
    sales = cursor.fetchall()
    return jsonify(sales)

@app.route('/api/sales', methods=['POST'])
def create_sale():
    """Create new sale entry"""
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateSale', [data['saleDate']])
    result = cursor.fetchone()
    new_sale_id = result['newSaleID']
    return jsonify({"message": "Sale created", "saleID": new_sale_id}), 201

@app.route('/api/sales/<int:sale_id>', methods=['GET'])
def get_sale(sale_id):
    """Get single sale by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('GetSale', [sale_id])
    sale = cursor.fetchone()
    return jsonify(sale)

@app.route('/api/sales/<int:sale_id>', methods=['PUT'])
def update_sale(sale_id):
    """Update sale date"""
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateSaleDate', [sale_id, data['saleDate']])
    mysql.connection.commit()
    return jsonify({"message": "Sale updated"})

@app.route('/api/sales/<int:sale_id>', methods=['DELETE'])
def delete_sale(sale_id):
    """Delete sale by ID"""
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteSale', [sale_id])
    mysql.connection.commit()
    return jsonify({"message": "Sale deleted"})

# ===========================================================================
# RECIPES ROUTES (PRODUCT_INGREDIENTS)
# ===========================================================================
@app.route('/api/products/<int:product_id>/ingredients', methods=['GET'])
def get_product_ingredients(product_id):
    """Get all ingredients for a product (recipe)"""
    cursor = mysql.connection.cursor()
    cursor.callproc('GetRecipeByProduct', [product_id])
    recipes = cursor.fetchall()
    return jsonify(recipes)

@app.route('/api/products/<int:product_id>/ingredients', methods=['POST'])
def create_recipe(product_id):
    """Add multiple ingredients to a product"""
    data = request.json
    cursor = mysql.connection.cursor()
    # Loop through ingredients array
    for ingredient in data.get('ingredients', []):
        cursor.callproc('CreateRecipe', [product_id, ingredient['ingredientID'], ingredient['unitQuantityRequired']])
    mysql.connection.commit()
    return jsonify({"message": "Ingredients added to product"}), 201

@app.route('/api/products/<int:product_id>/ingredients/<int:ingredient_id>', methods=['PUT'])
def update_recipe_ingredient(product_id, ingredient_id):
    """Update quantity for single ingredient in recipe"""
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateRecipe', [product_id, ingredient_id, data['unitQuantityRequired']])
    mysql.connection.commit()
    return jsonify({"message": "Recipe updated"})

@app.route('/api/products/<int:product_id>/ingredients', methods=['PUT'])
def update_recipe(product_id):
    """Bulk update recipe ingredients (add/update)"""
    data = request.get_json(silent=True) or {}
    ingredients = data.get('ingredients', [])
    
    if not ingredients:
        return jsonify({"message": "No ingredients provided"}), 400

    cursor = None
    try:
        cursor = mysql.connection.cursor()
        # Get existing ingredients
        cursor.execute("SELECT ingredientID from Product_Ingredients where productID = %s", (product_id,))
        existing_ids = {row['ingredientID'] for row in cursor.fetchall()}
        
        # Update existing or create new
        for i in ingredients:
            if i['ingredientID'] in existing_ids:
                cursor.callproc('UpdateRecipe', [product_id, i['ingredientID'], i['unitQuantityRequired']])
            else:
                cursor.callproc('CreateRecipe', [product_id, i['ingredientID'], i['unitQuantityRequired']])
        mysql.connection.commit()
        return jsonify({"message": "Recipe Updated"}), 200

    except Exception as e:
        mysql.connection.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()

@app.route('/api/products/<int:product_id>/ingredients/<int:ingredient_id>', methods=['DELETE'])
def delete_recipe(product_id, ingredient_id):
    """Remove ingredient from product recipe"""
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteRecipe', [product_id, ingredient_id])
    mysql.connection.commit()
    return jsonify({"message": "Ingredient removed from product"})

# ===========================================================================
# SALE DETAILS ROUTES
# ===========================================================================
@app.route('/api/sales/<int:sale_id>/details', methods=['GET'])
def get_sale_details(sale_id):
    """Get all line items for a sale"""
    cursor = mysql.connection.cursor()
    cursor.callproc('GetSaleDetails', [sale_id])
    details = cursor.fetchall()
    return jsonify(details)

# @app.route('/api/sales/<int:sale_id>/details', methods=['POST'])
# def create_sale_detail(sale_id):
#     """Add product to sale"""
#     data = request.json
#     cursor = mysql.connection.cursor()
#     cursor.callproc('CreateSaleDetail', [sale_id, data['productID'], data['quantity'], data['salePrice']])
#     mysql.connection.commit()
#     return jsonify({"message": "Product added to sale"}), 201

# @app.route('/api/sales/<int:sale_id>/details/<int:product_id>', methods=['PUT'])
# def update_sale_detail(sale_id, product_id):
#     """Update sale line item"""
#     data = request.json
#     cursor = mysql.connection.cursor()
#     cursor.callproc('UpdateSaleDetail', [sale_id, product_id, data['quantity'], data['salePrice']])
#     mysql.connection.commit()
#     return jsonify({"message": "Sale detail updated"})

@app.route('/api/sales/<int:sale_id>/details/<int:product_id>', methods=['DELETE'])
def delete_sale_detail(sale_id, product_id):
    """Remove product from sale"""
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteSaleDetail', [sale_id, product_id])
    mysql.connection.commit()
    return jsonify({"message": "Product removed from sale"})

# ===========================================================================
# RESET DATABASE
# ===========================================================================
@app.route('/api/reset', methods=['POST'])
def reset_database():
    """Reset database to initial state (stored procedure)"""
    cursor = mysql.connection.cursor()
    cursor.callproc('ResetDatabase')
    mysql.connection.commit()
    return jsonify({"message": "Database reset to initial state"})

# ===========================================================================
# SERVE FRONTEND
# ===========================================================================
@app.route('/assets/<path:filename>')
def serve_static(filename):
    """Serve static assets (JS/CSS/images)"""
    return send_from_directory(os.path.join(FRONTEND_DIST, 'assets'), filename)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_vue_app(path):
    """Main route serving Vue.js application"""
    return send_from_directory(FRONTEND_DIST, 'index.html')


# Listener
if __name__ == "__main__":
    app.run(port=5173, debug=True)
