/*******************************************************************************
Reset the events that are currently in Hold status for reprocessing
The procedure will run on a use case basis, using the dq config
It will update the session id with the session id the job was called with
and it will reset the event status back to 0.
*******************************************************************************/
create or replace PROCEDURE DQ_USER.PR_RESET_EVENTS_ON_HOLD
    (
          p_process_id       IN NUMBER
        , p_use_case_id      IN VARCHAR2
        , p_session_id       IN VARCHAR2
        , p_aptitude_project IN VARCHAR2
        , p_microflow        IN VARCHAR2
        , o_return_code      OUT NUMBER
    )
AS
  v_hold_status        NUMBER       := 9;
  v_unprocessed_status NUMBER       := 0;
  v_proc_name          VARCHAR2(30) := 'pr_reset_events_on_hold';
  v_row_count          NUMBER;

  l_cursor             SYS_REFCURSOR;
  v_session_id         VARCHAR2(200);
  dq_return_code       NUMBER;

  v_error_msg          VARCHAR2(32000);
  v_ecode              NUMBER       := -20999;
BEGIN

	FOR c IN
     (SELECT distinct mic.DQ_STAGING_TABLE,mic.DQ_MICROFLOW
        from v_meta_batch_task_dq mic  
       where lower(mic.dq_microflow)        = lower(p_microflow)
         and lower(mic.dq_aptitude_project) = lower(p_aptitude_project)
         and mic.dq_activation = 'NORMAL'
     )
  LOOP
    -- Run DQ checks for all session ids that have held records
    OPEN l_cursor FOR 'SELECT distinct SESSION_ID
                         FROM ' || c.DQ_STAGING_TABLE || ' stg
                       WHERE lower(stg.USE_CASE_ID) = lower(''' || p_use_case_id || ''')
                         AND stg.EVENT_STATUS =  ' || v_hold_status || '
                         AND stg.SESSION_ID <> ''' ||  p_session_id || '''';
    LOOP
       FETCH l_cursor INTO v_session_id;
       EXIT WHEN l_cursor%NOTFOUND;

       -- Inactivate the error message for held events
       EXECUTE IMMEDIATE
        ' UPDATE T_ERROR_LOG log
             SET ERROR_ACTIVE_IND = ''I''
          WHERE EXISTS ( SELECT ''X'' FROM ' || c.DQ_STAGING_TABLE || ' stg
                           WHERE log.ROW_IN_ERROR_KEY_ID = stg.GATEWAY_ID
                             AND SESSION_ID   = ''' || v_session_id || '''
                             AND lower(stg.USE_CASE_ID) = lower(''' || p_use_case_id || ''')
                             AND stg.EVENT_STATUS =  ' || v_hold_status || ' )
            AND log.TABLE_IN_ERROR_NAME = ''' || c.DQ_STAGING_TABLE || '''
            AND log.SEVERITY            IN (2, 5)
            AND log.ERROR_ACTIVE_IND = ''A''';

       -- Reset the status for held events
       EXECUTE IMMEDIATE
        ' UPDATE ' || c.DQ_STAGING_TABLE || '
             SET EVENT_STATUS = '   || v_unprocessed_status || '
          WHERE EVENT_STATUS = '   || v_hold_status || '
            AND lower(USE_CASE_ID)  = lower(''' || p_use_case_id || ''')
            AND SESSION_ID   = ''' || v_session_id || '''';

       -- Run the dq rules for that session/staging table
       pkg_dq_rules.pr_dq_wrapper (  p_process_id               =>    p_process_id
                                   , p_use_case_id              =>    p_use_case_id
                                   , p_session_id               =>    v_session_id
                                   , p_aptitude_project         =>    p_aptitude_project
                                   , p_rule_category            =>    'ROW'
                                   , p_microflow                =>    c.DQ_MICROFLOW
                                   , p_is_restart               =>    NULL
                                   , o_return_code              =>    dq_return_code
       );

       IF dq_return_code = 0
       THEN
         -- Set the session id for any records that passed dq rules
         EXECUTE IMMEDIATE
          ' UPDATE ' || c.DQ_STAGING_TABLE || '
               SET SESSION_ID   = ''' || p_session_id || '''
            WHERE EVENT_STATUS = '   || v_unprocessed_status || '
              AND lower(USE_CASE_ID)  = lower(''' || p_use_case_id || ''')
              AND SESSION_ID   = ''' || v_session_id || '''';

         v_row_count := SQL%ROWCOUNT;
       ELSE
         v_row_count := 0;
       END IF;

       pr_info( p_aptitude_project, v_proc_name, c.DQ_STAGING_TABLE || ': ' || v_row_count ||' held record reset for reprocessing for session id: ' || v_session_id || '.', p_table => c.DQ_STAGING_TABLE, p_batch_process_id => p_process_id, p_use_case_id => p_use_case_id, p_session_id => p_session_id );

       COMMIT;
     END LOOP;

  END LOOP;

  -- Only fail if technical error - not if dq rules fail for previous sessions
	o_return_code := 0;

EXCEPTION WHEN OTHERS THEN
  v_error_msg := 'Failure in ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm || ';' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
  ROLLBACK;
  o_return_code := 1;
  pr_error(p_aptitude_project, v_proc_name, v_error_msg, p_batch_process_id => p_process_id, p_use_case_id => p_use_case_id, p_session_id => p_session_id, p_value => p_use_case_id, p_table => 'V_META_BATCH_TASK_DQ', p_field => 'DQ_USE_CASE_ID');
  RAISE_APPLICATION_ERROR(v_ecode, v_error_msg);
END;
/
