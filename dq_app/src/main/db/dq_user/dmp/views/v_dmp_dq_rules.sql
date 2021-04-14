CREATE OR REPLACE VIEW DQ_USER.V_DMP_DQ_RULES
as
with dq as (select distinct 
                   DQ_USE_CASE_ID
                 , DQ_APTITUDE_PROJECT
                 , DQ_APTITUDE_MICROFLOW
                 , DQ_TABLE_NAME
              from t_dq_log
           )
   select distinct meta.DQ_CONFIG_ID
        , DECODE(meta.DQ_RULE_TYPE, 'T', 'IT DQ'
                                  , 'B', 'Business DQ'
                ) AS DQ_RULE_TYPE
        , meta.DQ_PURPOSE                  as DQ_DESC
        , meta.DQ_MESSAGE                  as DQ_FUNCTION_ERROR_MESSAGE        
        , meta.DQ_SEVERITY_ID
        , s.DQ_SEVERITY_DESC        
        , dq.DQ_USE_CASE_ID
        , u.USE_CASE_DESCRIPTION
        , i.APTITUDE_PROJECT
        , i.APTITUDE_PROJECT_DESC
        , meta.DQ_STAGING_TABLE
        , meta.DQ_COLUMN_NAME
        , DECODE(meta.DQ_ACTIVE_INDICATOR,'A','Active'
                                         ,'I','Inactive'
                ) AS DQ_ACTIVE_INDICATOR
     from v_meta_batch_task_dq_all                              meta
     join                                                       dq
       on dq.DQ_APTITUDE_PROJECT   = meta.DQ_APTITUDE_PROJECT
      and dq.DQ_APTITUDE_MICROFLOW = meta.DQ_MICROFLOW
      and dq.DQ_TABLE_NAME         = meta.DQ_STAGING_TABLE
     join t_meta_interface                                      i
       on i.APTITUDE_PROJECT       = meta.DQ_APTITUDE_PROJECT 
     join t_dq_severity                                         s
       on s.DQ_SEVERITY_ID         = meta.DQ_SEVERITY_ID     
LEFT JOIN T_DMP_USE_CASE_CONFIG                                 u
       ON dq.DQ_USE_CASE_ID        = u.USE_CASE_ID
 order by DQ_CONFIG_ID;
 