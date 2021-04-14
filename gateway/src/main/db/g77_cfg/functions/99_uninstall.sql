begin
  for obj in (select object_name
                from user_objects
               where lower(object_type) = 'function' 
             )
  loop 
    execute immediate 'drop function @g77_cfgUsername@.' || obj.object_name;
  end loop ;
end;
/