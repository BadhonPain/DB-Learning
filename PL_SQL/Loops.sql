-- FOR LOOP
DECLARE
BEGIN
    FOR i in 1..100
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

-- WHILE LOOP
DECLARE
    i NUMBER;
BEGIN
    i := 1;
    WHILE i<= 100
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
    END LOOP;
END;
/
    
-- UNCONDITIONAL LOOP
DECLARE
    i NUMBER;
BEGIN
    i := 1;
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
        EXIT WHEN (i>100);
    END LOOP;
END;
/

-- CURSOR FOR LOOP
--counts the number of employees who worked 10 years or more in the company. Then, it displays the count.
DECLARE
    EMP_COUNT NUMBER;
    YEARS NUMBER;
BEGIN
    EMP_COUNT := 0;
    FOR R IN (SELECT HIRE_DATE FROM HR.EMPLOYEES)
    LOOP
        YEARS := ROUND(MONTHS_BETWEEN(SYSDATE, R.HIRE_DATE)/12);
        IF YEARS > 10 THEN
        EMP_COUNT := EMP_COUNT + 1;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(EMP_COUNT || ' EMPLOYEE HAS EXPERIENCE OF MORE THEN 10 YEARS.');
END;


