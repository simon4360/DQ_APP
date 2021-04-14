set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON

conn @g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@

@db/g77_cfg/upgrade/00_install.sql

exec pr_meta_validate_config;

BEGIN
PKG_MAINTENANCE_UTIL.P_REGISTER_G77_DB_INSTALL('@versionTo@', 'configDataSets/src/main/configData/upgrade_install');
END;
/


commit; 

exit 0
