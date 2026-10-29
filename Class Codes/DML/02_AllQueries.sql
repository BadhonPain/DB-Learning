USE class_codes;

-- 01: Create a table named Student
CREATE TABLE Student (
	ID CHAR(10) UNIQUE NOT NULL,
    FIRST_NAME VARCHAR(30) NOT NULL,
    LAST_NAME VARCHAR(30),
    CITY VARCHAR(30),
    STATE VARCHAR(15)
);

-- 02: Insert some suitable values in it
INSERT INTO STUDENT VALUES ('S123456789','BADHON','PAIN','HOUSTON','TEXAS');
INSERT INTO STUDENT VALUES ('S111111111','MARY','JONES','HOUSTON','TEXAS');
INSERT INTO STUDENT (ID, FIRST_NAME, LAST_NAME) VALUES ('S987654321','JANE','SMTIH');
INSERT INTO STUDENT VALUES ('S112403102', 'JON','WALKER','CHICAGO','ILLINOIS');
INSERT INTO STUDENT VALUES ('S121212121', 'AMBRY','COTTIS','LOS ANGELES','CALIFORNIA');
INSERT INTO STUDENT (ID, FIRST_NAME, LAST_NAME, CITY) VALUES ('S242526013','STEVE','JOBS','PHOENIX');
INSERT INTO STUDENT VALUES ('S112607231', 'JONNY','BAIRSTOW','SAN DIEGO','CALIFORNIA');

-- 03: Bulk Insertion in a new table (example of copy table as well)
CREATE TABLE Student_Copy AS
SELECT *
FROM STUDENT;

-- 04: Bulk Insertion in a existing table
INSERT INTO STUDENT_COPY
SELECT *
FROM STUDENT
WHERE CITY = 'LOS ANGELES';

INSERT INTO STUDENT_COPY (ID, FIRST_NAME, LAST_NAME)
SELECT ID, FIRST_NAME, LAST_NAME
FROM STUDENT
WHERE STATE = 'ILLINOIS';

-- 05: Insert the fact that for every PC there is a laptop with the same manufacturer, speed, ram, and hard disk, a 17-inch screen, a model number 1100 greater and a price $500 more 
INSERT INTO LAPTOP (MODEL, SPEED, RAM, HD, SCREEN, PRICE)
SELECT MODEL + 1100, SPEED, RAM, HD, 17, PRICE + 500
FROM PC;

INSERT INTO PRODUCT3 (MAKER,MODEL, TYPE)
SELECT MAKER, MODEL + 1100, 'LAPTOP'
FROM PRODUCT3
WHERE TYPE = 'PC';
SELECT * FROM LAPTOP2;
SELECT * FROM STUDENT;

-- 06: Create a duplicate copy of Laptop table.
CREATE TABLE LAPTOP2 AS
SELECT *
FROM LAPTOP;

-- 07: Delete Student table ( CAUTION !!!!!! )
DELETE 
FROM STUDENT;

-- 08: Delete the student info whose id is 'S987654321'
DELETE 
FROM STUDENT
WHERE ID = 'S987654321';

-- 09: Delete all PC’s with less than 100 GB hard disk
DELETE
FROM PC
WHERE HD < 100;

DELETE 
FROM PRODUCT
WHERE MODEL IN (
				SELECT MODEL
				FROM PC 
				WHERE HD < 100
				);

-- 10: Delete all laptops made by manufacturer that does not make printers
DELETE
FROM LAPTOP 
WHERE MAKER NOT IN (
					SELECT MAKER
					FROM PRODUCT
					WHERE TYPE = 'PRINTER'
					);
DELETE 
FROM PRODUCT 
WHERE TYPE = 'LAPTOP'
AND MAKER NOT IN (
					SELECT MAKER
					FROM PRODUCT
					WHERE TYPE = 'PRINTER'
					);
                    
-- 11: Update the city and state of student with id = 'S123456789' to Austin and Texas

UPDATE STUDENT
SET CITY = 'AUSTIN', STATE = 'TEXAS'
WHERE ID = 'S123456789';

-- 12: Manufacturer A buys manufacturer B. Change all products made by B so they are now made by A

UPDATE PRODUCT3
SET MAKER = 'A'
WHERE MAKER = 'B';

-- 13: For each laptop made by manufacturer B, add one inch to the screen size and subtract $100 from the price
UPDATE LAPTOP
SET SCREEN = SCREEN + 1, PRICE = PRICE - 100
WHERE MODEL IN (
				SELECT MODEL 
                FROM PRODUCT3
                WHERE TYPE = 'LAPTOP'
                AND MAKER = 'B'
				);
