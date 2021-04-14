(select 
   release
 , owner
 , name
 , type
 , line
 , text 
    from user_source_compare 
   where install_type = 'upgrade' 
         and name not like 'MK%'
         and name not like 'MIGR_PART%'
 union
 select 
    release
  , owner
  , name
  , type
  , line
  , text 
    from user_source_compare 
   where install_type = 'full' 
     and name not like 'MK%'
     and name not like 'MIGR_PART%'
     and not exists (select 1 
                       from user_source_compare 
                      where install_type = 'upgrade')
)
