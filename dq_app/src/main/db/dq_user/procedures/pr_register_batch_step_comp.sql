CREATE OR REPLACE procedure DQ_USER.pr_register_batch_step_comp
     (p_process_id         IN     NUMBER
     ,p_use_case_id        IN     VARCHAR2
     ,p_session_id         IN     VARCHAR2
     ,p_records_processed  IN     NUMBER
     ,p_records_in_error   IN     NUMBER
     ,p_project_name       IN     VARCHAR2
     ,p_microflow_name     IN     VARCHAR2
     ,p_batch_task_status  IN OUT CHAR
     ) 
AS
    v_job_status             T_BATCH_TASK_STATUS.BATCH_TASK_STATUS%TYPE;
    v_threshold_is_percent   varchar2(1) := 'N';
    v_error_threshold        number := 0;
    v_event_status_mode      varchar2(30);
    v_target_column          number;
    v_thisTable_expected     number;
    v_batchTotal_expected    number := 0;
    v_thisTable_errors       number;
    v_batchTotal_errors      number := 0;
    v_thisTable_ok           number;
    v_batchTotal_ok          number := 0;
    v_number_of_input_tables number := 0;

    -- Error Logging
    e_batch_step_unregistered   EXCEPTION;
    v_msg                       T_ERROR_LOG.ERROR_TEXT%TYPE;
    v_row                       T_ERROR_LOG.ROW_IN_ERROR_KEY_ID%TYPE    := TO_CHAR(p_process_id);

BEGIN

    pr_info(p_project_name
           ,p_microflow_name
           ,'Completing process ' || p_project_name ||'.'||p_microflow_name  || ', p_records_processed: '||p_records_processed || ', p_records_in_error:  '||p_records_in_error 
           ,p_gateway_id       => v_row
           ,p_batch_process_id => p_process_id
           ,p_use_case_id      => p_use_case_id
           ,p_session_id       => p_session_id
           );

    v_job_status := p_batch_task_status;
    
    for set_event_states in (select btr.counterparty_system
                                  , btr.schema_name
                                  , btr.table_name
                                  , btr.threshold_is_percent
                                  , btr.error_threshold
                                  , btr.event_status_mode
                                  , regexp_replace ( btr.expected_rec_count_sql, 'REGEX_SESSION_ID' , p_session_id ) as rec_sql
                                  , regexp_replace ( btr.update_processed_sql  , 'REGEX_SESSION_ID' , p_session_id ) as upd_sql
                                  , btr.target_specific_sql
                                  , btr.input_table_count
                               from v_meta_batch_task_complete btr
                              where btr.aptitude_project = p_project_name
                                and btr.process_name     = p_microflow_name
                            )
    
        loop
               begin 
                      v_threshold_is_percent   := set_event_states.threshold_is_percent;
                      v_error_threshold        := set_event_states.error_threshold;
                      v_number_of_input_tables := set_event_states.input_table_count;
                      v_thisTable_expected     := 0;
                      v_thisTable_ok           := 0;
                      v_thisTable_errors       := 0;
              
              
                      --If there is a query defined in v_meta_batch_task_complete "expected_rec_count_sql" column, use this as the expected result
                      --otherwise use the number of records processed
                  if  length (set_event_states.rec_sql) > 0 
                then 
                      execute immediate set_event_states.rec_sql into v_thisTable_expected;
                else 
                      v_thisTable_expected := p_records_processed;
              end if;
              
                      v_batchTotal_expected := v_batchTotal_expected + v_thisTable_expected;
              
              
                      --If the event_status_mode has been configured as 'pr_register_batch_step_comp' in v_meta_batch_task_complete then the event status
                      --updates are handled by this section of code instead of the project.
              
                      --First set the errored records to event_status = 5
                  if  set_event_states.event_status_mode = 'pr_register_batch_step_comp'
                then
                      execute immediate 'merge into ' || set_event_states.schema_name ||'.'|| set_event_states.table_name ||' target 
                                              using ( select /*+ parallel (T_ERROR_LOG,8) */ distinct row_in_error_key_id as gateway_id 
                                                        from t_error_log 
                                                       where error_aptitude_project = ''' || p_project_name   || ''''||
                                                        'and error_rule_ident = '''       || p_microflow_name || ''''||
                                                        'and use_case_id = '''            || p_use_case_id    || ''''||
                                                        'and session_id = '''             || p_session_id     || ''''||
                                                        'and table_in_error_name = '''    || set_event_states.table_name || '''' ||
                                                        'and error_active_ind = ''A'''    ||
                                                   ') errors 
                                                 on ( target.gateway_id = errors.gateway_id )
                                               when matched then update 
                                                set target.event_status = 5';
                                               
                      v_thisTable_errors  := SQL%ROWCOUNT;
                      v_batchTotal_errors := v_batchTotal_errors + v_thisTable_errors;
                     
                      pr_info(p_project_name
                             ,p_microflow_name
                             ,v_thisTable_errors || ' records updated to event_status 5 in table '|| set_event_states.schema_name ||'.'|| set_event_states.table_name 
                             ,p_gateway_id       => v_row
                             ,p_batch_process_id => p_process_id
                             ,p_use_case_id      => p_use_case_id
                             ,p_session_id       => p_session_id
                             );
              
              
                     
                      --Next set the successfully processed records to event_status = 3       
                      EXECUTE IMMEDIATE 'UPDATE /*+ parallel ('|| set_event_states.table_name ||',8) */' || set_event_states.schema_name ||'.'|| set_event_states.table_name ||' target 
                                            SET target.EVENT_STATUS = 3  
                                          WHERE target.session_id = ''' || p_session_id || ''''||
                                           'AND target.event_status = 0 ' ||
                                           'AND '||set_event_states.target_specific_sql ||
                                           'AND '||set_event_states.upd_sql;
                     
                      v_thisTable_ok  := SQL%ROWCOUNT;
                      v_batchTotal_ok := v_batchTotal_ok + v_thisTable_ok;
                     
                      pr_info(p_project_name
                             ,p_microflow_name
                             ,v_thisTable_ok || ' records updated to event_status 3 in table '|| set_event_states.schema_name ||'.'|| set_event_states.table_name 
                             ,p_gateway_id       => v_row
                             ,p_batch_process_id => p_process_id
                             ,p_use_case_id      => p_use_case_id
                             ,p_session_id       => p_session_id
                             );
                 
              end if;
              
                 end;
              
    end loop;
    
    --If the number of successful rows + number of errored rows does not equal the expected number of updated rows, raise an error
        if v_number_of_input_tables > 0 and ( v_batchtotal_expected <> (nvl (v_batchtotal_ok, 0) + nvl ( v_batchtotal_errors , 0 )) )
      then
           v_msg        := 'Unexpected number of records updated in the input table(s) of this job : input records '|| v_batchTotal_expected || ', event_status 3 : '|| v_batchtotal_ok || ', event_status 5 : '|| v_batchTotal_errors ;
           v_job_status := 'E';
      
           pr_error(p_project_name
                   ,p_microflow_name
                   ,v_msg
                   ,p_row              => v_row
                   ,p_batch_process_id => p_process_id
                   ,p_use_case_id      => p_use_case_id
                   ,p_session_id       => p_session_id);
      
    end if;

    
    --If there was no query defined in v_meta_batch_task_complete "expected_rec_count_sql" column, use the number of processed records as the expected number of rows
        if v_batchTotal_expected = 0 
      then v_batchTotal_expected := p_records_processed; 
    end if;

    
    --Display the higher number of errors out of the number recorded by the process, or the number updated in the merge statement above.
    select greatest (p_records_in_error, v_batchtotal_errors ) 
      into v_batchtotal_errors 
      from dual; 


    --Check the error threshold if no earlier error is thrown. Default the status to C if there is no threshold configuration defined
        if v_job_status = 'C' 
      then
          
             SELECT NVL(MIN(  CASE WHEN v_threshold_is_percent = 'Y' 
                                   THEN 
                                        CASE WHEN (v_batchtotal_errors / decode(v_batchTotal_expected,0,1,v_batchTotal_expected))*100 > v_error_threshold 
                                             THEN 'E'
                                             ELSE 'C'
                                         END
                                   WHEN v_threshold_is_percent = 'N' 
                                   THEN
                                        CASE WHEN v_batchtotal_errors > v_error_threshold 
                                             THEN 'E'
                                             ELSE 'C'
                                         END
                               END
                           )
                       ,'C'
                       ) AS BATCH_TASK_STATUS
               INTO v_job_status
               FROM dual;
             
             -- Always fail the job if all records are failing
                 if v_batchtotal_errors > 0 AND ( v_batchTotal_expected = v_batchtotal_errors OR v_batchTotal_expected = 0 )
               then v_job_status := 'E';
             end if;
             
             
             --If the Job status has been set to "E", raise and error 
                 if v_job_status = 'E' 
               then v_msg := 'Error threshold breached in batch task - UC4_RUN_ID: '|| p_process_id;
                    pr_error(p_project_name
                            ,p_microflow_name
                            ,v_msg
                            ,p_row              => v_row
                            ,p_batch_process_id => p_process_id
                            ,p_use_case_id      => p_use_case_id
                            ,p_session_id       => p_session_id
                            );
             end if;

           --not sure where a status of 'H' is set, this maybe redundant?
     elsif v_job_status = 'H' 
      then v_job_status := 'C';
      
      else v_msg := 'Unexpected error in batch task - UC4_RUN_ID: '|| p_process_id;
           pr_error(p_project_name
                   ,p_microflow_name
                   ,v_msg
                   ,p_row              => v_row
                   ,p_batch_process_id => p_process_id
                   ,p_use_case_id      => p_use_case_id
                   ,p_session_id       => p_session_id
                   );
    end if;
  
    
    
    --Return the job status whic has been determined after all of this back to T_BATCH_TASK_STATUS 
    p_batch_task_status  := v_job_status;
    
    UPDATE G77_CFG.t_batch_task_status
       SET batch_task_status             = v_job_status
         , batch_task_completed          = 'Y'
         , batch_task_records_processed  = v_batchTotal_expected
         , batch_task_records_successful = decode(v_batchTotal_expected,0,0,v_batchTotal_expected - v_batchtotal_errors)
         , batch_task_records_in_error   = v_batchtotal_errors
         , batch_task_end_timestamp      = SYSDATE
         , dmp_error_active_indicator    = DECODE(v_job_status, 'E', 'A', NULL)
     WHERE batch_task_process_id         = p_process_id;


        IF sql%rowcount <> 0 
      THEN COMMIT;
      ELSE RAISE e_batch_step_unregistered;
    END IF;


EXCEPTION
  WHEN e_batch_step_unregistered 
  THEN v_msg := 'Failed Setting Batch Step ID to Complete - BATCH_TASK_PROCESS_ID: '|| p_process_id;
       ROLLBACK;
       pr_error(p_project_name
               ,p_microflow_name
               ,v_msg
               ,p_row              => v_row
               ,p_batch_process_id => p_process_id
               ,p_use_case_id      => p_use_case_id
               ,p_session_id       => p_session_id
               );
               
       RAISE_APPLICATION_ERROR (-20001, v_msg);
  WHEN OTHERS 
  THEN v_msg := 'Unexpected Failure Setting Batch Step ID to Complete - SQLERRM: '|| SQLERRM;
       ROLLBACK;
       pr_error(p_project_name
               ,p_microflow_name
               ,v_msg
               ,p_row              => v_row
               ,p_batch_process_id => p_process_id
               ,p_use_case_id      => p_use_case_id
               ,p_session_id       => p_session_id
               );
       RAISE;
END;
/
