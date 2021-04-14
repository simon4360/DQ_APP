declare
  c int;
  target_table_name varchar2(30) := 't_dq_severity';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'g77_cfg';
begin

  -- Tidy up and create merge table
  select count(*) into c 
    from all_tables
   where lower(table_name) = merge_table_name
     and lower(owner)      = target_schema;
  if c = 1 then
    execute immediate('drop table ' || target_schema || '.' || merge_table_name);
  end if;
  execute immediate('create table ' || target_schema || '.' || merge_table_name ||
                    ' as select * from ' || target_schema || '.' ||
                    target_table_name || ' where 1=0');
end;
/

-- Insert configuration
set define off
insert into g77_cfg.t_dq_severity_cfg ( dq_severity_id, dq_severity, dq_severity_desc ) 
  values (1, 'Warning', 'Send transaction through with warning' );
insert into g77_cfg.t_dq_severity_cfg ( dq_severity_id, dq_severity, dq_severity_desc ) 
  values (2, 'Hold', 'Hold transaction' );
insert into g77_cfg.t_dq_severity_cfg ( dq_severity_id, dq_severity, dq_severity_desc ) 
  values (3, 'Error', 'Fail only erroneous transactions back to source system for fixing' );
insert into g77_cfg.t_dq_severity_cfg ( dq_severity_id, dq_severity, dq_severity_desc ) 
  values (4, 'Batch Fails', 'Fail entire batch back to source system for fixing' );  
insert into g77_cfg.t_dq_severity_cfg ( dq_severity_id, dq_severity, dq_severity_desc ) 
  values (5, 'Hold Batch', 'Hold entire batch' );
insert into g77_cfg.t_dq_severity_cfg ( dq_severity_id, dq_severity, dq_severity_desc ) 
  values (6, 'Discard Data', 'Discard and exclude from reprocesing' );  
commit;

declare
  target_table_name varchar2(30) := 't_dq_severity';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'g77_cfg';
begin
  -- Delete removed configuration
  execute immediate '
  delete from '                     || target_schema || '.'  || target_table_name || ' target 
  where not exists (select 1 from ' || target_schema || ' .' || merge_table_name  || ' cfg 
                     where     target.dq_severity_id   = cfg.dq_severity_id 
                   )';
                   
  -- Merge cfg with target table
  execute immediate '
  merge
   into
     ' || target_schema || '.' || target_table_name || ' target
  using
    (select   
       cfg.dq_severity_id
      ,cfg.dq_severity
      ,cfg.dq_severity_desc
     from ' || target_schema || '.' || merge_table_name || ' cfg
     ) cfg
  on (    target.dq_severity_id   = cfg.dq_severity_id
     )
  when matched 
  then 
    update set 
        target.dq_severity = cfg.dq_severity
      , target.dq_severity_desc = cfg.dq_severity_desc
  when not matched then insert 
    ( target.dq_severity_id
     ,target.dq_severity
     ,target.dq_severity_desc
    ) 
    values 
    ( cfg.dq_severity_id
     ,cfg.dq_severity
     ,cfg.dq_severity_desc
    )';
  commit; 
  
  -- Drop temp table
  execute immediate 'drop table ' || target_schema || '.' || merge_table_name;
end;
/

commit;