  CREATE OR REPLACE VIEW G77_CFG.V_DQ_ERROR_RECON AS 
  with e as (
  select 
       count(*) as count
     , APTITUDE_PROJECT
     , APTITUDE_MICROFLOW
     , max(USE_CASE_ID)
     , max(SESSION_ID)
     , batch_process_id
  from v_dmp_error_log
  group by 
       APTITUDE_PROJECT
     , APTITUDE_MICROFLOW
     , batch_process_id
            )
  , dq as   (
  select max(DQ_RECORDS_FAILED) as count
     , DQ_CONFIG_ID
     , APTITUDE_PROJECT
     , APTITUDE_MICROFLOW
     , USE_CASE_ID
     , SESSION_ID
     , batch_process_id
     , DQ_RULE_TYPE
  from v_dmp_dq_log
  where 
       DQ_RULE_TYPE IN ('T','B')
  group by 
       DQ_CONFIG_ID
     , APTITUDE_PROJECT
     , APTITUDE_MICROFLOW
     , USE_CASE_ID
     , SESSION_ID
     , batch_process_id
     , DQ_RULE_TYPE
            )
  select 
       NVL(DQ.DQ_CONFIG_ID,0)                                                                           AS DQ_CONFIG_ID
     , bs.USE_CASE_ID
     , bs.SESSION_ID     
     , UPPER('@env@') ||  '.JOBP.' || UPPER(bs.APTITUDE_PROJECT) || '.' || UPPER(bs.APTITUDE_MICROFLOW) AS JOBNAME
     , bs.BATCH_PROCESS_ID
     , 'G77'                                                                                            AS APPLICATION_ID
     , NVL(dq.count,0)                                                                                  AS COUNT_OF_RECORDS
     , TO_CHAR(bs.END_TIME, 'DD/MM/YYYY HH24:MI:SS')                                                    AS TIME_FAILED
     , mt.schema_name || '.' || bs.TABLE_NAME                                                           AS TABLE_NAME
     , bs.aptitude_microflow                                                                            AS ENTITY_NAME
  from v_dmp_batch_status bs
  left join e
  on  
     bs.batch_process_id        = e.batch_process_id
     and  bs.aptitude_project   = e.aptitude_project
     and  bs.aptitude_microflow = e.Aptitude_microflow
  left join dq
     on  bs.batch_process_id    = dq.batch_process_id
     and  bs.aptitude_project   = dq.aptitude_project
     and  bs.aptitude_microflow = dq.Aptitude_microflow
  , t_meta_table mt
  where 
     NVL(dq.count,0) > 0
     and mt.table_name = bs.table_name;
/