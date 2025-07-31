/*
SELECT * FROM Products
JOIN Product_Ingredients ON Products.productID = Product_Ingredients.productID
JOIN Ingredients ON Product_Ingredients.ingredientID = Ingredients.ingredientID
JOIN Suppliers ON Ingredients.supplierID = Suppliers.supplierID
ORDER BY Products.productID ASC;
*/

/*
SELECT
  Sales.saleID,
  Sales.saleDate,
  Sale_Details.productID,
  Products.name AS productName,
  Sale_Details.quantity,
  Sale_Details.salePrice,
  (Sale_Details.quantity * Sale_Details.salePrice) AS itemTotal,
  Total.saleTotal
FROM Sales
  JOIN Sale_Details ON Sales.saleID = Sale_Details.saleID
  JOIN Products ON Sale_Details.productID = Products.productID
  JOIN (
    SELECT saleID, SUM(quantity * salePrice) AS saleTotal FROM Sale_Details GROUP BY saleID
  ) AS Total ON Sales.saleID = Total.saleID
ORDER BY Sales.saleID, Products.productID;
*/