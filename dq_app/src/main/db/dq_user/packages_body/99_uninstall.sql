begin
  for obj in (select object_name
                from user_objects
               where lower(object_type) = 'package' 
             )
  loop 
    execute immediate 'drop package DQ_USER.' || obj.object_name;
  end loop ;
end;
/