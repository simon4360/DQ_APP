CREATE TABLE G77_CFG.T_MAP_SRC_TRG_WF_REQ_DATA
(
  DMP_ROW_ID                 NUMBER(9)              NOT NULL,
  METADATA_ID                NUMBER                 NOT NULL,
  REQUEST_COUNT              NUMBER                 NOT NULL,
  REQUESTED_BY               VARCHAR2(100 CHAR)     NOT NULL,
  REQUESTED_TIME             TIMESTAMP(6)           NOT NULL,
  SOURCE_SYSTEM_VALUE1       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE1_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE2       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE2_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE3       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE3_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE4       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE4_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE5       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE5_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE6       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE6_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE7       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE7_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE8       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE8_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE9       VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE9_DESC  VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE10      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE10_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE11      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE11_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE12      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE12_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE13      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE13_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE14      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE14_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE15      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE15_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE16      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE16_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE17      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE17_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE18      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE18_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE19      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE19_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE20      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE20_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE21      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE21_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE22      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE22_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE23      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE23_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE24      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE24_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE25      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE25_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE26      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE26_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE27      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE27_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE28      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE28_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE29      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE29_DESC VARCHAR2(200 CHAR),
  SOURCE_SYSTEM_VALUE30      VARCHAR2(100 CHAR),
  SOURCE_SYSTEM_VALUE30_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE1       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE1_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE2       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE2_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE3       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE3_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE4       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE4_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE5       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE5_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE6       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE6_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE7       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE7_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE8       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE8_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE9       VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE9_DESC  VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE10      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE10_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE11      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE11_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE12      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE12_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE13      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE13_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE14      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE14_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE15      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE15_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE16      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE16_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE17      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE17_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE18      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE18_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE19      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE19_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE20      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE20_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE21      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE21_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE22      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE22_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE23      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE23_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE24      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE24_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE25      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE25_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE26      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE26_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE27      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE27_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE28      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE28_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE29      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE29_DESC VARCHAR2(200 CHAR),
  TARGET_SYSTEM_VALUE30      VARCHAR2(100 CHAR),
  TARGET_SYSTEM_VALUE30_DESC VARCHAR2(200 CHAR),
  REQUEST_STATUS             VARCHAR2(32 CHAR)      NOT NULL,
  REQUEST_TYPE               VARCHAR2(32 CHAR)      NOT NULL,
  REQUEST_CLOSED_BY          VARCHAR2(100 CHAR),
  REQUEST_CLOSED_ON          TIMESTAMP(6),
  CONSTRAINT PK_T_MAP_SRC_TRG_WF_REQ_DATA PRIMARY KEY (DMP_ROW_ID, REQUEST_COUNT)
);