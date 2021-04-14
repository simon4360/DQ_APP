begin
  for obj in (select trigger_name 
                from user_triggers 
               where lower(trigger_name) like 'mk%' 
             )
  loop 
    execute immediate 'drop trigger @g77_cfgUsername@. ' || obj.trigger_name;
  end loop ;
end;
/
