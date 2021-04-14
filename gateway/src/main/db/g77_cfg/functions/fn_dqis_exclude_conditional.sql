create or replace FUNCTION G77_CFG.FN_DQIS_EXCLUDE_CONDITIONAL ( p_ref_table         VARCHAR2,
                                                                 p_gateway_id        NUMBER,
                                                                 p_where             VARCHAR2)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sql         VARCHAR2(32000);
  v_return_code VARCHAR2(50);
BEGIN

  IF p_ref_table IS NOT NULL AND p_where IS NOT NULL
  THEN

    v_sql := '
    SELECT
        CASE
          WHEN COUNT(*) = 0 THEN ''SUCCESS''
          ELSE ''DQERROR''
        END AS DQ_CHECK
      FROM ' || p_ref_table || 
      ' WHERE GATEWAY_ID = ' || p_gateway_id ||
      ' AND ' || p_where
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