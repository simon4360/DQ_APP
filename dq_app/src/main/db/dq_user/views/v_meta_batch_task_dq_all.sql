CREATE OR REPLACE VIEW DQ_USER.V_META_BATCH_TASK_DQ_ALL
AS
  select 
  DQ_ACTIVE_INDICATOR
, DQ_STAGING_TABLE
, DQ_COLUMN_NAME
, DQ_LEGAL_ENTITY_COLUMN
, DQ_CONFIG_ID
, DQ_FUNCTION
, DQ_RULE_TYPE
, DQ_RULE_CATEGORY
, DQ_PURPOSE
, REPLACE (DQ_CORRECTIVE_ACTION, 'REGEX_SYSTEM', DQ_CONTACT_TEAM) as DQ_CORRECTIVE_ACTION
, DQ_CONTACT_TEAM
, DQ_SEVERITY_ID
, DQ_MESSAGE
,      'SELECT distinct '|| DQ_STAGING_TABLE || '.GATEWAY_ID'|| chr(10)
     ||'       , CASE WHEN EVENT_STATUS = 5 THEN 5 ELSE ' || case DQ_SEVERITY_ID 
                                                               when 2 then 9  
                                                               when 5 then 9
                                                               when 6 then 3
                                                               else 5 end || ' END as EVENT_STATUS'             || chr(10) 
     ||'       , '|| DQ_STAGING_TABLE || '.' || regexp_replace ( DQ_COLUMN_NAME, '\|', chr(10)||'       , ')    || chr(10)
     ||'         FROM DQ_USER.' || DQ_STAGING_TABLE                                                             || chr(10)
     ||                    DQ_WHERE_SQL                                                                         || chr(10)
      as DQ_FAILED_DATA_SQL
,      'merge into '|| DQ_STAGING_TABLE ||' target'                                                             || chr(10)
     ||'using (SELECT /*+ parallel ('||DQ_STAGING_TABLE|| ',8) */ distinct '|| DQ_STAGING_TABLE || '.GATEWAY_ID'|| chr(10)
     ||'       , CASE WHEN EVENT_STATUS = 5 THEN 5 ELSE ' || case DQ_SEVERITY_ID 
                                                               when 2 then 9  
                                                               when 5 then 9
                                                               when 6 then 3
                                                               else 5 end || ' END as EVENT_STATUS'             || chr(10) 
     ||'         FROM DQ_USER.' || DQ_STAGING_TABLE                                                             || chr(10)
     ||                    DQ_WHERE_SQL                                                                         || chr(10)
     ||'        ) dq_fails '                                                                                    || chr(10) 
     ||'on (target.GATEWAY_ID = dq_fails.GATEWAY_ID)'                                                           || chr(10) 
     ||' when matched then update '                                                                             || chr(10) 
     ||'  set target.event_status   = dq_fails.event_status'                                                    || chr(10) 
      as DQ_MERGE_SQL
, 'SELECT count(*) '|| chr(10) 
||'  FROM DQ_USER.'|| DQ_STAGING_TABLE  AS DQ_COUNT_SQL
, DQ_WHERE_SQL as DQ_WHERE_SQL
FROM 
(select distinct
             dqc.dq_active_indicator                                          as DQ_ACTIVE_INDICATOR
           , t.table_name                                                     as DQ_STAGING_TABLE
           , dqc.dq_column_name                                               as DQ_COLUMN_NAME
           , t.legal_entity_column                                            as DQ_LEGAL_ENTITY_COLUMN
           , dqc.dq_config_id                                                 as DQ_CONFIG_ID
		   , func.dq_function
           , dqc.dq_rule_type                                                 as DQ_RULE_TYPE
           , dqc.dq_rule_category                                             as DQ_RULE_CATEGORY
           , dqc.dq_purpose                                                   as DQ_PURPOSE
           , dqc.dq_corrective_action                                         as DQ_CORRECTIVE_ACTION
           , dqc.dq_contact_team                                              as DQ_CONTACT_TEAM
           , dqc.dq_severity_id                                               as DQ_SEVERITY_ID
           , err.dq_message                                                   as DQ_MESSAGE
           , case when lower(dqc.dq_method) = lower('JOIN')
                  then nvl(dqc.dq_join, ' 1 = 1') 
              end
           ||'        WHERE ' || NVL(cond.dq_condition, ' 1 = 1 ') || chr(10) 
           ||'          AND ' || case when lower(dqc.dq_method) = lower('FUNCTION')
                                      then 'DQ_USER.' || case nvl (dqc.dq_function_parameters, '1') 
                                                             when '1' 
                                                             then func.dq_function || chr(10) 
                                                             else func.dq_function || '(' || dqc.DQ_FUNCTION_PARAMETERS || ')' 
                                                         end || ' = '   || '''DQERROR'''
                                      when lower(dqc.dq_method) = lower('WHERE')
                                      then nvl(dqc.dq_where_clause, ' 1 = 1')
                                      when lower(dqc.dq_method) = lower('JOIN')
                                      then nvl(dqc.dq_where_clause, ' 1 = 1')
                                  end                                         as DQ_WHERE_SQL
      from DQ_USER.t_meta_table t
inner join DQ_USER.t_meta_table_dq dqc
        on dqc.table_id = t.table_id
 left join DQ_USER.t_dq_function func
        on func.dq_function_id   = dqc.dq_function_id
 left join DQ_USER.t_dq_condition cond
        on cond.dq_condition_id  = dqc.dq_condition_id
 left join DQ_USER.t_dq_error_messages err
        on dqc.dq_message_id = err.dq_message_id 
     WHERE 1=1
       and t.schema_name        = 'DQ_USER'
       and t.active_indicator   = 'A'
);
/