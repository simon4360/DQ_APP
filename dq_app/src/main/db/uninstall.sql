set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE
set sqlblanklines on

prompt Logging in as DQ_USER


ALTER SESSION SET recyclebin = OFF;

@dq_user/views/99_uninstall.sql
@dq_user/types/99_uninstall.sql

begin
  for obj in (select table_name 
                from user_tables 
             )
  loop 
    execute immediate 'drop table DQ_USER.' || obj.table_name || ' CASCADE CONSTRAINTS';
  end loop ;
end;
/

@dq_user/indexes/99_uninstall.sql
@dq_user/sequences/99_uninstall.sql
@dq_user/triggers/99_uninstall.sql
@dq_user/procedures/99_uninstall.sql
@dq_user/functions/99_uninstall.sql
@dq_user/packages_spec/99_uninstall.sql
@dq_user/packages_body/99_uninstall.sql
@dq_user/synonyms/99_uninstall.sql

ALTER SESSION SET recyclebin = ON;

purge user_recyclebin;

ALTER SESSION SET recyclebin = ON;

purge user_recyclebin;

commit;

exit 0
