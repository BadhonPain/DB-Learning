-- increases salary of each employee X by 15% who have worked in the company for 10 years or more.

DECLARE
    YEARS NUMBER;
    OLD_SALARY NUMBER;
    NEW_SALARY NUMBER;
BEGIN

    FOR R IN (SELECT HIRE_DATE, SALARY, EMPLOYEE_ID FROM HR.EMPLOYEES)
    LOOP
        OLD_SALARY := R.SALARY;
        YEARS := ROUND(MONTHS_BETWEEN(SYSDATE, R.HIRE_DATE)/12);
        IF YEARS > 10 THEN 
            UPDATE HR.EMPLOYEES SET SALARY = SALARY * 1.5
            WHERE EMPLOYEE_ID = R.EMPLOYEE_ID;
        END IF;
        SELECT SALARY INTO NEW_SALARY
        FROM HR.EMPLOYEES
        WHERE EMPLOYEE_ID = R.EMPLOYEE_ID;
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE ID: '|| R.EMPLOYEE_ID || ' SALARY : '|| OLD_SALARY ||' -> '||NEW_SALARY);
    END LOOP;
    COMMIT;
END;
/

-- print ‘Happy Anniversary X’ for each employee X whose hiring date is today. Use cursor FOR loop for the task.

DECLARE 
    J_MONTH NUMBER;
    J_DAY NUMBER;
    P_MONTH NUMBER;
    P_DAY NUMBER;
BEGIN 
    FOR R IN (SELECT HIRE_DATE, EMPLOYEE_ID FROM HR.EMPLOYEES)
    LOOP 
        J_MONTH := EXTRACT(MONTH FROM R.HIRE_DATE);
        J_DAY := EXTRACT(DAY FROM R.HIRE_DATE);
        P_MONTH := EXTRACT(MONTH FROM SYSDATE);
        P_DAY := EXTRACT(DAY FROM SYSDATE);
        
        IF J_DAY = P_DAY THEN 
            IF J_MONTH = P_MONTH THEN 
                DBMS_OUTPUT.PUT_LINE('HAPPY ANNIVERSARY '||R.EMPLOYEE_ID);
            END IF;
        END IF;
    END LOOP;
END;
/