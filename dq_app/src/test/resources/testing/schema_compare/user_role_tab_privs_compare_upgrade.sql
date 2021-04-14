(
select 
   release
 , role
 , owner
 , table_name
 , column_name
 , privilege
 , grantable
 , common
 from user_role_tab_privs_compare 
    where install_type = 'upgrade' 
       and table_name not like 'MK%'
       and table_name not like 'MIGR_PART%'
 union
select 
   release
 , role
 , owner
 , table_name
 , column_name
 , privilege
 , grantable
 , common
 from user_role_tab_privs_compare 
 where install_type = 'full'
   and table_name not like 'MK%'
   and table_name not like 'MIGR_PART%'
   and not exists (select 1 
                     from user_role_tab_privs_compare 
                    where install_type = 'upgrade')
)
