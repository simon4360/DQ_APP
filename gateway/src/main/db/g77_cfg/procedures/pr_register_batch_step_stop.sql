create or replace PROCEDURE g77_cfg.pr_register_batch_step_stop
    (
        p_project_name   IN  VARCHAR2,
        p_microflow_name IN  VARCHAR2,        
        p_use_case_id    IN  VARCHAR2,
        p_session_id     IN  VARCHAR2
    )
AS
    v_process_id                T_BATCH_TASK_STATUS.BATCH_TASK_PROCESS_ID%TYPE DEFAULT 0;
    v_process_running           CHAR(1) DEFAULT 'N';
  
    -- Error Logging
    v_rule_name                 T_ERROR_LOG.ERROR_RULE_IDENT%TYPE       := 'pr_register_batch_step_stop';
    v_project_name              T_ERROR_LOG.ERROR_APTITUDE_PROJECT%TYPE := 'g77_library';
    v_msg                       T_ERROR_LOG.ERROR_TEXT%TYPE;
    v_value                     T_ERROR_LOG.ERROR_VALUE%TYPE            := SUBSTR(p_project_name || '~' || p_microflow_name || '~' || p_session_id || '~' || p_use_case_id, 1, 200);
BEGIN
   -- This will 'close' all runnning processes, those that are actually running will be correctly updated by their respective processes.

   update t_batch_task_status
      set BATCH_TASK_STATUS = 'E', 
          BATCH_TASK_COMPLETED = 'Y',
          BATCH_TASK_END_TIMESTAMP = current_date
    where batch_task_status = 'R' 
      and batch_task_completed = 'N';
               
    commit;    
EXCEPTION 
  WHEN OTHERS THEN
    v_msg := 'Unexpected Failure when manually registering Batch Step complete.';
    ROLLBACK;    
    pr_error(v_project_name, v_rule_name, v_msg, p_value => v_value, p_use_case_id => p_use_case_id, p_session_id => p_session_id);
    RAISE;
END;
/