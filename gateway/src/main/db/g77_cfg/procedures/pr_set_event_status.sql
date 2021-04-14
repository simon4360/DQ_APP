CREATE OR REPLACE PROCEDURE g77_cfg.pr_set_event_status
    (
         p_process_id         IN   NUMBER
       , p_session_id         IN   VARCHAR2
       , p_use_case_id        IN   VARCHAR2
       , p_table_name         IN   VARCHAR2
       , p_aptitude_project   IN   VARCHAR2
       , o_return_code        OUT  NUMBER
    )
AS 
    v_count_updated NUMBER;
    v_count         NUMBER;
    
    v_event_status_processed NUMBER := 3;
    
    -- Error Logging
    e_batch_step_unregistered   exception;
    v_rule_name                 t_error_log.error_rule_ident%type       := 'pr_set_event_status';
    v_msg                       t_error_log.error_text%type;
    v_row                       t_error_log.row_in_error_key_id%type    := to_char(p_process_id);
    
BEGIN
 
 
    EXECUTE IMMEDIATE '  UPDATE /*+ FULL('||p_table_name||') PARALLEL('||p_table_name||', 8) */ ' ||  p_table_name
                      ||' SET EVENT_STATUS = ' || v_event_status_processed
                      ||' WHERE SESSION_ID    = ''' || p_session_id || ''''
                      ||' AND EVENT_STATUS = ''0''';
 
      v_count_updated := SQL%ROWCOUNT;
      
      pr_info ( p_aptitude_project
              , v_rule_name
              , 'Updated inbound records to processed. Records Updated : ' || v_count_updated
              , p_table            => p_table_name
              , p_batch_process_id => p_process_id
              , p_use_case_id      => p_use_case_id
              , p_session_id       => p_session_id
              );

  o_return_code := 0; 
  
  COMMIT;   
    
EXCEPTION 
  WHEN OTHERS THEN
    v_msg := 'Unexpected failure when updating records to processed : ' || p_table_name;
    ROLLBACK;    
    pr_error(p_aptitude_project, v_rule_name, v_msg, p_row => v_row, p_batch_process_id => p_process_id, p_use_case_id => p_use_case_id, p_session_id => p_session_id);
    RAISE;
    o_return_code := 1;
END;
/
