CREATE TABLE DQ_USER.T_DMP_FINANCE_WF_REQ_DATA
    (DMP_ROW_ID                 NUMBER(9)              NOT NULL
    ,METADATA_ID                NUMBER                 NOT NULL
    ,REQUEST_COUNT              NUMBER                 NOT NULL
    ,REQUESTED_BY               VARCHAR2(100 CHAR)     NOT NULL
    ,REQUESTED_TIME             TIMESTAMP(6)           NOT NULL
    ,SOURCE_SYSTEM_VALUE1       VARCHAR2(100 CHAR)
    ,SOURCE_SYSTEM_VALUE1_DESC  VARCHAR2(200 CHAR)
    ,REQUEST_STATUS             VARCHAR2(32 CHAR)      NOT NULL
    ,REQUEST_TYPE               VARCHAR2(32 CHAR)      NOT NULL
    ,REQUEST_CLOSED_BY          VARCHAR2(100 CHAR)
    ,REQUEST_CLOSED_ON          TIMESTAMP(6)
    ,CONSTRAINT PK_DMP_FINANCE_WF_REQ_DATA PRIMARY KEY (DMP_ROW_ID, REQUEST_COUNT)
);