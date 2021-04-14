CREATE OR REPLACE FUNCTION G77_CFG.FN_DQFA0_ROLLFRWD_BALANCE  ( p_session_id VARCHAR2
                                                              , p_where      VARCHAR2 DEFAULT NULL )
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_return_code VARCHAR2(50);
  v_count       NUMBER; 
  v_where       VARCHAR2(32000);   
  v_sql         VARCHAR2(32000);
BEGIN 
	
  v_where := NVL(p_where, ' 1=1 ');
  
  v_sql := '
    SELECT COUNT(*) FROM (
      SELECT SUM(AMOUNT_OC) AS SUM_AMOUNT_OC
           , SUM(AMOUNT_FC) AS SUM_AMOUNT_FC
       FROM T_FA0_INVESTMENT_IN
      WHERE SESSION_ID  = ''' || p_session_id || '''
       AND ' || v_where || '
     GROUP BY   
      ROLL_FORWARD_CODE_ID,
      SESSION_ID)
   WHERE SUM_AMOUNT_OC <> 0 OR (SUM_AMOUNT_FC > 10 OR SUM_AMOUNT_FC < -10)';
      
  EXECUTE IMMEDIATE v_sql
  INTO v_count;
  
  IF v_count > 0 
  THEN
    v_return_code := 'DQERROR';
  ELSE
    v_return_code := 'SUCCESS';
  END IF;

  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';      
END;
/