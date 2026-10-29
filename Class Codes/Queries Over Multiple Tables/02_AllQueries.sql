USE class_codes;

-- 01: Find all products under $200 manufactured in Japan; return their names and prices. 
SELECT P.PNAME, P.PRICE
FROM PRODUCT AS P, COMPANY AS C
WHERE P.MANUFACTURER = C.CNAME
AND P.PRICE <= 200 AND C.COUNTRY = 'JAPAN';

-- 02: Find all Chinese companies that manufacture electronic products or toy.
SELECT C.CNAME
FROM PRODUCT AS P, COMPANY AS C
WHERE P.MANUFACTURER = C.CNAME
AND C.COUNTRY = 'CHINA'
AND CATEGORY IN ('ELECTRONICS', 'TOY');

-- 03: Find all countries that manufacture some product in the ‘Gadgets’ category.
SELECT DISTINCT C.COUNTRY
FROM PRODUCT AS P, COMPANY AS C
WHERE P.MANUFACTURER = C.CNAME
AND CATEGORY = 'Gadgets';

-- 04: Find those persons whose address is the same as the company address
SELECT P.PNAME, P.ADDRESS, P.WORKSFOR
FROM PERSON AS P, COMPANY2 AS C2
WHERE P.WORKSFOR = C2.CNAME
AND P.ADDRESS = C2.ADDRESS;

-- 05: Find those pair of persons who have the same addresses
SELECT P1.PNAME, P2.PNAME
FROM PERSON AS P1, PERSON AS P2
WHERE P1.ADDRESS = P2.ADDRESS
AND P1.PNAME != P2.PNAME;

-- 06: Find the model number and price of all PCs and Laptops made by manufacturer ‘B’
SELECT P.MODEL, P.PRICE
FROM PRODUCT3 AS PRD, PC AS P
WHERE PRD.MODEL = P.MODEL
AND PRD.MAKER = 'B'
UNION 
SELECT L.MODEL, L.PRICE
FROM PRODUCT3 AS PRD, LAPTOP AS L
WHERE PRD.MODEL = L.MODEL
AND PRD.MAKER = 'B';

-- 07: Find those manufacturers that sell both PCs and Laptops
SELECT MAKER
FROM PRODUCT3
WHERE TYPE = 'PC'
INTERSECT          -- supports as of MySQL 8.0.31, also supported in ORACLE
SELECT MAKER
FROM PRODUCT3
WHERE TYPE = 'LAPTOP';

-- 08: Find those manufacturers that sell Laptops, but not PCs
SELECT MAKER
FROM PRODUCT3
WHERE TYPE = 'PC'
EXCEPT              -- supports as of MySQL 8.0.31, IN ORACLE : MINUS
SELECT MAKER
FROM PRODUCT3
WHERE TYPE = 'LAPTOP';

-- 09: IF YOU WANNA OUTPUT WITH DUPLICATES THEN USE UNION ALL, INTERSECT ALL, EXCEPT ALL