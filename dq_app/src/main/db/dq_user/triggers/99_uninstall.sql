begin
  for obj in (select trigger_name
                from user_triggers
             )
  loop 
    execute immediate 'drop trigger DQ_USER.' || obj.trigger_name;
  end loop ;
end;
/