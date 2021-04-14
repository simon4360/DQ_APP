CREATE OR REPLACE FUNCTION G77_CFG.FN_DQIS_SINGLEVAL_NULLABLE( p_value             VARCHAR2
                                                         , p_ref_table_column  VARCHAR2
                                                         , p_ref_table         VARCHAR2
                                                         , p_where             VARCHAR2 DEFAULT NULL)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sql         VARCHAR2(32000);
  v_where       VARCHAR2(32000);
  v_return_code VARCHAR2(50);
  c_return_success VARCHAR2(50):='SUCCESS';
  c_return_fail VARCHAR2(50):='DQERROR';
BEGIN

  IF p_value IS NOT NULL
  THEN
    -- Used for extra criteria, e.g. MASTER_DATA_ID
    v_where := NVL(p_where, ' 1=1 ');

    v_sql := '
    SELECT
        CASE
          WHEN COUNT(*) = 1 THEN '''||c_return_success||'''
          ELSE '''||c_return_fail||'''
        END AS DQ_CHECK
      FROM ' || p_ref_table || ' ref
      WHERE   ref.' || p_ref_table_column || ' = :value
      AND ' || v_where
      ;

    EXECUTE IMMEDIATE v_sql 
    INTO v_return_code using p_value;

  ELSE
    v_return_code := c_return_success;
  END IF;

  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
    RETURN c_return_fail;
END;
/
