CREATE OR REPLACE FORCE VIEW DQ_USER.VDMP_BUS_MAPPING_WF_DATA
(METADATA_ID, MODIFIED_BY, MODIFIED_ON)
BEQUEATH DEFINER
AS
SELECT METADATA_ID, MODIFIED_BY, MODIFIED_TIME MODIFIED_ON
  FROM T_MAP_SRC_TRG_WF_DATA;
