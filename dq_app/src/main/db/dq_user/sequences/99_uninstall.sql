begin
  for obj in (select sequence_name 
                from user_sequences 
               where sequence_name not like 'ISEQ%'
             )
  loop 
    execute immediate 'drop sequence DQ_USER.' || obj.sequence_name;
  end loop ;
end;
/