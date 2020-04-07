
USE AdventureWorks;
GO

IF OBJECT_ID(N'dbo.vw_TransactionHistorySummary', N'V') IS NOT NULL
	DROP VIEW dbo.vw_TransactionHistorySummary;
GO

CREATE VIEW dbo.vw_TransactionHistorySummary
	WITH SCHEMABINDING
	AS
		SELECT ProductID, SUM(Quantity) AS 'Quantity', COUNT_BIG(*) AS 'Count'
			FROM Production.TransactionHistory
			GROUP BY ProductID;
GO

CREATE UNIQUE CLUSTERED INDEX ix_TransactionHistorySummary
	ON dbo.vw_TransactionHistorySummary(ProductID);
GO

ALTER DATABASE AdventureWorks
	SET QUERY_STORE CLEAR;

SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;
SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;


UPDATE STATISTICS dbo.vw_TransactionHistorySummary
	WITH ROWCOUNT = 60000000, PAGECOUNT = 10000000;
--Exercise 2





SELECT SalesOrderID, ISNULL(SalesOrderDetailID * 2, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
	INTO Sales.SalesOrderDetailHeap
	FROM Sales.SalesOrderDetail;
GO



SELECT SalesOrderID, ISNULL(SalesOrderDetailID * 2, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
	INTO Sales.SalesOrderDetailClustered
	FROM Sales.SalesOrderDetail;
GO

ALTER TABLE Sales.SalesOrderDetailClustered
	ADD CONSTRAINT PK_SalesOrderDetailClustered PRIMARY KEY CLUSTERED (SalesOrderID, SalesOrderDetailID);
GO


SET STATISTICS XML ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;


SELECT *
	FROM Sales.SalesOrderDetailHeap;

SELECT *
	FROM Sales.SalesOrderDetailClustered;


SELECT *
	FROM Sales.SalesOrderDetailHeap
	ORDER BY SalesOrderID, SalesOrderDetailID
	OPTION (MAXDOP 1);


SELECT *
	FROM Sales.SalesOrderDetailClustered
	ORDER BY SalesOrderID, SalesOrderDetailID;


SELECT *
	FROM Sales.SalesOrderDetailHeap
	WHERE SalesOrderID BETWEEN 50000 AND 53000;

SELECT *
	FROM Sales.SalesOrderDetailClustered
	WHERE SalesOrderID BETWEEN 50000 AND 53000;

SELECT *
	FROM Sales.SalesOrderDetailHeap
	WHERE SalesOrderID BETWEEN 50000 AND 53000
	ORDER BY SalesOrderID, SalesOrderDetailID;

SELECT *
	FROM Sales.SalesOrderDetailClustered
	WHERE SalesOrderID BETWEEN 50000 AND 53000
	ORDER BY SalesOrderID, SalesOrderDetailID;


INSERT INTO Sales.SalesOrderDetailHeap (SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate)
	SELECT SalesOrderID, ISNULL((SalesOrderDetailID * 2) + 1, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
		FROM Sales.SalesOrderDetail;

INSERT INTO Sales.SalesOrderDetailClustered (SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate)
	SELECT SalesOrderID, ISNULL((SalesOrderDetailID * 2) + 1, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
		FROM Sales.SalesOrderDetail
	OPTION (MAXDOP 1);

SET STATISTICS XML OFF;
SET STATISTICS IO OFF;
SET STATISTICS TIME ON;




