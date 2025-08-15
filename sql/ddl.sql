DROP PROCEDURE IF EXISTS sp_load_lemonade_db;
DELIMITER //

CREATE PROCEDURE sp_load_lemonade_db()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;

    -- ===========================================================================
    -- TABLE DROPPING
    -- ===========================================================================
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

    -- Product_Ingredients (M:M)
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

    -- Sale_Details (M:M)
    CREATE TABLE Sale_Details (
        saleDetailID INT AUTO_INCREMENT PRIMARY KEY,
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

-- Date: 8/5/2025
-- Prompts used to generate an example operation for intersection tables.
-- Given the code: [ddl.sql file], write an example operation
-- for the intersection tables.
-- AI Source URL: https://chat.deepseek.com

    -- ===========================================================================
    -- EXAMPLE OPERATIONS FOR INTERSECTION TABLES
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