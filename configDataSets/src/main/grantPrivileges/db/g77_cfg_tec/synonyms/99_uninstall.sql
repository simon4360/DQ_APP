begin
  for obj in (select syn.synonym_name
                from user_synonyms syn
             )
  loop 
    execute immediate 'drop synonym @g77_cfg_tecUsername@.' || obj.synonym_name;
  end loop ;
end;
/