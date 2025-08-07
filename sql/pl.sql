-- ===========================================================================
-- CRUD FOR PRODUCTS TABLE
-- ===========================================================================

-- Create Product
DROP PROCEDURE IF EXISTS CreateProduct;
DELIMITER //
CREATE PROCEDURE CreateProduct(
    IN p_name VARCHAR(150),
    IN p_price DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Products (name, price)
    VALUES (p_name, p_price);
    SELECT LAST_INSERT_ID() AS id;
END //
DELIMITER ;

-- Read Product
DROP PROCEDURE IF EXISTS GetProduct;
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
DROP PROCEDURE IF EXISTS GetProducts;
DELIMITER //
CREATE PROCEDURE GetProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

-- Update Product
DROP PROCEDURE IF EXISTS UpdateProduct;
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
DROP PROCEDURE IF EXISTS DeleteProduct;
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
DROP PROCEDURE IF EXISTS CreateIngredient;
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
DROP PROCEDURE IF EXISTS GetIngredient;
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
DROP PROCEDURE IF EXISTS UpdateIngredient;
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
DROP PROCEDURE IF EXISTS CreateRecipe;
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
DROP PROCEDURE IF EXISTS GetRecipeByProduct;
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
DROP PROCEDURE IF EXISTS UpdateRecipe;
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
DROP PROCEDURE IF EXISTS DeleteRecipe;
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
DROP PROCEDURE IF EXISTS CreateSupplier;
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
DROP PROCEDURE IF EXISTS GetSupplier;
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
DROP PROCEDURE IF EXISTS UpdateSupplier;
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
DROP PROCEDURE IF EXISTS DeleteSupplier;
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
DROP PROCEDURE IF EXISTS CreateSale;
DELIMITER //
CREATE PROCEDURE CreateSale(IN p_saleDate TIMESTAMP)
BEGIN
    INSERT INTO Sales (saleDate) VALUES (p_saleDate);
    SELECT LAST_INSERT_ID() AS newSaleID;
END //
DELIMITER ;

-- Read Sale
DROP PROCEDURE IF EXISTS GetSale;
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
DROP PROCEDURE IF EXISTS UpdateSaleDate;
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
DROP PROCEDURE IF EXISTS DeleteSale;
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
DROP PROCEDURE IF EXISTS CreateSaleDetail;
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
DROP PROCEDURE IF EXISTS GetSaleDetails;
DELIMITER //
CREATE PROCEDURE GetSaleDetails(IN p_saleID INT)
BEGIN
    SELECT * FROM Sale_Details
    WHERE saleID = p_saleID;
END //
DELIMITER ;

-- Update Sale Detail
DROP PROCEDURE IF EXISTS UpdateSaleDetail;
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
DROP PROCEDURE IF EXISTS DeleteSaleDetail;
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

-- Reset Sale_Details
DROP PROCEDURE IF EXISTS CreateSaleDetailWithReset;
DELIMITER //
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
DELIMITER ;

-- ===========================================================================
-- RESET FUNCTIONALITY
-- ===========================================================================
DROP PROCEDURE IF EXISTS ResetDatabase;
DELIMITER //
CREATE PROCEDURE ResetDatabase()
BEGIN

    SET FOREIGN_KEY_CHECKS = 0;
    SET AUTOCOMMIT = 0;
    
    -- Drop tables in reverse dependency order
    DROP TABLE IF EXISTS Sale_Details;
    DROP TABLE IF EXISTS Sales;
    DROP TABLE IF EXISTS Product_Ingredients;
    DROP TABLE IF EXISTS Ingredients;
    DROP TABLE IF EXISTS Products;
    DROP TABLE IF EXISTS Suppliers;
    
    -- ===========================================================================
    -- TABLE CREATION
    -- ===========================================================================
    -- Suppliers (independent)
    CREATE TABLE Suppliers (
        supplierID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(150) NOT NULL UNIQUE,
        phone VARCHAR(14),
        email VARCHAR(150)
    );
    
    -- Ingredients (independent)
    CREATE TABLE Ingredients (
        ingredientID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(150) NOT NULL UNIQUE,
        unit VARCHAR(20) NOT NULL,
        costPerUnit DECIMAL(10, 2) NOT NULL,
        stock INT UNSIGNED NOT NULL,
        supplierID INT,
        FOREIGN KEY (supplierID) REFERENCES Suppliers(supplierID)
            ON DELETE SET NULL
            ON UPDATE CASCADE
    );
    
    -- Products (independent)
    CREATE TABLE Products (
        productID INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(150) NOT NULL UNIQUE,
        price DECIMAL(10, 2) NOT NULL
    );
    
    -- Product_Ingredients (M:M bridge)
    CREATE TABLE Product_Ingredients (
        recipeID INT AUTO_INCREMENT PRIMARY KEY,
        productID INT NOT NULL,
        ingredientID INT NOT NULL,
        unitQuantityRequired INT UNSIGNED NOT NULL,
        FOREIGN KEY (productID) REFERENCES Products(productID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        FOREIGN KEY (ingredientID) REFERENCES Ingredients(ingredientID)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    );
    
    -- Sales (independent)
    CREATE TABLE Sales (
        saleID INT AUTO_INCREMENT PRIMARY KEY,
        saleDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    
    -- Sale_Details (M:M bridge)
    CREATE TABLE Sale_Details (
        saleDetailsID INT AUTO_INCREMENT PRIMARY KEY,
        saleID INT NOT NULL,
        productID INT NOT NULL,
        quantity INT UNSIGNED NOT NULL,
        salePrice DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (saleID) REFERENCES Sales(saleID)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
        FOREIGN KEY (productID) REFERENCES Products(productID)
            ON DELETE RESTRICT
            ON UPDATE CASCADE
    );
    
    -- ===========================================================================
    -- DATA INSERTION
    -- ===========================================================================
    
    -- Suppliers
    INSERT INTO Suppliers (name, phone, email)
    VALUES 
    ("Wario's Warehouse", "1-800-555-1111", "wario.warehouse@gmail.com"),
    ("Stan's Store", "1-800-555-2222", "stan.store@hotmail.com"),
    ("Garry's Garden", "1-800-555-3333", "garry.garden@yahoo.com");
    
    -- Ingredients
    INSERT INTO Ingredients (name, unit, costPerUnit, stock, supplierID)
    SELECT "Lemons", "pieces", 7.25, 2500, supplierID 
    FROM Suppliers WHERE name = "Wario's Warehouse"
    UNION ALL
    SELECT "Sugar", "grams", 9.75, 2500, supplierID 
    FROM Suppliers WHERE name = "Wario's Warehouse"
    UNION ALL
    SELECT "Water", "ml", 5.00, 2500, supplierID 
    FROM Suppliers WHERE name = "Wario's Warehouse"
    UNION ALL
    SELECT "Strawberries", "pieces", 10.50, 1500, supplierID 
    FROM Suppliers WHERE name = "Stan's Store"
    UNION ALL
    SELECT "Watermelons", "pieces", 10.50, 1500, supplierID 
    FROM Suppliers WHERE name = "Garry's Garden";
    
    -- Products
    INSERT INTO Products (name, price)
    VALUES 
    ("Classic", 5.00),
    ("Strawberry", 7.25),
    ("Watermelon", 7.25);
    
    -- Product_Ingredients
    INSERT INTO Product_Ingredients (productID, ingredientID, unitQuantityRequired)
    -- Classic Lemonade
    SELECT 
        (SELECT productID FROM Products WHERE name = "Classic"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Lemons"),
        10
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Classic"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Sugar"),
        10
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Classic"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Water"),
        10
    -- Strawberry Lemonade
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Strawberry"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Lemons"),
        5
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Strawberry"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Sugar"),
        10
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Strawberry"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Water"),
        10
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Strawberry"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Strawberries"),
        5
    -- Watermelon Lemonade
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Watermelon"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Sugar"),
        10
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Watermelon"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Water"),
        10
    UNION ALL
    SELECT 
        (SELECT productID FROM Products WHERE name = "Watermelon"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Watermelons"),
        10;
    
    -- Sales
    INSERT INTO Sales (saleDate)
    VALUES 
    ("2025-06-20 06:23:23"),
    ("2025-06-24 12:28:23"),
    ("2025-06-27 16:37:10");
    
    -- Sale_Details
    INSERT INTO Sale_Details (saleID, productID, quantity, salePrice)
    -- Sale 1: 4 Classics
    SELECT 
        (SELECT saleID FROM Sales WHERE saleDate = "2025-06-20 06:23:23"),
        (SELECT productID FROM Products WHERE name = "Classic"),
        4,
        5.00
    UNION ALL
    -- Sale 2: 1 Classic
    SELECT 
        (SELECT saleID FROM Sales WHERE saleDate = "2025-06-24 12:28:23"),
        (SELECT productID FROM Products WHERE name = "Classic"),
        1,
        5.00
    UNION ALL
    -- Sale 2: 2 Strawberries
    SELECT 
        (SELECT saleID FROM Sales WHERE saleDate = "2025-06-24 12:28:23"),
        (SELECT productID FROM Products WHERE name = "Strawberry"),
        2,
        7.25
    UNION ALL
    -- Sale 3: 2 Watermelons
    SELECT 
        (SELECT saleID FROM Sales WHERE saleDate = "2025-06-27 16:37:10"),
        (SELECT productID FROM Products WHERE name = "Watermelon"),
        2,
        7.25;
    
    -- ===========================================================================
    -- CUD OPERATIONS FOR INTERSECTION TABLES (M:M relationships)
    -- ===========================================================================
    
    -- 1. CREATE: Add new recipe (Watermelon needs lemons)
    INSERT INTO Product_Ingredients (productID, ingredientID, unitQuantityRequired)
    SELECT 
        (SELECT productID FROM Products WHERE name = "Watermelon"),
        (SELECT ingredientID FROM Ingredients WHERE name = "Lemons"),
        3;
    
    -- 2. UPDATE: Modify existing recipe (increase sugar in Strawberry)
    UPDATE Product_Ingredients
    SET unitQuantityRequired = 12
    WHERE productID = (SELECT productID FROM Products WHERE name = "Strawberry")
    AND ingredientID = (SELECT ingredientID FROM Ingredients WHERE name = "Sugar");
    
    -- 3. DELETE: Remove unnecessary ingredient (water from Watermelon)
    DELETE FROM Product_Ingredients
    WHERE productID = (SELECT productID FROM Products WHERE name = "Watermelon")
    AND ingredientID = (SELECT ingredientID FROM Ingredients WHERE name = "Water");
    
    -- 4. CREATE: Add new sale detail (additional Watermelon in sale 3)
    INSERT INTO Sale_Details (saleID, productID, quantity, salePrice)
    SELECT 
        (SELECT saleID FROM Sales WHERE saleDate = "2025-06-27 16:37:10"),
        (SELECT productID FROM Products WHERE name = "Watermelon"),
        1,
        7.00;  -- Discounted price
    
    -- 5. UPDATE: Correct quantity in sale (sale 1 Classic from 4 to 3)
    UPDATE Sale_Details
    SET quantity = 3
    WHERE saleID = (SELECT saleID FROM Sales WHERE saleDate = "2025-06-20 06:23:23")
    AND productID = (SELECT productID FROM Products WHERE name = "Classic");
    
    -- 6. DELETE: Remove a sale detail (sale 2 Strawberry)
    DELETE FROM Sale_Details
    WHERE saleID = (SELECT saleID FROM Sales WHERE saleDate = "2025-06-24 12:28:23")
    AND productID = (SELECT productID FROM Products WHERE name = "Strawberry");
    
    SET FOREIGN_KEY_CHECKS = 1;
    COMMIT;
END //

DELIMITER ;
