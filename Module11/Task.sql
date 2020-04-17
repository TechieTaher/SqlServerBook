--view Query 
/*SELECT        dbo.Address.City, dbo.Customers.PhoneNo, dbo.Customers.CustomerId
FROM            dbo.Address INNER JOIN
                         dbo.Customers ON dbo.Address.CustomerId = dbo.Customers.CustomerId*/


CREATE TRIGGER TvCustomerUpdate
   ON  dbo.vCustomerAddress
  INSTEAD OF UPDATE
AS 
BEGIN

	SET NOCOUNT ON;
	declare @CustomerId int = (SELECT CustomerId FROM inserted)
	UPDATE vCustomerAddress SET PhoneNo = (SELECT PhoneNo FROM inserted) where CustomerId = @CustomerId
	UPDATE vCustomerAddress SET City = (SELECT City FROM inserted) where CustomerId = @CustomerId
END
GO

update vCustomerAddress SET PhoneNo = 1234567891,City = 'Jamnagar'