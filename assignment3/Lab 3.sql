
USE AdventureWorks2008R2;
--Lab 3-1
/* Modify the following query to add a column that identifies the frequency of repeat customers and contains the following values based on the number of orders during 2007:
 * 'No Order' for count = 0
 * 'One Time' for count = 1 
 * 'Regular' for count range of 2-5 
 * 'Often' for count range of 6-10 
 * 'Loyal' for count greater than 10
Give the new column an alias to make the report more readable. */

SELECT c.CustomerID, c.TerritoryID, 
	COUNT(o.SalesOrderid) [Total Orders],
	CASE 
		WHEN COUNT(o.SalesOrderid) = 0
			THEN 'No Order'
		WHEN COUNT(o.SalesOrderid) = 1
			THEN 'One Time'
		WHEN COUNT(o.SalesOrderid) >= 2 AND COUNT(o.SalesOrderid) <= 5
			THEN 'Regular'
		WHEN COUNT(o.SalesOrderid) >= 6 AND COUNT(o.SalesOrderid) <= 10
			THEN 'Often'
		ELSE 'Loyal'
	END AS 'Frequency'
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID 
WHERE DATEPART(year, OrderDate) = 2007 
GROUP BY c.TerritoryID, c.CustomerID;


--Lab 3-2
/* Modify the following query to add a rank with gaps in the ranking 
 * based on the total orders in the descending order. Also partition by territory.
 * Give the new column an alias to make the report more readable. */
SELECT c.CustomerID, c.TerritoryID, 
	COUNT(o.SalesOrderid) [Total Orders],
	RANK() OVER (PARTITION BY c.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) AS [Rank]
FROM Sales.Customer c
LEFT OUTER JOIN Sales.SalesOrderHeader o 
ON c.CustomerID = o.CustomerID
WHERE DATEPART(year, OrderDate) = 2007  
GROUP BY c.TerritoryID, c.CustomerID;

--Lab 3-3
/* Write a query that returns the highest bonus amount received for the male sales people in North America. */
--man : HumanResources.Employee.Gender
--north america : Sales.CountryRegionCurrency
--bonus amounts : Sales.SalesPerson
SELECT MAX(ssp.Bonus) AS [Hightest Bonus]
FROM Sales.SalesPerson ssp
INNER JOIN HumanResources.Employee hre ON hre.BusinessEntityID = ssp.BusinessEntityID
WHERE hre.Gender = 'M' AND ssp.TerritoryID IN (
	SELECT sst.TerritoryID
	FROM Sales.SalesTerritory sst
	WHERE sst.[Group] = 'North America' 
);

--Lab 3-4
/* Retrieve the top selling product of each day. 
 * Use the total sold quantity to determine the top selling product. 
 * The top selling product has the highest total sold quantity.
 * If there is a tie, the solution must pick up the tie.
 * Include the order date, product id, and the total sold quantity of the top selling product of each day in the returned data. 
 * Sort the returned data by the order date.
*/

WITH temp AS(
	SELECT ssoh.OrderDate, ssod.ProductID, 
		RANK() OVER (PARTITION BY ssoh.OrderDate ORDER BY SUM(ssod.OrderQty) DESC) AS [Rank],
		SUM(ssod.OrderQty) AS [Total]
	FROM Sales.SalesOrderHeader ssoh
	INNER JOIN Sales.SalesOrderDetail ssod
	ON ssod.SalesOrderID = ssoh.SalesOrderID
	GROUP BY ssoh.OrderDate, ssod.ProductID
)
SELECT CAST(temp.OrderDate AS DATE) AS OrderDate, temp.ProductID, temp.[Total] 
FROM temp
WHERE temp.[Rank] = 1
ORDER BY temp.OrderDate;
--ORDER BY temp.total DESC;

--Lab 3-5
/* Write a query to return a unique list of customer id’s which
 * have ordered both products 711 and 712 after July 1, 2008. Sort the list by customer id. */
SELECT DISTINCT ssoh.CustomerID
FROM Sales.SalesOrderDetail ssod
JOIN Sales.SalesOrderHeader ssoh
ON ssod.SalesOrderID = ssoh.SalesOrderID
WHERE ssod.ProductID = '711' AND ssoh.OrderDate > '07/01/2008'
INTERSECT
SELECT ssoh.CustomerID
FROM Sales.SalesOrderDetail ssod
JOIN Sales.SalesOrderHeader ssoh
ON ssod.SalesOrderID = ssoh.SalesOrderID
WHERE ssod.ProductID = '712' AND ssoh.OrderDate > '07/01/2008'
ORDER BY ssoh.CustomerID;

/* --for checking
SELECT ssoh.SalesOrderID
FROM Sales.SalesOrderHeader ssoh
WHERE ssoh.CustomerID = '11051' --AND ssoh.OrderDate >= '07/01/2008';


SELECT ssod.ProductID
FROM Sales.SalesOrderDetail ssod
WHERE ssod.SalesOrderID = '74253' --OR ssod.SalesOrderID = '74253'
ORDER BY ssod.ProductID;

SELECT ssoh.OrderDate
FROM Sales.SalesOrderHeader ssoh
WHERE ssoh.SalesOrderID = '74155'
*/



















