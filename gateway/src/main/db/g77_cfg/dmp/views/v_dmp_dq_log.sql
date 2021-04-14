CREATE OR REPLACE VIEW G77_CFG.V_DMP_DQ_LOG
as
select dq.dq_status                           as original_run_status
     , decode(m_dq.dq_rule_type
             ,'B','Business'
             ,'T','Technical')                as dq_rule_type_long
     , dq.batch_process_id
     , dq.dq_timestamp
     , dq.dq_use_case_id                      as use_case_id
     , dq.dq_session_id                       as session_id        
     , i.aptitude_project
     , bt.process_name                        as aptitude_microflow
     , t.table_name
     , dq.dq_config_id
     , dq.dq_purpose
     , dq.dq_corrective_action
     , dq.dq_contact_team
     , dq.dq_records_processed
     , dq.dq_records_failed
     , dq.dq_failed_data_sql
     , m_dq.dq_rule_type
  from t_meta_batch_task         bt
  join t_meta_interface          i
    on bt.interface_id                = i.interface_id
  join t_meta_batch_task_table_x x
    on bt.batch_task_id               = x.batch_task_id
  join t_meta_table              t
    on x.table_id                     = t.table_id
  join t_dq_log                  dq
    on i.aptitude_project             = dq.dq_aptitude_project
   and bt.process_name                = dq.DQ_APTITUDE_MICROFLOW
  join T_META_TABLE_DQ           m_dq
    on m_dq.DQ_CONFIG_ID              = dq.DQ_CONFIG_ID
   and m_dq.table_id                  = t.table_id 
 where dq.DQ_RECORDS_FAILED   > 0
   and dq.dq_active_indicator ='A'
    order by dq.DQ_CONFIG_ID, DQ.DQ_TIMESTAMP;
/