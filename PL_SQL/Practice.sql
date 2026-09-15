-- TABLE CREATION
create table manager_summary (
   manager_id          number,
   department_id       number,
   manager_name        varchar2(100),
   direct_report_count number,
   generated_by        varchar2(30),
   generated_on        date
);

-- DATA INSERTION
INSERT INTO manager_summary
VALUES (101, 10, 'John Smith', 5, 'ADMIN', DATE '2026-01-10');

INSERT INTO manager_summary
VALUES (102, 20, 'Alice Johnson', 3, 'ADMIN', DATE '2026-01-12');

INSERT INTO manager_summary
VALUES (103, 30, 'Robert Brown', 8, 'HR', DATE '2026-01-15');

INSERT INTO manager_summary
VALUES (104, 40, 'Emily Davis', 2, 'HR', DATE '2026-01-18');

INSERT INTO manager_summary
VALUES (105, 50, 'Michael Wilson', 12, 'ADMIN', DATE '2026-02-01');

INSERT INTO manager_summary
VALUES (106, 60, 'Sarah Miller', 7, 'MANAGER', DATE '2026-02-05');

INSERT INTO manager_summary
VALUES (107, 70, 'David Moore', 1, 'MANAGER', DATE '2026-02-10');

INSERT INTO manager_summary
VALUES (108, 80, 'Jessica Taylor', 10, 'ADMIN', DATE '2026-02-15');

INSERT INTO manager_summary
VALUES (109, 90, 'Daniel Anderson', 4, 'HR', DATE '2026-02-20');

INSERT INTO manager_summary
VALUES (110, 100, 'Laura Thomas', 6, 'MANAGER', DATE '2026-03-01');

INSERT INTO manager_summary
VALUES (111, 110, 'James Jackson', 15, 'ADMIN', DATE '2026-03-05');

INSERT INTO manager_summary
VALUES (112, 120, 'Sophia White', 9, 'HR', DATE '2026-03-10');

INSERT INTO manager_summary
VALUES (113, 130, 'William Harris', 0, 'ADMIN', DATE '2026-03-15');

INSERT INTO manager_summary
VALUES (114, 140, 'Olivia Martin', 3, 'MANAGER', DATE '2026-03-20');

INSERT INTO manager_summary
VALUES (115, 150, 'Christopher Thompson', 11, 'HR', DATE '2026-03-25');

COMMIT;

-- QUERIES
SELECT * FROM MANAGER_SUMMARY;

-- GPT TASKS

-- Write a procedure called CHECK_MANAGER that it should :
/*
 * Take manager_id as an IN parameter.
 * Find that manager's direct_report_count from MANAGER_SUMMARY.
 * If the manager has 5 or more direct reports, print: MANAGER HAS MANY DIRECT REPORTS.
 * Otherwise, print : MANAGER HAS FEW DIRECT REPORTS.
*/

CREATE OR REPLACE PROCEDURE CHECK_MANAGER(P_MANAGER_ID IN NUMBER) IS
    MANAGER_REPORT_COUNT NUMBER;
BEGIN 
    SELECT DIRECT_REPORT_COUNT INTO MANAGER_REPORT_COUNT
    FROM MANAGER_SUMMARY
    WHERE MANAGER_ID = P_MANAGER_ID;

    IF MANAGER_REPORT_COUNT >= 5 THEN
        DBMS_OUTPUT.PUT_LINE('MANAGER HAS MANY DIRECT REPORTS.');
    ELSE DBMS_OUTPUT.PUT_LINE('MANAGER HAS FEW DIRECT REPORTS.');
    END IF;
END;
/

BEGIN
    CHECK_MANAGER(101);
    CHECK_MANAGER(107);
END;
/

-- Write a procedure called GET_MANAGER_INFO that it should :
/*
 * Take manager_id as an IN parameter.
 * Find the following information from MANAGER_SUMMARY:
    manager_name
    department_id
    direct_report_count
 * Print the information like:
    MANAGER ID: 105
    MANAGER NAME: Michael Wilson
    DEPARTMENT ID: 50
    DIRECT REPORTS: 12
 * If the given manager_id doesn't exist, handle the exception: MANAGER NOT FOUND.

*/

CREATE OR REPLACE PROCEDURE GET_MANAGER_INFO(P_MANAGER_ID IN NUMBER) IS 
    NAME_ VARCHAR2(100);
    DEPT_ID NUMBER;
    REPORT_COUNT NUMBER;
BEGIN 
    SELECT MANAGER_NAME, DEPARTMENT_ID, DIRECT_REPORT_COUNT INTO NAME_, DEPT_ID, REPORT_COUNT
    FROM MANAGER_SUMMARY
    WHERE MANAGER_ID = P_MANAGER_ID;
    DBMS_OUTPUT.PUT_LINE('MANAGER ID: ' || P_MANAGER_ID);
    DBMS_OUTPUT.PUT_LINE('MANAGER NAME: ' || NAME_);
    DBMS_OUTPUT.PUT_LINE('DEPARTMENT ID: ' || DEPT_ID);
    DBMS_OUTPUT.PUT_LINE('DIRECT REPORTS: ' || REPORT_COUNT);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('MANAGER NOT FOUND.');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('SOMETHING WENT WRONG.');
END;
/

BEGIN
    GET_MANAGER_INFO(105);
    GET_MANAGER_INFO(999);
END;
/

