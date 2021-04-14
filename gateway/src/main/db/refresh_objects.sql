set pagesize 500
set linesize 500
set echo on
set sqlblanklines on

WHENEVER SQLERROR EXIT SQL.SQLCODE

prompt Logging in as G77_CFG

@connG77@

@g77_cfg/types/99_uninstall.sql
@g77_cfg/types/00_install.sql
@g77_cfg/functions/00_install.sql
@g77_cfg/views/00_install.sql
@g77_cfg/triggers/00_install.sql
@g77_cfg/packages_spec/00_install.sql
@g77_cfg/packages_body/00_install.sql
@g77_cfg/procedures/00_install.sql

commit;

BEGIN
  FOR cur_rec IN (SELECT owner,
                  object_name,
                  object_type,
                  DECODE(object_type, 'PACKAGE', 1,
                  'PACKAGE BODY', 2, 2) AS recompile_order
                  FROM   all_objects
                  WHERE  status != 'VALID'
                  ORDER BY 4,object_type)
  LOOP
    BEGIN
      IF cur_rec.object_type = 'PACKAGE BODY'
      THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE "' || cur_rec.owner || '"."' || cur_rec.object_name || '" COMPILE BODY';
      ElSE
        EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || ' "' || cur_rec.owner || '"."' || cur_rec.object_name || '" COMPILE';
      END IF;
    END;
  END LOOP;
END;
/

exit 0
