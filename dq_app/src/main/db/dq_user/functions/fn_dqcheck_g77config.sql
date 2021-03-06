CREATE OR REPLACE FUNCTION DQ_USER.FN_DQCHECK_G77CONFIG      ( p_value             VARCHAR2,
                                                               p_g77_table_column  VARCHAR2,
                                                               p_g77_table         VARCHAR2,
                                                               p_where             VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sql         VARCHAR2(32000);
  v_where       VARCHAR2(32000);   
  v_return_code VARCHAR2(50);
BEGIN 
  
  IF p_value IS NOT NULL
  THEN
    -- Used for extra criteria, e.g. MASTER_DATA_ID
    v_where := NVL(p_where, ' 1=1 ');
    
    v_sql := '
    SELECT 
        CASE
          WHEN COUNT(*) = 1 THEN ''SUCCESS''
          ELSE ''DQERROR''
        END AS DQ_CHECK
      FROM ' || p_g77_table || ' g77_config
      WHERE   g77_config.' || p_g77_table_column || ' =  ''' || p_value || '''
      AND ' || v_where
      ;
        
    EXECUTE IMMEDIATE v_sql
    INTO v_return_code;
  ELSE
    v_return_code := 'SUCCESS';
  END IF;
  
  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';
END;
/