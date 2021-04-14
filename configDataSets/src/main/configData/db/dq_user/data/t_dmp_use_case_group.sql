-- Insert into DQ_USER.t_dmp_use_case_group
delete from DQ_USER.t_dmp_use_case_group;

REM INSERTING into T_DMP_USE_CASE_GROUP
SET DEFINE OFF;
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (1,'Publish Source Transactions to CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (2,'Run DQ Rules');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (3,'Translate Source Data to CorDL');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (4,'Publish CorFAH Balances to CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (5,'Publish CorFAH Journals to CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (6,'Publish Transactions to CorFAH');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (7,'Publish Source Transactions to CorSo Data Warehouse');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (8,'Publish CorFAH Balances to CorSo Data Warehouse');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (9,'Publish CorFAH Journals to CorSo Data Warehouse');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (10,'Aggregate Transactions for CorFAH');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (11,'Publish CorFinOracle Phoenix Extract to the CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (12,'Publish Reconciliation to Phoenix');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (13,'Run File Control');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (14,'Publish Journals to CorFinOracle');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (15,'Publish CorFinOracle Journals to CorFAH');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (16,'Publish CorFinME Journals to CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (17,'Publish Expenses to CorFinGateway from CorFinOracle');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (18,'Publish Expenses to Reveal');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (19,'Publish Reference Data to CorFinGateway from MDM');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (20,'Publish Reference Data to CorFAH');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (21,'Publish Reference Data to CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (22,'Publish Reference Data to CorFinME');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (23,'Publish Reference Data to CorFinOracle');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (24,'Publish Reference Data to CorFinGateway from CorFAH');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (25,'Process General Mappings from DMP to CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (26,'Publish General Mappings to the CorSo Data Warehouse');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (27,'Publish Reference Data to CorFinGateway from CorFinOracle');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (28,'Publish Journals from CorFinOracle to the CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (29,'Publish General Mappings to CorFAH');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (30,'Create CorFAH Balancing Entry for Original and Functional Currency');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (31,'Publish Reference Data to CorSo Data Warehouse');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (32,'Publish Group Submissions to CorFinGateway');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (33,'Publish Group Submissions to Target sytem');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (34,'Publish AP Transactions to CorFinOracle');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (35,'Publish AR Transactions to CorFinOracle');
Insert into T_DMP_USE_CASE_GROUP (GROUP_ID,DESCRIPTION) values (36,'Publish ERS expenses to CorFinOracle');

COMMIT;