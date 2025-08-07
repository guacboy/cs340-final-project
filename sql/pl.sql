-- ===========================================================================
-- CRUD FOR PRODUCTS TABLE
-- ===========================================================================

-- Create Product
DELIMITER //
CREATE PROCEDURE CreateProduct(
    IN p_name VARCHAR(150),
    IN p_price DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Products (name, price)
    VALUES (p_name, p_price);
END //
DELIMITER ;

-- Read Product
DELIMITER //
CREATE PROCEDURE GetProduct(
    IN p_productID INT
)
BEGIN
    SELECT * FROM Products
    WHERE productID = p_productID;
END //
DELIMITER ;

-- Read All Products
DELIMITER //
CREATE PROCEDURE GetProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

-- Update Product
DELIMITER //
CREATE PROCEDURE UpdateProduct(
    IN p_productID INT,
    IN p_name VARCHAR(150),
    IN p_price DECIMAL(10,2)
)
BEGIN
    UPDATE Products
    SET name = p_name, price = p_price
    WHERE productID = p_productID;
END //
DELIMITER ;

-- Delete Product
DELIMITER //
CREATE PROCEDURE DeleteProduct(IN p_productID INT)
BEGIN
    DELETE FROM Products
    WHERE productID = p_productID;
END //
DELIMITER ;

-- ===========================================================================
-- CRUD FOR INGREDIENTS TABLE
-- ===========================================================================

-- Create Ingredient
DELIMITER //
CREATE PROCEDURE CreateIngredient(
    IN p_name VARCHAR(150),
    IN p_unit VARCHAR(20),
    IN p_costPerUnit DECIMAL(10,2),
    IN p_stock INT UNSIGNED,
    IN p_supplierID INT
)
BEGIN
    INSERT INTO Ingredients (name, unit, costPerUnit, stock, supplierID)
    VALUES (p_name, p_unit, p_costPerUnit, p_stock, p_supplierID);
END //
DELIMITER ;

-- Read Ingredient
DELIMITER //
CREATE PROCEDURE GetIngredient(
    IN p_ingredientID INT
)
BEGIN
    SELECT * FROM Ingredients
    WHERE ingredientID = p_ingredientID;
END //
DELIMITER ;

-- Update Ingredient
DELIMITER //
CREATE PROCEDURE UpdateIngredient(
    IN p_ingredientID INT,
    IN p_name VARCHAR(150),
    IN p_unit VARCHAR(20),
    IN p_costPerUnit DECIMAL(10,2),
    IN p_stock INT UNSIGNED,
    IN p_supplierID INT
)
BEGIN
    UPDATE Ingredients
    SET name = p_name, 
        unit = p_unit, 
        costPerUnit = p_costPerUnit, 
        stock = p_stock, 
        supplierID = p_supplierID
    WHERE ingredientID = p_ingredientID;
END //
DELIMITER ;

-- ===========================================================================
-- CRUD FOR PRODUCT_INGREDIENTS TABLE
-- ===========================================================================

-- Create Product Ingredient Relationship
DELIMITER //
CREATE PROCEDURE CreateRecipe(
    IN p_productID INT,
    IN p_ingredientID INT,
    IN p_unitQuantityRequired INT UNSIGNED
)
BEGIN
    INSERT INTO Product_Ingredients (productID, ingredientID, unitQuantityRequired)
    VALUES (p_productID, p_ingredientID, p_unitQuantityRequired);
END //
DELIMITER ;

-- Read Recipe by Product
DELIMITER //
CREATE PROCEDURE GetRecipeByProduct(
    IN p_productID INT
)
BEGIN
    SELECT * FROM Product_Ingredients pi
    JOIN Ingredients i ON pi.ingredientID = i.ingredientID
    WHERE productID = p_productID;
END //
DELIMITER ;

-- Update Recipe
DELIMITER //
CREATE PROCEDURE UpdateRecipe(
    IN p_productID INT,
    IN p_ingredientID INT,
    IN p_unitQuantityRequired INT UNSIGNED
)
BEGIN
    UPDATE Product_Ingredients
    SET unitQuantityRequired = p_unitQuantityRequired
    WHERE productID = p_productID AND ingredientID = p_ingredientID;
END //
DELIMITER ;

-- Delete Recipe
DELIMITER //
CREATE PROCEDURE DeleteRecipe(
    IN p_productID INT,
    IN p_ingredientID INT
)
BEGIN
    DELETE FROM Product_Ingredients 
    WHERE productID = p_productID AND ingredientID = p_ingredientID;
END //
DELIMITER ;

-- ===========================================================================
-- CRUD FOR SUPPLIERS TABLE
-- ===========================================================================

-- Create Supplier
DELIMITER //
CREATE PROCEDURE CreateSupplier(
    IN p_name VARCHAR(150),
    IN p_phone VARCHAR(14),
    IN p_email VARCHAR(150)
)
BEGIN
    INSERT INTO Suppliers (name, phone, email)
    VALUES (p_name, p_phone, p_email);
END //
DELIMITER ;

-- Read Supplier
DELIMITER //
CREATE PROCEDURE GetSupplier(
    IN p_supplierID INT
)
BEGIN
    SELECT * FROM Suppliers
    WHERE supplierID = p_supplierID;
END //
DELIMITER ;

-- Update Supplier
DELIMITER //
CREATE PROCEDURE UpdateSupplier(
    IN p_supplierID INT,
    IN p_name VARCHAR(150),
    IN p_phone VARCHAR(14),
    IN p_email VARCHAR(150)
)
BEGIN
    UPDATE Suppliers
    SET name = p_name, phone = p_phone, email = p_email
    WHERE supplierID = p_supplierID;
END //
DELIMITER ;

-- Delete Supplier
DELIMITER //
CREATE PROCEDURE DeleteSupplier(
    IN p_supplierID INT
)
BEGIN
    DELETE FROM Suppliers
    WHERE supplierID = p_supplierID;
END //
DELIMITER ;

-- ===========================================================================
-- CRUD FOR SALES TABLE
-- ===========================================================================

-- Create Sale
DELIMITER //
CREATE PROCEDURE CreateSale(IN p_saleDate TIMESTAMP)
BEGIN
    INSERT INTO Sales (saleDate) VALUES (p_saleDate);
    SELECT LAST_INSERT_ID() AS newSaleID;
END //
DELIMITER ;

-- Read Sale
DELIMITER //
CREATE PROCEDURE GetSale(
    IN p_saleID INT
)
BEGIN
    SELECT * FROM Sales
    WHERE saleID = p_saleID;
END //
DELIMITER ;

-- Update Sale Date
DELIMITER //
CREATE PROCEDURE UpdateSaleDate(
    IN p_saleID INT,
    IN p_saleDate TIMESTAMP
)
BEGIN
    UPDATE Sales
    SET saleDate = p_saleDate
    WHERE saleID = p_saleID;
END //
DELIMITER ;

-- Delete Sale
DELIMITER //
CREATE PROCEDURE DeleteSale(
    IN p_saleID INT
)
BEGIN
    DELETE FROM Sales
    WHERE saleID = p_saleID;
END //
DELIMITER ;

-- ===========================================================================
-- CRUD FOR SALE_DETAILS TABLE
-- ===========================================================================

-- Create Sale Detail
DELIMITER //
CREATE PROCEDURE CreateSaleDetail(
    IN p_saleID INT,
    IN p_productID INT,
    IN p_quantity INT,
    IN p_salePrice DECIMAL(10,2)
)
BEGIN
    INSERT INTO Sale_Details (saleID, productID, quantity, salePrice)
    VALUES (p_saleID, p_productID, p_quantity, p_salePrice);
END //
DELIMITER ;

-- Read Sale Details by Sale
DELIMITER //
CREATE PROCEDURE GetSaleDetails(IN p_saleID INT)
BEGIN
    SELECT * FROM Sale_Details
    WHERE saleID = p_saleID;
END //
DELIMITER ;

-- Update Sale Detail
DELIMITER //
CREATE PROCEDURE UpdateSaleDetail(
    IN p_saleID INT,
    IN p_productID INT,
    IN p_quantity INT,
    IN p_salePrice DECIMAL(10,2)
)
BEGIN
    UPDATE Sale_Details
    SET quantity = p_quantity, salePrice = p_salePrice
    WHERE saleID = p_saleID AND productID = p_productID;
END //
DELIMITER ;

-- Delete Sale Detail
DELIMITER //
CREATE PROCEDURE DeleteSaleDetail(
    IN p_saleID INT,
    IN p_productID INT
)
BEGIN
    DELETE FROM Sale_Details 
    WHERE saleID = p_saleID AND productID = p_productID;
END //
DELIMITER ;

DELIMITER //

-- Reset Sale_Details
CREATE PROCEDURE CreateSaleDetailWithReset(
    IN p_saleID INT,
    IN p_productID INT,
    IN p_quantity INT,
    IN p_salePrice DECIMAL(10, 2),
    IN reset_flag BOOLEAN
)
BEGIN
    -- Start transaction for atomic operation
    START TRANSACTION;
    
    -- CUD OPERATION: Create new sale detail
    INSERT INTO Sale_Details (saleID, productID, quantity, salePrice)
    VALUES (p_saleID, p_productID, p_quantity, p_salePrice);
    
    -- Store the new ID for potential return
    SET @new_id = LAST_INSERT_ID();
    
    -- Handle reset based on flag
    IF reset_flag THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END //

-- ===========================================================================
-- RESET FUNCTIONALITY
-- ===========================================================================
CREATE PROCEDURE ResetDatabase()
BEGIN
    -- Start transaction for atomic reset
    START TRANSACTION;
    
    -- Delete all sale details added after initial dataset
    DELETE FROM Sale_Details 
    WHERE saleDetailsID > 4;  -- Assuming initial dataset had 4 records
    
    -- Delete all sales added after initial dataset
    DELETE FROM Sales 
    WHERE saleID > 3;  -- Assuming initial dataset had 3 sales
    
    -- Reset auto-increment counters
    ALTER TABLE Sale_Details AUTO_INCREMENT = 5;
    ALTER TABLE Sales AUTO_INCREMENT = 4;
    
    COMMIT;
END //

DELIMITER ;