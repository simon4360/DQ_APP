CREATE TABLE DQ_USER.T_FILE_CONFIG
(
  FILE_ID            NUMBER(10) NOT NULL ENABLE,
  USE_CASE_ID        VARCHAR2(250 BYTE) NOT NULL ENABLE,  
  SOURCE_SYSTEM      VARCHAR2(50 BYTE) NOT NULL ENABLE,
  FILE_NAME_PATTERN  VARCHAR2(250 BYTE) NOT NULL ENABLE,
  FILE_PATH          VARCHAR2(500 BYTE) NOT NULL ENABLE,
  HEADER_FOOTER      VARCHAR2(1) NOT NULL ENABLE,
  FILE_DESC          VARCHAR2(1000 BYTE),
  TGT_CHARSET        VARCHAR2(50 BYTE),
  CONSTRAINT T_FILE_CONFIG_PK PRIMARY KEY (FILE_ID)
);