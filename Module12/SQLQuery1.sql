--Exercise 1

alter database InternetSales
add filegroup InternetSalesFG contains
MEMORY_OPTIMIZED_DATA
Go

ALTER DATABASE InternetSales   
ADD FILE   
(  
    NAME = SalesData,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\SalesData.ndf' 

)  
TO FILEGROUP InternetSalesFG;  


CREATE TABLE dbo.ShoppingCart
(SessionID INT NOT NULL,
TimeAdded DATETIME NOT NULL,
CustomerKey INT NOT NULL,
ProductKey INT NOT NULL,
Quantity INT NOT NULL
PRIMARY KEY NONCLUSTERED (SessionID, ProductKey)) 
WITH  (MEMORY_OPTIMIZED = ON,  DURABILITY = SCHEMA_AND_DATA);


INSERT INTO ShoppingCart(SessionID,TimeAdded,CustomerKey,ProductKey,Quantity)VALUES (1,GETDATE(),2,3,1);
INSERT INTO ShoppingCart(SessionID,TimeAdded,CustomerKey,ProductKey,Quantity)VALUES (2,GETDATE(),2,4,3);


--Exercise 2

CREATE PROCEDURE dbo.AddItemToCart
	@sessionID INT, 
@timeAdded DATETIME, 
@customerKey INT, 
@productKey INT, 
@quantity INT
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
	INSERT INTO dbo.ShoppingCart 
	(
	SessionID, 
	TimeAdded, 
	CustomerKey, 
	ProductKey, 
	Quantity
	)
	VALUES 
	(
	@sessionID, 
	@timeAdded, 
	@customerKey, 
	@productKey, 
	@quantity
	)
END


CREATE PROCEDURE dbo.DeleteItemFromCart
	@sessionID INT, 
	@productKey INT
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
	DELETE FROM dbo.ShoppingCart   
	WHERE SessionID = @sessionID  
	AND ProductKey = @productKey
END


CREATE PROCEDURE dbo.EmptyCart
	@sessionID INT
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
	DELETE FROM dbo.ShoppingCart   WHERE SessionID = @sessionID
END




DECLARE @now DATETIME = GETDATE();


EXEC dbo.AddItemToCart
	@sessionID = 1,
	@timeAdded = @now,
	@customerKey = 2,
	@productKey = 3,
	@quantity = 1;

EXEC dbo.AddItemToCart  
	@sessionID = 1,
	@timeAdded = @now,
	@customerKey = 2,
	@productKey = 4,
	@quantity = 1;


EXEC dbo.AddItemToCart
	@sessionID = 3,
	@timeAdded = @now,
	@customerKey = 2,
	@productKey = 3,
	@quantity = 1;

EXEC dbo.AddItemToCart  
	@sessionID = 3,
	@timeAdded = @now,
	@customerKey = 2,
	@productKey = 4,
	@quantity = 1;



EXEC dbo.DeleteItemFromCart 
	@sessionID = 3, 
	@productKey = 4;


EXEC dbo.EmptyCart 
	@sessionID = 3;
	
