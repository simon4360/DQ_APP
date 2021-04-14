begin
  for obj in (select object_name
                from user_objects
               where lower(object_type) = 'index' 
             )
  loop 
    execute immediate 'drop index DQ_USER.' || obj.object_name;
  end loop ;
end;
/