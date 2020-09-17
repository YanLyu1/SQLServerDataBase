-- Set the database context
USE AdventureWorks2008R2;

--2-1
/* Select product id, name and selling start date for all products that started selling after 02/01/2006 and had a yellow color. 
 * Use the CAST function to display the date only. Sort the returned data by the selling start date.
 * Hint: 
 * a: You need to work with the Production.Product table.
 * b: The syntax for CAST is CAST(expression AS data_type), 
   where expression is the column name we want to format and we can use DATE as data_type for this question to display just the date.
*/

--SELECT * FROM Production.Product;

SELECT ProductID, Name, CAST(SellStartDate AS DATE) AS [Selling Start Date]
FROM Production.Product
WHERE Color = 'Yellow' AND SellStartDate > 02/01/2006
ORDER BY [Selling Start Date];

--2-2
/* List the latest order date and total number of orders for each customer. 
 * Include only the customer ID, account number, latest order date and the total number of orders in the report.
 * Use column aliases to make the report more presentable.
 * Sort the returned data by the customer id.
 * Hint: You need to work with the Sales.SalesOrderHeader table. */

--SELECT * FROM Sales.SalesOrderHeader;

SELECT soh.CustomerID, soh.AccountNumber, 
		MAX(soh.OrderDate) AS LatestOrderDate, 
		COUNT(soh.SalesOrderID) AS TotalNumberOfOrders
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID, soh.AccountNumber
ORDER BY CustomerID


--2-3
/* Write a query to select the product id, name, and list price
 * for the products that have a list price greater than the average list price.
 * Sort the returned data by the product id.
 * Hint: You’ll need to use a simple subquery to get the average list price and use it in a WHERE clause. */

--SELECT * FROM Production.Product;
--SELECT AVG(ListPrice) FROM Production.Product

SELECT ProductID, Name, ListPrice
	FROM Production.Product
WHERE (SELECT AVG(ListPrice)
		FROM Production.Product) < ListPrice
ORDER BY ProductID


--2-4
/* Write a query to retrieve the total sold quantity for each product. 
 * Include only the products that have a total great than 50. 
 * Use a column alias to make the report more presentable. 
 * Sort the returned data by the total sold quantity in the descending order. 
 * Include the product ID, product name and total sold quantity columns in the report.
 * Hint: Use the Sales.SalesOrderDetail and Production.Product tables.
 */

--SELECT * FROM Sales.SalesOrderDetail;
--SELECT * FROM Production.Product;

--way 1
SELECT temp.ProductID, temp.Name, temp.TotalSold
	FROM (
		SELECT pp.ProductID, pp.Name, SUM(sso.OrderQty) AS 'TotalSold'
		FROM Sales.SalesOrderDetail sso
		INNER JOIN Production.Product pp
		ON sso.ProductID = pp.ProductID
		GROUP BY pp.ProductID, pp.Name
	) AS temp
WHERE temp.TotalSold > 50
ORDER BY TotalSold DESC

--way 2
SELECT pp.ProductID, pp.Name, SUM(sso.OrderQty) AS 'TotalSold'
FROM Sales.SalesOrderDetail sso
INNER JOIN Production.Product pp
	ON sso.ProductID = pp.ProductID
GROUP BY pp.ProductID, pp.Name
HAVING SUM(sso.OrderQty) > 50
ORDER BY TotalSold DESC

--2-5
/* Write a query to retrieve the salespersons who have sold more than 70 different products in a single order.
 * Include the salesperson id, sales order id, and total of different products columns in the returned data.
 * Sort the returned data by the sales person id. */

SELECT ssoh.SalesPersonID, ssoh.SalesOrderID, COUNT(ssod.ProductID) AS [product count]
FROM Sales.SalesOrderDetail ssod
	LEFT JOIN Sales.SalesOrderHeader ssoh
	ON ssod.SalesOrderID = ssoh.SalesOrderID
GROUP BY ssoh.SalesOrderID, ssoh.SalesPersonID
HAVING COUNT(ssod.ProductID) > 70
ORDER BY ssoh.SalesPersonID

--2-6
/* Provide a unique list of product ids and product names that were not ordered during 2007 and sort the list by product id. */
--SELECT * FROM Sales.SalesOrderHeader

SELECT ProductID, Name
FROM Production.Product
WHERE ProductID NOT IN (
	--get all the product id which is placed during 2007
	SELECT ProductID 
	FROM Sales.SalesOrderHeader ssoh
	LEFT JOIN Sales.SalesOrderDetail ssod
		ON ssoh.SalesOrderID = ssod.SalesOrderID
	WHERE YEAR(ssoh.OrderDate) = 2007
	)
ORDER BY ProductID


















