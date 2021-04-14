create or replace view g77_cfg.v_meta_batch_task_restart as 
select 
  i.aptitude_project 
, i.counterparty_system
, bt.process_name
, t.technical_user
, t.schema_name
, t.table_name
, btx.object_role
, btx.restart_mode
, nvl ( btx.event_status_mode, 'edf') as event_status_mode
, bt.error_threshold
, bt.threshold_is_percent
from 
     g77_cfg.t_meta_table t
inner 
 join g77_cfg.t_meta_batch_task_table_x btx 
   on t.table_id = btx.table_id
inner 
 join g77_cfg.t_meta_batch_task bt 
   on btx.batch_task_id = bt.batch_task_id
inner 
 join g77_cfg.t_meta_interface i 
   on bt.interface_id = i.interface_id
WHERE 1=1 
  and btx.restart_mode <> 'n/a'
  and btx.active_indicator = 'A'
  and bt.active_indicator = 'A'
  and t.active_indicator = 'A'
  and i.is_active = 'A';
