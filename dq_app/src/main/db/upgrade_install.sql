set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON

prompt Logging in as G77_CFG

@connG77@

prompt 'Check that the target system is at version @versionFrom@'

declare
 versionFromFound int;
begin
select  count(*) into versionFromFound from g77_cfg.t_build_version where current_build like '@versionFrom@';
if ( versionFromFound = 0 )
then 
  raise_application_error(-20000,'System not at version @versionFrom@. Cannot upgrade database to @versionTo@. Verify [RepositoryRoot].version_properties File');
end if;
end;
/

@upgrade/00_install.sql

commit;

prompt Logging in as G77_CFG

@connG77@

EXEC DBMS_UTILITY.compile_schema(schema => upper('@g77_cfgUsername@'));

commit;

exit 0
