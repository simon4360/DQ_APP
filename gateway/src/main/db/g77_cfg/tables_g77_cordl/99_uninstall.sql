begin
  for obj in (select table_name 
                from user_tables 
             )
  loop 
    execute immediate 'drop table @g77_cfgUsername@.' || obj.table_name || ' CASCADE CONSTRAINTS';
  end loop ;
end;
/