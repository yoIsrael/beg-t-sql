-- Listing 14-1. Adding a Check Constraint    
USE tempdb;    
GO    
--1    
IF OBJECT_ID('table1') IS NOT NULL BEGIN        
	DROP TABLE table1;    
END;       
--2    
CREATE TABLE table1 (col1 SMALLINT, col2 VARCHAR(20),        
	CONSTRAINT ch_table1_col2_months        
	CHECK (col2 IN ('January','February','March','April','May',            
		'June','July','August','September','October',            
		'November','December')        
	)     
);           
--3    
ALTER TABLE table1 ADD CONSTRAINT ch_table1_col1        
CHECK (col1 BETWEEN 1 and 12);       
PRINT 'January';       
--4    
INSERT INTO table1 (col1,col2)    
VALUES (1,'Jan'); 
--5    
PRINT 'February';
INSERT INTO table1 (col1,col2)    
VALUES (2,'February');       
PRINT 'March';       
--6    
INSERT INTO table1 (col1,col2)    
VALUES (13,'March');       
PRINT 'Change 2 to 20';    
--7    
UPDATE table1 SET col1 = 20;  

-- Listing 14-2. Creating Tables with UNIQUE Constraints    
USE tempdb;    
GO    
--1    
IF OBJECT_ID('table1') IS NOT NULL BEGIN        
	DROP TABLE table1;    
END;       
--2    
CREATE TABLE table1 (col1 INT NULL UNIQUE,        
	col2 VARCHAR(20) NULL, col3 DATE NULL);    
GO              
--3    
ALTER TABLE table1 ADD CONSTRAINT        
	unq_table1_col2_col3 UNIQUE (col2,col3);             
--4    
PRINT 'Statement 4'    
INSERT INTO table1(col1,col2,col3)    
VALUES (1,2,'2009/01/01'),(2,2,'2009/01/02');  
--5    
PRINT 'Statement 5'    
INSERT INTO table1(col1,col2,col3)    
VALUES (3,2,'2009/01/01');       
--6    
PRINT 'Statement 6'    
INSERT INTO table1(col1,col2,col3)    
VALUES (1,2,'2009/01/01');       
--7    
PRINT 'Statement 7'    
UPDATE table1 SET col3 = '2009/01/01'    
WHERE col1 = 1;  

-- Listing 14-3. Creating Primary Keys       
USE tempdb;    
GO       
--1    
IF OBJECT_ID('table1') IS NOT NULL BEGIN        
	DROP TABLE table1;    
END;       
IF OBJECT_ID('table2') IS NOT NULL BEGIN        
	DROP TABLE table2;    
END;
IF OBJECT_ID('table3') IS NOT NULL BEGIN        
	DROP TABLE table3;    
END;       
--2    
CREATE TABLE table1 (col1 INT NOT NULL,        
	col2 VARCHAR(10)        
	CONSTRAINT PK_table1_Col1 PRIMARY KEY (col1));       
--3    
CREATE TABLE table2 (col1 INT NOT NULL,        
	col2 VARCHAR(10) NOT NULL, col3 INT NULL,        
	CONSTRAINT PK_table2_col1col2 PRIMARY KEY        
	(col1, col2)    );      
--4    
CREATE TABLE table3 (col1 INT NOT NULL,        
	col2 VARCHAR(10) NOT NULL, col3 INT NULL);       
--5    
ALTER TABLE table3 ADD CONSTRAINT PK_table3_col1col2        
PRIMARY KEY NONCLUSTERED (col1,col2);  

-- Listing 14-4. Adding a Foreign Key
--1
IF OBJECT_ID('table1') IS NOT NULL BEGIN        
	DROP TABLE table1;    
END;   
IF OBJECT_ID('table2') IS NOT NULL BEGIN        
	DROP TABLE table2;    
END;     
--2    
CREATE TABLE table1 (col1 INT NOT NULL,        
	col2 VARCHAR(20), col3 DATETIME        
	CONSTRAINT PK_table1_Col1 PRIMARY KEY(col1));       
--3    
CREATE TABLE table2 (col4 INT NULL,        
col5 VARCHAR(20) NOT NULL,        
CONSTRAINT pk_table2 PRIMARY KEY (col5),        
CONSTRAINT fk_table2_table1 FOREIGN KEY (col4) REFERENCES table1(col1)        
);    
GO              
--4    
PRINT 'Adding to table1';    
INSERT INTO table1(col1,col2,col3)    
VALUES(1,'a','2014/01/01'),(2,'b','2014/01/01'),(3,'c','1/3/2014');       
--5    
PRINT 'Adding to table2';          
INSERT INTO table2(col4,col5)    
VALUES(1,'abc'),(2,'def');     
--6    
PRINT 'Violating foreign key with insert';    
INSERT INTO table2(col4,col5)    
VALUES (7,'aaa');       
--7    
PRINT 'Violating foreign key with update';    
UPDATE table2 SET col4 = 6    
WHERE col4 = 1;  

 
--Listing 14-5. Using Update and Delete Rules 
USE tempdb;    
GO    
SET NOCOUNT ON;    
GO    
--1    
IF OBJECT_ID('Child') IS NOT NULL BEGIN        
	DROP TABLE Child;    
END;       
IF OBJECT_ID('Parent') IS NOT NULL BEGIN        
	DROP TABLE Parent;    
END;       
--2   
CREATE TABLE Parent (col1 INT NOT NULL PRIMARY KEY,        
	col2 VARCHAR(20), col3 DATE);       
--3 default rules    
PRINT 'No action by default';    
CREATE TABLE Child (col4 INT NULL DEFAULT 7,        
	col5 VARCHAR(20) NOT NULL,        
	CONSTRAINT pk_Child PRIMARY KEY (col5),        
	CONSTRAINT fk_Child_Parent FOREIGN KEY (col4) REFERENCES Parent(col1)       
	);   

--4    
PRINT 'Adding to Parent';    
INSERT INTO Parent(col1,col2,col3)    
VALUES(1,'a','2014/01/01'),(2,'b','2014/02/01'),(3,'c','2014/01/03'),        
	(4,'d','2014/01/04'),(5,'e','2014/01/06'),(6,'g','2014/01/07'),        
	(7,'g','2014/01/08');       
--5    
PRINT 'Adding to Child';    
INSERT INTO Child(col4,col5)    
VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl');       
--6    
SELECT col4, col5 FROM Child;       
--7    
PRINT 'Delete from Parent'    

DELETE FROM Parent WHERE col1 = 1;       
--8    
ALTER TABLE Child DROP CONSTRAINT fk_Child_Parent;       
--9    
PRINT 'Add CASCADE';    
ALTER TABLE Child ADD CONSTRAINT fk_Child_Parent        
FOREIGN KEY (col4) REFERENCES Parent(col1)        
ON DELETE CASCADE        
ON UPDATE CASCADE;              
--10    
PRINT 
'Delete from Parent';    
DELETE FROM Parent WHERE col1 = 1;       
--11    
PRINT 'Update Parent';    
UPDATE Parent SET col1 = 10 WHERE col1 = 4;       
--12    
ALTER TABLE Child DROP CONSTRAINT fk_Child_Parent;       
--13    
PRINT 'Add SET NULL';    
ALTER TABLE Child ADD CONSTRAINT fk_Child_Parent        
FOREIGN KEY (col4) REFERENCES Parent(col1)        
ON DELETE SET NULL        
ON UPDATE SET NULL;       
--14    
DELETE FROM Parent WHERE col1 = 2; 
--15    
ALTER TABLE Child DROP CONSTRAINT fk_Child_Parent;       
--16    
PRINT 'Add SET DEFAULT';    
ALTER TABLE Child ADD CONSTRAINT fk_Child_Parent        
FOREIGN KEY (col4) REFERENCES Parent(col1)        
ON DELETE SET DEFAULT        
ON UPDATE SET DEFAULT;              
--17    
PRINT 'Delete from Parent';    
DELETE FROM Parent WHERE col1 = 3;       
--18    
SELECT col4, col5 FROM Child;  


-- Listing 14-6. Defining Tables with Automatically Populating Columns    
USE tempdb;    
GO    
--1    
IF OBJECT_ID('MySequence') IS NOT NULL BEGIN  
	DROP SEQUENCE MySequence;    
END;       
CREATE SEQUENCE MySequence START WITH 1;       
--2    
IF OBJECT_ID('table3') IS NOT NULL BEGIN        
	DROP TABLE table3;    
END;       
--2    
CREATE TABLE table3 (col1 CHAR(1),        
	idCol INT NOT NULL IDENTITY,        
	rvCol ROWVERSION,        
	defCol DATETIME2 DEFAULT GETDATE(),        
	SeqCol INT DEFAULT NEXT VALUE FOR dbo.MySequence,        
	calcCol1 AS DATEADD(m,1,defCol),        
	calcCol2 AS col1 + ':' + col1        
	);    
GO       
--3    
INSERT INTO table3 (col1)    
VALUES ('a'), ('b'), ('c'), ('d'), ('e'), ('g');       
--4    
INSERT INTO table3 (col1, defCol)    
VALUES ('h', NULL),('i','2014/01/01');       
--5    
SELECT col1, idCol, rvCol, defCol, calcCol1, calcCol2, SeqCol    
FROM table3;   


-- Listing 14-7. Creating and Using a View 
--1    
USE AdventureWorks;    
GO    
IF OBJECT_ID('dbo.vw_Customer') IS NOT NULL BEGIN        
	DROP VIEW dbo.vw_Customer;    
END;    
GO       
--2    
CREATE VIEW dbo.vw_Customer AS        
SELECT c.CustomerID, c.AccountNumber, c.StoreID,            
	c.TerritoryID, p.FirstName, p.MiddleName,            
	p.LastName        
FROM Sales.Customer AS c        
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID;    
GO       
--3    
SELECT CustomerID,AccountNumber,FirstName,        
	MiddleName, LastName    
	FROM dbo.vw_Customer;       
GO       
--4    
ALTER VIEW dbo.vw_Customer AS           
SELECT c.CustomerID,c.AccountNumber,c.StoreID,            
	c.TerritoryID, p.FirstName,p.MiddleName,            
	p.LastName, p.Title        
FROM Sales.Customer AS c        
INNER JOIN Person.Person AS p ON c.PersonID = p.BusinessEntityID;
GO
--5    
SELECT CustomerID,AccountNumber,FirstName,        
	MiddleName, LastName, Title    
FROM dbo.vw_Customer    
ORDER BY CustomerID;  


-- Listing 14-8. Common Problems Using Views 
--1   
IF OBJECT_ID('vw_Dept') IS NOT NULL BEGIN        
	DROP VIEW dbo.vw_Dept;    
END;    
IF OBJECT_ID('demoDept') IS NOT NULL BEGIN        
	DROP TABLE dbo.demoDept;    
END;       
--2    
SELECT DepartmentID,Name,GroupName,ModifiedDate    
INTO dbo.demoDept    
FROM HumanResources.Department; 
GO       
--3    
CREATE VIEW dbo.vw_Dept AS        
SELECT *        
FROM dbo.demoDept;    
GO       
--4    
SELECT DepartmentID, Name, GroupName, ModifiedDate    
FROM dbo.vw_Dept;       
--5    
DROP TABLE dbo.demoDept;    
GO       
--6    
SELECT DepartmentID, GroupName, Name, ModifiedDate    
INTO dbo.demoDept    
FROM HumanResources.Department;    
GO       
--7    
SELECT DepartmentID, Name, GroupName, ModifiedDate    
FROM dbo.vw_Dept;    
GO       
--8    
DROP VIEW dbo.vw_Dept;    
GO       
--9    
CREATE VIEW dbo.vw_Dept AS        
SELECT TOP(100) PERCENT DepartmentID,            
Name, GroupName, ModifiedDate        
FROM dbo.demoDept        
ORDER BY Name;    
GO       
--10    
SELECT DepartmentID, Name, GroupName, ModifiedDate    
FROM dbo.vw_Dept;  


--Listing 14-9. Modifying Data Through Views    
--1    
IF OBJECT_ID('dbo.demoCustomer') IS NOT NULL BEGIN        
	DROP TABLE dbo.demoCustomer;    
END;    
IF OBJECT_ID('dbo.demoPerson') IS NOT NULL BEGIN        
	DROP TABLE dbo.demoPerson;    
END;    
IF OBJECT_ID('dbo.vw_Customer') IS NOT NULL BEGIN        
	DROP VIEW dbo.vw_Customer;    
END;       
--2   
SELECT CustomerID, TerritoryID, StoreID, PersonID    
INTO dbo.demoCustomer    
FROM Sales.Customer;       
SELECT BusinessEntityID, Title, FirstName, MiddleName, LastName    
INTO dbo.demoPerson    
From Person.Person;    
GO       
--3    
CREATE VIEW vw_Customer AS        
SELECT CustomerID, TerritoryID, PersonID, StoreID,            
	Title, FirstName, MiddleName, LastName        
FROM dbo.demoCustomer       
INNER JOIN dbo.demoPerson ON PersonID = BusinessEntityID;    
GO       
--4    
SELECT CustomerID, FirstName, MiddleName, LastName    
FROM dbo.vw_Customer    
WHERE CustomerID IN (29484,29486,29489,100000);       
--5    
PRINT 'Update one row';    
UPDATE dbo.vw_Customer SET FirstName = 'Kathi'    
WHERE CustomerID = 29486;       
--6    
GO    
PRINT 'Attempt to update both sides of the join'    
GO    
UPDATE dbo.vw_Customer SET FirstName = 'Franie',TerritoryID = 5   
WHERE CustomerID = 29489
--7    
GO    
PRINT 'Attempt to delete a row';    
GO    
DELETE FROM dbo.vw_Customer    
WHERE CustomerID = 29484;       
--8    
GO       
PRINT 'Insert into dbo.demoCustomer';    
INSERT INTO dbo.vw_Customer(TerritoryID,        
	StoreID, PersonID)    
VALUES (5,5,100000);       
--9    
GO    
PRINT 'Attempt to insert a row into demoPerson';    
GO    
INSERT INTO dbo.vw_Customer(Title, FirstName, LastName)   
VALUES ('Mrs.','Lady','Samoyed');       
--10    
SELECT CustomerID, FirstName, MiddleName, LastName    
FROM dbo.vw_Customer    
WHERE CustomerID IN (29484,29486,29489,100000);       
--11    
SELECT CustomerID, TerritoryID, StoreID, PersonID    
FROM dbo.demoCustomer    
WHERE PersonID = 100000; 


-- Listing 14-10. Creating and Using User-Defined Scalar Functions 
--1   
IF OBJECT_ID('dbo.udf_Product') IS NOT NULL BEGIN        
	DROP FUNCTION dbo.udf_Product;    
END;    
IF OBJECT_ID('dbo.udf_Delim') IS NOT NULL BEGIN        
	DROP FUNCTION dbo.udf_Delim;    
END;   
GO       
--2    
CREATE FUNCTION dbo.udf_Product(@num1 INT, @num2 INT) RETURNS INT AS    
BEGIN           
	DECLARE @Product INT;        
	SET @Product = ISNULL(@num1,0) * ISNULL(@num2,0);        
	RETURN @Product;       
END;    
GO       
--3    
CREATE FUNCTION dbo.udf_Delim(@String VARCHAR(100),@Delimiter CHAR(1))        
	RETURNS VARCHAR(200) AS    
BEGIN       
	DECLARE @NewString VARCHAR(200) = '';        
	DECLARE @Count INT = 1;           
	WHILE @Count <= LEN(@String) BEGIN            
		SET @NewString += SUBSTRING(@String,@Count,1) + @Delimiter;            
		SET @Count += 1;        
	END           
	RETURN @NewString;    
END    
GO       
--4    
SELECT StoreID, TerritoryID,        
	dbo.udf_Product(StoreID, TerritoryID) AS TheProduct,        
	dbo.udf_Delim(FirstName,',') AS FirstNameWithCommas    
FROM Sales.Customer AS c    
INNER JOIN Person.Person AS p ON c.PersonID= p.BusinessEntityID;   

--Listing 14-11. Using a Table-Valued UDF 
--1    
SELECT PersonID,FirstName,LastName,JobTitle,BusinessEntityType    
FROM dbo.ufnGetContactInformation(1);       
--2    
SELECT PersonID,FirstName,LastName,JobTitle,BusinessEntityType    
FROM dbo.ufnGetContactInformation(7822);       
--3    
SELECT e.BirthDate, e.Gender, c.FirstName,c.LastName,c.JobTitle    
FROM HumanResources.Employee as e    
CROSS APPLY dbo.ufnGetContactInformation(e.BusinessEntityID ) AS c;       
--4       
SELECT sc.CustomerID,sc.TerritoryID,c.FirstName,c.LastName    
FROM Sales.Customer AS sc    
CROSS APPLY dbo.ufnGetContactInformation(sc.PersonID) AS c; 


-- Listing 14-12. Creating and Using a Stored Procedure    
--1   
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN        
	DROP PROC dbo.usp_CustomerName;    
END;    
GO       
--2    
CREATE PROC dbo.usp_CustomerName AS        
	SET NOCOUNT ON; 
	SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName       
	FROM Sales.Customer AS c        
	INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID        
	ORDER BY p.LastName, p.FirstName,p.MiddleName ;               
	RETURN 0;    
GO       
--3    
EXEC dbo.usp_CustomerName    
GO       
--4    
ALTER PROC dbo.usp_CustomerName @CustomerID INT AS        
	SET NOCOUNT ON;           
	IF @CustomerID > 0 BEGIN               
		SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName            
		FROM Sales.Customer AS c            
		INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID            
		WHERE c.CustomerID = @CustomerID;               
		RETURN 0;        
	END        
	ELSE BEGIN           
		RETURN -1;        
	END;                  
GO      
--5    
EXEC dbo.usp_CustomerName @CustomerID = 15128;     

       

-- Listing 14-13. Using Default Value Parameters    
--1    
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN        
	DROP PROC dbo.usp_CustomerName;    
END;    
GO       
--2    
CREATE PROC dbo.usp_CustomerName @CustomerID INT = -1 AS        
	SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName        
	FROM Sales.Customer AS c        
	INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID        
	WHERE @CustomerID = CASE @CustomerID WHEN -1 THEN -1 ELSE c.CustomerID END;               
	RETURN 0;    
GO  
--3    
EXEC dbo.usp_CustomerName 15128;       
--4    
EXEC dbo.usp_CustomerName ;   


-- Listing 14-14. Using an OUTPUT Parameter    
--1    
IF OBJECT_ID('dbo.usp_OrderDetailCount') IS NOT NULL BEGIN        
	DROP PROC dbo.usp_OrderDetailCount;    
END;    
GO       
--2    
CREATE PROC dbo.usp_OrderDetailCount @OrderID INT,        
	@Count INT OUTPUT AS           
	SELECT @Count = COUNT(*)       
	FROM Sales.SalesOrderDetail        
	WHERE SalesOrderID = @OrderID;           
	RETURN 0;    
GO       
--3    
DECLARE @OrderCount INT;       
--4    
EXEC usp_OrderDetailCount 71774, @OrderCount OUTPUT;       
--5    
PRINT @OrderCount; 

   
-- Listing 14-15. Inserting the Rows from a Stored Procedure into a Table    
--1   
IF OBJECT_ID('dbo.tempCustomer') IS NOT NULL BEGIN        
	DROP TABLE dbo.tempCustomer;    
END;    
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN        
	DROP PROC dbo.usp_CustomerName;    
END;   
GO       
--2    
CREATE TABLE dbo.tempCustomer(CustomerID INT, FirstName NVARCHAR(50),        
	MiddleName NVARCHAR(50), LastName NVARCHAR(50));    
GO       
--3    
CREATE PROC dbo.usp_CustomerName @CustomerID INT = -1 AS        
	SELECT c.CustomerID,p.FirstName,p.MiddleName,p.LastName        
	FROM Sales.Customer AS c        
	INNER JOIN Person.Person AS p on c.PersonID = p.BusinessEntityID        
	WHERE @CustomerID = CASE @CustomerID WHEN -1 THEN -1 ELSE c.CustomerID END;               
	RETURN 0;    
GO       
--4    
INSERT INTO dbo.tempCustomer EXEC dbo.usp_CustomerName;       
--5    
SELECT CustomerID, FirstName, MiddleName, LastName    
FROM dbo.tempCustomer;  


-- Listing 14-16. Using Logic in a Stored Procedure    
USE tempdb;    
GO       
--1    
IF OBJECT_ID('usp_ProgrammingLogic') IS NOT NULL BEGIN        
	DROP PROC usp_ProgrammingLogic;    
END;    
GO       
--2    
CREATE PROC usp_ProgrammingLogic AS        
	--2.1        
	CREATE TABLE #Numbers(number INT NOT NULL);        
	--2.2        
	DECLARE @count INT;        
	SET @count = ASCII('!');               
	--2.3        
	WHILE @count < 200 BEGIN            
		INSERT INTO #Numbers(number) VALUES (@count);            
		SET @count = @count + 1;        
	END; 
	--2.4       
	ALTER TABLE #Numbers ADD symbol NCHAR(1);        
	--2.5        
	UPDATE #Numbers SET symbol = CHAR(number);               
	--2.6        
	SELECT number, symbol FROM #Numbers;   
	GO       
--3       
EXEC usp_ProgrammingLogic;    


-- Listing 14-17. Creating a User-Defined Data Type 
IF  EXISTS     
	(SELECT * FROM sys.types st        
	JOIN sys.schemas ss ON st.schema_id = ss.schema_id        
	WHERE st.name = N'CustomerID' AND ss.name = N'dbo') BEGIN               
	DROP TYPE dbo.CustomerID;    
END;    
GO       
CREATE TYPE dbo.CustomerID FROM INT NOT NULL;

-- Listing 14-18. Create a Table Type    
--Clean up objects for this section if they exist   
IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'usp_TestTableVariable') BEGIN           
	DROP PROCEDURE usp_TestTableVariable;    
END;   
IF EXISTS(SELECT * FROM sys.types WHERE name = 'CustomerInfo') BEGIN            
	DROP TYPE dbo.CustomerInfo;    
END;      
CREATE TYPE dbo.CustomerInfo AS TABLE    (        
	CustomerID INT NOT NULL PRIMARY KEY,            
	FavoriteColor VARCHAR(20) NULL,            
	FavoriteSeason VARCHAR(10) NULL    
);     
   
-- Listing 14-19. Create and Populate Table Variable Based on the Type 
DECLARE @myTableVariable [dbo].[CustomerInfo];      
INSERT INTO @myTableVariable(CustomerID, FavoriteColor, FavoriteSeason)    
VALUES(11001, 'Blue','Summer'),(11002,'Orange','Fall');       
SELECT CustomerID, FavoriteColor, FavoriteSeason    
FROM @myTableVariable;  



-- Listing 14-20. Create a Stored Procedure and Use a Table Variable
--1 
GO   
CREATE PROC dbo.usp_TestTableVariable @myTable CustomerInfo READONLY AS        
	SELECT c.CustomerID, AccountNumber, FavoriteColor, FavoriteSeason        
	FROM AdventureWorks.Sales.Customer AS C INNER JOIN @myTable MT            
	ON C.CustomerID = MT.CustomerID;       
GO    
--2    
DECLARE @myTableVariable [dbo].[CustomerInfo]    
INSERT INTO @myTableVariable(CustomerID, FavoriteColor, FavoriteSeason)    
VALUES(11001, 'Blue','Summer'),(11002,'Orange','Fall');       
--3    
EXEC usp_TestTableVariable @myTableVariable;  

-- Listing 14-21. Performance Issues with UDFs    
--RUN THIS FIRST
USE AdventureWorks;
GO       
IF OBJECT_ID('dbo.udf_ProductTotal') IS NOT NULL BEGIN        
	DROP FUNCTION dbo.udf_ProductTotal;    
END;    
GO       
CREATE FUNCTION dbo.udf_ProductTotal(@ProductID INT,@Year INT) RETURNS MONEY AS    
BEGIN           
	DECLARE @Sum MONEY;               
	SELECT @Sum = SUM(LineTotal)        
	FROM Sales.SalesOrderDetail AS sod        
	INNER JOIN Sales.SalesOrderHeader AS soh                
	ON sod.SalesOrderID = soh.SalesOrderID        
	WHERE ProductID = @ProductID AND YEAR(OrderDate) = @Year;           
	RETURN ISNULL(@Sum,0);       
END;    
GO    
--TO HERE   

--3 Run this by itself to see how long it takes    
SELECT ProductID, dbo.udf_ProductTotal(ProductID, 2004) AS SumOfSales
FROM Production.Product    
ORDER BY SumOfSales DESC;       

--4 Run this by itself to see how long it takes    
WITH Sales AS (        
	SELECT SUM(LineTotal) AS SumOfSales, ProductID,           
	YEAR(OrderDate) AS OrderYear        
	FROM Sales.SalesOrderDetail AS sod        
	INNER JOIN Sales.SalesOrderHeader AS soh            
	ON sod.SalesOrderID = soh.SalesOrderID       
	GROUP BY ProductID, YEAR(OrderDate)    
	)    
SELECT p.ProductID, ISNULL(SumOfSales,0) AS SumOfSales    
FROM Production.Product AS p    
LEFT OUTER JOIN Sales ON p.ProductID = Sales.ProductID        
AND OrderYear = 2004    
ORDER BY SumOfSales DESC;   


-- isting 14-22. Database Cleanup 
IF OBJECT_ID('vw_Customer') IS NOT NULL BEGIN        
	DROP VIEW vw_Customer;    
END;       
IF OBJECT_ID('vw_Dept') IS NOT NULL BEGIN        
	DROP VIEW dbo.vw_Dept;    
END;       
IF OBJECT_ID('demoDept') IS NOT NULL BEGIN        
	DROP TABLE dbo.demoDept;    
END;  
IF OBJECT_ID('dbo.demoCustomer') IS NOT NULL BEGIN        
DROP TABLE dbo.demoCustomer;    
END;  
IF OBJECT_ID('dbo.demoPerson') IS NOT NULL BEGIN        
DROP TABLE dbo.demoPerson;    
END;   
IF OBJECT_ID('dbo.udf_Product') IS NOT NULL BEGIN        
DROP FUNCTION dbo.udf_Product;    
END;       
IF OBJECT_ID('dbo.udf_Delim') IS NOT NULL BEGIN        
DROP FUNCTION dbo.udf_Delim;    
END;       
IF OBJECT_ID('dbo.usp_CustomerName') IS NOT NULL BEGIN        
DROP PROC dbo.usp_CustomerName;    
END;       
IF OBJECT_ID('dbo.usp_OrderDetailCount') IS NOT NULL BEGIN        
DROP PROC dbo.usp_OrderDetailCount;    
END; 
IF OBJECT_ID('usp_ProgrammingLogic') IS NOT NULL BEGIN        
DROP PROC usp_ProgrammingLogic    
END;   

     
IF OBJECT_ID('dbo.tempCustomer') IS NOT NULL BEGIN        
DROP TABLE dbo.tempCustomer;    
END;
IF OBJECT_ID('dbo.udf_ProductTotal') IS NOT NULL BEGIN        
DROP FUNCTION dbo.udf_ProductTotal;    
END; 

IF OBJECT_ID('dbo.vw_Products') IS NOT NULL BEGIN       
DROP VIEW dbo.vw_Products;    
END;       
IF OBJECT_ID('dbo.vw_CustomerTotals') IS NOT NULL BEGIN        
DROP VIEW dbo.vw_CustomerTotals;    
END;       
IF OBJECT_ID('dbo.fn_AddTwoNumbers') IS NOT NULL BEGIN       
DROP FUNCTION dbo.fn_AddTwoNumbers;    
END;       
IF OBJECT_ID('dbo.Trim') IS NOT NULL BEGIN        
DROP FUNCTION dbo.Trim;    
END       
IF OBJECT_ID('dbo.fn_RemoveNumbers') IS NOT NULL BEGIN         
DROP FUNCTION dbo.fn_RemoveNumbers;    
END;  
IF OBJECT_ID('dbo.fn_FormatPhone') IS NOT NULL BEGIN        
DROP FUNCTION dbo.fn_FormatPhone;    
END;   

IF OBJECT_ID('dbo.usp_CustomerTotals') IS NOT NULL BEGIN			
DROP PROCEDURE dbo.usp_CustomerTotals;    
END;       
IF OBJECT_ID('dbo.usp_ProductSales') IS NOT NULL BEGIN        
DROP PROCEDURE dbo.usp_ProductSales;    
END; 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'usp_TestTableVariable') BEGIN            
DROP PROCEDURE usp_TestTableVariable;    
END;  
IF EXISTS(SELECT * FROM sys.types WHERE name = 'CustomerInfo') BEGIN            
DROP TYPE dbo.CustomerInfo;    
END;  
  
 IF OBJECT_ID('MySequence') IS NOT NULL BEGIN            
 DROP SEQUENCE MySequence;    
 END;     
 
 
