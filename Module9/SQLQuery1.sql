CREATE PROCEDURE Reports.GetProductColors
AS
SET NOCOUNT ON;
BEGIN
	SELECT DISTINCT p.Color
	FROM Marketing.Product AS p
	WHERE p.Color IS NOT NULL
	ORDER BY p.Color;
END
GO

EXEC Reports.GetProductColors;

CREATE PROCEDURE Reports.GetProductsAndModels
AS
SET NOCOUNT ON;
BEGIN
	SELECT p.ProductID,
		   p.ProductName,
		   p.ProductNumber,
		   p.SellStartDate,
		   p.SellEndDate,
		   p.Color,
		   pm.ProductModelID,
		   COALESCE(ed.Description,id.Description,p.ProductName) AS EnglishDescription,
		   COALESCE(fd.Description,id.Description,p.ProductName) AS FrenchDescription,
		   COALESCE(cd.Description,id.Description,p.ProductName) AS ChineseDescription
	FROM Marketing.Product AS p
	LEFT OUTER JOIN Marketing.ProductModel AS pm
	ON p.ProductModelID = pm.ProductModelID
	LEFT OUTER JOIN Marketing.ProductDescription AS ed
	ON pm.ProductModelID = ed.ProductModelID 
	AND ed.LanguageID = 'en'
	LEFT OUTER JOIN Marketing.ProductDescription AS fd
	ON pm.ProductModelID = fd.ProductModelID 
	AND fd.LanguageID = 'fr'
	LEFT OUTER JOIN Marketing.ProductDescription AS cd
	ON pm.ProductModelID = cd.ProductModelID 
	AND cd.LanguageID = 'zh-cht'
	LEFT OUTER JOIN Marketing.ProductDescription AS id
	ON pm.ProductModelID = id.ProductModelID 
	AND id.LanguageID = ''
	ORDER BY p.ProductID,pm.ProductModelID;
END
GO

EXEC Reports.GetProductsAndModels;

CREATE PROCEDURE Marketing.GetProductsByColor
@Color nvarchar(16)
AS
SET NOCOUNT ON;
BEGIN
	SELECT p.ProductID,
	p.ProductName,
	p.ListPrice AS Price,
	p.Color,
	p.Size,
	p.SizeUnitMeasureCode AS UnitOfMeasure
	FROM Marketing.Product AS p
	WHERE p.Color = @Color
	ORDER BY ProductName;
END
GO

EXEC Marketing.GetProductsByColor 'Blue';

--Add WITH EXECUTE AS OWNER in every sp