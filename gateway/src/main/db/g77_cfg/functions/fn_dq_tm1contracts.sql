create or replace FUNCTION G77_CFG.FN_DQ_TM1CONTRACTS( p_value             VARCHAR2
                                                     , p_ref_table_column  VARCHAR2
                                                     , p_ref_table         VARCHAR2
                                                     , p_contract_type     VARCHAR2
                                                     , p_where             VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sql_1         VARCHAR2(32000);
  v_sql_2         VARCHAR2(32000);
  v_where         VARCHAR2(32000);
  v_return_code   VARCHAR2(50);
  v_contract_type VARCHAR2(50);
BEGIN
  IF p_value IS NOT NULL
  THEN
    -- Used for extra criteria, e.g. MASTER_DATA_ID
    v_where := NVL(p_where, ' 1=1 ');

    v_sql_1 := '
    SELECT contr_typ
      FROM ' || p_ref_table || ' ref
      WHERE   ref.' || p_ref_table_column || ' =  ''' || p_value || ''''
      ;

    EXECUTE IMMEDIATE v_sql_1
    INTO v_contract_type;
    
     IF upper(v_contract_type) = upper(p_contract_type)
     THEN
     
        v_sql_2 := '
        SELECT
            CASE WHEN COUNT(*) != 0 
                 THEN ''SUCCESS''
                 ELSE ''DQERROR''
             END AS DQ_CHECK
          FROM ' || p_ref_table || ' ref
         WHERE   ref.' || p_ref_table_column || ' =  ''' || p_value || '''
           AND ' || v_where
        ;

       EXECUTE IMMEDIATE v_sql_2
       INTO v_return_code;
     END IF;

  ELSE
    v_return_code := 'SUCCESS';
  END IF;

  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';
END;
/
