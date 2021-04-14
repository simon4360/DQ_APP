begin
  for obj in (select view_name 
                from user_views
             )
  loop 
    execute immediate 'drop view @g77_cfgUsername@.' || obj.view_name;
  end loop ;
end;
/