CREATE OR REPLACE FORCE VIEW DQ_USER.VDMP_FINANCE_WF_DATA
(METADATA_ID
,MODIFIED_BY
,MODIFIED_ON
)
BEQUEATH DEFINER
AS
SELECT METADATA_ID
     , MODIFIED_BY
     , MODIFIED_TIME
  FROM T_DMP_FINANCE_WF_DATA;
