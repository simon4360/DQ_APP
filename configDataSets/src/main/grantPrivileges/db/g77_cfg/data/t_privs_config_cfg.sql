declare
  c int;
  target_table_name varchar2(30) := 't_privs_config';
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
 
  
commit;

declare
  target_table_name varchar2(30) := 't_privs_config';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'g77_cfg';
begin
  -- Delete removed configuration
  execute immediate '
  delete from '                     || target_schema || '.'  || target_table_name || ' target
  where not exists (select 1 from ' || target_schema || ' .' || merge_table_name  || ' cfg
                     where     target.user_or_role_name   = cfg.user_or_role_name
                           and target.object_type         = cfg.object_type
                           and target.object_name         = cfg.object_name
                   )';

  -- Merge cfg with target table
  execute immediate '
  merge
   into
     ' || target_schema || '.' || target_table_name || ' target
  using
    (select
       cfg.user_or_role_name
      ,cfg.object_name
      ,cfg.object_type
      ,cfg.privilege
     from ' || target_schema || '.' || merge_table_name || ' cfg
     ) cfg
  on (    target.user_or_role_name   = cfg.user_or_role_name
      and target.object_type         = cfg.object_type
      and target.object_name         = cfg.object_name
     )
  when matched
  then
    update set
      target.privilege = cfg.privilege
  when not matched then insert
    ( target.user_or_role_name
     ,target.object_type
     ,target.object_name
     ,target.privilege
    )
    values
    ( cfg.user_or_role_name
     ,cfg.object_type
     ,cfg.object_name
     ,cfg.privilege
    )';
  commit;

  -- Drop temp table
  execute immediate 'drop table ' || target_schema || '.' || merge_table_name;
end;
/

commit;                
