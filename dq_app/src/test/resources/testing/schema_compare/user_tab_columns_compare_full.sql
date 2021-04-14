(select 
   release
 , owner
 , table_name
 , column_name
 , data_type
 , data_length
 , data_precision
 , data_scale
 , nullable
 , identity_column 
 from user_tab_columns_compare 
 where install_type = 'full'
   and table_name not like 'ER_%'
   and table_name not like 'MK%'
   and table_name not like 'MIGR_PART%'
   and table_name not like 'V_%'
   and table_name not like 'VDMP%'
)