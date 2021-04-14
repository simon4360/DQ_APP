CREATE OR REPLACE FUNCTION G77_CFG.FN_DQ_VALIDATE_FILE_LOAD (p_session_id IN VARCHAR2)
   RETURN VARCHAR2
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_expected_records_processed NUMBER;
  v_records_processed NUMBER; 
  v_return_code VARCHAR2(50);
BEGIN
   SELECT SUM(EXPECTED_RECORDS_PROCESSED) ,SUM(RECORDS_PROCESSED) INTO v_expected_records_processed, v_records_processed
   FROM T_FILE_CONTROL WHERE FILE_STATUS='P'
   AND SESSION_ID=p_session_id;
   
   IF(v_expected_records_processed <> v_records_processed)
   THEN
    v_return_code := 'DQERROR';
   ELSE
    v_return_code := 'SUCCESS';
   END IF;
   
   RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';       
END FN_DQ_VALIDATE_FILE_LOAD;
/