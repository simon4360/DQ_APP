(
select 
   release
 , username
 , granted_role
 , admin_option
 , delegate_option
 , default_role
 , os_granted
 , common
 from user_role_privs_compare 
    where install_type = 'upgrade' 
 union
select 
   release
 , username
 , granted_role
 , admin_option
 , delegate_option
 , default_role
 , os_granted
 , common
 from user_role_privs_compare 
 where install_type = 'full'
   and not exists (select 1 
                     from user_role_privs_compare 
                    where install_type = 'upgrade')
)