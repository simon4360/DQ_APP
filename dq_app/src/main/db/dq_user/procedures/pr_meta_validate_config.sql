create or replace PROCEDURE DQ_USER.pr_meta_validate_config
IS
  v_proc_name             VARCHAR2(30)   := 'pr_dq_validate_config';
  v_function_call         VARCHAR2(32000) := NULL;
  e_config_validation     EXCEPTION;
  gv_error_msg            VARCHAR2(32000);
  gv_ecode                NUMBER       := -20999;
BEGIN

insert into DQ_USER.t_error_log
 (    EVENT_DATETIME
    , ERROR_STATUS
    , ERROR_APTITUDE_PROJECT
    , ERROR_RULE_IDENT
    , ERROR_TEXT
    , TABLE_IN_ERROR_NAME
    , FIELD_IN_ERROR_NAME
    )
    /*DQ basic configuration validation*/
    select SYSDATE
         , 'E'
         , nvl ( config.dq_aptitude_project , 'n/a' )
         , nvl ( config.dq_microflow , v_proc_name ) 
         , config.error_message
         , config.dq_staging_table
         , config.dq_column_name
      from
  (
     with cfg 
              ( dq_staging_table, dq_legal_entity_column, dq_aptitude_project, dq_column_name, dq_function_id ) as 
              ( select distinct t.table_name dq_staging_table, t.legal_entity_column dq_legal_entity_column, i.aptitude_project dq_aptitude_project, dq_column_name, dq_function_id
                  from DQ_USER.t_meta_table_dq dq inner join DQ_USER.t_meta_table t on t.table_id = dq.table_id
                    inner
                     join DQ_USER.t_meta_batch_task_table_x btx
                       on t.table_id = btx.table_id
                    inner
                     join DQ_USER.t_meta_batch_task bt
                       on btx.batch_task_id = bt.batch_task_id
                    inner
                     join DQ_USER.t_meta_interface i
                       on bt.interface_id = i.interface_id
                    where dq.dq_active_indicator = 'A'
                ),
           default_columns 
              ( dqc ) as
              ( select 'EVENT_STATUS' dqc FROM DUAL UNION
                select 'GATEWAY_ID'       FROM DUAL UNION
                select 'SOURCE_SYSTEM'    FROM DUAL UNION
                select 'SOURCE_SYSTEM_ID' FROM DUAL UNION
                select 'PARENT_SOURCE_ID' FROM DUAL UNION
                select 'SESSION_ID'       FROM DUAL UNION
                select 'USE_CASE_ID'      FROM DUAL
                )
                  
                  select distinct dq_staging_table, dq_legal_entity_column as dq_column_name, null as dq_aptitude_project, null as dq_microflow
                  
                  , 'The column '|| dq_staging_table || '.'|| dq_legal_entity_column || ' is not defined, but is used as t_meta_table.legal_entity_column' as error_message from cfg 
                  
                  union
                  
                  select distinct dq_staging_table , default_columns.dqc, null, null
                  
                  ,  'The column '|| dq_staging_table || '.'|| default_columns.dqc || ' is not defined,  but is a default column required for gateway processing.' as error_message from cfg

                          cross join default_columns
                                
                   union 
                  
                   select distinct dq_staging_table, trim(regexp_substr(dq_column_name,'[^|]+', 1, level) ) dq_column_name, null, null
                   
                   ,  'The column '|| dq_staging_table || '.'|| trim(regexp_substr(dq_column_name,'[^|]+', 1, level) ) || ' is not defined, but configured in a DQ rule.'  as error_message  from cfg  
                   
                            connect by regexp_substr(dq_column_name, '[^|]+', 1, level) is not null
                     
                   union 
                   
                   select distinct dq_staging_table, func.dq_function, null, null 
                        
                   , 'The DQ function '|| func.dq_function ||' is not defined or is invalid' as error_message   from cfg
                   
                            inner join  t_dq_function func on func.dq_function_id = cfg.dq_function_id
                        
                    union 
                    
                   select distinct mf.dq_staging_table, default_columns.dqc, mf.dq_aptitude_project,  mf.dq_microflow
                   
                   , 'The column '|| mf.dq_staging_table || '.'|| default_columns.dqc || ' is not defined,  but is a default column required for gateway processing.' as error_message  from v_meta_batch_task_dq mf


                            inner join cfg on cfg.dq_aptitude_project = mf.dq_aptitude_project
                            
                            cross join default_columns
                           
                  /* this test is probably now redundant union 
                   
                   select distinct mf.dq_staging_table, null dq_column_name, mf.dq_aptitude_project as dq_aptitude_project,  mf.dq_microflow as dq_microflow

                   , 'The aptitude project.microflow '|| mf.dq_aptitude_project||'.'||mf.dq_microflow|| ' is not configured in T_META_INTERFACE ' as error_message from v_meta_batch_task_dq mf

                             left join cfg on cfg.dq_aptitude_project = mf.dq_aptitude_project 
                             
                            where cfg.dq_aptitude_project is null */

    ) config
    left outer join all_tab_cols t on t.table_name = config.dq_staging_table and t.column_name = config.dq_column_name
    left outer join all_objects f on f.object_type = 'FUNCTION' and f.object_name = config.dq_column_name
   where t.column_name is null and f.object_name is null
   
   union all 
   
       /*UC basic configuration validation*/
   select SYSDATE
    , 'E'
    , nvl ( config.uc_aptitude_project , 'n/a' )
    , nvl ( config.uc_microflow , v_proc_name ) 
    , config.error_message
    , config.uc_staging_table
    , config.uc_column_name
    from
  (
     with cfg 
              ( uc_staging_table, uc_group_id, uc_bus_evt_tran_typ_filter ) as 
              ( select distinct uc_staging_table, uc_group_id, uc_bus_evt_tran_typ_filter
                  from t_meta_use_case 
                  where uc_active_indicator = 'A'
                ),
           default_columns 
              ( duc ) as
              ( select 'BUS_EVT_TRAN_TYP_SDL' duc FROM DUAL UNION
                select 'GATEWAY_ID'       FROM DUAL UNION
                select 'UC_SESSION_ID' FROM DUAL UNION
                select 'SESSION_ID'       FROM DUAL UNION
                select 'USE_CASE_ID'      FROM DUAL
                )
                
                  select distinct uc_staging_table, default_columns.duc as uc_column_name, uc_bus_evt_tran_typ_filter, null as uc_aptitude_project, null as uc_microflow
                  
                  , 'The column '|| uc_staging_table || '.'|| default_columns.duc || ' is not defined, but is mandatory in use case derivation' as error_message 
                  from cfg 
                  cross join default_columns 
                  where ( default_columns.duc <> 'BUS_EVT_TRAN_TYP_SDL' 
                     or ( default_columns.duc = 'BUS_EVT_TRAN_TYP_SDL' and 
                          uc_bus_evt_tran_typ_filter = 'Y' 
                         )
                        )
) config
left outer join all_tab_cols t on t.table_name = config.uc_staging_table and t.column_name = config.uc_column_name 
where  t.column_name is null 

union all

select SYSDATE
    , 'E'
    , 'n/a'
    , v_proc_name
    , 'T_META_USE_CASE.UC_BUS_EVT_TRAN_TYP_FILTER = Y. Please configure BETT / BETT GROUP filters for use case '|| a.UC_USE_CASE_ID || ' in T_META_UC_FILTER'
    , a.uc_staging_table
    , 'BUS_EVT_TRAN_TYP_SDL'
    from
         t_meta_use_case a
   where a.UC_BUS_EVT_TRAN_TYP_FILTER = 'Y' 
     and a.uc_active_indicator = 'A'
     and not exists (select 1 from v_meta_uc_bett_filter b where lower(b.UC_USE_CASE_ID) = lower(a.UC_USE_CASE_ID) )

   ;
   
  IF SQL%ROWCOUNT > 0
  THEN
    commit;
    RAISE e_config_validation;
  END IF;

  -- Check if function call and conditions configuration are working SQL
  FOR c2 IN
    (SELECT DISTINCT
       func.DQ_FUNCTION
     , config.DQ_CONFIG_ID
     , config.DQ_FUNCTION_PARAMETERS
     , t.TABLE_NAME DQ_STAGING_TABLE
     , cond.DQ_CONDITION
      FROM T_META_TABLE_DQ config
       inner join DQ_USER.t_meta_table t on t.table_id = config.table_id
       INNER JOIN      T_DQ_FUNCTION func ON func.DQ_FUNCTION_ID = config.DQ_FUNCTION_ID
       inner
                     join DQ_USER.t_meta_batch_task_table_x btx
                       on t.table_id = btx.table_id
                    inner
                     join DQ_USER.t_meta_batch_task bt
                       on btx.batch_task_id = bt.batch_task_id
                    inner
                     join DQ_USER.t_meta_interface i
                       on bt.interface_id = i.interface_id
       LEFT OUTER JOIN T_DQ_CONDITION cond ON cond.DQ_CONDITION_ID = config.DQ_CONDITION_ID
     WHERE DQ_ACTIVE_INDICATOR = 'A'
       AND lower(I.APTITUDE_PROJECT) in ( select distinct lower(aptitude_project) from t_meta_interface )
   )
  LOOP
    -- Set the function call - add any parameters
    IF c2.DQ_FUNCTION_PARAMETERS IS NOT NULL
    THEN
      v_function_call := c2.DQ_FUNCTION || '(' || c2.DQ_FUNCTION_PARAMETERS || ')';
    ELSE
      v_function_call := c2.DQ_FUNCTION;
    END IF;
    
    BEGIN
        EXECUTE IMMEDIATE 'SELECT * FROM '|| c2.DQ_STAGING_TABLE || ' WHERE ' ||
                  NVL(c2.DQ_CONDITION, ' 1 = 1 ') ||
                  ' AND ' || v_function_call || ' = '   || '''DQERROR''' ||
                  ' AND 1 != 1';
    EXCEPTION
    WHEN OTHERS THEN
      gv_error_msg := 'Configuration Validation Error for T_META_TABLE_DQ.DQ_CONFIG_ID: ' || c2.DQ_CONFIG_ID ||  ': ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm;
      RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
    END;
  END LOOP; 
  
  -- Check UC Configuration 
  FOR uc_config IN
     (SELECT
         uc_config_id,
         uc_assign_sql
       FROM v_meta_uc_config config
      ORDER BY UC_ORDER ASC
     )
  LOOP
    BEGIN
      EXECUTE IMMEDIATE uc_config.uc_assign_sql;
    EXCEPTION
    WHEN OTHERS THEN
      gv_error_msg := 'Configuration Validation Error for T_META_USE_CASE.UC_CONFIG_ID : ' || uc_config.UC_CONFIG_ID ||  '. uc_assign_sql : ' || uc_config.uc_assign_sql || ': '|| sqlcode || '-' || sqlerrm;
      RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
    END;
  END LOOP;

EXCEPTION
  WHEN e_config_validation THEN
    gv_error_msg := 'Configuration Validation Error: Failure in ' || v_proc_name || ': '|| sqlcode || '- check T_ERROR_LOG' ;
    RAISE_APPLICATION_ERROR (gv_ecode, gv_error_msg);
  WHEN OTHERS THEN
    gv_error_msg := 'Configuration Validation Error: Failure in ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm;
    RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
END pr_meta_validate_config;
/
