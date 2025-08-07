/*
=============================================================
Database Creation and Table Setup Script
=============================================================
Script Purpose:
    This script creates a new SQL Server database named 'SalesDB'. 
    If the database already exists, it is dropped to ensure a clean setup. 
    The script then creates three tables: 'customers', 'orders', and 'employees' 
    with their respective schemas, and populates them with sample data.
    
WARNING:
    Running this script will drop the entire 'SalesDB' database if it exists, 
    permanently deleting all data within it. Proceed with caution and ensure you 
    have proper backups before executing this script.
*/

USE master;
GO

-- Drop and recreate the 'SalesDB' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'SalesDB')
BEGIN
    ALTER DATABASE SalesDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SalesDB;
END;
GO

-- Create the 'SalesDB' database
CREATE DATABASE SalesDB;
GO

USE SalesDB;
GO

-- Check if the schema 'Sales' exists
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'Sales')
BEGIN
    -- If it does exist, drop the 'Sales' schema
    DROP SCHEMA Sales;
END;
GO

-- Create the 'Sales' Schema using dynamic SQL
EXEC sys.sp_executesql N'CREATE SCHEMA Sales;';
GO

-- ======================================================
-- Table: customers
-- ======================================================

CREATE TABLE Sales.Customers (
    CustomerID INT NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Country VARCHAR(50),
    Score INT,
    CONSTRAINT PK_customers PRIMARY KEY (CustomerID)
);
GO

-- Insert data into Customer table
INSERT INTO Sales.Customers 
VALUES
    (1, 'Jossef', 'Goldberg', 'Germany', 350),
    (2, 'Kevin', 'Brown', 'USA', 900),
    (3, 'Mary', NULL, 'USA', 750),
    (4, 'Mark', 'Schwarz', 'Germany', 500),
    (5, 'Anna', 'Adams', 'USA', NULL);
GO

-- ======================================================
-- Table: Employee
-- ======================================================

-- Create Employee table
CREATE TABLE Sales.Employees (
    EmployeeID INT NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    BirthDate DATE,
    Gender CHAR(1),
    Salary INT,
	ManagerID INT,
	CONSTRAINT PK_employees PRIMARY KEY (EmployeeID)
);
GO

-- Insert data into Employee table
INSERT INTO Sales.Employees
VALUES
    (1, 'Frank', 'Lee', 'Marketing', '1988-12-05', 'M', 55000, null),
    (2, 'Kevin', 'Brown', 'Marketing', '1972-11-25', 'M', 65000, 1),
    (3, 'Mary', null, 'Sales', '1986-01-05', 'F', 75000, 1),
    (4, 'Michael', 'Ray', 'Sales', '1977-02-10', 'M', 90000, 2),
    (5, 'Carol', 'Baker', 'Sales', '1982-02-11', 'F', 55000, 3);
GO

-- ======================================================
-- Table: Products
-- ======================================================

-- Create Products table
CREATE TABLE Sales.Products (
    ProductID INT NOT NULL,
    Product VARCHAR(50),
    Category VARCHAR(50),
    Price INT,
	CONSTRAINT PK_products PRIMARY KEY (ProductID)
);
GO

-- Insert data into Products table
INSERT INTO Sales.Products (ProductID, Product, Category, Price)
VALUES
    (101, 'Bottle', 'Accessories', 10),
    (102, 'Tire', 'Accessories', 15),
    (103, 'Socks', 'Clothing', 20),
    (104, 'Caps', 'Clothing', 25),
    (105, 'Gloves', 'Clothing', 30);
GO

-- ======================================================
-- Table: orders
-- ======================================================

-- Create Orders table
CREATE TABLE Sales.Orders (
    OrderID INT NOT NULL,
	ProductID INT,
    CustomerID INT,
    SalesPersonID INT,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(50),
	ShipAddress VARCHAR(255),
	BillAddress VARCHAR(255),
    Quantity INT,
    Sales INT,
	CreationTime DATETIME2,
	CONSTRAINT PK_orders PRIMARY KEY (OrderID)
);
GO

-- Insert data into Orders table
INSERT INTO Sales.Orders 
VALUES
    (1,  101, 2, 3, '2025-01-01', '2025-01-05', 'Delivered','9833 Mt. Dias Blv.', '1226 Shoe St.',  1, 10, '2025-01-01T12:34:56'),
    (2,  102, 3, 3, '2025-01-05', '2025-01-10', 'Shipped','250 Race Court',NULL, 1, 15, '2025-01-05T23:22:04'),
    (3,  101, 1, 5, '2025-01-10', '2025-01-25', 'Delivered','8157 W. Book','8157 W. Book', 2, 20, '2025-01-10T18:24:08'),
    (4,  105, 1, 3, '2025-01-20', '2025-01-25', 'Shipped', '5724 Victory Lane', '', 2, 60, '2025-01-20T05:50:33'),
    (5,  104, 2, 5, '2025-02-01', '2025-02-05', 'Delivered',NULL, NULL, 1, 25, '2025-02-01T14:02:41'),
    (6,  104, 3, 5, '2025-02-05', '2025-02-10', 'Delivered','1792 Belmont Rd.',NULL, 2, 50, '2025-02-06T15:34:57'),
    (7,  102, 1, 1, '2025-02-15', '2025-02-27', 'Delivered','136 Balboa Court', '', 2, 30, '2025-02-16T06:22:01'),
    (8,  101, 4, 3, '2025-02-18', '2025-02-27', 'Shipped','2947 Vine Lane','4311 Clay Rd', 3, 90, '2025-02-18T10:45:22'),
    (9,  101, 2, 3, '2025-03-10', '2025-03-15', 'Shipped','3768 Door Way', '', 2, 20,'2025-03-10T12:59:04'),
    (10, 102, 3, 5, '2025-03-15', '2025-03-20', 'Shipped',NULL, NULL, 0, 60,'2025-03-16T23:25:15');
GO

-- ======================================================
-- Table: OrdersArchive
-- ======================================================

-- Create OrdersArchive table
CREATE TABLE Sales.OrdersArchive (
    OrderID INT,
	ProductID INT,
    CustomerID INT,
    SalesPersonID INT,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(50),
	ShipAddress VARCHAR(255),
	BillAddress VARCHAR(255),
    Quantity INT,
    Sales INT,
	CreationTime DATETIME2
);
GO

INSERT INTO Sales.OrdersArchive 
VALUES
    (1, 101,2 , 3, '2024-04-01', '2024-04-05', 'Shipped','123 Main St', '456 Billing St', 1, 10, '2024-04-01T12:34:56'),
    (2, 102,3 , 3, '2024-04-05', '2024-04-10', 'Shipped','456 Elm St', '789 Billing St', 1, 15, '2024-04-05T23:22:04'),
    (3, 101, 1, 4, '2024-04-10', '2024-04-25', 'Shipped','789 Maple St','789 Maple St', 2, 20, '2024-04-10T18:24:08'),
    (4, 105,1 , 3, '2024-04-20', '2024-04-25', 'Shipped',   '987 Victory Lane', '', 2, 60, '2024-04-20T05:50:33'),
    (4, 105,1 , 3, '2024-04-20', '2024-04-25', 'Delivered', '987 Victory Lane', '', 2, 60, '2024-04-20T14:50:33'),
    (5, 104,2 , 5, '2024-05-01', '2024-05-05', 'Shipped','345 Oak St', '678 Pine St', 1, 25, '2024-05-01T14:02:41'),
    (6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered','543 Belmont Rd.',NULL, 2, 50, '2024-05-06T15:34:57'),
    (6, 104, 3, 5, '2024-05-05', '2024-05-10', 'Delivered','543 Belmont Rd.','3768 Door Way', 2, 50, '2024-05-07T13:22:05'),
    (6, 101, 3, 5, '2024-05-05', '2024-05-10', 'Delivered','543 Belmont Rd.','3768 Door Way', 2, 50, '2024-05-12T20:36:55'),
	(7, 102,3 , 5, '2024-06-15', '2024-06-20', 'Shipped','111 Main St', '222 Billing St', 0, 60,'2024-06-16T23:25:15');
GO


SELECT *
FROM sales.Customers

SELECT *
FROM sales.Employees

SELECT *
FROM sales.Orders

SELECT *
FROM sales.OrdersArchive

SELECT *
FROM sales.Products

--///////////////////////////////////

SELECT
	o.CustomerID,
	o.OrderID,
	o.Sales,
	c.FirstName AS CustomerFirstName,
	c.LastName AS CustomerLastName,
	p.Product AS ProductName,
	p.Price,
	e.FirstName AS EmployeeFirstName,
	e.LastName AS EmployeeLastName
FROM sales.Orders AS o
LEFT JOIN sales.Customers AS c
	ON	o.CustomerID = c.CustomerID
LEFT JOIN sales.Products AS p
	ON	o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
	ON o.SalesPersonID = e.EmployeeID;


--///////////////////////////////
-- SET OPERATORS --
-- THE IS USED TO COMBINE MULTIPLES ROWS TOGETHER
--SYNTAX:
SELECT
	FirstName,
	LastName
FROM Sales.Customers
UNION
SELECT
	FirstName,
	LastName
	--EmployeeID
FROM Sales.Employees


/* UNION SET OPERATOR
This combine rows together and return  all dinstinct rows from both queries
*/
--Combine the data from employees and customers into one table
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName
	
FROM Sales.Customers AS c
UNION
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.LastName
FROM Sales.Employees AS e


/* UNION ALL SET OPERATOR
This combine rows together and return  all rows from both queries
*/
--Combine the data from employees and customers into one table
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName
	
FROM Sales.Customers AS c
UNION
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.LastName
FROM Sales.Employees AS e

-- GITHUB UPDATE 16/07/2025

SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName
	
FROM Sales.Customers AS c
UNION ALL
SELECT 
	e.EmployeeID,
	e.FirstName,
	e.LastName
FROM Sales.Employees AS e

/* EXCEPT
This returns unique value from the first query that are not in the second query
The key table is the first one, the second table is to perform an extra filter or act as a lookup
Note: The order of the table does affect the result, switching the table will result in 2 different output
Task: Find the employees who are not customers at the same time
*/

SELECT 
	FirstName,
	LastName
FROM Sales.Employees 
EXCEPT
SELECT 
	FirstName,
	LastName
FROM Sales.Customers

--Switching the tables
SELECT 
	FirstName,
	LastName
FROM Sales.Customers 
EXCEPT
SELECT 
	FirstName,
	LastName
FROM Sales.Employees
SELECT *
FROM Sales.customers

SELECT *
FROM Sales.Employees




-- GITHUB UPDATE 24TH July 2025

/* This query works well and fine just as the query below but it's unadvisable to write a 
query like this because of future discrepancies incase of the additon of new column */

--SELECT * 
--FROM sales.Orders
--UNION
--SELECT *
--FROM sales.OrdersArchive

SELECT
	'Orders' AS SourceTable --This adds an extra column on each rows signifying the source table of each result for ease identification.
	,[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM sales.Orders
UNION 
SELECT
	'OrdersArchive' AS SourceTable
	,[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM sales.OrdersArchive
ORDER BY OrderID ASC, SalesPersonID DESC;

--DATA COMPLETENESS CHECK
/*Use EXCEPT operator to perform a data check, the result MUST 
be EMPTY even when tables are switched. This means the 2 tables are 100% the same */
SELECT
	'Orders' AS SourceTable
	,[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM sales.Orders
EXCEPT 
SELECT
	'OrdersArchive' AS SourceTable
	,[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM sales.OrdersArchive
ORDER BY OrderID ASC, SalesPersonID DESC;

--ROW LEVEL FUNCTION
--STRING FUNCTION
-- FUNCTION GROUP: Single Row, Multiple Row Function
/*	Single Row Function divided into 3 
	- Manipulation (CONCACT, UPPER, LOWER, TRIM, REPLACE)
	- Caculation (LEN)
	- Extraction (LEFT, RIGHT, SUBSTRING)
*/

--MANIPULATION
-- CONCAT: Combines multiple string together
	SELECT CONCAT(FirstName,' ', LastName)
	FROM SALES.Customers

-- UPPER/LOWER: Change the case of a string
	SELECT UPPER(firstname)
	FROM sales.Customers;
	
	SELECT LOWER(lastname)
	FROM sales.Customers;

	SELECT CONCAT(UPPER(Firstname),' ', LOWER(lastname))
	FROM sales.Customers;

-- TRIM: Removes starting and trailing spaces in a string
	SELECT FirstName,
	LEN(lastname) len_name
	--LEN(lastname) - LEN(TRIM(lastname)) flag	
	FROM Sales.Customers
	--WHERE (firstname) != TRIM(FirstName);

--REPLACE: Replace the old value with a new update
SELECT 
	'123-45-7890',
REPLACE ('123-45-7890', '-', '') newList;

-- CALCULATION -- LEN()
SELECT 
	lastname lastname,
	LEN(lastname) name_lenght
FROM sales.Customers

--DATA EXTRACTION --LEFT, RIGHT, SUBSTRING
SELECT	firstname,
		LEFT(firstname, 2)
FROM Sales.Customers;

SELECT	firstname,
		RIGHT(firstname, 2)
FROM Sales.Customers;

SELECT SUBSTRING(firstname, 2,4) extracted_value
FROM SALES.Customers;

SELECT (SUBSTRING(TRIM(firstname), 2, LEN(firstname))) as ExtractedData
FROM sales.Customers;

--NUMBER FUNCTIONS
--ROUND
SELECT 
	3.516,
	ROUND(3.516, 2),
	ROUND(3.516, 1),
	ROUND(3.516, 0);	

--DATE & TIME
--SOURCES OF DATEVALUE
--DATE COLUMN FROM A TABLE
SELECT
	orderID,
	OrderDate,
	ShipDate,
	CreationTime
FROM sales.Orders

--HARDCODED DATE STRING
SELECT '2020-08-24' Hardcoded;

--GETDATE() FUNCTION
SELECT 
	OrderID,
	CreationTime,
	GETDATE() GetDateFunc 
FROM Sales.Orders;

--PART EXTRACTION
--DAY/MONTH/YEAR
SELECT 
	CreationTime,
	YEAR(CreationTime) Year,
	MONTH(CreationTime) Month,
	DAY(CreationTime) Day
FROM Sales.orders

--DATEPART, Extract a specific part in a date (qtr, week, numberofweek etc)
--Result Format are all integers
--Accepts 2 parameter, the part you want and the datecolumn

SELECT
	DATEPART(year, creationtime) yeardp,
	DATEPART(month, CreationTime) monthdp,
	DATEPART(day, CreationTime) daydp,
	DATEPART(week, CreationTime) weekdp,
	DATEPART(quarter, CreationTime) qtrdp,
	DATEPART(hour, CreationTime) hour
FROM Sales.Orders


--DATENAME: Returns the name of the datepart
--Result Format are all strings
SELECT 
	DATENAME(DAY, creationtime),
	DATENAME(WEEKDAY, creationtime),
	DATENAME(YEAR, creationtime),
	DATENAME(WEEK, creationtime)
FROM sales.Orders


--DATETRUNC: Truncate or shorten the specified date
SELECT DATETRUNC(MINUTE, creationtime)
FROM sales.Orders

--USE CASE: Calculates the total orders in each month
/*The query below is wrong because everything is treated
in it's own group aside the CREATIONTIME column
--SELECT
--	CreationTime,
--	DATEPART(YEAR, CreationTime) as OrderYear,
--	DATENAME(MONTH, CreationTime) as OrderMonth,
--	DATETRUNC(MONTH, CreationTime) NumofOrder,
--	COUNT(*)
--FROM Sales.Orders
--GROUP BY 
--	DATETRUNC(MONTH, CreationTime),
--	DATEPART(YEAR, CreationTime),
--	DATENAME(MONTH, CreationTime),
--	CreationTime
*/

SELECT
    DATETRUNC(MONTH, CreationTime) AS MonthStart,
    DATEPART(YEAR, CreationTime) AS OrderYear,
    DATENAME(MONTH, CreationTime) AS OrderMonth,
    COUNT(*) AS NumOfOrders
FROM Sales.Orders
GROUP BY 
    DATETRUNC(MONTH, CreationTime),
    DATEPART(YEAR, CreationTime),
    DATENAME(MONTH, CreationTime)
ORDER BY MonthStart;


SELECT 
	DATETRUNC(MONTH, CreationTime) Creation,
	COUNT(*)
FROM Sales.Orders
GROUP  BY DATETRUNC(MONTH, CreationTime);


--EOMONTH/END OF MONTH: Return the last day of the month
--Accept just 1 parameter - datecolumn

SELECT EOMONTH(CreationTime)
FROM Sales.Orders

--DATA AGGREGATION
--TASK: How many orders were placed in each year

SELECT 
	DATEPART(YEAR, CreationTime) as dpYear,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY DATEPART(YEAR, CreationTime)

--This works fine too and also prefered over the one above
SELECT
	YEAR(CreationTime) as OrderYear,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY YEAR(CreationTime)

-- Show all orders that were placed during the month of february
SELECT
	*
FROM Sales.Orders 
WHERE MONTH(CreationTime) = 2;

-- FORMAT AND CASTING
SELECT
	FORMAT(CreationTime, 'MM-dd-yyyy'),
	FORMAT(CreationTime, 'dd'), -- 01
	FORMAT(CreationTime, 'ddd'), -- Mon
	FORMAT(CreationTime, 'dddd'), -- Monday
	FORMAT(CreationTime, 'MM'), -- 01
	FORMAT(CreationTime, 'MMM'), -- Jan
	FORMAT(CreationTime, 'MMMM') -- January
FROM sales.Orders

SELECT
	OrderID,
	CreationTime,
	'Day ' + 
	FORMAT(CreationTime, 'ddd MMM') +
	' Q' + DATENAME(quarter, CreationTime) + ' ' +
	FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomeFormat 
FROM Sales.orders;
