CREATE OR REPLACE FORCE VIEW DQ_USER.VDMP_PARTIAL_BM_ACCESS_DATA 
(METADATA_ID, ROLE_NAME, MODIFIED_BY, MODIFIED_ON)
AS
SELECT
 METADATA_ID, 
 ROLE_NAME,
 MODIFIED_BY, 
 MODIFIED_TIME 
     FROM T_PARTIAL_BM_ACCESS_DATA;    