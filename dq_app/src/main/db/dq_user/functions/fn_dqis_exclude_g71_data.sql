create or replace FUNCTION DQ_USER.FN_DQIS_EXCLUDE_G71_DATA ( p_in_table         VARCHAR2,
                                                              p_value            VARCHAR2,
                                                              p_ref_table        VARCHAR2,
                                                              p_where            VARCHAR2,
                                                              p_ending           VARCHAR2)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_sql         VARCHAR2(32000);
  v_return_code VARCHAR2(50);
BEGIN
  IF p_in_table IS NOT NULL AND p_value IS NOT NULL
  THEN
  
      v_sql := 
        'SELECT CASE WHEN count(*) = 0 
                     THEN ''SUCCESS''
                     ELSE ''DQERROR''
                 END AS DQ_CHECK
           FROM '||p_ref_table||'
          WHERE '||p_where||' = '''
                 ||p_value||''''||p_ending;

                             
    EXECUTE IMMEDIATE v_sql
    INTO v_return_code;
    
  ELSE
    v_return_code := 'SUCCESS';
  END IF;
 
  DBMS_OUTPUT.put_line(v_return_code || ' v_return_code');
  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';
END;
/
