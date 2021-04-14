begin
  for obj in (select table_name 
                from user_tables 
               where lower(table_name) not in 
               ( 'user_objects_compare'
               , 'user_source_compare'
               , 'user_tab_columns_compare'
               , 'user_ind_columns_compare'
               , 'user_tab_privs_compare'
               , 'user_role_privs_compare'
               , 'user_role_tab_privs_compare'
               )
             )
  loop 
    execute immediate 'drop table @g77_cfgUsername@.' || obj.table_name || ' CASCADE CONSTRAINTS';
  end loop ;
end;
/