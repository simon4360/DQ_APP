/******************************************************************************
Generic PROCEDURE to get the number of months between two dates as aptitude can't.
This will return a number, or -1 when it's an error.
*******************************************************************************/

CREATE OR REPLACE PROCEDURE G77_CFG.P_MONTHS_BETWEEN (p_date_larger IN DATE, p_date_smaller IN DATE, number_of_months OUT NUMBER)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   NULL_DATE_EXCEPTION EXCEPTION;
BEGIN
   IF (p_date_larger is null OR p_date_smaller is null ) THEN 
   RAISE NULL_DATE_EXCEPTION; 
   END IF;
   SELECT MONTHS_BETWEEN (p_date_larger,p_date_smaller) INTO number_of_months FROM DUAL;
EXCEPTION
   WHEN NULL_DATE_EXCEPTION
   THEN 
      number_of_months := -1;
   WHEN OTHERS
   THEN
      number_of_months := -1;
END P_MONTHS_BETWEEN;
/