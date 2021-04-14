create or replace view g77_cfg.v_meta_batch_task_gather_stats as
 select
  i.aptitude_project
, bt.process_name as aptitude_microflow
, t.schema_name
, t.table_name
, nvl( t.stats_refresh_min, 120 ) as stats_refresh_min 
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
  and btx.active_indicator = 'A'
  and bt.active_indicator = 'A'
  and t.active_indicator = 'A'
  and i.is_active = 'A'
  and nvl(lower ( btx.gather_stats), 'no') = 'yes'
  ;