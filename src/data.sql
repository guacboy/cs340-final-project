SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- Data insertion for Products
INSERT INTO Products (
    name,
    price
)
VALUES
("Classic", 5.00),
("Strawberry", 7.25),
("Watermelon", 7.25);

-- Data insertion for Ingredients
INSERT INTO Ingredients (
    name,
    unit,
    costPerUnit,
    stock,
    supplierID
)
VALUES
(
    "Lemons",
    "pieces",
    7.25,
    2500,
    1
),
(
    "Sugar",
    "grams",
    9.75,
    2500,
    1
),
(
    "Water",
    "ml",
    5.00,
    2500,
    1
),
(
    "Strawberries",
    "pieces",
    10.50,
    1500,
    2
),
(
    "Watermelons",
    "pieces",
    10.50,
    1500,
    3
);

-- Data insertion for Product_Ingredients
INSERT INTO Product_Ingredients (
    productID,
    ingredientID, 
    unitQuantityRequired
)
VALUES
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
INSERT INTO Suppliers (
    name,
    phone, 
    email
)
VALUES
    (
        "Wario's Warehouse",
        "1-800-555-1111",
        "wario.warehouse@gmail.com"
    ),
    (
        "Stan's Store",
        "1-800-555-2222",
        "stan.store@hotmail.com"
    ),
    (
        "Garry's Garden",
        "1-800-555-3333",
        "garry.garden@yahoo.com"
    );

-- Data insertion for Sales
INSERT INTO Sales (
    saleDate
)
VALUES
    ("2025-06-20"),
    ("2025-06-24"),
    ("2025-06-27");

-- Data insertion for Sale_Details
INSERT INTO Sale_Details (
    saleID,
    productID,
    quantity,
    salePrice
)
VALUES
    (1, 1, 4, 5.00),
    (2, 1, 1, 5.00),
    (2, 2, 2, 7.25),
    (3, 3, 2, 725);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;