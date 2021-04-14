merge into g77_cfg.t_build_version
using
dual on ( 1 = 1)
when matched then
  update set 
  current_build = '@versionTo@',
  build_date    = sysdate
when not matched then insert   
  (current_build , build_date)
values
  ( '@versionTo@', sysdate );

commit; 