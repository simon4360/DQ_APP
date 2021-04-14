begin
  for obj in (select sequence_name 
                from user_sequences 
               where lower(sequence_name) like 'mk%' 
             )
  loop 
    execute immediate 'drop sequence @g77_cfgUsername@.' || obj.sequence_name;
  end loop ;
end;
/