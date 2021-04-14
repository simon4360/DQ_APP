create or replace view DQ_USER.v_meta_batch_task_complete as 
select 
  i.aptitude_project 
, i.counterparty_system
, bt.process_name
, t.schema_name
, t.table_name
, btx.object_role
, btx.restart_mode
, nvl( btx.event_status_mode, 'edf') as event_status_mode
, btx.processed_rec_sql              as expected_rec_count_sql
, nvl ( btx.update_processed_sql, '1=1') as update_processed_sql
, bt.error_threshold
, bt.threshold_is_percent
, case 
    when nvl ( isCorDLTable.table_name, '1=1') <> '1=1' 
     and i.counterparty_system <> 'ALL' 
    then 'target = '''|| i.counterparty_system|| ''''
    else '1=1'
  end as target_specific_sql
, case when nvl( btx.event_status_mode, 'edf') = 'edf' then 0 else count(*) over (partition by i.aptitude_project, bt.process_name order by null) end as input_table_count
from DQ_USER.t_meta_batch_task bt
join 
     DQ_USER.t_meta_interface i 
  on bt.interface_id = i.interface_id
left join 
     DQ_USER.t_meta_batch_task_table_x btx 
  on ( btx.batch_task_id = bt.batch_task_id and 
  nvl( btx.event_status_mode, 'edf') != 'edf' and 
       btx.object_role = 'inbound' and 
       btx.restart_mode <> 'n/a' and 
       btx.active_indicator = 'A')
left join 
     DQ_USER.t_meta_table t 
  on (t.table_id = btx.table_id and t.active_indicator = 'A')
left join 
     (select table_name from user_tab_columns where column_name = 'TARGET' ) isCorDLTable 
  on isCorDLTable.table_name = t.table_name
WHERE 1=1 
  and bt.active_indicator = 'A'
  and i.is_active = 'A';