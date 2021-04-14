set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON

conn @g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@

-- Drop mock objects
@@uninstall.sql

-- Create mock objects
@@db/g77_cfg/tables/00_install.sql
@@db/g77_cfg/sequences/00_install.sql
@@db/g77_cfg/triggers/00_install.sql
@@db/g77_cfg/synonyms/00_install.sql
@@db/g77_cfg/procedures/00_install.sql
@db/g77_cfg/views/00_install.sql
@db/g77_cfg/ri_constraints/00_install.sql

BEGIN
PKG_MAINTENANCE_UTIL.P_REGISTER_G77_DB_INSTALL('@versionTo@', 'configDataSets/src/main/mockIntegration/full_install');
END;
/

commit;

exit 0
