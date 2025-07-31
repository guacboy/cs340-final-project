-- ===========================================================================
-- DDL including table creation and data insertion.
-- ===========================================================================

-- Dylan Nguyen
-- Ryan Davidson

SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- Drops any previously created tables
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Product_Ingredients;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Sale_Details;

-- ===========================================================================
-- TABLE CREATION
-- ===========================================================================

-- Table creation for Products
-- Products offered for sale to customers (including three flavors: Classic, Strawberry, and Watermelon)
CREATE TABLE Products (
    productID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (productID)
);

-- Table creation for Ingredients
-- Raw materials that are used to create the products (including lemons, sugar, water, strawberries, and watermelon)
CREATE TABLE Ingredients (
    ingredientID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL UNIQUE,
    unit VARCHAR(20) NOT NULL,
    costPerUnit DECIMAL(10, 2) NOT NULL,
    stock INT UNSIGNED NOT NULL,
    supplierID INT,
    PRIMARY KEY (ingredientID),
    FOREIGN KEY (supplierID) REFERENCES Suppliers(supplierID)
        ON DELETE SET NULL  -- Keep ingredient if supplier is deleted
        ON UPDATE CASCADE   -- Update if supplierID changes
);

-- Table creation for Product_Ingredients
-- Intersection table for product-ingredients recipe mapping (M:M)
CREATE TABLE Product_Ingredients (
    recipeID INT AUTO_INCREMENT UNIQUE NOT NULL,
    productID INT NOT NULL,
    ingredientID INT NOT NULL,
    unitQuantityRequired INT UNSIGNED NOT NULL,
    PRIMARY KEY (recipeID)
    FOREIGN KEY (productID) REFERENCES Products (productID)
        ON DELETE CASCADE  -- Delete recipe if product is deleted
        ON UPDATE CASCADE, -- Update if productID changes
    FOREIGN KEY (ingredientID) REFERENCES Ingredients (ingredientID)
        ON DELETE CASCADE  -- Delete recipe if ingredient is deleted
        ON UPDATE CASCADE  -- Update if ingredientID changes
);

-- Table creation for Suppliers
-- Local vendors provide their respective raw ingredients to produce the product
CREATE TABLE Suppliers (
    supplierID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(14),
    email VARCHAR(150),
    PRIMARY KEY (supplierID)
);

-- Table creation for Sales
-- Records of lemonade sale transactions
CREATE TABLE Sales (
    saleID INT AUTO_INCREMENT UNIQUE NOT NULL,
    saleDate TIMESTAMP NOT NULL,
    PRIMARY KEY (saleID)
);

-- Table creation for Sale_Details
-- Intersection table for sales-products mapping (M:M)
CREATE TABLE Sale_Details (
    saleDetailsID INT AUTO_INCREMENT UNIQUE NOT NULL,
    saleID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    salePrice DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (saleDetailsID)
    FOREIGN KEY (saleID) REFERENCES Sales (saleID)
        ON DELETE CASCADE  -- Delete details if sale is deleted
        ON UPDATE CASCADE, -- Update if saleID changes
    FOREIGN KEY (productID) REFERENCES Products (productID)
        ON DELETE RESTRICT  -- Prevent product deletion if sales exist
        ON UPDATE CASCADE   -- Update if productID changes
);

-- ===========================================================================
-- DATA INSERTION
-- ===========================================================================

-- Data insertion for Products
INSERT INTO Products (name, price) VALUES
("Classic", 5.00),
("Strawberry", 7.25),
("Watermelon", 7.25);

-- Data insertion for Ingredients
INSERT INTO Ingredients (name, unit, costPerUnit, stock, supplierID) VALUES
("Lemons", "pieces", 7.25, 2500, 1),
("Sugar", "grams", 9.75, 2500, 1),
("Water", "ml", 5.00, 2500, 1),
("Strawberries", "pieces", 10.50, 1500, 2),
("Watermelons", "pieces", 10.50, 1500, 3);

-- Data insertion for Product_Ingredients
INSERT INTO Product_Ingredients (productID, ingredientID, unitQuantityRequired) VALUES
(1, 1, 10),
(1, 2, 10),
(1, 3, 10),
(2, 1, 5),
(2, 2, 10),
(2, 3, 10),
(2, 4, 5),
(3, 2, 10),
(3, 3, 10),
(3, 5, 10);

-- Data insertion for Suppliers
INSERT INTO Suppliers (name, phone, email) VALUES
("Wario's Warehouse", "1-800-555-1111", "wario.warehouse@gmail.com"),
("Stan's Store", "1-800-555-2222", "stan.store@hotmail.com"),
("Garry's Garden", "1-800-555-3333", "garry.garden@yahoo.com");

-- Data insertion for Sales
INSERT INTO Sales (saleDate) VALUES
("2025-06-20 06:23:23"),
("2025-06-24 12:28:23"),
("2025-06-27 16:37:10");

-- Data insertion for Sale_Details
INSERT INTO Sale_Details (saleID, productID, quantity, salePrice) VALUES
(1, 1, 4, 5.00),    -- 4 × Classic @ $5.00 each
(2, 1, 1, 5.00),    -- 1 × Classic @ $5.00
(2, 2, 2, 7.25),    -- 2 × Strawberry @ $7.25 each
(3, 3, 2, 7.25);    -- 2 × Watermelon @ $7.25 each

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;