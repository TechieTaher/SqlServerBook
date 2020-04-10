
CREATE VIEW
Production.vOnlineProducts
AS
SELECT p.ProductID, p.Name, p.ProductNumber AS [Product Number], COALESCE(p.Color, 'N/A') AS Color,
CASE p.DaysToManufacture
WHEN 0 THEN 'In stock' 
WHEN 1 THEN 'Overnight'
WHEN 2 THEN '2 to 3 days delivery'
ELSE 'Call us for a quote'
END AS Availability,
p.Size, p.SizeUnitMeasureCode AS [Unit of Measure], p.ListPrice AS Price, p.Weight
FROM Production.Product AS p


CREATE VIEW
Production.vAvailableModels
AS
SELECT p.ProductID AS [Product ID], p.Name, pm.ProductModelID AS [Product Model ID], pm.Name as [Product Model]
FROM Production.Product AS p
INNER JOIN Production.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID


CREATE VIEW dbo.vCustomers
AS
SELECT CustomerId, CustomerName,PhoneNo,EmaiId,City
FROM dbo.Customers;

INSERT INTO dbo.vCustomers
VALUES
('admin',213146467,'asdasd@asd.com','asda'),
( 'admin5',6576,'admin@admin.com','admin');


SELECT * FROM dbo.vCustomers
ORDER BY CustomerID


