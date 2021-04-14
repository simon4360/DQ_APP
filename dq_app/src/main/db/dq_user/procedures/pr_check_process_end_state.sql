CREATE OR REPLACE PROCEDURE DQ_USER.pr_check_process_end_state
    (
        p_process_id     IN  NUMBER,
        p_use_case_id    IN  VARCHAR2,
        p_session_id     IN  VARCHAR2,
        p_return_code    OUT INT
    )
AS
    v_count      NUMBER DEFAULT 0;
    
    -- Error Logging
    e_batch_step_unregistered   EXCEPTION;
    v_rule_name                 T_ERROR_LOG.ERROR_RULE_IDENT%TYPE       := 'pr_check_process_end_state';
    v_project_name              T_ERROR_LOG.ERROR_APTITUDE_PROJECT%TYPE := 'g77_library';
    v_msg                       T_ERROR_LOG.ERROR_TEXT%TYPE;
    v_row                       T_ERROR_LOG.ROW_IN_ERROR_KEY_ID%TYPE    := TO_CHAR(p_process_id);
        
BEGIN

-- This procedure is executed after any microflow has run. Performs validation to check there has not been a "catastrophic" failure.

  SELECT COUNT(*) 
    INTO v_count  
    FROM DQ_USER.T_BATCH_TASK_STATUS 
   WHERE BATCH_TASK_PROCESS_ID = p_process_id
     AND BATCH_TASK_COMPLETED = 'Y';
  
  IF v_count = 1 THEN
    p_return_code := 0;
  ELSE
    p_return_code := 1;
  END IF; 
   
EXCEPTION 
  WHEN OTHERS THEN
    v_msg := 'Unexpected Failure Checking End State Batch Step - BATCH_TASK_PROCESS_ID: '|| p_process_id;
    ROLLBACK;    
    pr_error(v_project_name, v_rule_name, v_msg, p_source_system => p_use_case_id, p_row => v_row, p_batch_process_id => p_process_id, p_use_case_id => p_use_case_id, p_session_id => p_session_id);
    RAISE;
END;
/