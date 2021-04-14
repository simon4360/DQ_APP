(select 
   release
 , owner
 , object_type
 , object_name
 , status
 , temporary
 , generated
 , secondary 
   from user_objects_compare 
  where install_type = 'upgrade' 
  and object_name not like 'ISEQ$$%'
  and object_name not like 'ER_%'
  and object_name not like 'MK%'   
  and object_name not like 'MIGR_PART%'
  and object_name not like 'V_GM%'
  and object_type <> 'SYNONYM'
 union
 select 
   release
 , owner
 , object_type
 , object_name
 , status
 , temporary
 , generated
 , secondary 
   from user_objects_compare 
  where install_type = 'full' 
    and not exists (select 1 
                      from user_objects_compare 
                      where install_type = 'upgrade')
    and object_name not like 'ISEQ$$%'
    and object_name not like 'ER_%'
    and object_name not like 'MK%'
    and object_name not like 'MIGR_PART%'
    and object_name not like 'V_GM%'
    and object_type <> 'SYNONYM'
)
