begin
  for obj in (select table_name 
                from user_tables 
             )
  loop 
    execute immediate 'drop table DQ_USER.' || obj.table_name || ' CASCADE CONSTRAINTS';
  end loop ;
end;
/