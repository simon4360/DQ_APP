CREATE OR REPLACE VIEW DQ_USER.V_DMP_ERROR_LOG
as
select e.error_status                         
     , count(*)                              as error_count
     , e.batch_process_id
     , e.event_datetime
     , e.use_case_id
     , e.session_id
     , i.aptitude_project
     , bt.process_name                       as aptitude_microflow
     , t.table_name
     , e.error_text
     , s.dq_severity                         as severity
     , e.error_active_ind  
     ,'select * from T_ERROR_LOG '||chr(10) 
      ||'where SESSION_ID = '''||e.session_id||''''||chr(10) 
      ||'and ERROR_APTITUDE_PROJECT = '''||i.aptitude_project||''''||chr(10) 
      ||'and ERROR_RULE_IDENT = '''||bt.process_name||''''   as sql_query
  from t_meta_batch_task         bt
  join t_meta_interface          i
    on bt.interface_id               = i.interface_id
  join t_meta_batch_task_table_x x
    on bt.batch_task_id              = x.batch_task_id
  join t_meta_table              t
    on x.table_id                    = t.table_id
  join t_batch_task_status       bts
    on i.aptitude_project            = bts.batch_task_aptitude_project
   and bt.process_name               = bts.batch_task_aptitude_microflow
  join t_error_log               e
    on e.batch_process_id            = bts.batch_task_process_id 
  join T_DQ_SEVERITY             s
    on nvl(e.severity, '3')          = s.dq_severity_id
 where e.error_active_ind            ='A'
   and (   i.counterparty_role ='source' and x.object_role = 'outbound'
        or i.counterparty_role ='target' and x.object_role = 'inbound'
        or i.counterparty_role ='other'
       )
   and t.table_name  !='REF_EXCHANGE_RATE_TRIAGE'
   and dq_rule_type is null
 group by e.error_status                         
     , e.batch_process_id
     , e.event_datetime
     , e.use_case_id
     , e.session_id
     , i.aptitude_project
     , bt.process_name
     , t.table_name
     , e.error_text
     , s.dq_severity
     , e.error_active_ind

/*
with srv as (select * 
               from (select srv.*
                          , ROW_NUMBER() OVER (PARTITION BY srv.EXECUTION_NUMBER,srv.LOG_LEVEL
                                                   ORDER BY srv.LOG_LEVEL desc
                                              )                                                AS rnk 
                       from (select distinct
                                    srv.LOG_LEVEL
                                  , substr(srv.LOG_TIMESTAMP,1,19) as LOG_TIMESTAMP 
                                  , srv.PROJECT
                                  , srv.LOG_MESSAGE
                                  , srv.EXECUTION_NUMBER
                               from t_aptsrv srv
                               join T_BATCH_TASK_STATUS bts
                                 on to_char(bts.BATCH_TASK_START_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') <= substr(log_timestamp,1,19)
                                and to_char(bts.BATCH_TASK_END_TIMESTAMP  , 'YYYY-MM-DD HH24:MI:SS') >= substr(log_timestamp,1,19)
                                and substr(srv.PROJECT,1,11)        = bts.batch_task_aptitude_project
                                and srv.LOG_MESSAGE like '%ORA-%'
                            ) srv
                             order by rnk 
                    )
              where rnk =1
            )
UNION

select bts.batch_task_status                         
     , count(*)                              as error_count
     , bts.batch_task_uc4_run_id
     , bts.batch_task_start_timestamp
     , bts.batch_task_use_case_id
     , bts.batch_task_session_id
     , i.aptitude_project
     , bt.process_name                       as aptitude_microflow
     , t.table_name
     , srv.LOG_MESSAGE
     , 'Error'                         as severity
     , bts.dmp_error_active_indicator
     ,'select * from T_ERROR_LOG '||chr(10) 
      ||'where SESSION_ID = '''||bts.batch_task_session_id||''''||chr(10) 
      ||'and ERROR_APTITUDE_PROJECT = '''||i.aptitude_project||''''||chr(10) 
      ||'and ERROR_RULE_IDENT = '''||bt.process_name||''''   as sql_query
  from t_meta_batch_task         bt
  join t_meta_interface          i
    on bt.interface_id               = i.interface_id
  join t_meta_batch_task_table_x x
    on bt.batch_task_id              = x.batch_task_id
  join t_meta_table              t
    on x.table_id                    = t.table_id
  join t_batch_task_status       bts
    on i.aptitude_project            = bts.batch_task_aptitude_project
   and bt.process_name               = bts.batch_task_aptitude_microflow
  join srv
    on to_char(bts.BATCH_TASK_START_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') <= srv.log_timestamp
   and to_char(bts.BATCH_TASK_END_TIMESTAMP  , 'YYYY-MM-DD HH24:MI:SS') >= srv.log_timestamp
   and substr(srv.PROJECT,1,11)        = bts.batch_task_aptitude_project 
 where bts.dmp_error_active_indicator            ='A'
   and (   i.counterparty_role ='source' and x.object_role = 'outbound'
        or i.counterparty_role ='target' and x.object_role = 'inbound'
        or i.counterparty_role ='other'
       )
   and t.table_name  !='REF_EXCHANGE_RATE_TRIAGE'
 group by bts.batch_task_status                         
     , bts.batch_task_uc4_run_id
     , bts.batch_task_start_timestamp
     , bts.batch_task_use_case_id
     , bts.batch_task_session_id
     , i.aptitude_project
     , bt.process_name
     , t.table_name
     , srv.LOG_MESSAGE
     , bts.dmp_error_active_indicator
*/;
/