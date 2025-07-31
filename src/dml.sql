-- ===========================================================================
-- DML including CRUD operations for all entities.
-- ===========================================================================

-- Dylan Nguyen
-- Ryan Davidson

-- ===========================================================================
-- CRUD OPERATIONS FOR PRODUCTS TABLE
-- ===========================================================================

-- CREATE
INSERT INTO Products (name, price) 
VALUES (@nameInput, @priceInput);

-- READ
SELECT * FROM Products 
WHERE productID = @productIDInput;

-- UPDATE
UPDATE Products 
SET name = @nameInput, price = @priceInput 
WHERE productID = @productIDInput;

-- DELETE
DELETE FROM Products 
WHERE productID = @productIDInput;

-- ===========================================================================
-- CRUD OPERATIONS FOR INGREDIENTS TABLE
-- ===========================================================================

-- CREATE
INSERT INTO Ingredients (name, unit, costPerUnit, stock, supplierID) 
VALUES (@nameInput, @unitInput, @costPerUnitInput, @stockInput, @supplierIDInput);

-- READ
SELECT * FROM Ingredients 
WHERE ingredientID = @ingredientIDInput;

-- UPDATE
UPDATE Ingredients 
SET name = @nameInput, 
    unit = @unitInput, 
    costPerUnit = @costPerUnitInput, 
    stock = @stockInput, 
    supplierID = @supplierIDInput 
WHERE ingredientID = @ingredientIDInput;

-- ===========================================================================
-- CRUD OPERATIONS FOR PRODUCT_INGREDIENTS TABLE
-- ===========================================================================

-- CREATE
INSERT INTO Product_Ingredients (productID, ingredientID, unitQuantityRequired) 
VALUES (@productIDInput, @ingredientIDInput, @unitQuantityRequiredInput);

-- READ (by Product)
SELECT * FROM Product_Ingredients 
WHERE productID = @productIDInput;

-- UPDATE
UPDATE Product_Ingredients 
SET unitQuantityRequired = @unitQuantityRequiredInput 
WHERE productID = @productIDInput AND ingredientID = @ingredientIDInput;

-- DELETE
DELETE FROM Product_Ingredients 
WHERE productID = @productIDInput AND ingredientID = @ingredientIDInput;

-- ===========================================================================
-- CRUD OPERATIONS FOR SUPPLIERS TABLE
-- ===========================================================================

-- CREATE
INSERT INTO Suppliers (name, phone, email) 
VALUES (@nameInput, @phoneInput, @emailInput);

-- READ
SELECT * FROM Suppliers 
WHERE supplierID = @supplierIDInput;

-- UPDATE
UPDATE Suppliers 
SET name = @nameInput, phone = @phoneInput, email = @emailInput 
WHERE supplierID = @supplierIDInput;

-- DELETE
DELETE FROM Suppliers 
WHERE supplierID = @supplierIDInput;

-- ===========================================================================
-- CRUD OPERATIONS FOR SALES TABLE
-- ===========================================================================

-- CREATE (+ return new ID)
INSERT INTO Sales (saleDate) VALUES (@saleDateInput);
SELECT LAST_INSERT_ID() AS newSaleID;

-- READ
SELECT * FROM Sales 
WHERE saleID = @saleIDInput;

-- UPDATE
UPDATE Sales 
SET saleDate = @saleDateInput 
WHERE saleID = @saleIDInput;

-- DELETE
DELETE FROM Sales 
WHERE saleID = @saleIDInput;

-- ===========================================================================
-- CRUD OPERATIONS FOR SALE_DETAILS TABLE
-- ===========================================================================

-- CREATE
INSERT INTO Sale_Details (saleID, productID, quantity, salePrice) 
VALUES (@saleIDInput, @productIDInput, @quantityInput, @salePriceInput);

-- READ (by Sale)
SELECT * FROM Sale_Details 
WHERE saleID = @saleIDInput;

-- UPDATE
UPDATE Sale_Details 
SET quantity = @quantityInput, salePrice = @salePriceInput 
WHERE saleID = @saleIDInput AND productID = @productIDInput;

-- DELETE
DELETE FROM Sale_Details 
WHERE saleID = @saleIDInput AND productID = @productIDInput;