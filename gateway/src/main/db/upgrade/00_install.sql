 -- *****************************
-- Remove the below after each release
-- *****************************
--
-- 1. If new object - do not add the CREATE OBJECT to the upgrade. 
--   a. Add a new upgrade script
--   b. Add a call to a new object to the upgrade script
--   c. Add the call to the upgrade script below
--   d. Name the script upgrade_jiraid 
-- 2. All upgrade scripts need to be re-runnable (if possible)
-- 3. If the upgrade script is located in the same folder as the 00_install, then use '@@'
--    e.g. @@upgrade_cfcfg1302
--

-- LOGON to g77_cfg : @ connG77 @
-- LOGON to g77_cfg_arc : @ connG77ARC @
-- LOGON to g77_cfg_tec : @ connG77TEC @

-- DO NOT REMOVE 
-- Package Specs need to be refreshed at the start of upgrade
@connG77@

@g77_cfg/packages_spec/99_uninstall.sql
@g77_cfg/packages_body/99_uninstall.sql
@g77_cfg/packages_spec/00_install.sql
@g77_cfg/packages_body/pkg_maintenance_util.sql


--package body install after other objects are done. 

-- ****************************
-- Remove the below calls after each release
-- ****************************


-- DO NOT REMOVE 
-- The below is permanent part of the upgrade
-- *************************

@connG77@


@g77_cfg/types/99_uninstall.sql
@g77_cfg/types/00_install.sql
@g77_cfg/functions/99_uninstall.sql
@g77_cfg/functions/00_install.sql
@g77_cfg/views/99_uninstall.sql
@g77_cfg/views/00_install.sql
@g77_cfg/procedures/99_uninstall.sql

--This installs the first few procedures that are needed also
@g77_cfg/data/00_gm_install.sql

@g77_cfg/views/01_install.sql
@g77_cfg/triggers/99_uninstall.sql
@g77_cfg/triggers/00_install.sql

--Install the rest of the procedures
@g77_cfg/procedures/01_install.sql
@g77_cfg/synonyms/99_uninstall.sql
@g77_cfg/synonyms/00_install.sql
@g77_cfg/packages_body/00_install.sql
@g77_cfg/indexes/index_crr_interfaces.sql

--These upgrades need to be run after the triggers have been recomplied


--*************************************

--Upgrade DMP
@g77_cfg/dmp/views/00_install.sql
@g77_cfg/dmp/functions/00_install.sql

--data monitoring views
@g77_cfg/views/02_install.sql


@connG77ARC@

@g77_cfg_arc/packages_spec/99_uninstall.sql
@g77_cfg_arc/packages_body/99_uninstall.sql
@g77_cfg_arc/packages_spec/00_install.sql
@g77_cfg_arc/packages_body/00_install.sql
@g77_cfg_arc/grants/00_install.sql


@connG77@


EXEC DBMS_UTILITY.compile_schema(schema => 'G77_CFG');
