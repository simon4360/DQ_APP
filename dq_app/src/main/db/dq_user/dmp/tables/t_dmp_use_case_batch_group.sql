CREATE TABLE DQ_USER.T_DMP_USE_CASE_BATCH_GROUP (
  USE_CASE_ID       VARCHAR2(200 BYTE),    
  GROUP_ID          NUMBER,
  APTITUDE_PROJECT  VARCHAR2(200 BYTE),
  MICROFLOW         VARCHAR2(200 BYTE),
  DMP_ORDER         NUMBER,
CONSTRAINT PK_T_DMP_USE_CASE_BATCH_GROUP PRIMARY KEY (USE_CASE_ID, APTITUDE_PROJECT, MICROFLOW,DMP_ORDER)
);
