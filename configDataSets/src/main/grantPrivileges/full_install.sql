set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

SET SQLBLANKLINES ON
SET AUTOCOMMIT ON

-- Revoke and grant privileges g77_cfg
conn @g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@

set role all;

@db/g77_cfg/data/00_install.sql
@db/g77_cfg/synonyms/99_uninstall.sql
@db/g77_cfg/grants/99_uninstall.sql

@db/g77_cfg/synonyms/00_install.sql
@db/g77_cfg/grants/00_install.sql

conn @g77_cfg_arcUsername@/@g77_cfg_arcPassword@@@oracleServiceName@

set role all;
@db/g77_cfg_arc/grants/99_uninstall.sql
@db/g77_cfg_arc/grants/00_install.sql

EXEC DBMS_UTILITY.compile_schema(schema => 'G77_CFG_ARC');


-- ****************************
-- DROP TECHNICAL USER SYNONYMS
-- Don't drop the synonyms if the tec user is not owned by the Gateway
-- ****************************

conn @g77_cfg_tecUsername@/@g77_cfg_tecPassword@@@oracleServiceName@
@db/g77_cfg_tec/synonyms/99_uninstall.sql

conn @crrUsername@/@crrPassword@@@crrConnectString@
@db/g77_crr_tec/synonyms/99_uninstall.sql

conn @phoUsername@/@phoPassword@@@phoConnectString@
@db/g77_pho_tec/synonyms/99_uninstall.sql

conn @rvlUsername@/@rvlPassword@@@rvlConnectString@
@db/g77_rvl_tec/synonyms/99_uninstall.sql

--conn @g60Username@/@g60Password@@@g60ConnectString@
--@db/g77_g60_tec/synonyms/99_uninstall.sql

conn @mdmUsername@/@mdmPassword@@@mdmConnectString@
@db/g77_mdm_tec/synonyms/99_uninstall.sql

conn @fa0Username@/@fa0Password@@@fa0ConnectString@
@db/g77_nexus_tec/synonyms/99_uninstall.sql

conn @g31Username@/@g31Password@@@g31ConnectString@
@db/g77_g31_tec/synonyms/99_uninstall.sql

conn @g72Username@/@g72Password@@@g72ConnectString@
@db/g72_g77_tec/synonyms/99_uninstall.sql

conn @g76Username@/@g76Password@@@g76ConnectString@
@db/g77_g76_tec/synonyms/99_uninstall.sql

conn @g73Username@/@g73Password@@@g73ConnectString@
@db/g77_g73_tec/synonyms/99_uninstall.sql

conn @g79Username@/@g79Password@@@g79ConnectString@
@db/g79_g77_tec/synonyms/99_uninstall.sql

conn @g7cUsername@/@g7cPassword@@@g7cConnectString@
@db/g77_g7c_tec/synonyms/99_uninstall.sql

conn @g71Username@/@g71Password@@@g71ConnectString@
@db/g77_g71_tec/synonyms/99_uninstall.sql

conn @vmsUsername@/@vmsPassword@@@vmsConnectString@
@db/g77_vms_tec/synonyms/99_uninstall.sql

conn @g74Username@/@g74Password@@@g74ConnectString@
@db/g74_g77_tec/synonyms/99_uninstall.sql

-- ******************************
-- CREATE TECHNICAL USER SYNONYMS
-- ******************************

conn @g77_cfg_tecUsername@/@g77_cfg_tecPassword@@@oracleServiceName@
set role all;
@db/g77_cfg_tec/synonyms/00_install.sql

conn @crrUsername@/@crrPassword@@@crrConnectString@
set role all;
@db/g77_crr_tec/synonyms/00_install.sql

conn @phoUsername@/@phoPassword@@@phoConnectString@
set role all;
@db/g77_pho_tec/synonyms/00_install.sql

conn @rvlUsername@/@rvlPassword@@@rvlConnectString@
set role all;
@db/g77_rvl_tec/synonyms/00_install.sql

--conn @g60Username@/@g60Password@@@g60ConnectString@
--set role all;
--@db/g77_g60_tec/synonyms/00_install.sql

conn @mdmUsername@/@mdmPassword@@@mdmConnectString@
set role all;
@db/g77_mdm_tec/synonyms/00_install.sql

conn @fa0Username@/@fa0Password@@@fa0ConnectString@
set role all;
@db/g77_nexus_tec/synonyms/00_install.sql

conn @g72Username@/@g72Password@@@g72ConnectString@
set role all;
@db/g72_g77_tec/synonyms/00_install.sql

conn @migUsername@/@migPassword@@@migConnectString@
set role all;
@db/g71_mig_g77_tec/synonyms/00_install.sql

conn @g31Username@/@g31Password@@@g31ConnectString@
set role all;
@db/g77_g31_tec/synonyms/00_install.sql

conn @g76Username@/@g76Password@@@g76ConnectString@
set role all;
@db/g77_g76_tec/synonyms/00_install.sql

conn @g73Username@/@g73Password@@@g73ConnectString@
set role all;
@db/g77_g73_tec/synonyms/00_install.sql

conn @g79Username@/@g79Password@@@g79ConnectString@
set role all;
@db/g79_g77_tec/synonyms/00_install.sql

conn @g7cUsername@/@g7cPassword@@@g7cConnectString@
set role all;
@db/g77_g7c_tec/synonyms/00_install.sql

conn @g71Username@/@g71Password@@@g71ConnectString@
set role all;
@db/g77_g71_tec/synonyms/00_install.sql

conn @vmsUsername@/@vmsPassword@@@vmsConnectString@
set role all;                             
@db/g77_vms_tec/synonyms/00_install.sql  

conn @g74Username@/@g74Password@@@g74ConnectString@
set role all;
@db/g74_g77_tec/synonyms/00_install.sql

SET AUTOCOMMIT OFF

conn @g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@

EXEC DBMS_UTILITY.compile_schema(schema => 'G77_CFG');


BEGIN
PKG_MAINTENANCE_UTIL.P_REGISTER_G77_DB_INSTALL('@versionTo@', 'configDataSets/src/main/grantPrivileges/full_install');
END;
/

commit;

exit 0
