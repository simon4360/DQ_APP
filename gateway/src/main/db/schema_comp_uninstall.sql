set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE
set sqlblanklines on

prompt Logging in as G77_CFG

@connG77@

@g77_cfg/views/99_uninstall.sql
@g77_cfg/types/99_uninstall.sql

begin
  for obj in (select table_name 
                from user_tables 
               where lower(table_name) not in 
               ( 'user_objects_compare'
               , 'user_source_compare'
               , 'user_tab_columns_compare'
               , 'user_ind_columns_compare'
               , 'user_tab_privs_compare'
               , 'user_role_privs_compare'
               , 'user_role_tab_privs_compare'
               )
             )
  loop 
    execute immediate 'drop table @g77_cfgUsername@.' || obj.table_name || ' CASCADE CONSTRAINTS';
  end loop ;
end;
/

@g77_cfg/indexes/99_uninstall.sql
@g77_cfg/sequences/99_uninstall.sql
@g77_cfg/triggers/99_uninstall.sql
@g77_cfg/procedures/99_uninstall.sql
@g77_cfg/functions/99_uninstall.sql
@g77_cfg/packages_spec/99_uninstall.sql
@g77_cfg/packages_body/99_uninstall.sql
@g77_cfg/synonyms/99_uninstall.sql


commit;

prompt Logging in as G77_CFG_TEC
@connG77TEC@

@g77_cfg_tec/synonyms/99_uninstall.sql

commit;

exit 0
