CREATE OR REPLACE FUNCTION DQ_USER.FN_DQIS_NUMBER (p_string IN VARCHAR2)
   RETURN VARCHAR2
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_number NUMBER; 
BEGIN
   v_number := TO_NUMBER(p_string);
   RETURN 'SUCCESS';
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';
END FN_DQIS_NUMBER;
/