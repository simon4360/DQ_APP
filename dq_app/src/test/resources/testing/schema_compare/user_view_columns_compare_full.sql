(select 
   release
 , owner
 , table_name
 , column_name
 , data_type
 , data_precision
 , data_scale
 , nullable
 , identity_column 
 from user_tab_columns_compare 
 where install_type = 'full'
   and (   table_name  like 'V_%'
        OR table_name  like 'VDMP%')
)