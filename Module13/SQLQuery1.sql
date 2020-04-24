sp_configure;
GO
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'clr enabled', 1;

GO
sp_configure 'clr strict security', 0;
RECONFIGURE;
GO 


USE master
GO

IF EXISTS ( SELECT * FROM sys.server_principals WHERE name = N'sign_assemblies' )
	DROP LOGIN sign_assemblies

IF EXISTS ( SELECT * FROM sys.asymmetric_keys WHERE name = N'assembly_key')
	DROP ASYMMETRIC KEY testregex

CREATE ASYMMETRIC KEY testregex FROM FILE = 'F:\download\20762A\Labfiles\Lab13\Starter\strong_name.snk' ENCRYPTION BY PASSWORD = 'admin123';

CREATE LOGIN sign_assemblies FROM ASYMMETRIC KEY testregex;

GRANT UNSAFE ASSEMBLY TO sign_assemblies;

create assembly toyfactoryDB
AUTHORIZATION [dbo]
FROM 'C:\Users\Taher\source\repos\testregex\testregex\obj\Debug\testregex.dll'
WITH PERMISSION_SET = SAFE
GO

SELECT * FROM dbo.RegexMatches(N'admin abc', N' ');

