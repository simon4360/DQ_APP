set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON

SET DEFINE OFF

prompt Logging in as DQ_USER

@dq_user/sequences/00_install.sql

@dq_user/tables_meta/00_install.sql
@dq_user/tables/00_install.sql


@dq_user/procedures/00_install.sql
@dq_user/packages_spec/00_install.sql
@dq_user/ri_constraints/00_install.sql
@dq_user/types/00_install.sql
@dq_user/functions/00_install.sql
@dq_user/views/00_install.sql
@dq_user/indexes/00_install.sql
@dq_user/triggers/00_install.sql
@dq_user/packages_body/00_install.sql

--Install the rest of the procedures
@dq_user/procedures/01_install.sql
@dq_user/synonyms/00_install.sql

--Install DMP
@dq_user/dmp/tables/00_install.sql
@dq_user/dmp/views/00_install.sql
@dq_user/dmp/functions/00_install.sql

commit;

exec dbms_utility.compile_schema(schema => upper('DQ_USER'));

BEGIN
PKG_MAINTENANCE_UTIL.P_REGISTER_G77_DB_INSTALL('versionTo', 'gateway/src/main/db/full_install');
END;
/

commit;

exit 0