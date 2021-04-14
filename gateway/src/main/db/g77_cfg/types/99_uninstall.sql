begin
  for obj in (select type_name
                from user_types
             )
  loop 
    execute immediate 'drop type @g77_cfgUsername@.' || obj.type_name || ' force';
  end loop ;
end;
/