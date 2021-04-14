set define on

declare
  e_1917 exception;
  pragma exception_init ( e_1917, -1917);
  --Do not fail on ORA-01917 + ci: no such role
begin
  for obj in (
               select obj.object_name, config.privilege, config.user_or_role_name
                 from t_privs_config config inner join user_objects obj on  
                   (case
                     when lower(config.object_name) = 'all' then lower(obj.object_name)
                     else lower(config.object_name)
                   end) = lower(obj.object_name)
                   and lower(config.object_type) = lower(obj.object_type)
                where lower(config.object_type) = 'function'
             )
  loop 
    begin
      execute immediate 'grant ' || obj.privilege ||' on @g77_cfgUsername@.'|| obj.object_name ||' to ' || obj.user_or_role_name;
    exception
    when e_1917
    then 
      if ('&1' = 'ci' ) 
      then 
        null; 
      else 
        raise e_1917;
      end if;
    end;
  end loop ;
end;
/

set define off