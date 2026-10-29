USE class_codes;

-- 01: Find the employee(s) with the highest paid salary
SELECT *
FROM EMPLOYEE
WHERE SALARY = (
				SELECT MAX(SALARY)
                FROM EMPLOYEE
                );

-- WITHOUT AGGREGATE FUNCTION :
SELECT *
FROM EMPLOYEE
WHERE SALARY >= ALL (
				SELECT SALARY
                FROM EMPLOYEE
                );

-- WITH CO-RELEATED SUB-QUERIES :
SELECT *
FROM EMPLOYEE
WHERE SALARY > ALL (
					SELECT SALARY
                    FROM EMPLOYEE
                    WHERE SALARY < ANY (
										SELECT SALARY
										FROM EMPLOYEE
										)
					);

-- 02: Find the highest paid employee(s) in each department
SELECT ID, DEPT
FROM EMPLOYEE
WHERE (DEPT, SALARY) IN (
				SELECT DEPT, MAX(SALARY)
                FROM EMPLOYEE
                GROUP BY DEPT
                );
	
-- 03: Find the employees that earn above average
SELECT *
FROM EMPLOYEE
WHERE SALARY > (
				SELECT AVG(SALARY)
                FROM EMPLOYEE
                );

-- 04: Find the employees that earn above average of the employees within respective department 
SELECT *
FROM EMPLOYEE E1
WHERE SALARY > (
				SELECT AVG(SALARY)
                FROM EMPLOYEE E2
                WHERE E1.DEPT = E2.DEPT
                );
                
-- 05: Find all manufacturers that make both PC and Laptop
SELECT DISTINCT P.MAKER
FROM PCFORJOIN AS P
WHERE EXISTS (
				SELECT L.MAKER
                FROM LAPTOPFORJOIN AS L
                WHERE P.MAKER = L.MAKER
                );

-- 06: Find all manufacturers that make PCs but not Laptops
SELECT DISTINCT P.MAKER
FROM PCFORJOIN AS P
WHERE NOT EXISTS (
					SELECT L.MAKER
                    FROM LAPTOPFORJOIN AS L
                    WHERE P.MAKER = L.MAKER
                    );
                   
                   select * FROM PC;
                   
-- 07: Find the PC model with maximum processing speed using and without using aggregate function
SELECT P1.MODEL
FROM PC AS P1
WHERE P1.SPEED = (
					SELECT MAX(P2.SPEED)
                    FROM PC AS P2
                    );
                    
-- WITHOUT USING AGGREGATE FUNCTION:
SELECT MODEL
FROM PC
WHERE SPEED >= ALL (
					SELECT SPEED
                    FROM PC
                    );
                    
-- ANOTHER WITH CO-RELATED SUB-QUERIES:
SELECT MODEL
FROM PC
WHERE SPEED > ALL (
					SELECT SPEED
                    FROM PC
                    WHERE SPEED < ANY (
										SELECT SPEED 
                                        FROM PC
										)
					);
                    
-- 08: Find manufacturers of at least two different computers (PC’s or laptops) with speeds of at least 2.0
SELECT MAKER
FROM (
		SELECT PC.MODEL, PRODUCT3.MAKER
        FROM PRODUCT3 NATURAL JOIN PC
        WHERE PC.SPEED >= 2
        UNION
        SELECT LAPTOP.MODEL, PRODUCT3.MAKER
        FROM PRODUCT3 NATURAL JOIN LAPTOP
        WHERE LAPTOP.SPEED >= 2
	) AS COMBINED_TABLE
GROUP BY MAKER
HAVING COUNT(DISTINCT MODEL) >= 2;
SELECT * FROM PC;

-- 09: SOLVING PROBLEM 08 BREAKING DOWN

-- step 01: Find manufacturer of at least two different PCs with speed of at least 2.0
SELECT MAKER
FROM PRODUCT3 NATURAL JOIN PC
WHERE PC.SPEED >= 2
GROUP BY PRODUCT3.MAKER
HAVING COUNT(DISTINCT MODEL) >= 2;

-- WITH SUB-QUERY:
SELECT MAKER
FROM PRODUCT3
WHERE MODEL IN (
				SELECT MODEL
                FROM PC
                WHERE SPEED >= 2
                )
GROUP BY MAKER
HAVING COUNT(DISTINCT MODEL) >= 2;

-- step 02: Find manufacturer of at least two different LAPTOPs with speed of at least 2.0
SELECT MAKER
FROM PRODUCT3 NATURAL JOIN LAPTOP
WHERE LAPTOP.SPEED >= 2
GROUP BY PRODUCT3.MAKER
HAVING COUNT(DISTINCT MODEL) >= 2;

-- step 03: combine them
SELECT MAKER
FROM PRODUCT3 NATURAL JOIN (
							SELECT MODEL, SPEED FROM PC
                            WHERE PC.SPEED >= 2
                            UNION
                            SELECT MODEL, SPEED FROM LAPTOP
                            WHERE LAPTOP.SPEED >= 2
                            ) AS COMBINED
GROUP BY MAKER
HAVING COUNT(DISTINCT MODEL) >= 2;

-- A BETTER MERGE :
SELECT MAKER
FROM PRODUCT3 NATURAL JOIN (
							SELECT MODEL, SPEED FROM PC
                            UNION
                            SELECT MODEL, SPEED FROM LAPTOP
                            ) AS COMBINED
WHERE PRODUCT3.MODEL = COMBINED.MODEL
AND SPEED >= 2
GROUP BY MAKER
HAVING COUNT(DISTINCT COMBINED.MODEL) >= 2;