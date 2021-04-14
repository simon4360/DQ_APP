CREATE OR REPLACE VIEW G77_CFG.V_DMP_INTERFACE_DETAILS 
AS
select USE_CASE_ID
     , USE_CASE_DESCRIPTION
     , USE_CASE_FREQUENCY
     , LAST_START_TIME
     , BATCH_STATUS
     , DQ_STATUS
     , OTHER_ISSUES
     , IT_DQ_ISSUES
     , BIZ_DQ_ISSUES
     , NO_OF_DQ_RULES
     , USE_CASE_CATEGORY
  FROM (
with dq as (select count(*) as count
                 , DQ_USE_CASE_ID    as USE_CASE_ID
              from V_DMP_DQ_RULES   
             group by DQ_USE_CASE_ID 
                           )
, c as (select count(*) as count
                , DQ_USE_CASE_ID    as USE_CASE_ID
                , DQ_STAGING_TABLE  as TABLE_NAME
             from V_DMP_DQ_RULES   
            group by DQ_USE_CASE_ID 
                , DQ_STAGING_TABLE
          )
, bs as   (select max(batch_task_start_timestamp) as batch_task_start_timestamp
                , batch_task_use_case_id
             from t_batch_task_status
            group by batch_task_use_case_id
          )                           
, results as   (
                   --Get the use cases that have either IT or DQ issues  
                   select distinct 
                          summ.USE_CASE_ID                      as USE_CASE_ID
                        , conf.USE_CASE_DESCRIPTION             as USE_CASE_DESCRIPTION
                        , conf.FREQUENCY                        as USE_CASE_FREQUENCY
                        , max(summ.START_TIME)                  as LAST_START_TIME
                        , min(CASE WHEN summ.BATCH_STATUS = 'E'        
                                   THEN '1'                      
                                   WHEN summ.BATCH_STATUS = 'R'        
                                   THEN '2'                      
                                   WHEN summ.BATCH_STATUS = 'C'        
                                   THEN '3'                      
                           END)                                 as BATCH_STATUS
                        , min (CASE WHEN (NVL(summ.BUS_ERROR_COUNT,0) + NVL(summ.TECH_ERROR_COUNT,0)) > 0        
                                    THEN '1'                      
                                    WHEN (NVL(summ.BUS_ERROR_COUNT,0) + NVL(summ.TECH_ERROR_COUNT,0)) = 0        
                                    THEN '3'                      
                           END)                                 as DQ_STATUS
                        , sum(NVL(summ.ERROR_COUNT,0)      )    as OTHER_ISSUES                           
                        , sum(NVL(summ.TECH_ERROR_COUNT,0) )    as IT_DQ_ISSUES
                        , sum(NVL(summ.BUS_ERROR_COUNT,0)  )    as BIZ_DQ_ISSUES                        
                        , nvl(dq.count, 0)                      as NO_OF_DQ_RULES
                        , conf.USE_CASE_CATEGORY                as USE_CASE_CATEGORY
                        , 1                                     as rank 
                     from V_DMP_SESSION_SUMMARY summ
                left join T_DMP_USE_CASE_CONFIG conf
                       on conf.use_case_id = summ.USE_CASE_ID
                LEFT JOIN dq
                       ON summ.USE_CASE_ID = dq.USE_CASE_ID
                 group by summ.USE_CASE_ID
                        , conf.USE_CASE_DESCRIPTION
                        , conf.FREQUENCY
                        , NVL(summ.BUS_ERROR_COUNT,0)
                        , nvl(dq.count, 0)
                        , conf.USE_CASE_CATEGORY            
                                           
                    UNION
                   
                   -- get the use cases that have no Errors and have DQ rules configured
                   select distinct 
                          conf.use_case_id                   as USE_CASE_ID
                        , conf.USE_CASE_DESCRIPTION          as USE_CASE_DESCRIPTION
                        , conf.FREQUENCY                     as USE_CASE_FREQUENCY
                        , bs.batch_task_start_timestamp      as LAST_START_TIME
                        , '3'                                as BATCH_STATUS
                        , '3'                                as DQ_STATUS
                        , 0                                  as OTHER_ISSUES
                        , 0                                  as IT_DQ_ISSUES
                        , 0                                  as BIZ_DQ_ISSUES
                        , nvl(c.count, 0)                    as NO_OF_DQ_RULES
                        , conf.USE_CASE_CATEGORY             as USE_CASE_CATEGORY
                        , 2                                  as rank
                     from t_meta_table_dq                                 dq
                left join t_meta_table                                    t
                       on t.table_id                = dq.table_id
                left join t_meta_batch_task_table_x                       x
                       on x.table_id                = t.table_id    
                left join t_meta_batch_task                               bt
                       on bt.batch_task_id          = x.batch_task_id
                     join T_DMP_USE_CASE_CONFIG                           conf
                       on conf.dq_table_name        = t.table_name 
                left join                                                 c
                       on conf.dq_table_name        = c.TABLE_NAME
                left join                                                 bs
                       on bs.batch_task_use_case_id = conf.use_case_id  
                    where bt.process_name in (select dq_microflow 
                                                from v_meta_batch_task_dq 
                                               where dq_activation        ='NORMAL')
                                                  
                    UNION

                   --finally get the use cases that have no errors but also no DQ rules configured
                   SELECT bs.BATCH_TASK_USE_CASE_ID          as USE_CASE_ID
                        , conf.USE_CASE_DESCRIPTION          as USE_CASE_DESCRIPTION
                        , conf.FREQUENCY                     as USE_CASE_FREQUENCY
                        , max(bs.BATCH_TASK_START_TIMESTAMP) as LAST_START_TIME
                        , '3'                                as BATCH_STATUS
                        , '3'                                as DQ_STATUS
                        , 0                                  as OTHER_ISSUES
                        , 0                                  as IT_DQ_ISSUES
                        , 0                                  as BIZ_DQ_ISSUES
                        , nvl(dq.count, 0)                   as NO_OF_DQ_RULES
                        , conf.USE_CASE_CATEGORY             as USE_CASE_CATEGORY
                        , 3                                  as rank
                     FROM T_BATCH_TASK_STATUS                             bs
                LEFT JOIN T_DMP_USE_CASE_CONFIG                           conf
                       ON bs.BATCH_TASK_USE_CASE_ID = conf.use_case_id
                left join                                                 dq
                       on bs.BATCH_TASK_USE_CASE_ID = dq.USE_CASE_ID
                    WHERE BATCH_TASK_STATUS = 'C'   
                    AND BATCH_TASK_USE_CASE_ID like '%3009%'
                 GROUP BY bs.BATCH_TASK_USE_CASE_ID
                        , conf.USE_CASE_DESCRIPTION
                        , conf.FREQUENCY 
                        , nvl(dq.count, 0)                
                        , conf.USE_CASE_CATEGORY
               )
                     
   select USE_CASE_ID
        , USE_CASE_DESCRIPTION
        , USE_CASE_FREQUENCY
        , max(LAST_START_TIME) as LAST_START_TIME
        , min(BATCH_STATUS)    as BATCH_STATUS
        , min(DQ_STATUS)       as DQ_STATUS
        , sum(BIZ_DQ_ISSUES)   as BIZ_DQ_ISSUES
        , sum(IT_DQ_ISSUES)    as IT_DQ_ISSUES
        , sum(OTHER_ISSUES)    as OTHER_ISSUES
        , sum(NO_OF_DQ_RULES)  as NO_OF_DQ_RULES
        , USE_CASE_CATEGORY
        , rank
     FROM results
    where (use_case_id, rank ) in (select use_case_id
                                        , min(rank)
                                     from results
                                    group by use_case_id
                                  )
group by  USE_CASE_ID
        , USE_CASE_DESCRIPTION
        , USE_CASE_FREQUENCY
        , USE_CASE_CATEGORY
        , rank
order by USE_CASE_ID
);
/
