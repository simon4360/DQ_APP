begin
  for obj in (select distinct privs.owner, privs.table_name 
                from user_tab_privs privs
               where lower(privs.grantee) = lower('@g77_cfg_tecUsername@')
                and  lower(privs.owner) not like lower('sys%')
              union               
              select distinct privs.owner, privs.table_name 
                from role_tab_privs privs
                inner join user_role_privs role
                  on role.granted_role = privs.role
               where lower(role.username) = lower('@g77_cfg_tecUsername@')
                and  lower(privs.owner) not like lower('sys%')
              union
              --create synonyms for the mock table synonyms
              select distinct syn.owner, syn.synonym_name  
                from all_synonyms syn               
               where lower(syn.owner)     = lower('@g77_cfgUsername@')
             )
  loop 
    execute immediate 'create or replace synonym @g77_cfg_tecUsername@.' || obj.table_name || '
                         for ' || obj.owner || '.' || obj.table_name;
  end loop ;
end;
/

create or replace synonym @g77_cfg_tecUsername@.t_project_config for @g77_cfg_tecUsername@.t_meta_interface;