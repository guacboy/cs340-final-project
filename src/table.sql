SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- Table creation for Products
CREATE OR REPLACE TABLE Products (
    productID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (productID)
);

-- Table creation for Suppliers
CREATE OR REPLACE TABLE Suppliers (
    supplierID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(14),
    email VARCHAR(150),
    PRIMARY KEY (supplierID)
);

-- Table creation for Ingredients
CREATE OR REPLACE TABLE Ingredients (
    ingredientID INT AUTO_INCREMENT UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL UNIQUE,
    unit VARCHAR(20) NOT NULL,
    costPerUnit DECIMAL(10, 2) NOT NULL,
    stock INT UNSIGNED NOT NULL,
    supplierID INT,
    PRIMARY KEY (ingredientID),
    FOREIGN KEY (supplierID) REFERENCES Suppliers(supplierID)
);

-- Table creation for Product_Ingredients
CREATE OR REPLACE TABLE Product_Ingredients (
    productID INT NOT NULL,
    ingredientID INT NOT NULL,
    unitQuantityRequired INT UNSIGNED NOT NULL,
    FOREIGN KEY (productID) REFERENCES Products (productID),
    FOREIGN KEY (ingredientID) REFERENCES Ingredients (ingredientID)
);

-- Table creation for Sales
CREATE OR REPLACE TABLE Sales (
    saleID INT AUTO_INCREMENT UNIQUE NOT NULL,
    saleDate TIMESTAMP NOT NULL,
    PRIMARY KEY (saleID)
);

-- Table creation for Sale_Details
CREATE OR REPLACE TABLE Sale_Details (
    saleID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    salePrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (saleID) REFERENCES Sales (saleID),
    FOREIGN KEY (productID) REFERENCES Products (productID)
);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;