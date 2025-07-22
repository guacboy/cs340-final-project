SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- products
CREATE OR REPLACE TABLE Products(
    productID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY(productID)
)

-- ingredients
CREATE OR REPLACE TABLE Ingredients(
    ingredientID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL UNIQUE,
    unit INT UNSIGNED NOT NULL,
    costPerUnit DECIMAL(10, 2) NOT NULL,
    stock INT UNSIGNED NOT NULL,
    PRIMARY KEY(ingredientID)
)

-- product_ingredients
CREATE OR REPLACE TABLE Product_Ingredients(
    productID INT NOT NULL,
    ingredientID INT NOT NULL,
    unitQuantityRequired INT UNSIGNED NOT NULL,
    FOREIGN KEY(productID) REFERENCES Products(productID),
    FOREIGN KEY(ingredientID) REFERENCES Ingredients(ingredientID)
)

-- suppliers
CREATE OR REPLACE TABLE Suppliers(
    supplierID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(14),
    email VARCHAR(150),
    PRIMARY KEY(supplierID)
)

-- sales
CREATE OR REPLACE TABLE Sales(
    saleID INT AUTO_INCREMENT UNIQUE NOT NULL,
    saleDate TIMESTAMP NOT NULL,
    PRIMARY KEY(saleID)
)

-- sale_details
CREATE OR REPLACE TABLE Sale_Details(
    saleID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    salePrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY(saleID) REFERENCES Sales(saleID),
    FOREIGN KEY(productID) REFERENCES Products(productID)
)

SET FOREIGN_KEY_CHECKS=1;
COMMIT;