set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON

prompt Logging in as G77_CFG

@connG77@

BEGIN
PKG_MAINTENANCE_UTIL.P_REGISTER_G77_VERSION('@versionTo@');
END;
/
commit;

exit 0
