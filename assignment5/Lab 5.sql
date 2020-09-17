-- Lab 5-1
 
/* Create a function in your own database that takes three
parameters:
1) A beginning year parameter
2) An ending year parameter 
3) A month parameter
The function then calculates and returns the total sale
for the requested month of the requested years. If there was no sale for the requested period, returns 0.
Hints: a) Use the TotalDue column of the Sales.SalesOrderHeader table in an AdventureWorks database for calculating the total sale.
b) The year and month parameters should use the INT data type.
c) Make sure the function returns 0 if there was no sale in the database for the requested period. */

USE LYU_YAN_TEST;

CREATE FUNCTION uf_Lab5_1
(@BeginYear int, @EndingYear int, @M int)
RETURNS TABLE 
AS 
RETURN 
	(SELECT isnull(SUM(ssoh.TotalDue),0) AS [Total Due]
	FROM AdventureWorks2008R2.Sales.SalesOrderHeader ssoh
	WHERE YEAR(ssoh.OrderDate) >= @BeginYear AND YEAR(ssoh.OrderDate) <= @EndingYear AND MONTH(ssoh.OrderDate) = @M
	);
GO
SELECT * FROM uf_Lab5_1(2003, 2005, 3);
DROP FUNCTION uf_Lab5_1;

-- database search check
SELECT isnull(SUM(ssoh.TotalDue),0) AS [Total Due]
	FROM AdventureWorks2008R2.Sales.SalesOrderHeader ssoh
	WHERE YEAR(ssoh.OrderDate) >= 2003 AND YEAR(ssoh.OrderDate) <= 2005 AND MONTH(ssoh.OrderDate) = 3
	
-- Lab 5-2
/*
 * Create a table in your own database using the following statement.
CREATE TABLE DateRange (DateID INT IDENTITY,
DateValue DATE, Year INT, Quarter INT, Month INT, DayOfWeek INT);
Write a stored procedure in your own database that accepts two parameters:
1) A starting date
2) The number of the consecutive dates beginning with the starting
date
The stored procedure then populates all columns of the DateRange table according to the two provided parameters.
 */
	
-- WAY 1 : insert and then populate
CREATE TABLE DateRange (
	DateID INT IDENTITY,
	DateValue DATE,
	Year INT,
	Quarter INT,
	Month INT,
	DayOfWeek INT);

CREATE PROCEDURE Lab5_2
	@StartDate DATE, @NumOfDays INT 
AS
BEGIN
	DECLARE @counter int = 0
	DECLARE @tempdate DATE = @StartDate
	WHILE(@counter < @NumOfDays)
	BEGIN
		INSERT INTO dbo.DateRange VALUES (@tempdate, 
			DATEPART(YEAR, @tempdate), 
			DATEPART(QUARTER, @tempdate), 
			DATEPART(MONTH, @tempdate),
			DATEPART(weekday, @tempdate))
		SET @counter += 1
		SET @tempdate = DATEADD(day, 1, @tempdate)
	END
END;

TRUNCATE TABLE dbo.DateRange
DECLARE @inputdate DATE
DECLARE @inputrange INT
SET @inputdate = '2018-10-25'
SET @inputrange = 8
EXEC Lab5_2 @inputdate, @inputrange
SELECT * FROM dbo.DateRange;
DROP PROC Lab5_2
DROP TABLE dbo.DateRange;

-- Lab 5-3
/* Using an AdventureWorks database, create a function that 
 * accepts a customer id and returns the full name (last name + first name) of the customer, as isted below. */
-- Create a table-valued function 

CREATE FUNCTION uf_GetCustomerName (@CustID INT)
RETURNS @tbl TABLE (name varchar(200))
BEGIN
	DECLARE @fullname varchar(200) = ''
	SELECT @fullname = p.FirstName + ' ' + p.LastName 
	FROM AdventureWorks2008R2.Sales.Customer c
	JOIN AdventureWorks2008R2.Person.Person p
	ON c.PersonID = p.BusinessEntityID
	WHERE c.CustomerID = @custID
	INSERT INTO @tbl values (@fullname)
RETURN
END;
-- Test run the function
SELECT * FROM dbo.uf_GetCustomerName(11000);
/* Use the new function, SalesOrderHeader and SalesOrderDetail to return all customers, 
 * with each customer's id, full name, total number of orders and total number of unique products a customer has purchased. 
 * Sort the returned data by CustomerID. */

CREATE FUNCTION CustomerInformation()
RETURNS TABLE
AS
RETURN (SELECT TOP 100 PERCENT ssoh.CustomerID,STUFF(
   (SELECT * FROM dbo.uf_GetCustomerName(ssoh.CustomerID)) 
   ,1,0,'') AS FullName,
   COUNT(DISTINCT ssod.SalesOrderID) AS[Total Order],COUNT(DISTINCT ssod.ProductID) AS[Total Product]
   FROM AdventureWorks2008R2.Sales.SalesOrderDetail ssod
   Join AdventureWorks2008R2.Sales.SalesOrderHeader ssoh
   on ssod.SalesOrderID = ssoh.SalesOrderID
   GROUP BY ssoh.CustomerID
   ORDER BY ssoh.CustomerID 
 );

SELECT * FROM CustomerInformation() ORDER BY CustomerID;
DROP function CustomerInformation;
DROP FUNCTION uf_GetCustomerName;

-- Lab 5-4
/* With three tables as defined below: */

DROP TABLE dbo.Customer;
DROP TABLE dbo.SaleOrder;
DROP TABLE dbo.SaleOrderDetail;

CREATE TABLE Customer 
	(CustomerID INT PRIMARY KEY,
	CustomerLName VARCHAR(30), 
	CustomerFName VARCHAR(30));

CREATE TABLE SaleOrder
	(OrderID INT IDENTITY PRIMARY KEY,
	CustomerID INT REFERENCES Customer(CustomerID), 
	OrderDate DATE,
	LastModified datetime);

CREATE TABLE SaleOrderDetail
	(OrderID INT REFERENCES SaleOrder(OrderID),
	ProductID INT,
	Quantity INT,
	UnitPrice INT,
	PRIMARY KEY (OrderID, ProductID));

/* Write a trigger to put the change date and time in the LastModified column of the Order table 
 * whenever an order item in SaleOrderDetail is changed. */
DROP TRIGGER Lab5_4;
Create TRIGGER Lab5_4
ON dbo.SaleOrderDetail
FOR INSERT,UPDATE
AS
 BEGIN
  DECLARE @LMDate DateTime
  DECLARE @OrderID INT
 SELECT @OrderID = OrderID FROM inserted
SET
@LMDate = (Select SYSDATETIME())
UPDATE
 dbo.SaleOrder
SET
 LastModified=@LMDate
WHERE
 OrderID=@OrderID
END;


-- INSERT INTO dbo.SaleOrderDetail values (2,1,1,1);
-- update dbo.SaleOrderDetail set Quantity = 1 WHERE orderid = 2;
UPDATE dbo.SaleOrderDetail SET Quantity=11 WHERE OrderID = 1;
SELECT * FROM dbo.SaleOrder;
SELECT * FROM dbo.SaleOrderDetail;
-- DELETE FROM dbo.SaleOrderDetail WHERE OrderID = 2;
INSERT INTO dbo.SaleOrderDetail VALUES(1,2,2,2);
INSERT INTO dbo.SaleOrderDetail VALUES(2,2,2,2);
INSERT INTO dbo.Customer values (2, 'Leyi', 'Wang');
INSERT INTO dbo.SaleOrder values (2, null, null);
INSERT INTO dbo.SaleOrder values (1, null, null);
INSERT INTO dbo.Customer values (1, 'Yan', 'Lyu');
