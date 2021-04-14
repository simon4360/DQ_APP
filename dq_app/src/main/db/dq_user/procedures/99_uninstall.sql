begin
  for obj in (select object_name
                from user_objects
               where lower(object_type) = 'procedure' 
             )
  loop 
    execute immediate 'drop procedure DQ_USER.' || obj.object_name;
  end loop ;
end;
/