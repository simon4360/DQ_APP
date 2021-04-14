CREATE TABLE DQ_USER.T_META_TABLE
(
TABLE_ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY (START WITH 1 CACHE 1000 NOORDER) 
, SCHEMA_NAME           VARCHAR2(30)
, TABLE_NAME            VARCHAR2(30)
, TECHNICAL_USER        VARCHAR2(30)
, CATEGORY              VARCHAR2(20 BYTE)
, STATS_REFRESH_MIN     NUMBER                   -- gather stats if older than STATS_REFRESH_MIN, if applicable. (batch task x table config)
, ARCHIVE_CONFIG_ID     VARCHAR2(100 BYTE)
, AUDIT_TABLE_ID        NUMBER
, MOCK_TABLE_NAME       VARCHAR2(30 BYTE)
, LEGAL_ENTITY_COLUMN   VARCHAR2(30)
, PARTITION_COLUMN      VARCHAR2(30)
, ACTIVE_INDICATOR      VARCHAR2(1) NOT NULL
, CONSTRAINT PK_T_META_TABLE PRIMARY KEY (TABLE_ID)
);