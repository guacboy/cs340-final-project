SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- products
INSERT INTO Products(
    name,
    price
)
VALUES (
    (
        "Classic",
        5.00
    ),
    (
        "Strawberry",
        7.25
    ),
    (
        "Watermelon",
        7.25
    )
)

-- ingredients
INSERT INTO Ingredients(
    name,
    unit,
    costPerUnit,
    stock
)
VALUES (
    (
        "Lemons",
        10,
        7.25,
        25
    ),
    (
        "Sugar",
        10,
        9.75,
        25
    ),
    (
        "Water",
        10,
        5.00,
        25
    ),
    (
        "Strawberries",
        5,
        10.50,
        15
    ),
    (
        "Watermelons",
        5,
        10.50,
        15
    )
)

-- product_ingredients
INSERT INTO Product_Ingredients(

)
VALUES (
    
)

-- suppliers
INSERT INTO Suppliers(
    name,
    phone,
    email
)
VALUES (
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
    )
)

-- sales
INSERT INTO Sales(
    saleDate
)
VALUES (
    (
        "2025-06-20"
    ),
    (
        "2025-06-24"
    ),
    (
        "2025-06-27"
    )
)

-- sale_details
INSERT INTO Sale_Details(
    saleID,
    productID,
    quantity,
    salePrice
)
VALUES (
    (
        1,
        1,
        4,
        20.00
    ),
    (
        2,
        2,
        2,
        14.50
    ),
    (
        3,
        3,
        2,
        14.50
    )
)

SET FOREIGN_KEY_CHECKS=1;
COMMIT;