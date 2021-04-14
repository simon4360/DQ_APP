create or replace FUNCTION DQ_USER.FN_DMP_INACTIVATE_ERR_SESSION (json_data in clob)
  RETURN       NUMBER
IS
  exec_stat    NUMBER(2, 0);
  v_rule_name  VARCHAR2(30) := 'fn_dmp_inactivate_err_session';
  v_msg                       T_ERROR_LOG.ERROR_TEXT%TYPE;
  v_archive_event_status  NUMBER(1)    := 3;
  v_failed_event_status   NUMBER(1)    := 5;
  v_hold_event_status     NUMBER(1)    := 9;
  
BEGIN
  FOR data_param_row IN (SELECT *
                           FROM json_table(json_data
                                          ,'$.data[*]' COLUMNS("SESSION_ID"     PATH '$.param1'
                                                              )
                                          )
                        )
--sample JSON data to test with: {"data" : {"param1" : "G72_123"}}                        
LOOP

FOR result IN (                        
               select distinct TABLE_NAME
                 from T_BATCH_TASK_STATUS bs
                 join V_META_BATCH_TASK_DETAIL v
                   on v.APTITUDE_PROJECT = bs.BATCH_TASK_APTITUDE_PROJECT
                  and v.PROCESS_NAME     = bs.BATCH_TASK_APTITUDE_MICROFLOW
               where bs.DMP_ERROR_ACTIVE_INDICATOR = 'A'
                 and v.SCHEMA_NAME                 ='DQ_USER'
                 and bs.batch_task_session_id      = data_param_row.SESSION_ID
                 )    
  LOOP
      
      EXECUTE IMMEDIATE 'UPDATE ' || result.TABLE_NAME || 
                        ' SET EVENT_STATUS       = ' || v_archive_event_status || '
                        WHERE EVENT_STATUS      != ' || v_archive_event_status || '
                          AND lower(SESSION_ID)  = lower(''' || data_param_row.SESSION_ID  || ''')';

  END LOOP;


      UPDATE T_ERROR_LOG 
         SET ERROR_ACTIVE_IND = 'I'
       WHERE SESSION_ID       = data_param_row.SESSION_ID
         AND ERROR_ACTIVE_IND = 'A';
         
      UPDATE T_DQ_LOG 
         SET DQ_ACTIVE_INDICATOR = 'I'
       WHERE DQ_SESSION_ID       = data_param_row.SESSION_ID
         AND DQ_ACTIVE_INDICATOR = 'A';         


      UPDATE T_BATCH_TASK_STATUS 
         SET DMP_ERROR_ACTIVE_INDICATOR = 'I'
       WHERE BATCH_TASK_SESSION_ID      = data_param_row.SESSION_ID;

  COMMIT;
  
END LOOP;



  exec_stat := 0;
  RETURN(exec_stat);
EXCEPTION
  WHEN OTHERS THEN
    v_msg := 'Unexpected Failure inactivating Error Message';
    ROLLBACK;
    pr_error('DMP Front End', v_rule_name, v_msg, p_use_case_id => 'DMP');
    RAISE;
    exec_stat := 1;
end FN_DMP_INACTIVATE_ERR_SESSION;
/