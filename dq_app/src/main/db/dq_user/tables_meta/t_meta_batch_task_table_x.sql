CREATE TABLE DQ_USER.t_meta_batch_task_table_x
(
  BATCH_TASK_ID         NUMBER
, TABLE_ID              NUMBER
, OBJECT_ROLE           VARCHAR2(50)  -- inbound / outbound / ref / lookup 
, PROCESSING_ORDER      NUMBER
, RESTART_MODE          VARCHAR2(30)  -- reset / delete 
, GATHER_STATS          VARCHAR2(10)  -- gather stats at start of process (if stale)
, EVENT_STATUS_MODE     VARCHAR2(30)  -- batch_task_complete, record_level
, PROCESSED_REC_SQL     VARCHAR2(4000)  -- sql to check expected value for processed records
, UPDATE_PROCESSED_SQL  VARCHAR2(4000)  -- sql to check expected value for processed records
, DQ_CHECKS             VARCHAR2(30)  -- yes,  no_use_case_id, nvl ( n/a),
, ACTIVE_INDICATOR      VARCHAR2(1) NOT NULL
, CONSTRAINT PK_T_META_BT_TABLE_X PRIMARY KEY (BATCH_TASK_ID, TABLE_ID, OBJECT_ROLE )
);