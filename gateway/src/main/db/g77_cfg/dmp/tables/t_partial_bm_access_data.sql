CREATE TABLE G77_CFG.T_PARTIAL_BM_ACCESS_DATA
(
  METADATA_ID   NUMBER NOT NULL,
  ROLE_NAME     VARCHAR2(255 BYTE),
  MODIFIED_BY   VARCHAR2(100 CHAR),
  MODIFIED_TIME DATE,
  CONSTRAINT PK_T_PARTIAL_BM_ACCESS_DATA PRIMARY KEY (METADATA_ID,ROLE_NAME)
);
