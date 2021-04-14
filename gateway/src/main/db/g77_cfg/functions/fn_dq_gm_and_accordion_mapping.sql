create or replace FUNCTION G77_CFG.FN_DQ_GM_AND_ACCORDION_MAPPING( p_gm_match_key    varchar2
                                                                 , p_gm_lookup_value varchar2
                                                                 , p_gm_view         varchar2
                                                                 , p_gm_value        varchar2
                                                                 , p_gm_where        varchar2
                                                                 , p_ref_table       varchar2
                                                                 , p_ref_column      varchar2
                                                                 , p_where           varchar2)                                                         
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_gm_sql      VARCHAR2(32000);
  v_gm_value    VARCHAR2(200);
  v_gm_where    VARCHAR2(32000);
  v_sql         VARCHAR2(32000);
  v_where       VARCHAR2(32000);
  v_return_code VARCHAR2(50);
BEGIN
   --retreive general mappin value to use in combined accordion lookup
   v_gm_where := NVL(p_gm_where, ' 1=1 ');

   v_gm_sql := 'select '||p_gm_lookup_value
             || ' from '||p_gm_view
             ||' where '||p_gm_match_key||' = '''|| p_gm_value
             ||''' and '||v_gm_where ;
             
dbms_output.put_line(v_gm_sql);             

   EXECUTE IMMEDIATE v_gm_sql INTO v_gm_value;

   IF v_gm_value IS NOT NULL
   THEN
      -- Used for extra criteria, e.g. MASTER_DATA_ID
      v_where := NVL(p_where, ' 1=1 ');

      v_sql := '
        SELECT CASE WHEN COUNT(*) != 0 
                    THEN ''SUCCESS''
                    ELSE ''DQERROR''
                END   AS DQ_CHECK
          FROM ' || p_ref_table || ' ref
         WHERE   ref.' || p_ref_column || ' =  ''' || v_gm_value || '''
           AND ' || v_where ;

dbms_output.put_line(v_sql);           

      EXECUTE IMMEDIATE v_sql INTO v_return_code;

   ELSE
      v_return_code := 'SUCCESS';
   END IF;

   RETURN v_return_code;
EXCEPTION
   WHEN OTHERS 
   THEN RETURN 'DQERROR';
END;
/