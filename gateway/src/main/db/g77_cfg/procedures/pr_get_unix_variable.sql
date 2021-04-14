CREATE OR REPLACE PROCEDURE g77_cfg.pr_get_unix_variable
    (
        p_query          IN  VARCHAR2,
        p_sql_type       IN  VARCHAR2,
        o_variable       OUT VARCHAR2,
        o_return_code    OUT NUMBER
    )
AS
    -- Error Logging
    v_rule_name                 T_ERROR_LOG.ERROR_RULE_IDENT%TYPE       := 'pr_get_unix_variable';
    v_project_name              T_ERROR_LOG.ERROR_APTITUDE_PROJECT%TYPE := 'g77_library';
    v_msg                       T_ERROR_LOG.ERROR_TEXT%TYPE;
BEGIN
  
  IF p_sql_type = 'SELECT'
  THEN
    EXECUTE IMMEDIATE p_query INTO o_variable;
  ELSIF p_sql_type = 'DML'
  THEN 
    EXECUTE IMMEDIATE p_query;
  END IF;
  
  COMMIT;
    
  o_return_code := 0;    
EXCEPTION 
  WHEN OTHERS THEN
    v_msg := 'Unexpected Failure Executing ' || p_query;
    o_return_code := 1;
    ROLLBACK;    
    pr_error(v_project_name, v_rule_name, v_msg);
    RAISE;
END;
/