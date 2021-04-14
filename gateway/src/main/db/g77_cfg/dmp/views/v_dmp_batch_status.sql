CREATE OR REPLACE VIEW G77_CFG.V_DMP_BATCH_STATUS 
AS 
  select i.aptitude_project
     , bt.process_name                        as aptitude_microflow
     , t.table_name
     , bs.BATCH_TASK_PROCESS_ID               as batch_process_id
     , bs.batch_task_use_case_id              as use_case_id
     , bs.batch_task_session_id               as session_id
     , bs.batch_task_status                   as status
     , bs.batch_task_start_timestamp          as start_time
     , bs.batch_task_end_timestamp            as end_time
     , bs.dmp_error_active_indicator          as error_active_ind
  from t_meta_batch_task         bt
  join t_meta_interface          i
    on bt.interface_id              = i.interface_id
  join t_meta_batch_task_table_x x
    on bt.batch_task_id             = x.batch_task_id
  join t_meta_table              t
    on x.table_id                   = t.table_id
  join t_batch_task_status  bs
    on i.aptitude_project           = bs.batch_task_aptitude_project
   and bt.process_name              = bs.batch_task_aptitude_microflow
  where bs.dmp_error_active_indicator ='A'
    and x.object_role = 'inbound'
    and t.table_name  !='REF_EXCHANGE_RATE_TRIAGE';
/