begin
  for obj in (select object_name 
                from user_procedures
               where lower(object_type) = 'procedure' 
                 and lower(object_name) like 'mk_%'
             )
  loop 
    execute immediate 'drop procedure @g77_cfgUsername@.' || obj.object_name;
  end loop ;
end;
/
