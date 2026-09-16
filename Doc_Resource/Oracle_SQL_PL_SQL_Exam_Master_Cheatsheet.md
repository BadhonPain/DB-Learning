# Oracle SQL + PL/SQL Exam Master Cheatsheet
### CSE 216 / Oracle — Basic SQL → Advanced SQL → PL/SQL

> **Purpose:** A practical, exam-oriented reference for writing Oracle SQL and PL/SQL under time pressure.
>
> This cheatsheet is based on the recurring patterns in the supplied CSE 216 question bank covering **2017–2023**. The archive repeatedly uses procedures, functions, cursors, DML triggers, multi-table joins, self-joins, aggregation/ranking, salary/business-rule validation, audit/history tables, `ROWNUM`/top-1 logic, and exception handling.  
> Source: supplied question bank, which identifies coverage from 2017–2023 and these recurring categories. 

---

# 0. THE ONE SQL ORDER YOU MUST MEMORIZE

Even though you **write** SQL like this:

```sql
SELECT ...
FROM ...
JOIN ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...
FETCH ...
```

Oracle logically processes it roughly like:

```text
FROM / JOIN
      ↓
WHERE
      ↓
GROUP BY
      ↓
HAVING
      ↓
SELECT
      ↓
DISTINCT
      ↓
ORDER BY
      ↓
FETCH
```

### The most important rule

```text
WHERE  → filters individual ROWS before grouping
HAVING → filters GROUPS after GROUP BY
```

Example:

```sql
SELECT department_id, AVG(salary)
FROM employees
WHERE salary > 3000
GROUP BY department_id
HAVING AVG(salary) > 5000
ORDER BY AVG(salary) DESC;
```

Meaning:

1. Ignore employees with salary <= 3000.
2. Group remaining employees by department.
3. Calculate average salary of each department.
4. Keep departments whose average > 5000.
5. Sort them.

---

# 1. BASIC SELECT

## Select everything

```sql
SELECT *
FROM employees;
```

## Select specific columns

```sql
SELECT employee_id, first_name, salary
FROM employees;
```

## Alias

```sql
SELECT first_name AS name,
       salary AS monthly_salary
FROM employees;
```

Oracle also allows:

```sql
SELECT first_name name
FROM employees;
```

## Remove duplicates

```sql
SELECT DISTINCT department_id
FROM employees;
```

---

# 2. WHERE — FILTER ROWS

```sql
SELECT *
FROM employees
WHERE salary > 5000;
```

## Operators

```text
=       equal
<>      not equal
!=      not equal
>       greater
<       smaller
>=      greater/equal
<=      smaller/equal
```

## AND / OR / NOT

```sql
SELECT *
FROM employees
WHERE salary > 5000
AND department_id = 10;
```

```sql
SELECT *
FROM employees
WHERE department_id = 10
   OR department_id = 20;
```

Use parentheses when mixing:

```sql
WHERE (department_id = 10 OR department_id = 20)
AND salary > 5000;
```

---

# 3. BETWEEN

```sql
SELECT *
FROM employees
WHERE salary BETWEEN 3000 AND 7000;
```

`BETWEEN` is inclusive:

```text
3000 <= salary <= 7000
```

Dates:

```sql
WHERE hire_date BETWEEN DATE '2020-01-01' AND DATE '2023-12-31'
```

---

# 4. IN

Instead of:

```sql
WHERE department_id = 10
   OR department_id = 20
   OR department_id = 30
```

write:

```sql
WHERE department_id IN (10, 20, 30);
```

---

# 5. LIKE — STRING PATTERN

```text
%  → any number of characters
_  → exactly one character
```

Starts with A:

```sql
WHERE first_name LIKE 'A%';
```

Ends with n:

```sql
WHERE first_name LIKE '%n';
```

Contains "an":

```sql
WHERE first_name LIKE '%an%';
```

Exactly 4 characters:

```sql
WHERE first_name LIKE '____';
```

Second character is `a`:

```sql
WHERE first_name LIKE '_a%';
```

Case-insensitive:

```sql
WHERE UPPER(first_name) LIKE 'A%';
```

Very common exam pattern:

```sql
WHERE UPPER(department_name) = 'ACCOUNTING';
```

---

# 6. NULL — VERY IMPORTANT

Never write:

```sql
WHERE commission_pct = NULL
```

Wrong.

Use:

```sql
WHERE commission_pct IS NULL;
```

Not null:

```sql
WHERE commission_pct IS NOT NULL;
```

## NVL

Replace NULL with a value:

```sql
NVL(commission_pct, 0)
```

Example:

```sql
SELECT first_name,
       salary + salary * NVL(commission_pct, 0)
FROM employees;
```

## NVL2

```sql
NVL2(commission_pct, 'HAS COMMISSION', 'NO COMMISSION')
```

---

# 7. COMMON STRING FUNCTIONS

```sql
UPPER(first_name)
LOWER(first_name)
INITCAP(first_name)
LENGTH(first_name)
SUBSTR(first_name, 1, 3)
INSTR(first_name, 'a')
TRIM(first_name)
REPLACE(first_name, 'a', 'x')
```

Example:

```sql
SELECT UPPER(first_name),
       LENGTH(first_name),
       SUBSTR(first_name, 1, 3)
FROM employees;
```

Concatenation:

```sql
SELECT first_name || ' ' || last_name AS full_name
FROM employees;
```

---

# 8. NUMBER FUNCTIONS

```sql
ROUND(123.456, 2)     -- 123.46
TRUNC(123.456, 2)     -- 123.45
CEIL(10.2)            -- 11
FLOOR(10.8)           -- 10
ABS(-50)              -- 50
MOD(10, 3)            -- 1
POWER(2, 3)           -- 8
```

Very common:

```sql
ROUND(AVG(salary), 2)
```

---

# 9. DATE FUNCTIONS — EXAM FAVORITES

Current date/time:

```sql
SYSDATE
```

Years of service:

```sql
MONTHS_BETWEEN(SYSDATE, hire_date) / 12
```

Whole years:

```sql
FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date) / 12)
```

Add months:

```sql
ADD_MONTHS(hire_date, 12)
```

Last day:

```sql
LAST_DAY(hire_date)
```

Next weekday:

```sql
NEXT_DAY(SYSDATE, 'FRIDAY')
```

Date formatting:

```sql
TO_CHAR(hire_date, 'DD-MON-YYYY')
```

Date to string:

```sql
TO_CHAR(SYSDATE, 'YYYY-MM-DD')
```

String to date:

```sql
TO_DATE('2025-01-15', 'YYYY-MM-DD')
```

---

# 10. AGGREGATE FUNCTIONS

```sql
COUNT(*)
COUNT(column)
COUNT(DISTINCT column)
SUM(column)
AVG(column)
MIN(column)
MAX(column)
```

Example:

```sql
SELECT COUNT(*),
       AVG(salary),
       MIN(salary),
       MAX(salary),
       SUM(salary)
FROM employees;
```

## Important COUNT difference

```sql
COUNT(*)          -- counts rows
COUNT(commission_pct) -- counts non-NULL commission values
```

---

# 11. GROUP BY

Basic:

```sql
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id;
```

Multiple columns:

```sql
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id, job_id;
```

### Golden rule

If you write:

```sql
SELECT department_id, job_id, AVG(salary)
```

then non-aggregate selected columns generally need to appear in:

```sql
GROUP BY department_id, job_id
```

---

# 12. HAVING

Wrong:

```sql
WHERE AVG(salary) > 5000
```

Correct:

```sql
GROUP BY department_id
HAVING AVG(salary) > 5000;
```

Common:

```sql
SELECT manager_id,
       COUNT(*) AS employee_count,
       AVG(salary) AS avg_salary
FROM employees
GROUP BY manager_id
HAVING COUNT(*) > 3
   AND AVG(salary) < 6000;
```

This exact pattern is highly relevant to the supplied question bank: manager/subordinate count + average salary + ranking appears in the archive. 

---

# 13. ORDER BY

Ascending:

```sql
ORDER BY salary ASC;
```

Descending:

```sql
ORDER BY salary DESC;
```

Multiple:

```sql
ORDER BY salary DESC, hire_date ASC;
```

By alias:

```sql
SELECT salary * 12 AS annual_salary
FROM employees
ORDER BY annual_salary DESC;
```

---

# 14. TOP 1 / TOP N IN ORACLE

## Modern Oracle

```sql
SELECT *
FROM employees
ORDER BY salary DESC
FETCH FIRST 1 ROW ONLY;
```

Top 5:

```sql
SELECT *
FROM employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;
```

## Classic Oracle exam trick

```sql
SELECT *
FROM (
    SELECT *
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM = 1;
```

### VERY IMPORTANT

This is dangerous:

```sql
SELECT *
FROM employees
WHERE ROWNUM = 1
ORDER BY salary DESC;
```

It can select a row **before** sorting.

Use the subquery:

```sql
SELECT *
FROM (
    SELECT *
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM = 1;
```

The supplied archive repeatedly uses this pattern for "lowest paid", "highest paid", closest match, etc. 

---

# 15. JOINS — MASTER THIS

Suppose:

```text
employees.department_id
        ↓
departments.department_id
```

## INNER JOIN

Only matching rows:

```sql
SELECT e.employee_id,
       e.first_name,
       d.department_name
FROM employees e
JOIN departments d
  ON e.department_id = d.department_id;
```

---

# 16. JOIN 3 TABLES

```sql
SELECT e.first_name,
       d.department_name,
       l.city
FROM employees e
JOIN departments d
  ON e.department_id = d.department_id
JOIN locations l
  ON d.location_id = l.location_id;
```

---

# 17. JOIN MANY TABLES

Typical HR chain:

```text
employees
   ↓
departments
   ↓
locations
   ↓
countries
   ↓
regions
```

```sql
SELECT e.first_name || ' ' || e.last_name AS name,
       j.job_title,
       e.hire_date,
       c.country_name,
       d.department_name,
       l.city,
       r.region_name
FROM employees e
JOIN jobs j
  ON e.job_id = j.job_id
JOIN departments d
  ON e.department_id = d.department_id
JOIN locations l
  ON d.location_id = l.location_id
JOIN countries c
  ON l.country_id = c.country_id
JOIN regions r
  ON c.region_id = r.region_id
WHERE UPPER(r.region_name) = UPPER('Europe');
```

This multi-table chain is directly represented in the supplied archive. 

---

# 18. LEFT JOIN

Keep every row from the left table:

```sql
SELECT e.employee_id,
       e.first_name,
       j.job_title
FROM employees e
LEFT JOIN jobs j
  ON e.job_id = j.job_id;
```

If job doesn't exist, employee still appears and job columns become NULL.

---

# 19. RIGHT JOIN

```sql
SELECT e.first_name,
       d.department_name
FROM employees e
RIGHT JOIN departments d
  ON e.department_id = d.department_id;
```

Keeps all departments.

---

# 20. FULL OUTER JOIN

```sql
SELECT *
FROM employees e
FULL OUTER JOIN departments d
  ON e.department_id = d.department_id;
```

Keeps unmatched rows from both sides.

---

# 21. SELF JOIN — EXTREMELY IMPORTANT

Employee → manager is often the same table.

```text
employees e  = employee
employees m  = manager
```

```sql
SELECT e.first_name AS employee,
       m.first_name AS manager
FROM employees e
JOIN employees m
  ON e.manager_id = m.employee_id;
```

This pattern appears repeatedly in the question bank for manager/subordinate problems. 

---

# 22. SELF JOIN + GROUP BY

Find managers and their subordinate statistics:

```sql
SELECT m.employee_id AS manager_id,
       m.first_name || ' ' || m.last_name AS manager_name,
       COUNT(e.employee_id) AS subordinate_count,
       AVG(e.salary) AS avg_subordinate_salary
FROM employees m
JOIN employees e
  ON e.manager_id = m.employee_id
GROUP BY m.employee_id,
         m.first_name,
         m.last_name;
```

Filter groups:

```sql
HAVING COUNT(e.employee_id) > 3
AND AVG(e.salary) < 6000;
```

---

# 23. SUBQUERY — BASIC

Employees earning above average:

```sql
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

---

# 24. SUBQUERY WITH IN

```sql
SELECT *
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location_id = 1700
);
```

---

# 25. EXISTS

```sql
SELECT *
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM employees x
    WHERE x.manager_id = e.employee_id
);
```

Meaning:

> Select employees for whom at least one subordinate exists.

---

# 26. NOT EXISTS

```sql
SELECT *
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);
```

Meaning:

> Departments with no employees.

---

# 27. CORRELATED SUBQUERY

The inner query refers to the outer query.

```sql
SELECT e.*
FROM employees e
WHERE salary > (
    SELECT AVG(x.salary)
    FROM employees x
    WHERE x.department_id = e.department_id
);
```

Meaning:

> Employees whose salary is greater than the average salary of their own department.

---

# 28. MIN / MAX WITH CONDITIONS

Lowest salary in a particular job:

```sql
SELECT MIN(salary)
FROM employees
WHERE job_id = 5;
```

Find employee with lowest salary:

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
);
```

---

# 29. CASE — VERY IMPORTANT

Basic:

```sql
SELECT first_name,
       salary,
       CASE
           WHEN salary >= 10000 THEN 'HIGH'
           WHEN salary >= 5000 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS salary_level
FROM employees;
```

## CASE inside UPDATE

```sql
UPDATE employees
SET salary =
    CASE
        WHEN salary < 3000 THEN salary * 1.20
        WHEN salary < 6000 THEN salary * 1.10
        ELSE salary
    END;
```

## CASE with dates/tenure

```sql
CASE
    WHEN MONTHS_BETWEEN(SYSDATE, hire_date) / 12 >= 10
        THEN 'SENIOR'
    WHEN MONTHS_BETWEEN(SYSDATE, hire_date) / 12 >= 5
        THEN 'MID'
    ELSE 'JUNIOR'
END
```

---

# 30. DECODE

Oracle-specific alternative to simple CASE:

```sql
SELECT department_id,
       DECODE(department_id,
              10, 'ACCOUNTING',
              20, 'RESEARCH',
              30, 'SALES',
              'OTHER')
FROM employees;
```

For complicated conditions, prefer `CASE`.

---

# 31. SET OPERATIONS

## UNION

Combines and removes duplicates:

```sql
SELECT employee_id FROM employees
UNION
SELECT employee_id FROM managers;
```

## UNION ALL

Keeps duplicates:

```sql
SELECT employee_id FROM employees
UNION ALL
SELECT employee_id FROM managers;
```

## INTERSECT

Common rows:

```sql
SELECT employee_id FROM employees
INTERSECT
SELECT employee_id FROM managers;
```

## MINUS

Oracle equivalent commonly used for set difference:

```sql
SELECT employee_id FROM employees
MINUS
SELECT employee_id FROM managers;
```

---

# 32. CREATE TABLE

```sql
CREATE TABLE students (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    age NUMBER
);
```

---

# 33. COPY TABLE

## Copy structure + data

```sql
CREATE TABLE employees_copy AS
SELECT *
FROM employees;
```

This is extremely useful in lab exams and appears directly in the supplied archive. 

## Copy selected columns

```sql
CREATE TABLE employees_copy AS
SELECT employee_id, first_name, salary
FROM employees;
```

## Copy only structure / no rows

```sql
CREATE TABLE employees_copy AS
SELECT *
FROM employees
WHERE 1 = 0;
```

### Important

`CREATE TABLE AS SELECT` does **not** automatically reproduce all original constraints/indexes in the same way as the source table.

---

# 34. INSERT

```sql
INSERT INTO employees_copy
VALUES (101, 'John', 5000);
```

Specific columns:

```sql
INSERT INTO employees_copy
    (employee_id, first_name, salary)
VALUES
    (101, 'John', 5000);
```

Insert from SELECT:

```sql
INSERT INTO employees_copy
SELECT *
FROM employees
WHERE department_id = 10;
```

---

# 35. UPDATE

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department_id = 10;
```

Multiple columns:

```sql
UPDATE employees
SET salary = salary * 1.10,
    department_id = 20
WHERE employee_id = 101;
```

---

# 36. DELETE

```sql
DELETE FROM employees
WHERE employee_id = 101;
```

Delete all rows:

```sql
DELETE FROM employees;
```

---

# 37. TRUNCATE

```sql
TRUNCATE TABLE employees;
```

Quickly removes all rows.

Difference:

```text
DELETE     → DML, can use WHERE
TRUNCATE   → DDL, no WHERE
DROP       → removes table itself
```

---

# 38. ALTER TABLE

Add column:

```sql
ALTER TABLE employees
ADD phone VARCHAR2(20);
```

Modify:

```sql
ALTER TABLE employees
MODIFY phone VARCHAR2(30);
```

Drop:

```sql
ALTER TABLE employees
DROP COLUMN phone;
```

---

# 39. CONSTRAINTS

```sql
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
```

Example:

```sql
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    salary NUMBER CHECK (salary > 0),
    department_id NUMBER,
    CONSTRAINT emp_dept_fk
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);
```

---

# 40. MERGE — VERY USEFUL ADVANCED OPERATION

```sql
MERGE INTO target t
USING source s
ON (t.employee_id = s.employee_id)

WHEN MATCHED THEN
    UPDATE SET
        t.salary = s.salary

WHEN NOT MATCHED THEN
    INSERT (employee_id, salary)
    VALUES (s.employee_id, s.salary);
```

The supplied archive also uses `MERGE` inside trigger-related logic to maintain department salary summaries. 

---

# 41. ANALYTIC FUNCTIONS — HIGH-VALUE

## ROW_NUMBER

```sql
SELECT employee_id,
       salary,
       ROW_NUMBER() OVER (
           ORDER BY salary DESC
       ) AS rn
FROM employees;
```

## RANK

```sql
RANK() OVER (ORDER BY salary DESC)
```

Ties receive same rank, with gaps.

```text
Salary: 100, 100, 90

RANK:
1, 1, 3
```

## DENSE_RANK

```sql
DENSE_RANK() OVER (ORDER BY salary DESC)
```

No gaps:

```text
1, 1, 2
```

The question bank explicitly uses `DENSE_RANK()` for employee salary ranking. 

---

# 42. RANK WITHIN EACH DEPARTMENT

```sql
SELECT employee_id,
       department_id,
       salary,
       DENSE_RANK() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS dept_rank
FROM employees;
```

This is one of the most useful advanced SQL patterns for PL/SQL exams.

---

# 43. TOP N PER GROUP

Example: top 2 employees per department.

```sql
SELECT *
FROM (
    SELECT e.*,
           ROW_NUMBER() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rn
    FROM employees e
)
WHERE rn <= 2;
```

If ties should share rank:

```sql
DENSE_RANK() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)
```

---

# 44. FETCH FIRST

```sql
SELECT *
FROM employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;
```

With ties:

```sql
FETCH FIRST 5 ROWS WITH TIES;
```

---

# 45. LISTAGG

Combine multiple rows into one string:

```sql
SELECT department_id,
       LISTAGG(first_name, ', ')
       WITHIN GROUP (ORDER BY first_name) AS employees
FROM employees
GROUP BY department_id;
```

---

# 46. ROLLUP

```sql
SELECT department_id,
       SUM(salary)
FROM employees
GROUP BY ROLLUP(department_id);
```

Produces department totals + grand total.

---

# 47. CUBE

```sql
SELECT department_id,
       job_id,
       SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id);
```

Produces combinations of subtotals.

---

# 48. DUAL

Oracle's one-row utility table:

```sql
SELECT SYSDATE
FROM dual;
```

```sql
SELECT 2 + 3
FROM dual;
```

```sql
SELECT 'Hello'
FROM dual;
```

Very useful inside PL/SQL/SQL expressions.

---

# 49. COMMON ORACLE SQL TRICKS

## Absolute difference

```sql
ABS(salary - 5000)
```

Find closest salary:

```sql
SELECT *
FROM (
    SELECT employee_id,
           ABS(salary - 5000) AS diff
    FROM employees
    ORDER BY diff
)
WHERE ROWNUM = 1;
```

The supplied question bank uses `ABS(...)` + ordered subquery + `ROWNUM = 1` for closest-salary/subordinate matching problems. 

## Conditional count

```sql
COUNT(CASE WHEN salary > 5000 THEN 1 END)
```

## Conditional sum

```sql
SUM(
    CASE
        WHEN department_id = 10 THEN salary
        ELSE 0
    END
)
```

## Conditional average

```sql
AVG(
    CASE
        WHEN salary > 5000 THEN salary
    END
)
```

---

# 50. SQL INSIDE PL/SQL — THE MOST IMPORTANT CONCEPT

PL/SQL is basically:

```text
SQL + variables + IF + LOOP + procedures + functions + exceptions + triggers
```

You can write normal SQL inside PL/SQL.

Example:

```sql
DECLARE
    v_salary NUMBER;
BEGIN

    SELECT salary
    INTO v_salary
    FROM employees
    WHERE employee_id = 101;

    DBMS_OUTPUT.PUT_LINE(v_salary);

END;
/
```

### Golden rule

In PL/SQL:

```sql
SELECT column
INTO variable
FROM table;
```

A normal `SELECT` that returns a value needs `INTO`.

---

# 51. PL/SQL BASIC BLOCK

```sql
SET SERVEROUTPUT ON;

DECLARE
    v_name VARCHAR2(100);
    v_salary NUMBER;
BEGIN

    SELECT first_name, salary
    INTO v_name, v_salary
    FROM employees
    WHERE employee_id = 101;

    DBMS_OUTPUT.PUT_LINE(
        v_name || ' earns ' || v_salary
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
```

---

# 52. VARIABLE DECLARATION

```sql
DECLARE
    v_salary NUMBER;
    v_name VARCHAR2(100);
    v_date DATE;
    v_found BOOLEAN := FALSE;
BEGIN
    ...
END;
/
```

---

# 53. `%TYPE` — VERY IMPORTANT TRICK

Instead of guessing datatype:

```sql
v_salary NUMBER;
```

use:

```sql
v_salary employees.salary%TYPE;
```

Meaning:

> Make `v_salary` have the same datatype as `employees.salary`.

Question-bank solutions frequently use this technique. 

---

# 54. `%ROWTYPE`

Store an entire row:

```sql
DECLARE
    v_emp employees%ROWTYPE;
BEGIN

    SELECT *
    INTO v_emp
    FROM employees
    WHERE employee_id = 101;

    DBMS_OUTPUT.PUT_LINE(v_emp.first_name);
    DBMS_OUTPUT.PUT_LINE(v_emp.salary);

END;
/
```

Very useful when a procedure needs many columns from one employee.

The supplied archive uses `%ROWTYPE` in employee-transfer/exchange problems. 

---

# 55. SELECT INTO — THREE IMPORTANT CASES

## Exactly one row

```sql
SELECT salary
INTO v_salary
FROM employees
WHERE employee_id = 101;
```

Works.

## No row

Raises:

```text
NO_DATA_FOUND
```

## More than one row

Raises:

```text
TOO_MANY_ROWS
```

---

# 56. IF / ELSIF / ELSE

```sql
IF v_salary > 10000 THEN
    DBMS_OUTPUT.PUT_LINE('High');

ELSIF v_salary > 5000 THEN
    DBMS_OUTPUT.PUT_LINE('Medium');

ELSE
    DBMS_OUTPUT.PUT_LINE('Low');
END IF;
```

---

# 57. PL/SQL LOOP

## Simple loop

```sql
LOOP
    ...
    EXIT WHEN condition;
END LOOP;
```

## WHILE

```sql
WHILE condition LOOP
    ...
END LOOP;
```

## FOR

```sql
FOR i IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
END LOOP;
```

Reverse:

```sql
FOR i IN REVERSE 1..10 LOOP
    ...
END LOOP;
```

---

# 58. CURSOR — BASIC IDEA

A cursor lets PL/SQL process multiple rows one by one.

## Explicit cursor

```sql
DECLARE

    CURSOR c_emp IS
        SELECT employee_id, first_name, salary
        FROM employees;

BEGIN

    FOR r IN c_emp LOOP

        DBMS_OUTPUT.PUT_LINE(
            r.employee_id || ' ' ||
            r.first_name || ' ' ||
            r.salary
        );

    END LOOP;

END;
/
```

### Best exam shortcut

Use cursor FOR loop when possible:

```sql
FOR r IN (
    SELECT ...
    FROM ...
) LOOP

    ...

END LOOP;
```

No need to manually:

```text
OPEN
FETCH
CLOSE
```

The supplied archive repeatedly uses cursor FOR loops for reports and mass updates. 

---

# 59. IMPLICIT CURSOR

After DML:

```sql
UPDATE employees
SET salary = salary * 1.10
WHERE department_id = 10;

DBMS_OUTPUT.PUT_LINE(
    SQL%ROWCOUNT
);
```

Useful attributes:

```text
SQL%ROWCOUNT
SQL%FOUND
SQL%NOTFOUND
SQL%ISOPEN
```

---

# 60. CURSOR WITH PARAMETER

```sql
CURSOR c_emp(p_dept_id NUMBER) IS
    SELECT *
    FROM employees
    WHERE department_id = p_dept_id;
```

Use:

```sql
FOR r IN c_emp(10) LOOP
    ...
END LOOP;
```

---

# 61. SELECT + UPDATE PATTERN

A very common exam structure:

```sql
DECLARE
    v_salary employees.salary%TYPE;
BEGIN

    SELECT salary
    INTO v_salary
    FROM employees
    WHERE employee_id = 101;

    IF v_salary < 5000 THEN

        UPDATE employees
        SET salary = salary * 1.10
        WHERE employee_id = 101;

    END IF;

    COMMIT;
END;
/
```

---

# 62. BULK UPDATE USING CURSOR

```sql
BEGIN

    FOR r IN (
        SELECT employee_id, salary
        FROM employees
        WHERE department_id = 10
    ) LOOP

        UPDATE employees
        SET salary = r.salary * 1.10
        WHERE employee_id = r.employee_id;

    END LOOP;

    COMMIT;

END;
/
```

---

# 63. CURSOR + WHERE CURRENT OF

For updateable cursor:

```sql
DECLARE

    CURSOR c_emp IS
        SELECT employee_id, commission_pct
        FROM employees
        FOR UPDATE OF commission_pct;

BEGIN

    FOR r IN c_emp LOOP

        IF r.commission_pct IS NULL THEN

            UPDATE employees
            SET commission_pct = 0.10
            WHERE CURRENT OF c_emp;

        END IF;

    END LOOP;

END;
/
```

The question bank specifically uses `FOR UPDATE OF ...` with `WHERE CURRENT OF`. 

---

# 64. PROCEDURE

A procedure performs an action.

```sql
CREATE OR REPLACE PROCEDURE increase_salary(
    p_emp_id IN NUMBER,
    p_percent IN NUMBER
) IS
BEGIN

    UPDATE employees
    SET salary = salary * (1 + p_percent / 100)
    WHERE employee_id = p_emp_id;

END;
/
```

Call:

```sql
BEGIN
    increase_salary(101, 10);
END;
/
```

---

# 65. IN / OUT / IN OUT

## IN

Input:

```sql
p_id IN NUMBER
```

## OUT

Returns value:

```sql
p_msg OUT VARCHAR2
```

Example:

```sql
CREATE OR REPLACE PROCEDURE check_employee(
    p_id  IN NUMBER,
    p_msg OUT VARCHAR2
) IS
    v_name VARCHAR2(100);
BEGIN

    SELECT first_name
    INTO v_name
    FROM employees
    WHERE employee_id = p_id;

    p_msg := 'Employee: ' || v_name;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_msg := 'Employee does not exist';
END;
/
```

Question-bank procedures frequently use `OUT` message parameters for operation status. 

---

# 66. FUNCTION

A function returns a value.

```sql
CREATE OR REPLACE FUNCTION get_salary(
    p_emp_id IN NUMBER
)
RETURN NUMBER
IS
    v_salary NUMBER;
BEGIN

    SELECT salary
    INTO v_salary
    FROM employees
    WHERE employee_id = p_emp_id;

    RETURN v_salary;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/
```

Call inside PL/SQL:

```sql
DECLARE
    v_salary NUMBER;
BEGIN
    v_salary := get_salary(101);
    DBMS_OUTPUT.PUT_LINE(v_salary);
END;
/
```

---

# 67. FUNCTION VS PROCEDURE

```text
FUNCTION:
    must RETURN a value

PROCEDURE:
    does not have to return a value
    can use OUT parameters
```

Think:

```text
Function = "Give me something"
Procedure = "Do something"
```

---

# 68. SQL QUERY INSIDE FUNCTION

You can use complex SQL:

```sql
CREATE OR REPLACE FUNCTION get_dept_avg(
    p_dept_id IN NUMBER
)
RETURN NUMBER
IS
    v_avg NUMBER;
BEGIN

    SELECT AVG(salary)
    INTO v_avg
    FROM employees
    WHERE department_id = p_dept_id;

    RETURN NVL(v_avg, 0);
END;
/
```

---

# 69. COMPLEX JOIN INSIDE FUNCTION

```sql
CREATE OR REPLACE FUNCTION get_job_title(
    p_emp_id IN NUMBER
)
RETURN VARCHAR2
IS
    v_title jobs.job_title%TYPE;
BEGIN

    SELECT j.job_title
    INTO v_title
    FROM employees e
    JOIN jobs j
      ON e.job_id = j.job_id
    WHERE e.employee_id = p_emp_id;

    RETURN v_title;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/
```

---

# 70. ANALYTIC FUNCTION INSIDE PL/SQL

Example: salary rank under a manager:

```sql
CREATE OR REPLACE FUNCTION get_salary_rank(
    p_emp_id NUMBER,
    p_mgr_id NUMBER
)
RETURN NUMBER
IS
    v_rank NUMBER;
BEGIN

    SELECT rnk
    INTO v_rank
    FROM (
        SELECT employee_id,
               DENSE_RANK() OVER (
                   ORDER BY salary DESC
               ) AS rnk
        FROM employees
        WHERE manager_id = p_mgr_id
    )
    WHERE employee_id = p_emp_id;

    RETURN v_rank;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/
```

This pattern appears directly in the supplied archive. 

---

# 71. ADVANCED FUNCTION PATTERN: CALCULATE → IF → RETURN

```sql
CREATE OR REPLACE FUNCTION is_ready(
    p_emp_id NUMBER
)
RETURN VARCHAR2
IS
    v_hire DATE;
    v_salary NUMBER;
    v_min NUMBER;
    v_max NUMBER;
    v_subordinates NUMBER;
BEGIN

    SELECT e.hire_date,
           e.salary,
           j.min_salary,
           j.max_salary
    INTO v_hire,
         v_salary,
         v_min,
         v_max
    FROM employees e
    JOIN jobs j
      ON e.job_id = j.job_id
    WHERE e.employee_id = p_emp_id;

    SELECT COUNT(*)
    INTO v_subordinates
    FROM employees
    WHERE manager_id = p_emp_id;

    IF MONTHS_BETWEEN(SYSDATE, v_hire) / 12 >= 5
       AND v_salary > (v_min + v_max) / 2
       AND v_subordinates >= 1
    THEN
        RETURN 'YES';
    ELSE
        RETURN 'NO';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'NO';
END;
/
```

This is essentially the recurring structure used by the archive's promotion-readiness problem. 

---

# 72. EXCEPTION HANDLING

Basic:

```sql
EXCEPTION

    WHEN NO_DATA_FOUND THEN
        ...

    WHEN TOO_MANY_ROWS THEN
        ...

    WHEN OTHERS THEN
        ...
```

---

# 73. SQLERRM

Get error message:

```sql
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
```

Error number:

```sql
SQLCODE
```

Both:

```sql
DBMS_OUTPUT.PUT_LINE(
    SQLCODE || ': ' || SQLERRM
);
```

---

# 74. USER-DEFINED ERROR

```sql
RAISE_APPLICATION_ERROR(
    -20001,
    'Salary cannot be decreased'
);
```

Valid custom error range:

```text
-20000 to -20999
```

Very common in trigger questions.

---

# 75. RAISE

```sql
IF v_salary < 0 THEN
    RAISE_APPLICATION_ERROR(
        -20001,
        'Invalid salary'
    );
END IF;
```

---

# 76. CUSTOM EXCEPTION

```sql
DECLARE

    e_invalid_salary EXCEPTION;

    v_salary NUMBER := -10;

BEGIN

    IF v_salary < 0 THEN
        RAISE e_invalid_salary;
    END IF;

EXCEPTION

    WHEN e_invalid_salary THEN
        DBMS_OUTPUT.PUT_LINE(
            'Salary cannot be negative'
        );

END;
/
```

---

# 77. TRIGGER — BASIC STRUCTURE

```sql
CREATE OR REPLACE TRIGGER trigger_name
BEFORE INSERT OR UPDATE OR DELETE
ON employees
FOR EACH ROW
BEGIN

    ...

END;
/
```

---

# 78. BEFORE VS AFTER

Use:

```text
BEFORE
```

when you want to validate/modify `:NEW`.

Use:

```text
AFTER
```

when the operation should happen first and then you want to log/react.

---

# 79. :OLD AND :NEW

For UPDATE:

```text
:OLD.salary → previous value
:NEW.salary → new value
```

Example:

```sql
IF :NEW.salary < :OLD.salary THEN
    RAISE_APPLICATION_ERROR(
        -20001,
        'Salary cannot decrease'
    );
END IF;
```

For INSERT:

```text
:NEW exists
:OLD does not
```

For DELETE:

```text
:OLD exists
:NEW does not
```

---

# 80. INSERTING / UPDATING / DELETING

Inside trigger:

```sql
IF INSERTING THEN
    ...
ELSIF UPDATING THEN
    ...
ELSIF DELETING THEN
    ...
END IF;
```

Column-specific:

```sql
IF UPDATING('SALARY') THEN
    ...
END IF;
```

---

# 81. CLASSIC SALARY VALIDATION TRIGGER

```sql
CREATE OR REPLACE TRIGGER trg_salary_limit
BEFORE INSERT OR UPDATE OF salary, job_id
ON employees
FOR EACH ROW
DECLARE
    v_min jobs.min_salary%TYPE;
    v_max jobs.max_salary%TYPE;
BEGIN

    SELECT min_salary, max_salary
    INTO v_min, v_max
    FROM jobs
    WHERE job_id = :NEW.job_id;

    IF :NEW.salary < v_min
       OR :NEW.salary > v_max
    THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Salary outside allowed range'
        );
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Invalid job ID'
        );
END;
/
```

This exact conceptual pattern appears in the 2023 archive: validate `:NEW.salary` against `jobs.min_salary`/`max_salary` and handle missing job data. 

---

# 82. SIMPLE AUDIT TRIGGER

Suppose:

```sql
CREATE TABLE salary_audit (
    employee_id NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    changed_at DATE
);
```

Trigger:

```sql
CREATE OR REPLACE TRIGGER trg_salary_audit
AFTER UPDATE OF salary
ON employees
FOR EACH ROW
BEGIN

    INSERT INTO salary_audit
    VALUES (
        :OLD.employee_id,
        :OLD.salary,
        :NEW.salary,
        SYSDATE
    );

END;
/
```

---

# 83. PREVENT DELETE

```sql
CREATE OR REPLACE TRIGGER trg_no_delete
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN

    RAISE_APPLICATION_ERROR(
        -20001,
        'Employee deletion is not allowed'
    );

END;
/
```

---

# 84. DML TRIGGER FOR INSERT / DELETE

```sql
CREATE OR REPLACE TRIGGER trg_emp_change
BEFORE INSERT OR DELETE
ON employees
FOR EACH ROW
BEGIN

    IF INSERTING THEN

        DBMS_OUTPUT.PUT_LINE(
            'New employee: ' || :NEW.employee_id
        );

    ELSIF DELETING THEN

        DBMS_OUTPUT.PUT_LINE(
            'Deleted employee: ' || :OLD.employee_id
        );

    END IF;

END;
/
```

The archive contains this recurring BEFORE INSERT/DELETE trigger pattern. 

---

# 85. TRIGGER: IF SALARY DECREASES MORE THAN 20%

```sql
IF :NEW.salary < :OLD.salary * 0.80 THEN

    INSERT INTO demotions(employee_id, ...)
    VALUES (:OLD.employee_id, ...);

END IF;
```

Or reject it:

```sql
IF :NEW.salary < :OLD.salary * 0.80 THEN
    RAISE_APPLICATION_ERROR(
        -20010,
        'Salary decrease exceeds 20%'
    );
END IF;
```

---

# 86. MUTATING TABLE — BIG TRIGGER TRICK

### Problem

A row-level trigger on `employees` cannot safely query `employees` itself during the triggering DML in many cases.

This causes:

```text
ORA-04091: table ... is mutating
```

Example dangerous idea:

```sql
CREATE TRIGGER ...
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN

    SELECT COUNT(*)
    FROM employees
    WHERE ...;

END;
/
```

If the question asks you to inspect the same table after a row-level change, think:

```text
COMPOUND TRIGGER
```

or redesign the logic.

---

# 87. COMPOUND TRIGGER PATTERN

```sql
CREATE OR REPLACE TRIGGER trg_example
FOR INSERT OR UPDATE ON employees
COMPOUND TRIGGER

    TYPE t_set IS TABLE OF BOOLEAN
        INDEX BY PLS_INTEGER;

    g_ids t_set;

    AFTER EACH ROW IS
    BEGIN
        g_ids(:NEW.department_id) := TRUE;

        IF UPDATING THEN
            g_ids(:OLD.department_id) := TRUE;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
        v_id PLS_INTEGER;
        v_total NUMBER;
    BEGIN

        v_id := g_ids.FIRST;

        WHILE v_id IS NOT NULL LOOP

            SELECT NVL(SUM(salary), 0)
            INTO v_total
            FROM employees
            WHERE department_id = v_id;

            IF v_total > 50000 THEN
                RAISE_APPLICATION_ERROR(
                    -20013,
                    'Department salary limit exceeded'
                );
            END IF;

            v_id := g_ids.NEXT(v_id);

        END LOOP;

    END AFTER STATEMENT;

END;
/
```

The supplied 2023 question bank uses a compound trigger specifically to avoid the mutating-table issue while checking department total salary. 

---

# 88. TRIGGER TIMING CHEATSHEET

```text
BEFORE INSERT
BEFORE UPDATE
BEFORE DELETE

AFTER INSERT
AFTER UPDATE
AFTER DELETE

FOR EACH ROW
```

### Statement-level

No:

```sql
FOR EACH ROW
```

Runs once per SQL statement.

### Row-level

Has:

```sql
FOR EACH ROW
```

Runs once for every affected row.

---

# 89. AUTONOMOUS TRANSACTION — KNOW THE NAME

Some advanced trigger questions may use:

```sql
PRAGMA AUTONOMOUS_TRANSACTION;
```

Example:

```sql
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO audit_log ...
    COMMIT;
END;
```

The supplied archive contains triggers using autonomous transactions for logging-related behavior. 

### Important

Do not blindly add it.

Understand that an autonomous transaction is independent of the main transaction and must handle its own commit/rollback appropriately.

---

# 90. DYNAMIC SQL

When SQL structure is decided at runtime:

```sql
EXECUTE IMMEDIATE
    'TRUNCATE TABLE employees_copy';
```

Example:

```sql
EXECUTE IMMEDIATE
    'UPDATE employees
     SET salary = salary * 1.1
     WHERE department_id = :1'
USING v_dept;
```

The question bank includes `EXECUTE IMMEDIATE` for dynamic `TRUNCATE` operations. 

---

# 91. COMMIT / ROLLBACK

```sql
COMMIT;
```

Save transaction.

```sql
ROLLBACK;
```

Undo uncommitted transaction changes.

```sql
SAVEPOINT sp1;
```

Then:

```sql
ROLLBACK TO sp1;
```

---

# 92. IMPORTANT: COMMIT IN PL/SQL

For exam questions that explicitly ask for database changes to be committed:

```sql
COMMIT;
```

But remember:

> A function called from SQL has restrictions around transaction control; don't put arbitrary `COMMIT`/`ROLLBACK` inside functions intended for SQL expressions.

---

# 93. PRINTING OUTPUT

Enable:

```sql
SET SERVEROUTPUT ON;
```

Print:

```sql
DBMS_OUTPUT.PUT_LINE('Hello');
```

Concatenate:

```sql
DBMS_OUTPUT.PUT_LINE(
    'Name: ' || v_name ||
    ' Salary: ' || v_salary
);
```

---

# 94. THE MOST USEFUL PL/SQL EXAM TEMPLATE

Memorize this:

```sql
SET SERVEROUTPUT ON;

DECLARE

    -- variables
    v_value NUMBER;

BEGIN

    -- SELECT INTO
    SELECT ...
    INTO v_value
    FROM ...
    WHERE ...;

    -- decision
    IF ... THEN
        ...
    ELSE
        ...
    END IF;

    -- DML
    UPDATE ...;

    DBMS_OUTPUT.PUT_LINE(...);

    COMMIT;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Not found');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Too many rows');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(
            SQLCODE || ' ' || SQLERRM
        );

END;
/
```

---

# 95. PROCEDURE EXAM TEMPLATE

```sql
CREATE OR REPLACE PROCEDURE procedure_name(
    p_input IN NUMBER,
    p_msg   OUT VARCHAR2
)
IS

    v_value NUMBER;

BEGIN

    SELECT ...
    INTO v_value
    FROM ...
    WHERE ...;

    IF ... THEN
        ...
    END IF;

    UPDATE ...;

    COMMIT;

    p_msg := 'Success';

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        p_msg := 'Not found';

    WHEN OTHERS THEN
        p_msg := 'Error: ' || SQLERRM;

END;
/
```

---

# 96. FUNCTION EXAM TEMPLATE

```sql
CREATE OR REPLACE FUNCTION function_name(
    p_id IN NUMBER
)
RETURN NUMBER
IS

    v_result NUMBER;

BEGIN

    SELECT ...
    INTO v_result
    FROM ...
    WHERE ...;

    IF ... THEN
        RETURN ...;
    ELSE
        RETURN ...;
    END IF;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        RETURN NULL;

    WHEN OTHERS THEN
        RETURN NULL;

END;
/
```

---

# 97. CURSOR REPORT TEMPLATE

```sql
CREATE OR REPLACE PROCEDURE report IS

BEGIN

    FOR r IN (
        SELECT ...
        FROM ...
        JOIN ...
        WHERE ...
        GROUP BY ...
        HAVING ...
        ORDER BY ...
    ) LOOP

        DBMS_OUTPUT.PUT_LINE(
            ...
        );

    END LOOP;

END;
/
```

This is one of the safest ways to combine advanced SQL with PL/SQL.

---

# 98. "SELECT → CALCULATE → UPDATE" PATTERN

Many difficult questions reduce to this:

```text
1. SELECT required data
2. Store it in variables
3. Calculate new value
4. IF needed
5. UPDATE
6. Print
7. COMMIT
8. Handle exceptions
```

Example:

```sql
DECLARE
    v_old_salary NUMBER;
    v_new_salary NUMBER;
BEGIN

    SELECT salary
    INTO v_old_salary
    FROM employees
    WHERE employee_id = 101;

    v_new_salary := v_old_salary * 1.15;

    UPDATE employees
    SET salary = v_new_salary
    WHERE employee_id = 101;

    DBMS_OUTPUT.PUT_LINE(
        'Old: ' || v_old_salary ||
        ' New: ' || v_new_salary
    );

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found');
END;
/
```

---

# 99. "JOIN → GROUP → HAVING → ORDER → LOOP" PATTERN

For report questions:

```sql
BEGIN

    FOR r IN (
        SELECT d.department_name,
               COUNT(e.employee_id) AS emp_count,
               ROUND(AVG(e.salary), 2) AS avg_salary
        FROM departments d
        JOIN employees e
          ON d.department_id = e.department_id
        GROUP BY d.department_name
        HAVING COUNT(e.employee_id) > 2
        ORDER BY avg_salary DESC
    ) LOOP

        DBMS_OUTPUT.PUT_LINE(
            r.department_name || ' | ' ||
            r.emp_count || ' | ' ||
            r.avg_salary
        );

    END LOOP;

END;
/
```

---

# 100. "FIND ONE ROW" PATTERN

If exactly one row is expected:

```sql
SELECT ...
INTO ...
FROM ...
WHERE primary_key = ...;
```

If you need the highest/lowest/closest row:

```sql
SELECT *
INTO ...
FROM (
    SELECT *
    FROM ...
    ORDER BY ...
)
WHERE ROWNUM = 1;
```

Or:

```sql
SELECT ...
INTO ...
FROM ...
ORDER BY ...
FETCH FIRST 1 ROW ONLY;
```

---

# 101. "FIND COUNT" PATTERN

```sql
SELECT COUNT(*)
INTO v_count
FROM employees
WHERE manager_id = p_manager_id;
```

Then:

```sql
IF v_count > 0 THEN
    ...
END IF;
```

---

# 102. "FIND AGGREGATE" PATTERN

```sql
SELECT NVL(AVG(salary), 0)
INTO v_avg
FROM employees
WHERE department_id = p_dept_id;
```

Remember:

```text
AVG/SUM/MIN/MAX/COUNT normally return one row,
even if no matching rows exist.
```

But the aggregate value can be `NULL`, so use:

```sql
NVL(...)
```

when appropriate.

---

# 103. "FIND MIN/MAX ROW" PATTERN

```sql
SELECT *
INTO v_emp
FROM (
    SELECT *
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM = 1;
```

Lowest:

```sql
ORDER BY salary ASC
```

Oldest:

```sql
ORDER BY hire_date ASC
```

Newest:

```sql
ORDER BY hire_date DESC
```

---

# 104. "CLOSEST VALUE" PATTERN

```sql
SELECT employee_id
INTO v_id
FROM (
    SELECT employee_id,
           ABS(salary - p_target_salary) AS diff
    FROM employees
    ORDER BY diff ASC
)
WHERE ROWNUM = 1;
```

---

# 105. "TOP N" PATTERN INSIDE FUNCTION

```sql
SELECT rnk
INTO v_rank
FROM (
    SELECT employee_id,
           DENSE_RANK() OVER (
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
    WHERE department_id = (
        SELECT department_id
        FROM employees
        WHERE employee_id = p_emp_id
    )
)
WHERE employee_id = p_emp_id;
```

Then:

```sql
IF v_rank <= p_n THEN
    RETURN 1;
ELSE
    RETURN 0;
END IF;
```

This mirrors a recurring top-N ranking task in the supplied archive. 

---

# 106. "COPY TABLE → MODIFY COPY"

Common lab pattern:

```sql
CREATE TABLE employees_copy AS
SELECT *
FROM employees;
```

Then:

```sql
UPDATE employees_copy
SET ...
WHERE ...;
```

This is useful when the question says:

> "Do not modify the original employees table."

---

# 107. "AUDIT TABLE → UPDATE → LOG"

```sql
UPDATE employees
SET salary = v_new_salary
WHERE employee_id = p_emp_id;

INSERT INTO salary_audit
(
    employee_id,
    old_salary,
    new_salary,
    changed_at
)
VALUES
(
    p_emp_id,
    v_old_salary,
    v_new_salary,
    SYSDATE
);
```

Then:

```sql
COMMIT;
```

The 2023 archive repeatedly uses update + audit/history logging patterns. 

---

# 108. "TRANSFER EMPLOYEE" PATTERN

Typical logic:

```text
1. Find employee
2. Validate destination
3. Save old details/history
4. Update department/job
5. Calculate salary
6. Commit
7. Return/print message
8. Handle NO_DATA_FOUND
```

Template:

```sql
CREATE OR REPLACE PROCEDURE transfer_employee(
    p_emp_id NUMBER,
    p_new_dept NUMBER,
    p_msg OUT VARCHAR2
)
IS
    v_emp employees%ROWTYPE;
BEGIN

    SELECT *
    INTO v_emp
    FROM employees
    WHERE employee_id = p_emp_id;

    INSERT INTO job_history (...)
    VALUES (...);

    UPDATE employees
    SET department_id = p_new_dept,
        salary = salary * 1.15
    WHERE employee_id = p_emp_id;

    COMMIT;

    p_msg := 'Transfer successful';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_msg := 'Employee not found';

    WHEN OTHERS THEN
        p_msg := 'Transfer error: ' || SQLERRM;
END;
/
```

This closely follows the supplied archive's employee-transfer question pattern. 

---

# 109. "MANAGER + SUBORDINATES" MASTER QUERY

```sql
SELECT m.employee_id AS manager_id,
       m.first_name || ' ' || m.last_name AS manager_name,
       COUNT(e.employee_id) AS subordinate_count,
       AVG(e.salary) AS avg_salary
FROM employees m
JOIN employees e
  ON e.manager_id = m.employee_id
GROUP BY m.employee_id,
         m.first_name,
         m.last_name
HAVING COUNT(e.employee_id) > 3
ORDER BY AVG(e.salary);
```

---

# 110. "EMPLOYEE + JOB + DEPARTMENT" MASTER JOIN

```sql
SELECT e.employee_id,
       e.first_name,
       e.salary,
       j.job_title,
       d.department_name
FROM employees e
JOIN jobs j
  ON e.job_id = j.job_id
JOIN departments d
  ON e.department_id = d.department_id;
```

Memorize this structure.

---

# 111. "EMPLOYEE → REGION" MASTER JOIN

```sql
SELECT e.first_name,
       j.job_title,
       d.department_name,
       l.city,
       c.country_name,
       r.region_name
FROM employees e
JOIN jobs j
  ON e.job_id = j.job_id
JOIN departments d
  ON e.department_id = d.department_id
JOIN locations l
  ON d.location_id = l.location_id
JOIN countries c
  ON l.country_id = c.country_id
JOIN regions r
  ON c.region_id = r.region_id;
```

Then simply add:

```sql
WHERE ...
```

---

# 112. MULTI-CONDITION BUSINESS LOGIC

Example:

```sql
IF tenure >= 10 THEN
    v_allowed_ratio := 0.95;

ELSIF tenure >= 5 THEN
    v_allowed_ratio := 0.90;

ELSE
    v_allowed_ratio := 0.85;
END IF;

IF v_salary > v_max_salary * v_allowed_ratio THEN
    RETURN 1;
ELSE
    RETURN 0;
END IF;
```

This style is useful for questions such as salary/tenure eligibility and overpayment evaluation. The supplied 2023 archive contains exactly this kind of threshold-based function. 

---

# 113. NULL-SAFE ARITHMETIC

Danger:

```sql
salary + commission_pct
```

If commission is NULL, result can become NULL.

Use:

```sql
salary + NVL(commission_pct, 0)
```

Percentage:

```sql
salary * (1 + NVL(commission_pct, 0))
```

---

# 114. PERCENTAGE CALCULATIONS

10% increase:

```sql
salary * 1.10
```

15% increase:

```sql
salary * 1.15
```

20% decrease:

```sql
salary * 0.80
```

Percentage change:

```sql
(salary * percentage) / 100
```

Generic:

```sql
salary * (1 + p_pct / 100)
```

---

# 115. ROUNDING

```sql
v_new_salary :=
    ROUND(
        v_old_salary * (1 + p_pct / 100),
        2
    );
```

---

# 116. IMPORTANT BOOLEAN GOTCHA

PL/SQL supports:

```sql
BOOLEAN
```

but SQL itself does not treat BOOLEAN exactly like a normal SQL column datatype in older Oracle SQL contexts.

Inside PL/SQL:

```sql
v_found BOOLEAN := FALSE;
```

Then:

```sql
IF NOT v_found THEN
    ...
END IF;
```

---

# 117. EXIT FROM LOOP

```sql
FOR r IN (...) LOOP

    IF condition THEN
        EXIT;
    END IF;

END LOOP;
```

Very useful when you found the first valid option.

Example:

```sql
FOR opt IN c_options LOOP

    IF v_capacity > 0 THEN
        INSERT INTO ...
        v_assigned := TRUE;
        EXIT;
    END IF;

END LOOP;
```

The supplied archive uses this exact idea for assigning employees to the first available department choice. 

---

# 118. CONTINUE

```sql
FOR i IN 1..10 LOOP

    IF MOD(i, 2) = 0 THEN
        CONTINUE;
    END IF;

    DBMS_OUTPUT.PUT_LINE(i);

END LOOP;
```

---

# 119. NESTED LOOPS

```sql
FOR emp IN c_employees LOOP

    FOR opt IN c_options(emp.employee_id) LOOP

        ...

    END LOOP;

END LOOP;
```

Useful for:

```text
employee → options
manager → employees
department → employees
```

---

# 120. RECORD VARIABLE

```sql
DECLARE
    TYPE emp_record IS RECORD (
        id NUMBER,
        name VARCHAR2(100),
        salary NUMBER
    );

    v_emp emp_record;
BEGIN
    ...
END;
/
```

Usually `%ROWTYPE` is easier if matching a table row.

---

# 121. COLLECTION — BASIC IDEA

Associative array:

```sql
TYPE t_names IS TABLE OF VARCHAR2(100)
    INDEX BY PLS_INTEGER;

v_names t_names;
```

Use:

```sql
v_names(1) := 'John';
v_names(2) := 'Alice';
```

Useful methods:

```text
FIRST
LAST
NEXT
PRIOR
EXISTS
COUNT
DELETE
```

Compound-trigger solutions in the archive use associative arrays with `FIRST`/`NEXT` to remember affected department IDs. 

---

# 122. ADVANCED COLLECTION LOOP

```sql
v_id := v_set.FIRST;

WHILE v_id IS NOT NULL LOOP

    ...

    v_id := v_set.NEXT(v_id);

END LOOP;
```

Memorize this if compound triggers are in your syllabus.

---

# 123. ORACLE ROWID

Every physical row has a `ROWID`.

```sql
SELECT ROWID, employee_id
FROM employees;
```

Usually not needed for normal exam questions, but useful to know.

---

# 124. SEQUENCE

Create:

```sql
CREATE SEQUENCE emp_seq
START WITH 1
INCREMENT BY 1;
```

Use:

```sql
INSERT INTO employees(employee_id, name)
VALUES(emp_seq.NEXTVAL, 'John');
```

Current value:

```sql
emp_seq.CURRVAL
```

---

# 125. VIEW

```sql
CREATE VIEW high_paid_employees AS
SELECT employee_id,
       first_name,
       salary
FROM employees
WHERE salary > 10000;
```

Use:

```sql
SELECT *
FROM high_paid_employees;
```

---

# 126. INDEX — BASIC

```sql
CREATE INDEX idx_emp_dept
ON employees(department_id);
```

Useful conceptually for searching/joining, though index design is separate from query-writing.

---

# 127. EXAM QUERY BUILDING METHOD

When a question looks scary, do NOT immediately write PL/SQL.

Break it down.

### Step 1 — What rows/tables do I need?

```text
employees
jobs
departments
...
```

### Step 2 — Build the JOIN

```sql
FROM employees e
JOIN jobs j ...
JOIN departments d ...
```

### Step 3 — Apply row conditions

```sql
WHERE ...
```

### Step 4 — Need COUNT/AVG/SUM?

Use:

```sql
GROUP BY
```

### Step 5 — Need conditions on aggregate?

Use:

```sql
HAVING
```

### Step 6 — Need ranking/top/closest?

Use:

```text
ROW_NUMBER
RANK
DENSE_RANK
ROWNUM
FETCH FIRST
ORDER BY
```

### Step 7 — Put that SQL inside PL/SQL.

This is the single most useful strategy.

---

# 128. HOW TO CONVERT SQL → PL/SQL

Suppose SQL:

```sql
SELECT AVG(salary)
FROM employees
WHERE department_id = 10;
```

PL/SQL:

```sql
DECLARE
    v_avg NUMBER;
BEGIN

    SELECT AVG(salary)
    INTO v_avg
    FROM employees
    WHERE department_id = 10;

    DBMS_OUTPUT.PUT_LINE(v_avg);

END;
/
```

Only major addition:

```text
INTO variable
```

---

# 129. HOW TO CONVERT MULTI-ROW SQL → PL/SQL

SQL:

```sql
SELECT first_name, salary
FROM employees
WHERE department_id = 10;
```

Multiple rows → use cursor loop:

```sql
BEGIN

    FOR r IN (
        SELECT first_name, salary
        FROM employees
        WHERE department_id = 10
    ) LOOP

        DBMS_OUTPUT.PUT_LINE(
            r.first_name || ' ' || r.salary
        );

    END LOOP;

END;
/
```

### Remember

```text
1 row expected     → SELECT INTO
multiple rows      → cursor / FOR loop
```

---

# 130. HOW TO COMBINE AGGREGATE + PL/SQL

SQL:

```sql
SELECT AVG(salary)
FROM employees
WHERE department_id = 10;
```

PL/SQL:

```sql
DECLARE
    v_avg NUMBER;
BEGIN

    SELECT NVL(AVG(salary), 0)
    INTO v_avg
    FROM employees
    WHERE department_id = 10;

    IF v_avg > 5000 THEN
        DBMS_OUTPUT.PUT_LINE('High average');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Low average');
    END IF;

END;
/
```

---

# 131. HOW TO COMBINE JOIN + PL/SQL

```sql
DECLARE
    v_job jobs.job_title%TYPE;
BEGIN

    SELECT j.job_title
    INTO v_job
    FROM employees e
    JOIN jobs j
      ON e.job_id = j.job_id
    WHERE e.employee_id = 101;

    DBMS_OUTPUT.PUT_LINE(v_job);

END;
/
```

---

# 132. HOW TO COMBINE GROUP BY + CURSOR

```sql
BEGIN

    FOR r IN (
        SELECT department_id,
               COUNT(*) AS cnt,
               AVG(salary) AS avg_sal
        FROM employees
        GROUP BY department_id
        HAVING COUNT(*) > 3
    ) LOOP

        DBMS_OUTPUT.PUT_LINE(
            'Dept: ' || r.department_id ||
            ' Count: ' || r.cnt ||
            ' Avg: ' || r.avg_sal
        );

    END LOOP;

END;
/
```

---

# 133. HOW TO COMBINE ANALYTIC FUNCTION + PL/SQL

```sql
BEGIN

    FOR r IN (
        SELECT employee_id,
               salary,
               DENSE_RANK() OVER (
                   ORDER BY salary DESC
               ) AS rnk
        FROM employees
    ) LOOP

        DBMS_OUTPUT.PUT_LINE(
            r.employee_id || ' Rank=' || r.rnk
        );

    END LOOP;

END;
/
```

---

# 134. HOW TO COMBINE SUBQUERY + PL/SQL

```sql
DECLARE
    v_salary NUMBER;
BEGIN

    SELECT salary
    INTO v_salary
    FROM employees
    WHERE salary > (
        SELECT AVG(salary)
        FROM employees
    )
    AND employee_id = 101;

END;
/
```

---

# 135. ADVANCED: SUBQUERY + RANK + FUNCTION

```sql
CREATE OR REPLACE FUNCTION is_top_n(
    p_emp_id NUMBER,
    p_n NUMBER
)
RETURN NUMBER
IS
    v_rank NUMBER;
BEGIN

    SELECT rnk
    INTO v_rank
    FROM (
        SELECT employee_id,
               DENSE_RANK() OVER (
                   ORDER BY salary DESC
               ) AS rnk
        FROM employees
        WHERE department_id = (
            SELECT department_id
            FROM employees
            WHERE employee_id = p_emp_id
        )
    )
    WHERE employee_id = p_emp_id;

    IF v_rank <= p_n THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END;
/
```

This combines:

```text
subquery
+
analytic function
+
PL/SQL variable
+
IF
+
RETURN
+
exception
```

---

# 136. "MISSING DATA" TRICK

If lookup may fail:

```sql
BEGIN

    SELECT ...
    INTO ...
    FROM ...
    WHERE ...;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ...
END;
```

If a query might return multiple rows:

```sql
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        ...
```

---

# 137. "NO DATA" VS "NULL"

Very important:

```sql
SELECT AVG(salary)
INTO v_avg
FROM employees
WHERE department_id = 999;
```

This usually does **not** raise `NO_DATA_FOUND`.

Instead:

```text
v_avg = NULL
```

Therefore:

```sql
v_avg := NVL(v_avg, 0);
```

But:

```sql
SELECT salary
INTO v_salary
FROM employees
WHERE employee_id = 999;
```

raises:

```text
NO_DATA_FOUND
```

---

# 138. `COUNT(*)` TRICK

This:

```sql
SELECT COUNT(*)
INTO v_count
FROM employees
WHERE department_id = 999;
```

returns:

```text
0
```

not `NO_DATA_FOUND`.

So:

```sql
IF v_count = 0 THEN
    ...
END IF;
```

---

# 139. WHEN TO USE COUNT VS EXISTS

Need number?

```sql
COUNT(*)
```

Need only whether something exists?

```sql
EXISTS
```

Inside PL/SQL, often:

```sql
SELECT COUNT(*)
INTO v_count
...
```

then:

```sql
IF v_count > 0 THEN
```

---

# 140. COMMON SQL MISTAKES

## Mistake 1

```sql
WHERE AVG(salary) > 5000
```

Correct:

```sql
HAVING AVG(salary) > 5000
```

## Mistake 2

```sql
WHERE salary = NULL
```

Correct:

```sql
WHERE salary IS NULL
```

## Mistake 3

```sql
SELECT salary
FROM employees;
```

inside PL/SQL without handling multiple rows.

Use:

```sql
SELECT salary INTO v_salary ...
```

for one row, or cursor for many.

## Mistake 4

Wrong top-1:

```sql
WHERE ROWNUM = 1
ORDER BY salary DESC
```

Use ordered subquery first.

## Mistake 5

Forgetting aliases in joins:

```sql
e.employee_id
d.department_id
```

## Mistake 6

Using `WHERE` to filter aggregate results.

Use `HAVING`.

---

# 141. CLAUSE DECISION TABLE

| Requirement | Use |
|---|---|
| Select data | `SELECT` |
| Choose table | `FROM` |
| Connect tables | `JOIN ... ON` |
| Filter individual rows | `WHERE` |
| Remove duplicates | `DISTINCT` |
| Group rows | `GROUP BY` |
| Filter groups | `HAVING` |
| Sort | `ORDER BY` |
| Top N | `FETCH FIRST` / analytic / `ROWNUM` |
| Conditional output | `CASE` |
| Oracle simple mapping | `DECODE` |
| Aggregate | `COUNT/SUM/AVG/MIN/MAX` |
| Existence | `EXISTS` |
| Compare with another query | subquery |
| Combine result sets | `UNION/INTERSECT/MINUS` |
| Multiple rows in PL/SQL | cursor / `FOR` loop |
| One row in PL/SQL | `SELECT INTO` |
| Perform action | procedure |
| Return value | function |
| Validate DML automatically | trigger |
| Handle error | exception |
| Custom error | `RAISE_APPLICATION_ERROR` |

---

# 142. QUESTION WORD → SQL TOOL

| If question says... | Think... |
|---|---|
| "whose salary is..." | `WHERE` |
| "for each department" | `GROUP BY department_id` |
| "departments having..." | `HAVING` |
| "highest paid" | `ORDER BY salary DESC` |
| "lowest paid" | `ORDER BY salary ASC` |
| "top N" | `DENSE_RANK` / `ROW_NUMBER` |
| "rank" | `RANK` / `DENSE_RANK` |
| "manager and employees" | self join |
| "employee and job" | join |
| "all departments including empty" | `LEFT JOIN` |
| "no employees" | `NOT EXISTS` / `LEFT JOIN ... IS NULL` |
| "closest" | `ABS(...) + ORDER BY` |
| "average" | `AVG` |
| "number of" | `COUNT` |
| "total" | `SUM` |
| "maximum" | `MAX` |
| "minimum" | `MIN` |
| "if...otherwise" | `CASE` / PL/SQL `IF` |
| "print each" | cursor `FOR` loop |
| "return a value" | function |
| "perform update and message" | procedure |
| "automatically when update happens" | trigger |
| "old/new value" | `:OLD` / `:NEW` |
| "prevent operation" | `BEFORE` trigger + `RAISE_APPLICATION_ERROR` |
| "audit/log" | `AFTER` trigger |
| "same table queried inside row trigger" | mutating table → compound trigger |
| "copy table" | `CREATE TABLE ... AS SELECT` |
| "error if not found" | `NO_DATA_FOUND` |
| "any error" | `WHEN OTHERS` |

---

# 143. HIGH-FREQUENCY QUESTION PATTERNS FROM THE ARCHIVE

The supplied 2017–2023 archive shows a strong recurrence of these structures:

### A. Salary modification
```text
find employee
→ calculate salary
→ update
→ print
→ commit
```

### B. Manager/subordinate
```text
employees e
JOIN employees m
GROUP BY manager
HAVING COUNT / AVG
ORDER BY
```

### C. Ranking
```text
DENSE_RANK() OVER (...)
```

### D. Longest-serving
```text
ORDER BY hire_date ASC
FETCH FIRST 1 ROW ONLY
```

### E. Top/lowest employee
```text
ORDER BY salary
FETCH FIRST 1 ROW ONLY
```

or classic:

```text
ORDER BY salary
ROWNUM = 1
```

### F. Transfer
```text
SELECT employee
→ INSERT history
→ UPDATE employee
→ COMMIT
```

### G. Trigger validation
```text
BEFORE UPDATE
→ compare :NEW / :OLD
→ RAISE_APPLICATION_ERROR
```

### H. Audit
```text
AFTER UPDATE
→ INSERT into audit table
```

### I. Complex trigger
```text
row trigger
→ same table query
→ mutating problem
→ compound trigger
```

### J. Report
```text
complex SELECT
→ cursor FOR loop
→ DBMS_OUTPUT.PUT_LINE
```

These patterns are documented across the supplied archive's 2017–2023 sections. fileciteturn2file0

---

# 144. LAST-MINUTE EXAM CHECKLIST

Before submitting a SQL query, ask:

```text
[ ] Did I use the correct JOIN condition?
[ ] Do I need WHERE?
[ ] Do I need GROUP BY?
[ ] Is an aggregate condition supposed to be HAVING?
[ ] Do I need ORDER BY?
[ ] Do I need top 1 / top N?
[ ] Is ROWNUM being applied after ORDER BY?
[ ] Are NULLs handled?
[ ] Did I use IS NULL instead of = NULL?
[ ] Do I need CASE?
[ ] Could a self join solve this?
[ ] Could EXISTS be simpler?
```

Before submitting PL/SQL:

```text
[ ] DECLARE variables correctly
[ ] Use %TYPE when useful
[ ] Use %ROWTYPE for whole row
[ ] SELECT ... INTO ... for single-row query
[ ] Cursor FOR loop for multiple rows
[ ] Correct IF / ELSIF / ELSE
[ ] Correct loop
[ ] Correct procedure/function return
[ ] Handle NO_DATA_FOUND
[ ] Handle TOO_MANY_ROWS when relevant
[ ] Use SQLERRM for unexpected errors
[ ] Use RAISE_APPLICATION_ERROR for custom validation
[ ] COMMIT if required
[ ] End every PL/SQL block with /
```

Before submitting a trigger:

```text
[ ] BEFORE or AFTER?
[ ] INSERT / UPDATE / DELETE?
[ ] FOR EACH ROW?
[ ] :OLD or :NEW?
[ ] INSERTING / UPDATING / DELETING?
[ ] Is same-table querying causing mutating-table risk?
[ ] Do I need a compound trigger?
```

---

# 145. THE 15 PATTERNS YOU SHOULD MEMORIZE FIRST

If time is short, memorize these **15**:

## 1. Basic SELECT

```sql
SELECT columns
FROM table
WHERE condition
ORDER BY column;
```

## 2. Join

```sql
SELECT ...
FROM A a
JOIN B b ON a.id = b.id;
```

## 3. Multiple joins

```sql
FROM A
JOIN B ...
JOIN C ...
JOIN D ...
```

## 4. Self join

```sql
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
```

## 5. Group

```sql
GROUP BY department_id
HAVING COUNT(*) > 3;
```

## 6. Aggregate

```sql
COUNT / SUM / AVG / MIN / MAX
```

## 7. CASE

```sql
CASE
    WHEN condition THEN value
    ELSE value
END
```

## 8. Subquery

```sql
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
```

## 9. Top 1

```sql
SELECT *
FROM (
    SELECT *
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM = 1;
```

## 10. Ranking

```sql
DENSE_RANK() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)
```

## 11. PL/SQL SELECT INTO

```sql
SELECT ...
INTO v_variable
FROM ...
WHERE ...;
```

## 12. Cursor loop

```sql
FOR r IN (
    SELECT ...
) LOOP
    ...
END LOOP;
```

## 13. Procedure

```sql
CREATE OR REPLACE PROCEDURE p(...) IS
BEGIN
    ...
END;
/
```

## 14. Function

```sql
CREATE OR REPLACE FUNCTION f(...)
RETURN NUMBER
IS
BEGIN
    ...
    RETURN ...;
END;
/
```

## 15. Trigger

```sql
CREATE OR REPLACE TRIGGER t
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'Not allowed');
    END IF;
END;
/
```

---

# 146. FINAL MENTAL MODEL

When you see a complicated PL/SQL question, translate it:

```text
QUESTION
   ↓
WHAT TABLES?
   ↓
WHAT JOIN?
   ↓
WHAT ROW FILTER?
   ↓
GROUP?
   ↓
AGGREGATE?
   ↓
HAVING?
   ↓
RANK / TOP / LOWEST?
   ↓
ONE ROW OR MANY ROWS?
   ↓
ONE ROW → SELECT INTO
MANY ROWS → CURSOR/FOR LOOP
   ↓
CALCULATE
   ↓
IF / ELSE
   ↓
UPDATE / INSERT / DELETE
   ↓
PRINT
   ↓
COMMIT
   ↓
EXCEPTION
```

And for triggers:

```text
WHAT EVENT?
INSERT / UPDATE / DELETE
        ↓
WHEN?
BEFORE / AFTER
        ↓
ONE ROW OR STATEMENT?
FOR EACH ROW?
        ↓
NEED OLD/NEW?
:OLD / :NEW
        ↓
VALIDATE / MODIFY / LOG
        ↓
RAISE_APPLICATION_ERROR if needed
        ↓
MUTATING TABLE?
        ↓
COMPOUND TRIGGER if necessary
```

---

# 147. ULTRA-COMPACT MEMORY SHEET

```text
WHERE       = filter rows
GROUP BY    = make groups
HAVING      = filter groups
ORDER BY    = sort
JOIN        = combine tables
SELF JOIN   = same table twice
CASE        = conditional SQL value
NVL         = replace NULL
COUNT       = number
SUM         = total
AVG         = average
MIN/MAX     = extreme
EXISTS      = does a row exist?
ROWNUM      = Oracle row limiting
FETCH       = modern row limiting
RANK        = rank with gaps
DENSE_RANK  = rank without gaps
ROW_NUMBER  = unique sequential rank

SELECT INTO = one-row PL/SQL query
CURSOR      = many-row PL/SQL processing
%TYPE       = same datatype as column
%ROWTYPE    = whole table row
PROCEDURE   = perform action
FUNCTION    = return value
:OLD        = old trigger value
:NEW        = new trigger value
BEFORE      = validate/change before DML
AFTER       = react/log after DML
RAISE_APPLICATION_ERROR = custom error
NO_DATA_FOUND = zero rows for SELECT INTO
TOO_MANY_ROWS = >1 row for SELECT INTO
SQLERRM     = error message
SQLCODE     = error number
COMMIT      = save
ROLLBACK    = undo uncommitted changes
```

---

## Sources used

The supplied **CSE 216: Database Sessional — PL/SQL Past Examination Question Papers & Complete Solutions** archive states that it covers 2017–2023 and includes procedures, functions, triggers, exceptions, multi-table joins, rankings, string matching, mutating triggers, job-history/audit logic, salary-cap triggers, and overpayment verification. fileciteturn2file0

Specific recurring examples verified in the archive include:
- senior-manager salary updates, procedures, functions, and triggers fileciteturn2file2
- manager/subordinate grouping and ranking fileciteturn2file3
- `DENSE_RANK()` salary ranking fileciteturn1file7
- multi-table employee → job → department → location → country → region joins fileciteturn1file9
- copy-table + employee exchange logic fileciteturn1file4
- transfer procedure with history logging fileciteturn1file2
- salary validation trigger fileciteturn1file2
- compound trigger / mutating-table solution fileciteturn1file6
- `FOR UPDATE` + `WHERE CURRENT OF` cursor pattern fileciteturn2file6
- audit/update function patterns fileciteturn1file6

