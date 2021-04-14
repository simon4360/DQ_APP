-- Data Load Tool
-- Template Version 1.30
-- Generated on 2020/07/08 11:20:28 in 0.09 second(s)
-- Parameters:
--   Product = Other
--   Database = Oracle
--   S/W Version = 0-1-0
--   Order Data Load = Yes
--   Default Rows = Yes
--   Pre-Load SQL = Yes
--   Post-Load SQL = Yes
--   Table Pre-Load SQL = Yes
--   Table Post-Load SQL = Yes
--   Include Remarks = Yes
--   Empty Table Data = No
--   Script Type = Insert
--   Data Validation = Yes
--   Ignore Suffix = x
--   Escape Character = **

set define off

-- Pre-Load SQL
Prompt Pre-Load SQL
/* From the file https://shp.swissre.com/sites/corsofinanceit/Data Management Library/0. CorFinGateway/05. Build/02. CorFinGateway Configuration Metadata/ */

-- Pre-Load SQL T_META_INTERFACE_CFG
Prompt Pre-Load SQL T_META_INTERFACE_CFG
Prompt drop and create empty configuration table for DQ_USER.T_META_INTERFACE_CFG

declare
  c int;
  target_table_name varchar(28) := 't_meta_interface';
  merge_table_name varchar2(32) := target_table_name || '_cfg';
  target_schema varchar(32) := 'DQ_USER';
begin

  -- Tidy up and create merge table
  --
  select count(*) into c from all_tables
    where lower(table_name) = merge_table_name
    and lower(owner) = 'DQ_USER';
  if c = 1 then
    execute immediate('drop table ' || target_schema || '.' || merge_table_name);
  end if;
  execute immediate('create table ' || target_schema || '.' || merge_table_name ||
                    ' as select technology, aptitude_project,aptitude_project_desc,counterparty_system,counterparty_role,stop_project_flag,reset_events_flag,is_active from ' || target_schema || '.' ||
                    target_table_name || ' where 1=0');
end;
/

-- Populate DQ_USER.T_META_INTERFACE_CFG
Prompt Populate DQ_USER.T_META_INTERFACE_CFG
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g71_tgt_g72','AdminHub - Oracle Remittance','G72','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g72_tgt_g71','Oracle -AdminHub Remittance Feedback','G71','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g74_tgt_crr','CorFAH - CorFinGateway - CorDWH Interface','CRR','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_housekeeping','CorFinGateway - Housekeeping','G77','other','N','N','I');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_library','Aptitude Project Library','G77','other','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_maintain_data','CorFinGateway Data Maintainence','G77','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_retro','CorFinGateway IGR - Corfacts interfaces','ALL','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_ady','ADY - CorFinGateway Interface','ADY','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_asl','ASL - CorFinGateway Interface','ASL','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_ers','ERS - CorFinGateway Interface','ERS','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_fa0','AM FAH - CorFinGateway','FA0','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g24','PERLS IBNR - CorFinGateway Interface','G24','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g32','IGR Hub - CorFinGateway Interface','G32','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g51','TM1 - CorFinGateway Interface','G51','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g61','SAP - CorFinGateway Interface','G61','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g71','AdminHub - CorFinGateway Interface','G71','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g72','CorFinOracle - CorFinGateway Interface','G72','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g73','CorFinCalcs - CorFinGateway Interface','G73','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g74','CorFAH - CorFinGateway Interface','G74','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g76','CoUVM - CorFinGateway Interface','G76','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g79','CorFinME','G79','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g7c','CorResADS - CorFinGateway Interface','G7C','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_g7m','Migration - CorFinGateway Interface','G7M','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_mdm','MDM - CorFinGateway Interface','MDM','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_pil','PIL - CorFinGateway Interface','PIL','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_src_q0t','Quantum - CorFinGateway Interface','Q0T','source','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_a38','CorFinGateway - Finance Data Repository','A38','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_ady','CorFinGateway - ADY Interface','ADY','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_crr','CorFinGateway - CorDWH Interface','CRR','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g24','CorFinGateway - PERLS Interface','G24','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g32','CorFinGateway - IGR','G32','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g51','CorFinGateway-TM1 Interface','G51','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g72','CorFinGateway - CorFinOracle Interface','G72','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g73','CorFinGateway - CorFinCalcs Interface','G73','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g74','CorFinGateway - CorFAH Interface','G74','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g76','CorFinGateway - CorUVM Interface','G76','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g77','CorFinGateway - CorFinGateway Interface','G77','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g79','CorFinME','G79','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g7c','CorFinGateway - CorResADS Interface','G7C','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_pho','CorFinGateway - Phoenix Interface','PHO','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_rvl','CorFinGateway - Reveal Interface','RVL','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_tgt_g60','CorFinGateway - ZOOM Interface','G60','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g77_utils','Aptitude Project Utilities','G77','other','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g7c_tgt_a38','CorResADS - FDSI','A38','target','N','N','A');
INSERT INTO DQ_USER.T_META_INTERFACE_CFG ("TECHNOLOGY","APTITUDE_PROJECT","APTITUDE_PROJECT_DESC","COUNTERPARTY_SYSTEM","COUNTERPARTY_ROLE","STOP_PROJECT_FLAG","RESET_EVENTS_FLAG","IS_ACTIVE")
  VALUES ('aptitude','g7c_tgt_g24','CorResADS - PERLS','G24','target','N','N','A');

-- Post-Load SQL T_META_INTERFACE_CFG
Prompt Post-Load SQL T_META_INTERFACE_CFG
prompt merge to t_meta_interface

delete from DQ_USER.t_meta_interface target
where not exists (select 1 from DQ_USER.t_meta_interface_cfg cfg where target.aptitude_project = cfg.aptitude_project);

merge
 into
   DQ_USER.t_meta_interface target
   using
     ( select   
            cfg.technology,
            cfg.aptitude_project,
            cfg.aptitude_project_desc,
            cfg.counterparty_system,
            cfg.counterparty_role,
            cfg.stop_project_flag,
            cfg.reset_events_flag,
            cfg.is_active
         from DQ_USER.t_meta_interface_cfg cfg
         inner join DQ_USER.t_meta_interface target
         on target.aptitude_project = cfg.aptitude_project 
         and (
            nvl(target.technology, '~') <> nvl(cfg.technology, '~') or
            nvl(target.aptitude_project_desc, '~') <> nvl(cfg.aptitude_project_desc, '~') or
            nvl(target.counterparty_system, '~') <> nvl(cfg.counterparty_system, '~') or
            nvl(target.counterparty_role, '~') <> nvl(cfg.counterparty_role, '~') or
            nvl(target.stop_project_flag, '~') <> nvl(cfg.stop_project_flag, '~') or
            nvl(target.reset_events_flag, '~') <> nvl(cfg.reset_events_flag, '~') or
            nvl(target.is_active, '~') <> nvl(cfg.is_active, '~') 
              )
        union all
         select   
            cfg.technology,
            cfg.aptitude_project,
            cfg.aptitude_project_desc,
            cfg.counterparty_system,
            cfg.counterparty_role,
            cfg.stop_project_flag,
            cfg.reset_events_flag,
            cfg.is_active
         from DQ_USER.t_meta_interface_cfg cfg
         where not exists (select 1 from DQ_USER.t_meta_interface target where target.aptitude_project = cfg.aptitude_project )
         ) cfg
  on ( target.aptitude_project = cfg.aptitude_project)
  when matched 
  then 
    update set 
            target.technology = cfg.technology 
          , target.aptitude_project_desc = cfg.aptitude_project_desc 
          , target.counterparty_system = cfg.counterparty_system 
          , target.counterparty_role = cfg.counterparty_role 
          , target.stop_project_flag = cfg.stop_project_flag 
          , target.reset_events_flag = cfg.reset_events_flag 
          ,  target.is_active = cfg.is_active  
    when not matched then insert 
    (       target.aptitude_project,
            target.aptitude_project_desc,
            target.counterparty_system,
            target.counterparty_role,
            target.stop_project_flag,
            target.reset_events_flag,
            target.is_active,
            target.technology
      ) values 
         (
            cfg.aptitude_project,
            cfg.aptitude_project_desc,
            cfg.counterparty_system,
            cfg.counterparty_role,
            cfg.stop_project_flag,
            cfg.reset_events_flag,
            cfg.is_active,
            cfg.technology
         );
commit;

Prompt dropping temporary config table DQ_USER.T_META_INTERFACE_CFG

begin
  execute immediate 'drop table DQ_USER.t_meta_interface_cfg';
end;
/

commit;




set define on

commit;