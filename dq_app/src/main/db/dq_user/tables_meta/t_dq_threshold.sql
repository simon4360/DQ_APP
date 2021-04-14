CREATE TABLE DQ_USER.T_DQ_THRESHOLD
(
    DQ_CONFIG_ID                   NUMBER(12)         NOT NULL,
    DQ_THRESHOLD                   NUMBER(10)         NOT NULL, -- Percentage or absolute number of records that is 'allowed' to fail
    THRESHOLD_IS_PERCENT           CHAR(1 BYTE)       NOT NULL  CHECK (THRESHOLD_IS_PERCENT IN ('Y','N')),
    CONSTRAINT PK_T_DQ_THRESHOLD PRIMARY KEY (DQ_CONFIG_ID)    
);