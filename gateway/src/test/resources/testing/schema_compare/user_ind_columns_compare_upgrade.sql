( select
    release
  , owner
  , index_name
  , table_name
  , column_name
  , column_position
  , column_length
  , char_length
  , descend
    from user_ind_columns_compare 
   where install_type = 'upgrade' 
     and index_name not like 'SYS%'
     and table_name not like 'ER_%'
     and table_name not like 'MK_%'
     and table_name not like 'MIGR_PART%'
     and table_name not like 'V_GM%'
union
 select
    release
  , owner
  , index_name
  , table_name
  , column_name
  , column_position
  , column_length
  , char_length
  , descend
    from user_ind_columns_compare 
   where install_type = 'full' and NOT exists (select 1 
                                                 from user_ind_columns_compare 
                                                where install_type = 'upgrade')
    and index_name not like 'SYS%'
    and table_name not like 'ER_%'
    and table_name not like 'MK_%'
    and table_name not like 'MIGR_PART%'
    and table_name not like 'V_GM%'
)
