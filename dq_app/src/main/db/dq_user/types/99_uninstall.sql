begin
  for obj in (select type_name
                from user_types
             )
  loop 
    execute immediate 'drop type DQ_USER.' || obj.type_name || ' force';
  end loop ;
end;
/