USE class_codes;

-- 01: Show all entries from product table
SELECT * FROM PRODUCT;

-- 02: Show all product categories
SELECT CATEGORY
FROM PRODUCT;

-- 03: Show all product categories without duplicates
SELECT DISTINCT CATEGORY
FROM PRODUCT;

-- 04: List all products along with their price and manufacturers (without category)
SELECT PNAME, PRICE, MANUFACTURER
FROM PRODUCT;

-- 05: Duplicates from multiple columns
SELECT DISTINCT MAKER, TYPE_
FROM PRODUCT2;

-- 06: Show all product’s info that will cost more than 100 dollars
SELECT *
FROM PRODUCT 
WHERE PRICE > 100;

-- 07: Show all product’s info in the price range $100 to $200 (inclusive)
SELECT *
FROM PRODUCT 
WHERE PRICE BETWEEN 100 AND 200;

-- 08: Show all product’s info not in the price range $10 to $200 (inclusive)
SELECT *
FROM PRODUCT
WHERE PRICE NOT BETWEEN 10 AND 200;

-- 09: Show all household product’s info
SELECT *
FROM PRODUCT 
WHERE CATEGORY = 'Household';

-- 10: Show all product’s info that has ‘mo’ as a substring of the product name
SELECT *
FROM PRODUCT
WHERE PNAME LIKE '%mo%';

-- 11: Show all product’s info where the product name ends with ‘Touch’
SELECT *
FROM PRODUCT
WHERE PNAME LIKE '%Touch';

-- 12: 
SELECT * 
FROM PRODUCT 
WHERE MANUFACTURER LIKE'G_z_oWorks';

-- 13: Search for all company names having apostrophe s in the name
SELECT NAME
FROM COMPANY                          -- COMPANY TABLE DOESN'T EXISTS
WHERE NAME LIKE '%''s%';

-- 14: Search for all interest rates having percent at the end
SELECT *
FROM BANK                             -- BANK TABLE DOESN'T EXISTS
WHERE RATE LIKE '%!%' ESCAPE '!';     -- MYSQL (OR MORE SIMPLY : '%\%';)
-- WHERE RATE LIKE '%\%' ESCAPE '\';  -- ORACLE

-- 15: Search for all country names having underscore inside
SELECT NAME
FROM COUNTRY                            -- COMPANY TABLE DOESN'T EXISTS
WHERE NAME LIKE '%!_%' ESCAPE '!';      -- MYSQL (OR MORE SIMPLY : '%\_%';)
-- WHERE RATE LIKE '%\_%' ESCAPE '\';   -- ORACLE

-- 16: NOT LIKE Operator
SELECT *
FROM PRODUCT
WHERE PNAME NOT LIKE '%mo%';

-- 17: Show all household products having prices more than $100 
SELECT *
FROM PRODUCT
WHERE CATEGORY = 'Household' 
AND PRICE > 100;

-- 18 : Show all manufacturer that make photography or household items
SELECT DISTINCT MANUFACTURER
FROM PRODUCT
WHERE CATEGORY = 'Photography'
OR CATEGORY = 'Household';

-- 19: Show all manufacturer that make both photography and household items
SELECT DISTINCT MANUFACTURER
FROM PRODUCT
WHERE CATEGORY IN ('Photography', 'Household')
GROUP BY MANUFACTURER
HAVING COUNT(DISTINCT CATEGORY) >= 2;

-- 20: Display all products whose name contains "Giz" or whose category ends with "hold", and whose price is greater than 100.
SELECT *
FROM PRODUCT 
WHERE ( PNAME LIKE '%Giz%' 
OR CATEGORY LIKE '%hold' )             -- AND has higher precedence over OR that's why wee need to use brackets
AND PRICE > 100; 

-- 21: Display the products priced above 50, sorted alphabetically by product name in ascending order.
SELECT *
FROM PRODUCT 
WHERE PRICE > 50
ORDER BY PNAME;

-- 22: Display the name, price, and manufacturer of all products in the Gadgets category priced above 10, sorted first by price in ascending & then product name in descending order.
SELECT PNAME, PRICE, MANUFACTURER
FROM PRODUCT 
WHERE CATEGORY = 'Gadgets'
AND PRICE > 10
ORDER BY PRICE ASC, PNAME DESC;

-- 23: Find all albums launched in 1984 or 1996.
SELECT ALBUM
FROM CDCOLLECTION
WHERE YEAR IN (1984, 1996);     -- or : YEAR = 1984 OR YEAR = 1996

-- 24: Display all columns of CDs released in years other than 1984 and 1996.
SELECT *
FROM CDCOLLECTION
WHERE YEAR NOT IN (1984, 1996); -- or : YEAR != 1984 AND YEAR != 1996

