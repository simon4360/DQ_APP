-- Insert into t_dmp_use_case_config
DELETE FROM G77_CFG.T_DMP_USE_CASE_CATEGORY;

SET DEFINE OFF;
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('CorFACTS Integration and Orchestration','1',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('CorFinReporting'                       ,'2',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('EVM valuation'                         ,'3',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('Manual Entry Tool'                     ,'4',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('Oracle GL Accounting and Cash'         ,'5',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('Reporting & Analysis'                  ,'6',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('Reserving'                             ,'7',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('Retro'                                 ,'8',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('Subledger Accounting'                  ,'9',null);
Insert into G77_CFG.T_DMP_USE_CASE_CATEGORY (CATEGORY_NAME,CATEGORY_GROUP,DESCRIPTION) values ('Traditional Valuation'                 ,'10',null);

COMMIT;