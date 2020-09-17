
-------------------------Step 0. Create Project Database on the server--------------------------

CREATE DATABASE Group_23_Project;
USE Group_23_Project;

-------------------------Step 1. Create Tables--------------------------

--1. create table Category
CREATE TABLE dbo.Category
 (
 Category_ID int IDENTITY NOT NULL PRIMARY KEY ,
 Name varchar(40) NOT NULL
 );

--2. create table Customer
CREATE TABLE dbo.Customer
(
Customer_ID int IDENTITY NOT NULL PRIMARY KEY ,
Customer_First_Name varchar(40) NOT NULL,
Customer_Last_Name varchar(40) NOT NULL,
Customer_Password varchar(100),
Customer_Email varchar(100),
Customer_PhoneNumber varchar(100)
);
--3. create table Restaurant_Info
CREATE TABLE dbo.Restaurant_Info(
Restaurant_ID int IDENTITY NOT NULl PRIMARY KEY,
Restaurant_Name varchar(100) NOT NULL,
Website_Link varchar(100),
Restaurant_Dscpt varchar(2000)
);

--4. create table Customer_Favorite
CREATE TABLE dbo.Customer_Favorite(
Favorite_ID int IDENTITY NOT NULl PRIMARY KEY,
Customer_ID int NOT NULL
 REFERENCES dbo.Customer(Customer_ID) 
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE
);

--5. create table Rating
CREATE TABLE dbo.Rating(
Rating_ID int IDENTITY NOT NULl PRIMARY KEY,
Customer_ID int NOT NULL
 REFERENCES dbo.Customer(Customer_ID) 
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Rating_Value FLOAT CHECK (Rating_Value>= 0.0 AND Rating_Value <= 5.0) NOT NULL
);

--6. create table Reservation
CREATE TABLE dbo.Reservation(
Reservation_ID int IDENTITY NOT NULl PRIMARY KEY,
Customer_ID int NOT NULL
 REFERENCES dbo.Customer(Customer_ID) 
 ON UPDATE CASCADE
 ON DELETE CASCADE,
 Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
 Date date NOT NULL,
 Number_of_People int NOT NULL,
 Time time NOT NULL
 );

--7. create table Restaurant_Address
CREATE TABLE dbo.Restaurant_Address(
Address_ID int IDENTITY NOT NULl PRIMARY KEY,
State varchar(100) NOT NULL,
City varchar(100) NOT NULL,
Street_1 varchar(100) NOT NULL,
Street_2 varchar(100),
Zipcode int NOT NULL,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE
);

--8. create table Restaurant_Category
CREATE TABLE dbo.Restaurant_Category(
Rc_ID int IDENTITY NOT NULl PRIMARY KEY,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Category_ID int NOT NULL
 REFERENCES dbo.Category(Category_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE
);

--9. create table Restaurant_Dish
CREATE TABLE dbo.Restaurant_Dish(
Dish_ID int IDENTITY NOT NULl PRIMARY KEY,
Dish_Dscpt varchar(100),
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Dish_Name varchar(100) NOT NULL,
Price money NOT NULL,
Img_Path varchar(100)
);

--10. create table Restaurant_OpenHour
CREATE TABLE dbo.Restaurant_OpenHour(
OpenHour_ID int IDENTITY NOT NULl PRIMARY KEY,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Workday_Open time NOT NULL,
Workday_Close time NOT NULL,
Weekend_Open time NOT NULL,
Weekend_Close time NOT NULL
);

--11. create table Restaurant_Phone
CREATE TABLE dbo.Restaurant_Phone(
Phone_ID int IDENTITY NOT NULl PRIMARY KEY,
Phone_Number varchar(40) NOT NULL,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE
);

--12. create table Restaurant_Promotion
CREATE TABLE dbo.Restaurant_Promotion(
Promotion_ID int IDENTITY NOT NULl PRIMARY KEY,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Date_Begin date NOT NULL,
Date_End date NOT NULL,
Promotion_Dscpt varchar(100)
);

--13. create table Review
CREATE TABLE dbo.Review(
Review_ID int IDENTITY NOT NULl PRIMARY KEY,
Customer_ID int NOT NULL
 REFERENCES dbo.Customer(Customer_ID) 
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Restaurant_ID int NOT NULL
 REFERENCES dbo.Restaurant_Info(Restaurant_ID)
 ON UPDATE CASCADE
 ON DELETE CASCADE,
Content varchar(1000) NOT NULL
);

-------------------------Step 2. Insert data--------------------------

--1. insert data to dbo.Customer

INSERT dbo.Customer VALUES ( 'Anindita','Baishya', '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Sayli Umesh','Bhutkar',  '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ( 'Mingchang', 'Chen','123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Sahithi', 'Cherukuri', '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Sri Pooja', 'Gade', '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Ya', 'Gao', '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Ashish Harishchandra', 'Gurav', '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Minxuan', 'Hu', '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Xianyu', 'Jin', '123456','123@gami.com',null);
INSERT dbo.Customer VALUES ('Deepank', 'Khurana', '123456','123@gami.com',null);

--2. insert data to dbo.Review

INSERT INTO dbo.Review VALUES(2,2,'My expectations for McDonalds are t rarely high. But for one to still fail so spectacularly...that takes something special!')
INSERT INTO dbo.Review VALUES(3,3,'I was told that part of the tooth had broken off and that a crown was no longer possible.  I didnt know any better, so I agreed to schedule the extraction for a few weeks later. ')
INSERT INTO dbo.Review VALUES(5,5,'Some of the best chow around--love this place. The bread and salads and soups are great.s')
INSERT INTO dbo.Review VALUES(7,7,'I had to hound them to get an answer about my bill. ')
INSERT INTO dbo.Review VALUES(9,9,'Cant miss stop for the best Fish Sandwich in Pittsburgh.')
INSERT INTO dbo.Review VALUES(10,10,'After a morning of Thrift Store hunting, a friend and I were thinking of lunch, and he suggested Emils after hed seen Chris Sebak do a bit on it and had tried it a time or two before, and I had not. ')
INSERT INTO dbo.Review VALUES(1,10,'A pound of fish on a fish-shaped bun (as opposed to da burghs seemingly popular hamburger bun).')
INSERT INTO dbo.Review VALUES(2,9,'A great townie bar with tasty food and an interesting clientele.')
INSERT INTO dbo.Review VALUES(3,8,'Very disappointed in the customer service. We ordered Reubens  and wanted coleslaw instead of kraut. They charged us $3.00 for the coleslaw. We will not be back . The iced tea is also terrible tasting.')
INSERT INTO dbo.Review VALUES(4,7,'Terrible. Preordered my tires and when I arrived they couldnt find the order anywhere. ')
INSERT INTO dbo.Review VALUES(5,6,'I love this place! The food is always so fresh and delicious. The staff is always friendly, as well.')
INSERT INTO dbo.Review VALUES(6,5,'Half of the tees are not available, including all the grass tees.  It is cash only, and they sell the last bucket at 8, despite having lights.')
INSERT INTO dbo.Review VALUES(7,4,'The worst dental office I ever been. No one can beat it!!! You should avoid it at any time.')
INSERT INTO dbo.Review VALUES(9,2,'I writing this review to give you a heads up before you see this Doctor. The office staff and administration are very unprofessional.')

--3. insert data to dbo.Rating

INSERT INTO dbo.Rating VALUES(1,1,5);
INSERT INTO dbo.Rating VALUES(2,2,4);
INSERT INTO dbo.Rating VALUES(3,3,3);
INSERT INTO dbo.Rating VALUES(4,4,2);
INSERT INTO dbo.Rating VALUES(5,5,1);
INSERT INTO dbo.Rating VALUES(6,6,0.5);
INSERT INTO dbo.Rating VALUES(7,7,1.5);
INSERT INTO dbo.Rating VALUES(8,8,2.5);
INSERT INTO dbo.Rating VALUES(9,9,3.5);
INSERT INTO dbo.Rating VALUES(10,10,4.5);
INSERT INTO dbo.Rating VALUES(1,10,5);
INSERT INTO dbo.Rating VALUES(2,9,5);
INSERT INTO dbo.Rating VALUES(3,8,4);
INSERT INTO dbo.Rating VALUES(4,7,3);
INSERT INTO dbo.Rating VALUES(5,6,3.5);
INSERT INTO dbo.Rating VALUES(6,5,4.5);
INSERT INTO dbo.Rating VALUES(7,4,4);
INSERT INTO dbo.Rating VALUES(8,3,3);
INSERT INTO dbo.Rating VALUES(9,2,4);
INSERT INTO dbo.Rating VALUES(10,1,3);

--4. insert data into dbo.Category

INSERT INTO dbo.Category VALUES('Chinese Restaurant');
INSERT INTO dbo.Category VALUES('Theme Restaurant');
INSERT INTO dbo.Category VALUES('Roast Duck');
INSERT INTO dbo.Category VALUES('Barbecue');
INSERT INTO dbo.Category VALUES('Japanese Ramen');
INSERT INTO dbo.Category VALUES('Hot Pot');
INSERT INTO dbo.Category VALUES('Sushi Bar');
INSERT INTO dbo.Category VALUES('Korean Restaurant');
INSERT INTO dbo.Category VALUES('Japanese Restaurant');
INSERT INTO dbo.Category VALUES('French Restaurant');
SELECT * FROM dbo.Category;

--5. insert data into dbo.Customer_Favorite

INSERT INTO dbo.Customer_Favorite VALUES(1,1);
INSERT INTO dbo.Customer_Favorite VALUES(1,3);
INSERT INTO dbo.Customer_Favorite VALUES(2,2);
INSERT INTO dbo.Customer_Favorite VALUES(2,4);
INSERT INTO dbo.Customer_Favorite VALUES(3,3);
INSERT INTO dbo.Customer_Favorite VALUES(3,5);
INSERT INTO dbo.Customer_Favorite VALUES(4,4);
INSERT INTO dbo.Customer_Favorite VALUES(4,6);
INSERT INTO dbo.Customer_Favorite VALUES(5,5);
INSERT INTO dbo.Customer_Favorite VALUES(5,7);
INSERT INTO dbo.Customer_Favorite VALUES(6,6);
INSERT INTO dbo.Customer_Favorite VALUES(6,8);
INSERT INTO dbo.Customer_Favorite VALUES(7,7);
INSERT INTO dbo.Customer_Favorite VALUES(7,9);
INSERT INTO dbo.Customer_Favorite VALUES(8,8);
INSERT INTO dbo.Customer_Favorite VALUES(8,10);
INSERT INTO dbo.Customer_Favorite VALUES(9,9);
INSERT INTO dbo.Customer_Favorite VALUES(9,3);
INSERT INTO dbo.Customer_Favorite VALUES(10,10);
INSERT INTO dbo.Customer_Favorite VALUES(10,4);

--Using stored Procedure to insert Customer_PhoneNumber
DROP PROC INSERTPhoneNumber;
CREATE PROCEDURE INSERTPhoneNumber @rowNumber INT 
AS
BEGIN
 DECLARE @PhoneNumber int = 1171234567
 DECLARE @counter int = 1
 WHILE(@counter <= @rowNumber)
 BEGIN
  UPDATE dbo.Customer SET Customer_PhoneNumber = @PhoneNumber
  WHERE dbo.Customer.Customer_ID = @counter
  SET @counter += 1
  SET @PhoneNumber += 1
 END
END;
DECLARE @rowNumber INT = 10
EXEC INSERTPhoneNumber @rowNumber;


-------------------------Step 3. Data Import Wizard--------------------------
--6. import Restaurant_info.scv to Table dbo.Restaurant_info
--7. import Restaurant_OpenHour.csv to Table dbo.Restaurant_OpenHour
--8. import Reservation.csv to Table dbo.Reservation
--9. import Restaurant_Address.csv to Table dbo.Restaurant_Address
--10. import Restaurant_Phone.csv to Table dbo.Restaurant_Phone
--11. import Restaurant_Dish.csv to Table dbo.Restaurant_Dish
--12. import Restaurant_Promotion.csv to Table dbo.Restaurant_Promotion
--13. import Restaurant_Category.csv to Table dbo.Restaurant_Category

-------------------------Step 4. Create views--------------------------

--1. create view of Restaurant_RatingList

CREATE VIEW [Restaurant_RatingList] AS 
SELECT ri.Restaurant_ID,ri.Restaurant_Name,ri.Restaurant_Dscpt,AVG(r.Rating_Value)AS Average_Rating,COUNT(r.Rating_Value)AS Number_Of_Ratings FROM dbo.Restaurant_Info ri
INNER JOIN dbo.Rating r
ON ri.Restaurant_ID = r.Restaurant_ID
GROUP BY ri.Restaurant_ID,ri.Restaurant_Name,ri.Restaurant_Dscpt;

select *from [Restaurant_RatingList]
ORDER BY Average_Rating DESC;
ORDER BY Number_Of_Ratings DESC;
DROP VIEW [Restaurant_RatingList];

--2. create view of Customer_FavoriteList

CREATE VIEW [Customer_FavoriteList] AS
SELECT cf.Customer_ID, rr.Restaurant_ID, rr.Restaurant_Name, rr.Restaurant_Dscpt, rr.Average_Rating, ra.State, 
ra.City, ra.Street_1, ra.Street_2, ro.Workday_Open, ro.Workday_Close, ro.Weekend_Open, ro.Weekend_Close, rp.Phone_Number,
rpr.Date_Begin, rpr.Date_End, rpr.Promotion_Dscpt
FROM (((((Customer_Favorite cf INNER JOIN [Restaurant_RatingList] rr ON cf.Restaurant_ID = rr.Restaurant_ID)
INNER JOIN Restaurant_Address ra ON cf.Restaurant_ID = ra.Restaurant_ID) 
INNER JOIN Restaurant_OpenHour ro ON cf.Restaurant_ID =  ro.Restaurant_ID)
INNER JOIN Restaurant_Phone rp ON cf.Restaurant_ID = rp.Restaurant_ID)
INNER JOIN Restaurant_Promotion rpr ON cf.Restaurant_ID = rpr.Restaurant_ID)
;

select *from [Customer_FavoriteList]
where Customer_ID = 1;

DROP VIEW [Customer_FavoriteList];

--3. create view of Restaurant_ReviewList

CREATE VIEW [Restaurant_ReviewList] AS
SELECT rr.Restaurant_ID, rr.Restaurant_Name, rr.Restaurant_Dscpt, r.Customer_ID, r.Content
FROM [Restaurant_RatingList] rr INNER JOIN Review r
ON rr.Restaurant_ID = r.Restaurant_ID
;

select *from [Restaurant_ReviewList]
where Restaurant_ID = 2;

DROP VIEW [Restaurant_ReviewList];

--4. create view of Restaurant_RateofHighScore

CREATE VIEW [Restaurant_RateofHighScore] AS
SELECT rr.Restaurant_ID,CAST(ra.High_Rating AS float)/CAST(rr.Number_Of_Ratings AS float)AS rate FROM
(SELECT r.Restaurant_ID,COUNT(r.Rating_Value) AS High_Rating  FROM Rating r
WHERE rating_Value >= 4.0
GROUP BY r.Restaurant_ID) ra INNER JOIN [Restaurant_RatingList] rr ON ra.Restaurant_ID = rr.Restaurant_ID;

--5. create view of Restaurant_Menu
CREATE VIEW[Restaurant_Menu] AS
SELECT i.Restaurant_Name,d.Dish_Name,d.Dish_Dscpt,d.Price,d.Img_Path 
FROM Restaurant_Dish d INNER JOIN Restaurant_Info i ON d.Restaurant_ID = i.Restaurant_ID;

select *from [Restaurant_Menu];

DECLARE @list varchar(MAX) = " ";

-------------------------Step 5. Implementation--------------------------

--Fuction 1: Avoid the duplicate rating from the same customer

SELECT *FROM Rating;

CREATE FUNCTION CheckRating (@CustomerID int,@RetaurantID int)
RETURNS smallint
AS 
BEGIN
  DECLARE @Count smallint = 0
  SELECT @Count = COUNT(r.Rating_Value) FROM Rating r
  WHERE r.Customer_ID = @CustomerID
  AND r.Restaurant_ID = @RetaurantID
  RETURN ISNULL(@Count, 0)
END;
SELECT dbo.CheckRating(1,1);


--1. Table-level CHECK Constraints based on a Function 1

ALTER TABLE Rating WITH NOCHECK
ADD CONSTRAINT  BanMutipleRating CHECK(dbo.CheckRating(Customer_ID,Restaurant_ID) = 0);
--testing
INSERT INTO Rating(Customer_ID,Restaurant_ID,Rating_Value)
VALUES(1,1,3);


--Function 2: Define high score when customer gave a rate > 4.0
CREATE FUNCTION RateOfHighScore (@RestaurantID int)
RETURNS float
AS
BEGIN
DECLARE @High_Score_Rate float = (SELECT rate FROM
(SELECT rr.Restaurant_ID,CAST(ra.High_Rating AS float)/CAST(rr.Number_Of_Ratings AS float)AS rate FROM
(SELECT r.Restaurant_ID,COUNT(r.Rating_Value) AS High_Rating  FROM Rating r
WHERE rating_Value >= 4.0
GROUP BY r.Restaurant_ID) ra INNER JOIN [Restaurant_RatingList] rr ON ra.Restaurant_ID = rr.Restaurant_ID) re
WHERE re.Restaurant_ID = @RestaurantID)
RETURN ISNULL(@High_Score_Rate, 0)
END;

--2. Computed Columns based on a Function 2
ALTER TABLE Restaurant_Info 
ADD High_Score_Rate AS (dbo.RateOfHighScore(Restaurant_ID));
SELECT * FROM Restaurant_Info ;

--——3. Column Data Encryption
CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = 'databaseteam23'; 

ALTER TABLE Customer
ADD Customer_PasswordEncrypted varbinary(160);   

CREATE CERTIFICATE RRRS  
WITH SUBJECT = 'Customer Password'; 

CREATE SYMMETRIC KEY CustomerPassword  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE RRRS;  
   
OPEN SYMMETRIC KEY CustomerPassword  
   DECRYPTION BY CERTIFICATE RRRS;  
SELECT*FROM Customer;
  
UPDATE Customer  
SET Customer_PasswordEncrypted = EncryptByKey(Key_GUID('CustomerPassword')  
    , Customer_Password, 1, HashBytes('SHA1', CONVERT( varbinary  
    , Customer_Password))); 
 
  --verify 
 OPEN SYMMETRIC KEY CustomerPassword DECRYPTION BY CERTIFICATE RRRS;  
  
 SELECT Customer_Password, Customer_PasswordEncrypted   
    AS 'Encrypted password', CONVERT(varchar,  
    DecryptByKey(Customer_PasswordEncrypted, 1 ,   
    HashBytes('SHA1', CONVERT(varbinary, Customer_Password))))  
    AS 'Decrypted password' FROM Customer;  
 

