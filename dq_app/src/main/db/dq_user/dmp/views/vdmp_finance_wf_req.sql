CREATE OR REPLACE FORCE VIEW DQ_USER.VDMP_FINANCE_WF_REQ
(REC_ID
,METADATA_ID
,REQUEST_COUNT
,REQUEST_STATUS
,REQUEST_TYPE
,REQUESTED_BY
,REQUESTED_ON
,REQUEST_CLOSED_BY
,REQUEST_CLOSED_ON
,SOURCE_DATA_1
,SOURCE_DATA_1_DESC
)
BEQUEATH DEFINER
AS
SELECT dmp_row_id
     , metadata_id
     , request_count
     , request_status
     , request_type
     , requested_by
     , requested_time
     , request_closed_by
     , request_closed_on
     , source_system_value1
     , source_system_value1_desc
  FROM t_dmp_finance_wf_req_data;