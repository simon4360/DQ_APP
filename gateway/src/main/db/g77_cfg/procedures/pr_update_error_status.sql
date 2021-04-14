create or replace PROCEDURE g77_cfg.pr_update_error_status
(
p_session_id IN VARCHAR2,
p_target_table IN  VARCHAR2,
p_target_column IN VARCHAR2,
p_return_code out pls_integer,
p_in_table in VARCHAR2
)
AS
v_sql_delete VARCHAR2(1000);
v_sql_update VARCHAR2(1000);
BEGIN
v_sql_delete := 'Delete from ' || p_target_table || ' where target = ' ||''''|| p_target_column ||''''|| ' and session_id = '|| ''''||p_session_id ||'''' ;
v_sql_update := 'UPDATE ' || p_in_table || ' SET EVENT_STATUS = 5 WHERE EVENT_STATUS IN (3,0)and session_id = '|| ''''|| p_session_id || '''';
EXECUTE IMMEDIATE v_sql_delete;
EXECUTE IMMEDIATE v_sql_update;
p_return_code := 0;
COMMIT;
EXCEPTION WHEN OTHERS THEN
  ROLLBACK; 
   p_return_code := 1;
  RAISE;
END pr_update_error_status;
/