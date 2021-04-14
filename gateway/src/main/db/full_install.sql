set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON

SET DEFINE OFF

prompt Logging in as G77_CFG

@connG77@

@g77_cfg/sequences/00_install.sql

@g77_cfg/tables_g77_meta/00_install.sql
@g77_cfg/tables_g77_cordl/00_install.sql


@g77_cfg/procedures/00_install.sql
@g77_cfg/packages_spec/00_install.sql
@g77_cfg/ri_constraints/00_install.sql
@g77_cfg/types/00_install.sql
@g77_cfg/functions/00_install.sql
@g77_cfg/views/00_install.sql
@g77_cfg/indexes/00_install.sql
@g77_cfg/triggers/00_install.sql
@g77_cfg/packages_body/00_install.sql

--Install the rest of the procedures
@g77_cfg/procedures/01_install.sql
@g77_cfg/synonyms/00_install.sql

--Install DMP
@g77_cfg/dmp/tables/00_install.sql
@g77_cfg/dmp/views/00_install.sql
@g77_cfg/dmp/functions/00_install.sql

commit;

exec dbms_utility.compile_schema(schema => upper('@g77_cfgUsername@'));

BEGIN
PKG_MAINTENANCE_UTIL.P_REGISTER_G77_DB_INSTALL('@versionTo@', 'gateway/src/main/db/full_install');
END;
/

commit;

exit 0