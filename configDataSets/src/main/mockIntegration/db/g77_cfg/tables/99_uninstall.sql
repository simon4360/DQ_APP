begin
  for obj in (select table_name 
                from user_tables 
               where lower(table_name) like 'mk_%'
             )
  loop 
    execute immediate 'drop table @g77_cfgUsername@.' || obj.table_name;
  end loop ;
end;
/