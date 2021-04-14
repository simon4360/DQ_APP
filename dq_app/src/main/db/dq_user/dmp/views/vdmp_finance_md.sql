CREATE OR REPLACE VIEW DQ_USER.VDMP_FINANCE_MD
(metadata_id
,mapping_table
,mapping_table_desc
,source_system_code
,source_desc
)
AS
SELECT DISTINCT ATTRIBUTE_NBR
     , ATTRIBUTE_ID
     , ATTRIBUTE_NAME
     , 'G77' AS SOURCE_SYSTEM_CODE
     , null
  FROM REF_FINANCE_DATA
  ORDER BY 1;