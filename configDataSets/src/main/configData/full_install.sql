set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON

conn @g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@

@db/g77_cfg/data/00_install.sql

BEGIN
PKG_MAINTENANCE_UTIL.P_REGISTER_G77_DB_INSTALL('@versionTo@', 'configDataSets/src/main/configData/full_install');
END;
/

commit; 

exit 0
