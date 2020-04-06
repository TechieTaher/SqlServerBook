CREATE TABLE Sales.MediaOutlets (
MediaOutletID INT NOT NULL,
MediaOutletName NVARCHAR(40),
PrimaryContact NVARCHAR (50),
City NVARCHAR (50)
);
CREATE TABLE Sales.PrintMediaPlacement ( 
PrintMediaPlacementID INT NOT NULL,
MediaOutletID INT,
PlacementDate DATETIME,
PublicationDate DATETIME,
RelatedProductID INT,
PlacementCost DECIMAL(18,2)
);

ALTER TABLE Sales.MediaOutlets ADD CONSTRAINT IX_MediaOutlet UNIQUE CLUSTERED (
MediaOutletID
);

ALTER TABLE Sales.PrintMediaPlacements ADD CONSTRAINT IX_PrintMediaPlacements UNIQUE CLUSTERED (
PrintMediaPlacementID ASC
);

CREATE NONCLUSTERED INDEX NCI_PrintMediaPlacement
ON [Sales].[PrintMediaPlacements] ([PublicationDate],[PlacementCost])
INCLUDE ([PrintMediaPlacementID],[MediaOutletID],[PlacementDate],[RelatedProductID])
