(
select 
   release
 , grantee
 , owner
 , table_name
 , grantor
 , privilege
 , grantable
 , hierarchy
 , common
 , type
 from user_tab_privs_compare 
    where install_type = 'upgrade' 
      and table_name not like 'ISEQ%'
      and table_name not like 'USER%COMPARE'
      and table_name not like 'MK%'
      and table_name not like 'MIGR_PART%'
      and table_name not like 'V_GM%'
      and table_name not like 'SYS%'
 union
select 
   release
 , grantee
 , owner
 , table_name
 , grantor
 , privilege
 , grantable
 , hierarchy
 , common
 , type
 from user_tab_privs_compare 
 where install_type = 'full'
   and table_name not like 'ISEQ%'
   and table_name not like 'USER%COMPARE'
   and table_name not like 'MK%'
   and table_name not like 'MIGR_PART%'
   and table_name not like 'V_GM%'
   and table_name not like 'SYS%'
   and not exists (select 1 
                     from user_tab_privs_compare 
                    where install_type = 'upgrade')
)
