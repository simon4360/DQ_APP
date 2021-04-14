CREATE OR REPLACE FUNCTION DQ_USER.FN_DQQ0T_BALANCE             (  p_session_id VARCHAR2
                                                                 , p_where      VARCHAR2 DEFAULT NULL)
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
  SELECT COUNT (*) FROM (
   SELECT
      SUM
      (
      CASE WHEN DR_CR_FLAG = ''D''
              THEN TO_NUMBER(JRNL_LINE_AMT_ORIG_CRNCY)
      ELSE 
          0
      END
      ) -
      SUM
      ( 
      CASE WHEN DR_CR_FLAG = ''C''                        
              THEN TO_NUMBER(JRNL_LINE_AMT_ORIG_CRNCY)
      ELSE 
          0
      END
        ) AS SUM_DR_CR_AMOUNT    
   FROM T_Q0T_CASHFLOW_IN
    WHERE SESSION_ID = ''' || p_session_id || '''
       AND ' || v_where || '
   GROUP BY   
    LDGR_CO_CD,
    TRAN_EFF_DT,
    ORIG_CRNCY_CD)
  WHERE SUM_DR_CR_AMOUNT <> 0';
  
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