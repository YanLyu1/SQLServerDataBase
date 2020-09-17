/*Part A
Step 1) Create a new database of the format: LASTNAME_FIRSTNAME_TEST
Step 2) Within this database, experiment creating, altering, and dropping tables and columns. 
Put in sample data and play around with other kinds of queries. 
Write at least 20 SQL statements for this step.
*/

-- Step 1) create database
CREATE DATABASE LYU_YAN_TEST;
-- Step 2) use this db
USE LYU_YAN_TEST;
-- 1. creating a new table
CREATE TABLE dbo.PartA_Step2(
	SampleID int IDENTITY NOT NULL PRIMARY KEY,
	FirstName varchar(40),
	LastName varchar(40),
	University varchar(40),
	CourseID int NOT NULL
);

-- 2. creating another table
CREATE TABLE dbo.Course(
	CourseID int IDENTITY NOT NULL PRIMARY KEY,
	CourseName varchar(40),
	inttructer varchar(40)
);

-- 3. alter table name 
EXEC sp_rename 'dbo.PartA_Step2', 'Student';

-- 4. add FK constrain to student table
ALTER TABLE dbo.Student ADD CONSTRAINT Student_FK FOREIGN KEY (CourseID) REFERENCES dbo.Course(CourseID);

-- 5. alter table column name
sp_rename 'dbo.Course.inttructer', 'Instructer' , 'COLUMN';

-- 6. insert courses to course table
INSERT Course VALUES ('DATABASE', 'Professor Wang');
INSERT Course VALUES ('Big Data', 'Professor Ozbek');
INSERT Course VALUES ('Java Application', 'Professor Kal');

-- 7. select inserted data
SELECT * FROM dbo.Course;

-- 8. add column for course table
ALTER TABLE Course ADD Department varchar(40);

-- 9. alter column content for course
UPDATE Course SET Department = 'Engineering' WHERE Instructer = 'Professor Wang';

-- 10. alter column under some condition
UPDATE Course SET Department = 'Eng' WHERE Instructer <> 'Professor Wang';

-- 11. select data after alter
SELECT * FROM Course;

-- 12. drop student table
DROP TABLE Student;

-- 13. create a new student table
CREATE TABLE dbo.Student(
	StudentID int IDENTITY NOT NULL PRIMARY KEY,
	FirstName varchar(40),
	LastName varchar(40),
	University varchar(40)
);

-- 14. create a bridge table
CREATE TABLE Student_Course(
	StudentID int NOT NULL REFERENCES Student(StudentID),
	CourseID int NOT NULL REFERENCES Course(CourseID),
	CONSTRAINT Student_Course_PK PRIMARY KEY (StudentID,CourseID),
);
        
-- 15. add new date to student
INSERT INTO Student VALUES ('Yan', 'Lyu', 'NEU');
INSERT INTO Student VALUES ('Tom', 'Lyu', 'CMU');
INSERT INTO Student VALUES ('Smith', 'Lyu', 'NEU');
INSERT INTO Student VALUES ('Tom', 'Li', 'NYU');

-- 16. select student information from table
SELECT * FROM Student;

-- 17. insert some data into bridge table
INSERT INTO Student_Course VALUES(1, 1);
INSERT INTO Student_Course VALUES(1, 2);
INSERT INTO Student_Course VALUES(1, 3);
INSERT INTO Student_Course VALUES(2, 2);
INSERT INTO Student_Course VALUES(3, 3);
INSERT INTO Student_Course VALUES(4, 3);

-- 18. select data in bridge table
SELECT * FROM Student_Course;

-- 19. select students information who registered database
SELECT s.StudentID, s.FirstName, s.LastName, s.University 
FROM Student s
INNER JOIN Student_Course sc
ON s.StudentID = sc.StudentID
INNER JOIN Course c 
ON c.CourseID = sc.CourseID
WHERE c.CourseName = 'database';

-- 20. select course which registered more than 1
WITH temp AS(
	SELECT sc.CourseID, COUNT(sc.StudentID) AS [Count]
	FROM Student_Course sc
	GROUP BY sc.CourseID
)
SELECT c.CourseID, c.CourseName, temp.[Count]
FROM temp
INNER JOIN Course c 
ON c.CourseID = temp.CourseID;

-- 21. delete records
DELETE FROM Student_Course WHERE CourseID = 2;
SELECT * FROM Student_Course;

-- 22. truncate all the tables
DELETE FROM Student_Course;
SELECT * FROM Student_Course;
DELETE FROM Student;
SELECT * FROM Student;
DELETE FROM Course;
SELECT * FROM Course;

-- 23. drop all the tables
DROP TABLE Student_Course;
DROP Table Student;
DROP TABLE Course;

-- 24. drop the db
DROP DATABASE LYU_YAN_TEST;

/*Step 3) Eventually, create 3 tables and the corresponding relationships to implement the ERD below in the database.
*/
-- create 3 tbales
CREATE TABLE dbo.TargetCustomers(
	TargetID int IDENTITY NOT NULL PRIMARY KEY,
	FirstName varchar(40),
	LastName varchar(40),
	Address varchar(40),
	City varchar(40),
	State varchar(40),
	ZipCode int
); 

CREATE TABLE dbo.MailingLists(
	MailingListID int IDENTITY NOT NULL PRIMARY KEY,
	MailingList varchar(40)
);

CREATE TABLE dbo.TargetMailingLists (
	TargetID int NOT NULL REFERENCES TargetCustomers(TargetID),
	MailingListID int NOT NULL REFERENCES MailingLists(MailingListID),
	CONSTRAINT TargetMailingLists_PK PRIMARY KEY (TargetID,MailingListID)
);

/* Part B (1.5 points) 
Using the content of an AdventureWorks database, 
write a query to list all distinct products included in an order for all orders. 
The report needs to have the following format. 
Sort the returned data by the sales order id column. 
Within each order, sort the products in the ascending order.
43659	709, 711, 712, 714, 716, 771, 772, 773, 774, 776, 777, 778
43660	758, 762
43661	708, 711, 712, 715, 716, 741, 742, 743, 745, 747, 773, 775, 776, 777, 778
*/

USE AdventureWorks2008R2;
-- declare sql varibles
SELECT DISTINCT ssod.salesOrderID, 
	STUFF((SELECT ', ' +RTRIM(CAST(ProductID AS char))
	FROM sales.salesOrderDetail
	WHERE salesOrderID = ssod.salesOrderID
	ORDER BY ProductID
	FOR XML PATH('')),1,2,'') AS ProductID
FROM sales.salesOrderDetail ssod
ORDER BY ssod.salesOrderID;



--Part C (1.5 points)
/* Bill of Materials - Recursive */
/* The following code retrieves the components required for manufacturing "Mountain-500 Black, 48" (Product 992). 
 * Modify the code to retrieve the most expensive component(s) at each component level. 
 * Use the list price of a component to determine the most expensive component for each level. 
 * Sort the returned data by the component level. */
-- first with get the recursive of level
WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty, b.EndDate, 0 AS ComponentLevel
FROM Production.BillOfMaterials AS b
WHERE b.ProductAssemblyID = 992 AND b.EndDate IS NULL
UNION ALL
SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty, bom.EndDate, ComponentLevel + 1
FROM Production.BillOfMaterials AS bom
INNER JOIN Parts AS p
ON bom.ProductAssemblyID = p.ComponentID AND bom.EndDate IS NULL
), 
-- temp get the rank in each componentLevel
temp AS (SELECT AssemblyID, ComponentID, pr.Name, ComponentLevel, pr.ListPrice, RANK() OVER(PARTITION BY ComponentLevel ORDER BY ListPrice DESC) AS [Rank]
FROM Parts AS p
INNER JOIN Production.Product AS pr
ON p.ComponentID = pr.ProductID
GROUP BY AssemblyID, ComponentID, ComponentLevel, ListPrice, pr.Name
)
-- get the required attributes from temp
SELECT DISTINCT AssemblyID, ComponentID, Name, ComponentLevel, ListPrice FROM temp
WHERE [Rank] = 1
ORDER BY ComponentLevel;


