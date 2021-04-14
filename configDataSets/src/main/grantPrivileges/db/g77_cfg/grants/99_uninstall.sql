begin
  for obj in (select distinct privs.owner, privs.grantee, privs.table_name
                from user_tab_privs privs 
               where lower(owner)   = lower('@g77_cfgUsername@')
             )
  loop
    execute immediate 'revoke all on @g77_cfgUsername@.' || obj.table_name || ' from ' || obj.grantee;
  end loop;
end;
/