CREATE TABLE DQ_USER.T_DMP_INTERFACE_DETAILS
(
  COL_IDENTIFIER  VARCHAR2(128 CHAR)            NOT NULL,
  COL_METADATA    VARCHAR2(512 CHAR),
  CONSTRAINT PK_T_DMP_INTERFACE_DETAILS PRIMARY KEY (COL_IDENTIFIER, COL_METADATA)
);