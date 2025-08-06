from flask import Flask, jsonify, request
from flask_mysqldb import MySQL

app = Flask(__name__)

# Database configuration remains the same
app.config['MYSQL_HOST'] = 'classmysql.engr.oregonstate.edu'
app.config['MYSQL_USER'] = 'cs340_[your_onid]'
app.config['MYSQL_PASSWORD'] = '[your_db_password]'
app.config['MYSQL_DB'] = 'cs340_[your_onid]'
app.config['MYSQL_CURSORCLASS'] = "DictCursor"
app.config['MYSQL_AUTOCOMMIT'] = True

mysql = MySQL(app)

# ===========================================================================
# PRODUCTS ROUTES
# ===========================================================================
@app.route('/products', methods=['GET'])
def get_products():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Products")
    products = cursor.fetchall()
    return jsonify(products)

@app.route('/products', methods=['POST'])
def create_product():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateProduct', [data['name'], data['price']])
    mysql.connection.commit()
    return jsonify({"message": "Product created"}), 201

@app.route('/products/<int:product_id>', methods=['GET'])
def get_product(product_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetProduct', [product_id])
    product = cursor.fetchone()
    return jsonify(product)

@app.route('/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateProduct', [product_id, data['name'], data['price']])
    mysql.connection.commit()
    return jsonify({"message": "Product updated"})

@app.route('/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteProduct', [product_id])
    mysql.connection.commit()
    return jsonify({"message": "Product deleted"})

# ===========================================================================
# INGREDIENTS ROUTES
# ===========================================================================
@app.route('/ingredients', methods=['GET'])
def get_ingredients():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Ingredients")
    ingredients = cursor.fetchall()
    return jsonify(ingredients)

@app.route('/ingredients', methods=['POST'])
def create_ingredient():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateIngredient', [
        data['name'], 
        data['unit'], 
        data['costPerUnit'], 
        data['stock'], 
        data['supplierID']
    ])
    mysql.connection.commit()
    return jsonify({"message": "Ingredient created"}), 201

@app.route('/ingredients/<int:ingredient_id>', methods=['GET'])
def get_ingredient(ingredient_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetIngredient', [ingredient_id])
    ingredient = cursor.fetchone()
    return jsonify(ingredient)

@app.route('/ingredients/<int:ingredient_id>', methods=['PUT'])
def update_ingredient(ingredient_id):
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

# ===========================================================================
# SUPPLIERS ROUTES
# ===========================================================================
@app.route('/suppliers', methods=['GET'])
def get_suppliers():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Suppliers")
    suppliers = cursor.fetchall()
    return jsonify(suppliers)

@app.route('/suppliers', methods=['POST'])
def create_supplier():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateSupplier', [data['name'], data['phone'], data['email']])
    mysql.connection.commit()
    return jsonify({"message": "Supplier created"}), 201

@app.route('/suppliers/<int:supplier_id>', methods=['GET'])
def get_supplier(supplier_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetSupplier', [supplier_id])
    supplier = cursor.fetchone()
    return jsonify(supplier)

@app.route('/suppliers/<int:supplier_id>', methods=['PUT'])
def update_supplier(supplier_id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateSupplier', [supplier_id, data['name'], data['phone'], data['email']])
    mysql.connection.commit()
    return jsonify({"message": "Supplier updated"})

@app.route('/suppliers/<int:supplier_id>', methods=['DELETE'])
def delete_supplier(supplier_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteSupplier', [supplier_id])
    mysql.connection.commit()
    return jsonify({"message": "Supplier deleted"})

# ===========================================================================
# SALES ROUTES
# ===========================================================================
@app.route('/sales', methods=['GET'])
def get_sales():
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT * FROM Sales")
    sales = cursor.fetchall()
    return jsonify(sales)

@app.route('/sales', methods=['POST'])
def create_sale():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateSale', [data['saleDate']])
    result = cursor.fetchone()
    new_sale_id = result['newSaleID']
    return jsonify({"message": "Sale created", "saleID": new_sale_id}), 201

@app.route('/sales/<int:sale_id>', methods=['GET'])
def get_sale(sale_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetSale', [sale_id])
    sale = cursor.fetchone()
    return jsonify(sale)

@app.route('/sales/<int:sale_id>', methods=['PUT'])
def update_sale(sale_id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateSaleDate', [sale_id, data['saleDate']])
    mysql.connection.commit()
    return jsonify({"message": "Sale updated"})

@app.route('/sales/<int:sale_id>', methods=['DELETE'])
def delete_sale(sale_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteSale', [sale_id])
    mysql.connection.commit()
    return jsonify({"message": "Sale deleted"})

# ===========================================================================
# RECIPES ROUTES (PRODUCT_INGREDIENTS)
# ===========================================================================
@app.route('/products/<int:product_id>/ingredients', methods=['GET'])
def get_product_ingredients(product_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetRecipeByProduct', [product_id])
    recipes = cursor.fetchall()
    return jsonify(recipes)

@app.route('/products/<int:product_id>/ingredients', methods=['POST'])
def create_recipe(product_id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateRecipe', [product_id, data['ingredientID'], data['unitQuantityRequired']])
    mysql.connection.commit()
    return jsonify({"message": "Ingredient added to product"}), 201

@app.route('/products/<int:product_id>/ingredients/<int:ingredient_id>', methods=['PUT'])
def update_recipe(product_id, ingredient_id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateRecipe', [product_id, ingredient_id, data['unitQuantityRequired']])
    mysql.connection.commit()
    return jsonify({"message": "Recipe updated"})

@app.route('/products/<int:product_id>/ingredients/<int:ingredient_id>', methods=['DELETE'])
def delete_recipe(product_id, ingredient_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteRecipe', [product_id, ingredient_id])
    mysql.connection.commit()
    return jsonify({"message": "Ingredient removed from product"})

# ===========================================================================
# SALE DETAILS ROUTES
# ===========================================================================
@app.route('/sales/<int:sale_id>/details', methods=['GET'])
def get_sale_details(sale_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('GetSaleDetails', [sale_id])
    details = cursor.fetchall()
    return jsonify(details)

@app.route('/sales/<int:sale_id>/details', methods=['POST'])
def create_sale_detail(sale_id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('CreateSaleDetail', [sale_id, data['productID'], data['quantity'], data['salePrice']])
    mysql.connection.commit()
    return jsonify({"message": "Product added to sale"}), 201

@app.route('/sales/<int:sale_id>/details/<int:product_id>', methods=['PUT'])
def update_sale_detail(sale_id, product_id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.callproc('UpdateSaleDetail', [sale_id, product_id, data['quantity'], data['salePrice']])
    mysql.connection.commit()
    return jsonify({"message": "Sale detail updated"})

@app.route('/sales/<int:sale_id>/details/<int:product_id>', methods=['DELETE'])
def delete_sale_detail(sale_id, product_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('DeleteSaleDetail', [sale_id, product_id])
    mysql.connection.commit()
    return jsonify({"message": "Product removed from sale"})

# ===========================================================================
# RESET DATABASE
# ===========================================================================
@app.route('/reset', methods=['POST'])
def reset_database():
    cursor = mysql.connection.cursor()
    cursor.callproc('ResetDatabase')
    mysql.connection.commit()
    return jsonify({"message": "Database reset to initial state"})

# Listener
if __name__ == "__main__":
    app.run(port=5173, debug=True)