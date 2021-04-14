create or replace view DQ_USER.v_meta_batch_task_dq as
select 
  DQ_ACTIVATION
, DQ_ACTIVE_INDICATOR
, DQ_APTITUDE_PROJECT
, DQ_MICROFLOW
, DQ_STAGING_TABLE
, DQ_COLUMN_NAME
, DQ_LEGAL_ENTITY_COLUMN
, DQ_TYPE
, DQ_CONFIG_ID
, DQ_USE_CASE_ID
, DQ_RULE_TYPE
, DQ_RULE_CATEGORY
, DQ_PURPOSE
, DQ_CORRECTIVE_ACTION
, DQ_CONTACT_TEAM
, DQ_SEVERITY_ID
, DQ_MESSAGE
, DQ_FAILED_DATA_SQL
, DQ_MERGE_SQL
, DQ_COUNT_SQL
, DQ_USE_CASE_ERR_SQL
, DQ_WHERE_SQL
FROM v_meta_batch_task_dq_all 
where dq_active_indicator = 'A'
;