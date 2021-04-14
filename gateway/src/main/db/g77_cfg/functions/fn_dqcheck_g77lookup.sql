create or replace FUNCTION G77_CFG.FN_DQCHECK_G77LOOKUP ( p_g77_value          VARCHAR2
                                                        , p_g77_column         VARCHAR2
                                                        , p_g77_lookup_value   VARCHAR2
                                                        , p_g77_lookup_column  VARCHAR2
                                                        , p_g77_table          VARCHAR2
                                                        , p_where              VARCHAR2 DEFAULT NULL)
/* Simon Williams 07/06/2018
   This DQ Function is for when you need to lookup up a ref value using another value.
   For example DQ009, we need to check the incept_date of a contract has not changed once the contract has been bound.
   In this case set the lookup variables p_g77_lookup_value and p_g77_lookup_column to the incept_dt
   and lookup the date from the contract_id in p_g77_value and p_g77_column. A filter can then be added to this with p_where.*/

RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sql         VARCHAR2(32000);
  v_where       VARCHAR2(32000);
  v_return_code VARCHAR2(50);
BEGIN
  IF p_g77_value IS NOT NULL
  THEN
    -- Used for extra criteria, e.g. MASTER_DATA_IDD
    v_where := NVL(p_where, ' 1=1 ');

    v_sql := 'SELECT
                     CASE WHEN count(*) = 1 THEN ''SUCCESS''
                          ELSE ''DQERROR''
                     END  AS DQ_CHECK
                FROM ' || p_g77_table || ' g77_config
               WHERE   g77_config.' || p_g77_column || ' =  ''' || p_g77_value || '''
                 AND ' || p_g77_lookup_column || ' = ''' || p_g77_lookup_value || '''
                 AND ' || v_where ;

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
