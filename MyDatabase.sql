/*
=============================================================
Database Creation and Table Setup Script
=============================================================
Script Purpose:
    This script creates a new SQL Server database named 'MyDatabase'. 
    If the database already exists, it is dropped to ensure a clean setup. 
    The script then creates three tables: 'customers', 'orders', and 'employees' 
    with their respective schemas, and populates them with sample data.
    
WARNING:
    Running this script will drop the entire 'MyDatabase' database if it exists, 
    permanently deleting all data within it. Proceed with caution and ensure you 
    have proper backups before executing this script.
*/

USE master;
GO

-- Drop and recreate the 'MyDatabase' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'MyDatabase')
BEGIN
    ALTER DATABASE MyDatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MyDatabase;
END;
GO

-- Create the 'MyDatabase' database
CREATE DATABASE MyDatabase;
GO

USE MyDatabase;
GO

-- ======================================================
-- Table: customers
-- ======================================================
DROP TABLE IF EXISTS customers;
GO

CREATE TABLE customers (
    id INT NOT NULL,
    first_name  VARCHAR(50) NOT NULL,
    country     VARCHAR(50),
    score       INT,
    CONSTRAINT PK_customers PRIMARY KEY (id)
);
GO

-- Insert customers data
INSERT INTO customers (id, first_name, country, score) VALUES
    (1, 'Maria',     'Germany', 350),
    (2, ' John',     'USA',     900),
    (3, 'Georg',   'UK',      750),
    (4, 'Martin', 'Germany', 500),
    (5, 'Peter',   'USA',     0);
GO

-- ======================================================
-- Table: orders
-- ======================================================
DROP TABLE IF EXISTS orders;
GO

CREATE TABLE orders (
    order_id    INT NOT NULL,
    customer_id INT NOT NULL,
    order_date  DATE,
    sales    INT,
    CONSTRAINT PK_orders PRIMARY KEY (order_id)
);
GO

-- Insert orders data
INSERT INTO orders (order_id, customer_id, order_date, sales) VALUES
    (1001, 1, '2021-01-11', 35),
    (1002, 2, '2021-04-05', 15),
    (1003, 3, '2021-06-18', 20),
    (1004, 6, '2021-08-31', 10);
GO


-- MY PERSONAL QUERY BEGINS HERE
--Retrive each customer's name, country and score.

SELECT 
	first_name, 
	country,
	score 
FROM customers;

--USING THE WHRE CLAUSE TO FILTER/CONDITONAL STATEMENT
--Retrieve customers with a score not equal to 0

SELECT	* 
FROM	customers
WHERE	score > 0

-- OR --

SELECT	* 
FROM	customers
WHERE	score != 0

--Retrieve customers from Germany

SELECT	*
FROM	customers
WHERE	country = 'Germany';

-- DATA SORTING USING THE ORDER BY CLAUSE

SELECT *
FROM customers
ORDER BY score desc;

--NESTED ORDER BY (Usually for columns with repeated data

SELECT *
FROM customers
ORDER BY country ASC, score DESC;

--Retrieve all customers and sort the result by the country and then by the hgihest score

SELECT		*
FROM		customers 
ORDER BY	country ASC, score DESC;

--GROUP BY STATEMENT, AGGREGATE A COLUMN BY ANOTHER COLUMN, IT WORKS WITH AN AGGREGATE STATEMENT
--
SELECT first_name, Country, SUM(SCORE) As 'Total Score'
FROM customers
GROUP BY country, first_name
ORDER BY [Total Score] DESC;

--Find the total score and total number of customers for each country
SELECT Country, SUM(score) As 'Total Score', COUNT(id) As 'Total Customers'
FROM customers
GROUP BY country;

--HAVING CLAUSE, Filters data after aggregation

SELECT Country, SUM(score) As 'Total Score', COUNT(id) As 'Total Customers'
FROM customers
GROUP BY country
HAVING SUM(SCORE) > 800;

--MIXING WITH THE WHERE CLAUSE and THE HAVING CLAUSE
--WHERE IS USED BEFORE THE GROUP BY STATEMENT WHILE HAVING IS AFTER THE GROUP BY STATEMENT
SELECT Country, SUM(Score) As 'Total Score'
FROM Customers
WHERE score > 400
GROUP BY country
HAVING SUM(Score) > 600;

/* Find the average score for each country considering only customers 
with a score not equal to 0 and return only those countries with an 
average score greater than 430 */

SELECT country, AVG(score) As 'Average Score'
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(Score) > 430

select *
from customers

-- THE DINSTICT STATMENT, This removes duplicate values/repeated values
-- Return unique list of all countries

SELECT DISTINCT country
FROM customers

-- TOP(LIMIT) Return the specified number of rows
--Retrieve only 3 customers
SELECT TOP 3 *
FROM customers

--Retrieve the Top 3 customers with the highest score
SELECT TOP 3 *
FROM customers
ORDER BY score DESC;

--Get the 2 most recent orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC;

--Static Values
--Values that only availabel during execution, not stored in the DB
SELECT 12345 As 'Static Value'

SELECT 'New String' As 'Static String'

--
SELECT id, first_name,
'New Customer' As 'Customer Type'
FROM customers

--DDL- DATA DEFINITION LANGUAGE (CREATE, ALTER, INSERT)
--Create a new table called persons with columns: id, person_name, birth_date, and phone

CREATE TABLE Persons (
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
);
GO

SELECT *
FROM Persons

-- DDL- ALTER
--Add a new email column
ALTER TABLE Persons
ADD email VARCHAR(50) NOT NULL

SELECT *
FROM Persons

--Remove the colum phone from the persons table
ALTER TABLE Persons
DROP COLUMN phone

SELECT *
FROM Persons

-- DDL- DROP
--Delete the table persons from the database
DROP TABLE Persons;

--DML - INSERT INTO
INSERT INTO customers (id, first_name, country, score) VALUES
(6, 'Damilola', 'Nigeria', 870);
GO

INSERT INTO customers (id, first_name, country, score) VALUES
(7, 'Ayomide', NULL, 230);
GO
--NOT SPECIFYING THE COLUMN NAME
INSERT INTO customers VALUES
(8, 'Deborah', 'France', 190);
GO


-- DML -- INSERT
--Copy data from 'customers' table into the 'persons' table
INSERT INTO Persons
SELECT 
	id,
	first_name,
	NULL,
	'Unknwown' 
FROM Customers

SELECT *
FROM Persons

--DML -- UPDATE
--Change the score of customer 6 to 0
UPDATE customers
SET	score = 980
WHERE id = 6;

UPDATE customers
SET	country = 'Switzerland'
WHERE id = 7;

SELECT *
FROM customers
WHERE id = 7

--Change the score of customer with ID 8 to 0 and update the country to UK
SELECT *
FROM customers
WHERE id = 10

UPDATE customers
SET id = 0, country = 'UK'
WHERE id = 8

SELECT *
FROM customers

--INSERT INTO customers VALUES
--	(8, 'Ife', 'Nigeria', NULL),
--	(9, 'Sam', 'Chad', NULL),
--	(10, 'James', 'Kenya', 175);

--Update all customers with a NULL score by setting their score to 0
UPDATE Customers
SET score  = 0
WHERE score IS NULL;

SELECT *
FROM Customers;

-- THE DELETE STATEMENT
-- NOTE: ALWAYS USE THE 'WHERE';
-- DELETE ALL CUSTOMER ID GREATER THAN 5

DELETE FROM customers
WHERE id > 5; 

SELECT *
FROM customers;

--Delete all data from table persons
DELETE FROM persons;

TRUNCATE TABLE persons;
/*NOTE: They (DELETE & TRUNCATE) both do same the thing, but TRUNCATE is faster, 
no protocols or loggin checks */

--WHERE CONDITIONS - COMPARISON CONDITION
--Retrieve all customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';

--Retrieve all customers NOT from Germany
SELECT *
FROM customers
WHERE country != 'Germany';

-- OR WE DO IT THIS WAY --

SELECT *
FROM customers
WHERE country <> 'Germany';

-- OR

SELECT *
FROM customers
WHERE NOT country = 'Germany';

--Retrieve all customers with a score greater than 500.
SELECT *
FROM customers
WHERE score > 500;

--Retrieve all customers with a score of 500 or more
SELECT *
FROM customers
WHERE score >= 500;

--Retrieve all customers with a score less than 500
SELECT *
FROM customers
WHERE score < 500;

--Retrieve all customers with a score of 500 or less
SELECT *
FROM customers
WHERE score <= 500;

--LOGICAL OPERATOR
--AND, OR, NOT
--AND: All conditions MUST be TRUE
--Retrieve all customers who are from USA and have a score higher than 500.
SELECT *
FROM customers
WHERE country = 'USA' AND score > 500;

--OR OPERATOR: At least one condition must be TRUE
--
SELECT * 
FROM customers
WHERE country = 'USA' OR score > 500;

--NOT OPERATOR: Reverse the condition
--If condition is TRUE, return FALSE
--If condition is FALSE, return TRUE

SELECT *
FROM customers
WHERE NOT country = 'USA';


--RANGE OPERATOR
--BETWEEN
--Retrieve all customers whose score falls in the range between 100 and 500
SELECT *
FROM customers
WHERE  score BETWEEN 100 AND 500;

SELECT *
FROM customers
WHERE score >=100 AND score <=500;
--------------------------

--IN OPERATOR
--Check if value exist in a list
--Retrieve all customers from either Germany or USA

SELECT *
FROM customers
WHERE country = 'Germany' OR country = 'USA'; /*This works too but longer and more 
processing time */

SELECT *
FROM customers
WHERE country IN ('USA', 'Germany'); --This works best, shorter and short processing time

--The Reverse -- NOT IN
SELECT *
FROM customers
WHERE country NOT IN ('USA', 'Germany');

--SEARCH OPERATOR/WILD CARD
--LIKE: Search for a pattern in a text
--Find all customers whose first name starts with the letter M
SELECT *
FROM customers
WHERE first_name LIKE 'm%'

--Find all customers whose first name ends with the letter N
SELECT *
FROM customers
WHERE first_name LIKE '%n';

--Find all customers whose first name contains the letter R
SELECT *
FROM customers
WHERE first_name LIKE '%r%';

--Find all customers whose first name has 'r' in the third position
SELECT *
FROM customers
WHERE first_name    LIKE '__r%';

--JOINS/TYPES OF JOINS
--BASIC TYPES (INNER , LEFT, RIGHT, NO JOIN)
--Retrieve all data from customerrs and orders in two different results. 
--NO JOIN--
SELECT *
FROM customers;

SELECT *
FROM orders;

--INNER JOIN: Only matching rows from both table
/*Get all customers along their orders but only for customers who have placed an order */
 
SELECT 
	c.id, 
	c.first_name, 
	o.order_id, 
	o.order_date,
	o.sales
FROM customers as c
INNER JOIN orders AS o
	ON c.id = o.customer_id
ORDER BY sales ASC;
-- ///////////////////////////////////////////// --
--The above query is the best for this task

--SELECT *
--FROM customers
--INNER JOIN orders
--ON customer_id=id


--LEFT JOIN
/* Return all rows from the left and only matching rows from the right */
/* Order of tables matter */
/* Table 1 = Left Table = Primary Data Source */
/* Table 2 = Right Table = Additional Data Source */

/*Get all customers along their orders but only for customers who have placed an order */
 
SELECT 
	c.id, 
	c.first_name, 
	o.order_id, 
	o.order_date,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
	ON c.id = o.customer_id

/* USE [MyDatabase]-- This automatically select and activate my pereferred-named DB */

--RIGHT JOIN
/* Return all rows from the right and only matching rows from the left */
/* Order of tables matter */
/* Table 1 = Left Table = Additional Data Source */
/* Table 2 = Right Table = Primary Data Source */

/*Get all customers along their orders but only for customers who have placed an order */
 
SELECT 
	c.id, 
	c.first_name, 
	o.order_id, 
	o.order_date,
	o.sales
FROM customers as c
RIGHT JOIN orders AS o
	ON c.id = o.customer_id;


SELECT *
FROM customers

--DELETE FROM customers
--WHERE id IN (0,5,6,7);

/* Task: Get all customers along with their orders including orders 
without matching customers using LEFT JOIN */
SELECT 
	c.id, 
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
LEFT JOIN customers AS c
ON c.id = o.customer_id 

--FULL JOIN
/* Returns all rows from both table */
SELECT 
	c.id, 
	c.first_name,
	o.order_id,
	o.sales
FROM customers as c
FULL JOIN orders AS o
ON c.id = o.customer_id 

/* ADVANCED SQL JOINS */
--LEFT ANTI JOIN
/* Returns rows from left that have NO MATCH in right */

SELECT *
FROM customers AS c
LEFT JOIN orders as o
ON  c.id = o.customer_id
WHERE o.customer_id IS NULL


--RIGHT ANTI JOIN
/* Returns rows from right that have NO MATCH in left */
--Get all orders without matching customers

SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON  c.id = o.customer_id
WHERE c.id IS NULL;



SELECT *
FROM orders
SELECT *
FROM customers
WHERE country IS NULL;

--USE [MyDatabase]
--GO

--INSERT INTO orders VALUES
--	(5, '', NULL, 101),
--	(6, '', NULL, NULL);

--UPDATE customers
--SET first_name = 'Elisha'
--WHERE id IN (6);

--SELECT *
--FROM customers

--FULL ANTI JOIN
-- Returns only rows that do not match in either table
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL 
	OR o.order_id IS NULL;


--CHALLENGE
/* Get all customers along with their orders,
but only for customers who have placed an order
(WITHOUT USING INNER JOIN) */

--SELECT *
--FROM customers AS c
--INNER JOIN orders AS o
--	ON c.id = o.customer_id;

SELECT *
FROM customers AS c
FULL JOIN orders AS o
	ON c.id = o.customer_id
WHERE o.order_id IS NOT NULL;

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
	ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;


SELECT *
FROM ORDERS

--CROSS JOIN

SELECT *
FROM customers
CROSS JOIN orders;