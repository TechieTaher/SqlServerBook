Alter database HumanResources ADD FILEGROUP FG0
Alter database HumanResources ADD FILEGROUP FG1
Alter database HumanResources ADD FILEGROUP FG2
Alter database HumanResources ADD FILEGROUP FG3
Alter database HumanResources ADD FILE (NAME = FG0, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\FG0.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG0;
Alter database HumanResources ADD FILE (NAME = FG1, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\FG1.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG1;
Alter database HumanResources ADD FILE (NAME = FG2, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\FG2.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2;
Alter database HumanResources ADD FILE (NAME = FG3, FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\FG3.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG3;
create  partition function pfHumanResourcesDatess(smalldatetime)
as range left
for values('2018-01-01 00:00','2019-01-01 00:00','2020-01-01 00:00')


create partition scheme psHumanResourcess as partition pfHumanResourcesDatess
to(FG0,FG1,FG2,FG3);

CREATE TABLE TimeSheet (TimeSheetId int Identity(1,1), TimeSheetDate smalldatetime)  
    ON psHumanResourcess (TimeSheetDate) ;  
select * from TimeSheet;

SELECT $PARTITION.pfHumanResourcesDatess('2018-01-01 00:00') FROM TimeSheet 

DECLARE @par int = $PARTITION.pfHumanResourcesDatess('2018-02-06 00:00');
print(@par);
 

 CREATE TABLE TimeSheetStaging(
 RegisteredStartTime smalldatetime
 
) ON FG0

ALTER TABLE TimeSheetStaging
ADD CONSTRAINT CHK_date CHECK (RegisteredStartTime<'2019-01-01 00:00' and RegisteredStartTime>='2018-01-01 00:00');
alter table TimeSheetStaging drop constraint CHK_datetime;




DECLARE @p int = $PARTITION.pfHumanResourcesDatess('2019-10-10 00:00');
print @p;
ALTER TABLE TimeSheet
SWITCH PARTITION @p TO TimeSheetStaging;

select pstats.partition_number as PartitionNumber,
pstats.row_count as PartitionRowCount
from sys.dm_db_partition_stats as pstats where
pstats.object_id=OBJECT_ID('TimeSheet')
Order by PartitionNumber;
