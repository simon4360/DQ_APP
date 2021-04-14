begin
  for obj in (select synonym_name 
                from user_synonyms 
               where lower(table_name) like 'mk_%'
             )
  loop 
    execute immediate 'drop synonym @g77_cfgUsername@.' || obj.synonym_name;
  end loop ;
end;
/
