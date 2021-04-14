begin
  for obj in (select object_name
                from user_objects
               where lower(object_type) = 'procedure' 
             )
  loop 
    execute immediate 'drop procedure @g77_cfgUsername@.' || obj.object_name;
  end loop ;
end;
/