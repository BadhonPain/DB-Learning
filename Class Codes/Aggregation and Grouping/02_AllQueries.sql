USE class_codes;

-- 01: Find day-wise sale of each products
SELECT PRODUCT, DAY, PRICE*QUANTITY AS SALES
FROM PURCHASE;

-- 02: Aggregation Example
SELECT AVG(PRICE*QUANTITY) AS AVG_SALES
FROM PURCHASE
WHERE PRODUCT = 'BAGEL';

SELECT COUNT(*) AS 'PRODCUTS MADE BY C'
FROM PRODUCT3
WHERE MAKER = 'C';

-- 03: Find total sales
SELECT SUM(PRICE*QUANTITY) AS TOTAL_SALES
FROM PURCHASE;

-- 04: Find total sales of product Bagel
SELECT SUM(PRICE*QUANTITY) AS 'TOTAL_SALES OF BAGEL'
FROM PURCHASE
WHERE PRODUCT = 'BAGEL';

-- 05: Find total sales after 10/04/2005 per product.
SELECT PRODUCT, SUM(PRICE*QUANTITY) AS 'TOTAL SALES'
FROM PURCHASE
WHERE DAY > '2005-10-04'
GROUP BY PRODUCT;

-- 06: Find all products and their total sales which were sold at least 30 pieces after 10/04/2005. 
SELECT PRODUCT, SUM(PRICE*QUANTITY) AS 'TOTAL SALES'
FROM PURCHASE
WHERE DAY > '2005-10-04'
GROUP BY PRODUCT
HAVING SUM(QUANTITY) >= 30;

-- 07: Find the manufacturers that make at least three different models of PCs
SELECT MAKER
FROM PRODUCT3
WHERE TYPE = 'PC'
GROUP BY MAKER
HAVING COUNT(DISTINCT MODEL) >= 3;

-- 08: Find all manufacturers that produce all three types of products (pc, printer, laptop)
SELECT MAKER
FROM PRODUCT3
GROUP BY MAKER
HAVING COUNT(DISTINCT TYPE) = 3;

-- 09: Find all manufacturers that produce only one product type and more than one model 
SELECT MAKER
FROM PRODUCT3
GROUP BY MAKER
HAVING COUNT(DISTINCT TYPE) = 1
AND COUNT(DISTINCT MODEL) > 1;

-- 10: Find the average speed of PCs
SELECT AVG(SPEED) AS AVG_SPEED
FROM PC;

-- 11: Find the average price of PCs made by manufacturer ‘A’
SELECT AVG(PC.PRICE) AS AVG_PRICE
FROM PRODUCT3 INNER JOIN PC
ON PRODUCT3.MODEL = PC.MODEL
WHERE PRODUCT3.MAKER = 'A';

-- 12: Find for each speed of PC above 2.0, the average price
SELECT SPEED, AVG(PRICE) AS AVG_PRICE
FROM PC
WHERE SPEED > 2
GROUP BY SPEED;

-- 13: Find for each manufacturer who sell’s PCs the maximum price of a PC
SELECT MAKER, MAX(PC.PRICE)
FROM PRODUCT3 INNER JOIN PC
ON PRODUCT3.MODEL = PC.MODEL
WHERE PRODUCT3.TYPE = 'PC'
GROUP BY MAKER;
