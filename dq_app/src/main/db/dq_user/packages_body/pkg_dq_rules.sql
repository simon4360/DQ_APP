create or replace PACKAGE BODY DQ_USER.pkg_dq_rules
AS

-- Global variables
gv_package_name         VARCHAR2(30) := 'pkg_dq_rules';
gv_total_row_count      NUMBER;
gv_error_row_count      NUMBER;
gv_return_code          NUMBER;
gv_status_dq_check      VARCHAR2(50);
gv_error_msg            VARCHAR2(32000);
gv_ecode                NUMBER       := -20999;
/******************************************************************************
fn_concat_columns: Return concatenaded column
Delimeter set to |
*******************************************************************************/
FUNCTION fn_concat_columns ( p_string_in IN VARCHAR2 )
RETURN VARCHAR2
IS
  vStartIdx    BINARY_INTEGER;
  vEndIdx      BINARY_INTEGER;
  vValue       VARCHAR2(30);
  o_string_out VARCHAR2 (32000);
BEGIN
  vStartIdx := 0;
  vEndIdx   := INSTR(p_string_in, '|');

  WHILE(vEndIdx > 0) LOOP
    vValue := SUBSTR(p_string_in, vStartIdx+1, vEndIdx - vStartIdx - 1);

    IF vStartIdx = 0
    THEN
      o_string_out := vValue;
    ELSE
      o_string_out := o_string_out || '|| ''|'' || ' || vValue;
    END IF;

    vStartIdx := vEndIdx;
    vEndIdx := INSTR(p_string_in, '|', vStartIdx + 1);
  END LOOP;

  vValue := SUBSTR(p_string_in, vStartIdx+1);

  IF vStartIdx = 0
  THEN
    o_string_out := vValue;
  ELSE
    o_string_out := o_string_out || '|| ''|'' || ' || vValue;
  END IF;

  RETURN o_string_out;

END fn_concat_columns;
/******************************************************************************
pr_dq_wrapper: Wrapper running DQ rules
*******************************************************************************/
PROCEDURE pr_dq_wrapper (  p_process_id         IN    NUMBER
                         , p_use_case_id        IN    VARCHAR2
                         , p_session_id         IN    VARCHAR2
                         , p_aptitude_project   IN    VARCHAR2
                         , p_rule_category      IN    VARCHAR2
                         , p_microflow          IN    VARCHAR2
                         , p_is_restart         IN    VARCHAR2
                         , o_return_code        OUT   NUMBER
                        )
IS

  v_update_sql        VARCHAR2(32000);
  v_count_sql         VARCHAR2(32000);
  v_ucd_err_sql       VARCHAR2(32000);
  v_proc_name         VARCHAR2(30)   := 'pr_dq_wrapper';

BEGIN

  -- Reset global variables
  gv_total_row_count := 0;
  gv_error_row_count := 0;
  gv_return_code     := 0;

    -- Get the configuration
  FOR c IN
     (SELECT config.DQ_CONFIG_ID
           , config.DQ_RULE_TYPE
           , config.DQ_PURPOSE
           , config.DQ_CORRECTIVE_ACTION
           , config.DQ_CONTACT_TEAM
           , config.DQ_SEVERITY_ID
           , config.DQ_STAGING_TABLE
           , config.DQ_COLUMN_NAME
           , config.DQ_LEGAL_ENTITY_COLUMN
           , config.DQ_MESSAGE
           , config.DQ_TYPE
           , REPLACE(REPLACE(config.DQ_FAILED_DATA_SQL
                            ,'REGEX_SESSION'
                            ,p_session_id
                            )
                    ,'REGEX_USE_CASE'
                    ,p_use_case_id
                    )                                   as DQ_FAILED_DATA_SQL
           , config.DQ_MERGE_SQL
           , config.DQ_COUNT_SQL
           , config.DQ_USE_CASE_ERR_SQL
           , config.DQ_WHERE_SQL
       FROM v_meta_batch_task_dq config
      WHERE config.DQ_RULE_CATEGORY      = p_rule_category
        AND config.DQ_MICROFLOW          = p_microflow
        AND config.DQ_APTITUDE_PROJECT   = p_aptitude_project
        AND ( 
             ( config.dq_activation = 'NORMAL'                and nvl ( p_is_restart, 'N') = 'N' ) or
             ( config.dq_activation = 'AT BATCH TASK RESTART' and nvl ( p_is_restart, 'N') = 'Y' ) 
            )
        and config.dq_use_case_id = case when ( select count(*)
                                                  from v_meta_batch_task_dq config
                                                 where config.dq_rule_category      = p_rule_category
                                                   and config.dq_microflow          = p_microflow
                                                   and config.dq_aptitude_project   = p_aptitude_project
                                                   and config.dq_use_case_id        = p_use_case_id 
                                               ) > 0 
                                         then p_use_case_id
                                         else 'ALL'
                                         end
        and config.DQ_COLUMN_NAME like case when config.DQ_MICROFLOW = 'run_use_case_derivation'
                                            then 'USE_CASE_ID'
                                            else '%'
                                        end
     )
  LOOP



    -- Set the where clause to check for errors
    -- Only select the current session id
    -- For failed events the function call should return "DQERROR"

    v_update_sql := regexp_replace ( regexp_replace ( c.DQ_MERGE_SQL, 'REGEX_SESSION', p_session_id), 'REGEX_USE_CASE', p_use_case_id);

    -- Get total row count
    v_count_sql  := regexp_replace ( regexp_replace ( c.DQ_COUNT_SQL, 'REGEX_SESSION', p_session_id), 'REGEX_USE_CASE', p_use_case_id);

    EXECUTE IMMEDIATE (v_count_sql) INTO gv_total_row_count;

    IF c.DQ_TYPE = 'no_use_case_id' THEN 
        -- check if no use case has been assigned
        v_ucd_err_sql := regexp_replace ( regexp_replace ( c.DQ_USE_CASE_ERR_SQL, 'REGEX_SESSION', p_session_id), 'REGEX_USE_CASE', p_use_case_id);
        EXECUTE IMMEDIATE (v_ucd_err_sql) INTO gv_error_row_count;
    END IF;

     -- Only process DQ068 (~ no_use_case_id) if there are use case errors
    IF ( c.DQ_TYPE = 'no_use_case_id' AND gv_error_row_count > 0 ) OR ( c.DQ_TYPE != 'no_use_case_id' ) 
      THEN 
        pr_dq_run_checks (  p_process_id               =>    p_process_id
                          , p_dq_config_id             =>    c.DQ_CONFIG_ID
                          , p_dq_rule_type             =>    c.DQ_RULE_TYPE
                          , p_dq_purpose               =>    c.DQ_PURPOSE
                          , p_dq_corrective_action     =>    c.DQ_CORRECTIVE_ACTION
                          , p_dq_contact_team          =>    c.DQ_CONTACT_TEAM
                          , p_use_case_id              =>    CASE 
                                                             WHEN c.DQ_TYPE = 'no_use_case_id'
                                                                  THEN 'NULL' --DQ068
                                                             ELSE
                                                                  p_use_case_id -- All other DQ rules
                                                             END
                          , p_session_id               =>    p_session_id
                          , p_aptitude_project         =>    p_aptitude_project
                          , p_aptitude_microflow       =>    p_microflow
                          , p_severity_id              =>    c.DQ_SEVERITY_ID
                          , p_function                 =>    p_microflow
                          , p_table                    =>    c.DQ_STAGING_TABLE
                          , p_column                   =>    c.DQ_COLUMN_NAME
                          , p_legal_entity_column      =>    c.DQ_LEGAL_ENTITY_COLUMN
                          , p_dq_update_sql            =>    v_update_sql
                          , p_dq_ucd_err_sql           =>    v_ucd_err_sql
                          , p_dq_where_sql             =>    c.DQ_WHERE_SQL
                          , p_dq_failed_data_sql       =>    c.DQ_FAILED_DATA_SQL
                          , p_rule_category            =>    p_rule_category
                          , p_condition                =>    NULL
                          , p_function_error_message   =>    c.DQ_MESSAGE
                         );
    -- Commit after every DQ check
    COMMIT;
    END IF;

  END LOOP;

  -- Set the return code
  o_return_code := gv_return_code;

EXCEPTION
  WHEN OTHERS THEN
  gv_error_msg := 'Failure in ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm || ';' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE();
  ROLLBACK;
  o_return_code := 1;
  pr_error(p_aptitude_project, v_proc_name, gv_error_msg, p_batch_process_id => p_process_id, p_use_case_id => p_use_case_id, p_session_id => p_session_id, p_value => p_use_case_id, p_table => 'V_META_BATCH_TASK_DQ', p_field => 'DQ_USE_CASE_ID' );
  RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
END pr_dq_wrapper;
/******************************************************************************
pr_dq_run_checks: Run the DQ checks
*******************************************************************************/
PROCEDURE pr_dq_run_checks (  p_process_id              IN NUMBER
                            , p_dq_config_id            IN NUMBER
                            , p_dq_rule_type            IN VARCHAR2
                            , p_dq_purpose              IN VARCHAR2
                            , p_dq_corrective_action    IN VARCHAR2
                            , p_dq_contact_team         IN VARCHAR2
                            , p_use_case_id             IN VARCHAR2
                            , p_session_id              IN VARCHAR2
                            , p_aptitude_project        IN VARCHAR2
                            , p_aptitude_microflow      IN VARCHAR2
                            , p_severity_id             IN NUMBER
                            , p_function                IN VARCHAR2
                            , p_table                   IN VARCHAR2
                            , p_column                  IN VARCHAR2
                            , p_legal_entity_column     IN VARCHAR2
                            , p_dq_update_sql           IN VARCHAR2
                            , p_dq_ucd_err_sql          IN VARCHAR2
                            , p_dq_where_sql            IN VARCHAR2
                            , p_dq_failed_data_sql      IN VARCHAR2
                            , p_rule_category           IN VARCHAR2
                            , p_condition               IN VARCHAR2 DEFAULT NULL
                            , p_function_error_message  IN VARCHAR2 DEFAULT NULL
                           )
IS
  v_proc_name  VARCHAR2(30) := 'pr_dq_run_checks';
  v_sql_count  CLOB;
BEGIN
  -- Log the end of the DQ check
  pr_dq_log (  p_process_id           =>    p_process_id
             , p_dq_config_id         =>    p_dq_config_id
             , p_dq_purpose           =>    p_dq_purpose
             , p_dq_corrective_action =>    p_dq_corrective_action
             , p_dq_contact_team      =>    p_dq_contact_team
             , p_use_case_id          =>    p_use_case_id
             , p_aptitude_project     =>    p_aptitude_project
             , p_aptitude_microflow   =>    p_aptitude_microflow
             , p_session_id           =>    p_session_id
             , p_severity_id          =>    p_severity_id
             , p_table                =>    p_table
             , p_column               =>    p_column
             , p_dq_failed_data_sql   =>    p_dq_failed_data_sql
             , p_total_row_count      =>    0
             , p_error_row_count      =>    0
             , p_status_dq_check      =>    'STARTED'
            );
  -- Reset number of errors for every dq rule
  gv_error_row_count := 0;

  -- Update the event status for failed events.
  -- Don't update the status if the severity is 1 (Warning) or if no records to process
  IF p_severity_id <> 1 and gv_total_row_count > 0
  THEN
    pr_dq_update_status (  p_dq_config_id           =>  p_dq_config_id
                         , p_use_case_id            =>  p_use_case_id
                         , p_session_id             =>  p_session_id
                         , p_process_id             =>  p_process_id
                         , p_severity_id            =>  p_severity_id
                         , p_table                  =>  p_table
                         , p_dq_update_sql          =>  p_dq_update_sql);
  ELSE
    gv_status_dq_check := 'PASSED';
  END IF;

  -- Log errors in T_ERROR_LOG
  IF gv_error_row_count > 0 OR p_severity_id = 1
  THEN
    pr_dq_log_errors (  p_dq_config_id           =>  p_dq_config_id
                      , p_dq_rule_type           =>  p_dq_rule_type
                      , p_process_id             =>  p_process_id
                      , p_use_case_id            =>  p_use_case_id
                      , p_session_id             =>  p_session_id
                      , p_aptitude_project       =>  p_aptitude_project
                      , p_severity_id            =>  p_severity_id
                      , p_function               =>  p_function
                      , p_table                  =>  p_table
                      , p_column                 =>  p_column
                      , p_legal_entity_column    =>  p_legal_entity_column
                      , p_dq_update_sql          =>  p_dq_update_sql
                      , p_dq_where_sql           =>  p_dq_where_sql
                      , p_rule_category          =>  p_rule_category
                      , p_function_error_message =>  p_function_error_message);
  END IF;
    -- Populate the gv_error_row_count for DQ068 only as it was reset above
    IF ( LOWER (p_aptitude_project) = 'g77_utils'
       AND
       LOWER (p_aptitude_microflow) = 'run_use_case_derivation') THEN 
     EXECUTE IMMEDIATE (p_dq_ucd_err_sql)
     INTO gv_error_row_count;
    END IF;

  pr_dq_log (  p_process_id           =>    p_process_id
             , p_dq_config_id         =>    p_dq_config_id
             , p_dq_purpose           =>    p_dq_purpose
             , p_dq_corrective_action =>    p_dq_corrective_action
             , p_dq_contact_team      =>    p_dq_contact_team
             , p_use_case_id          =>    p_use_case_id
             , p_aptitude_project     =>    p_aptitude_project
             , p_session_id           =>    p_session_id
             , p_severity_id          =>    p_severity_id
             , p_aptitude_microflow   =>    p_aptitude_microflow
             , p_table                =>    p_table
             , p_column               =>    p_column
             , p_dq_failed_data_sql   =>    p_dq_failed_data_sql
             , p_total_row_count      =>    gv_total_row_count
             , p_error_row_count      =>    gv_error_row_count
             , p_status_dq_check      =>    gv_status_dq_check
            );

EXCEPTION
  WHEN OTHERS THEN
    gv_error_msg := 'Failure in ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm;
    RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
END pr_dq_run_checks;
/******************************************************************************
pr_dq_update_status: Update EVENT_STATUS
*******************************************************************************/
PROCEDURE pr_dq_update_status (  p_dq_config_id    IN VARCHAR2
                               , p_use_case_id     IN VARCHAR2
                               , p_session_id      IN VARCHAR2
                               , p_process_id      IN NUMBER
                               , p_severity_id     IN NUMBER
                               , p_table           IN VARCHAR2
                               , p_dq_update_sql    IN VARCHAR2
                              )
IS
  v_threshold_breach     VARCHAR2(1);
  v_proc_name            VARCHAR2(30) := 'pr_update_status';
  v_failed_event_status  NUMBER       := 5;
  v_hold_event_status    NUMBER       := 9;
  v_discard_event_status NUMBER       := 3;
  v_event_status         NUMBER;
BEGIN

      EXECUTE IMMEDIATE p_dq_update_sql;

      gv_error_row_count := SQL%ROWCOUNT;

      -- If severity is 2 or 5, the event status need to be set to 9 (Hold Transaction or Batch), otherwise set it to 5 (Failed)
      -- Don't update failed events back to warnings
      IF    p_severity_id in (2,5)
      THEN
            v_event_status := v_hold_event_status;
            
            update DQ_USER.t_batch_task_status 
               set dmp_error_active_indicator = 'A' 
             where batch_task_process_id      = p_process_id;
            
      ELSIF p_severity_id = 6
      THEN
            v_event_status := v_discard_event_status;
            
            update DQ_USER.t_batch_task_status 
               set dmp_error_active_indicator = 'A' 
             where batch_task_process_id      = p_process_id;
            
      ELSE
            v_event_status := v_failed_event_status;

            update DQ_USER.t_batch_task_status 
               set dmp_error_active_indicator = 'A' 
             where batch_task_process_id      = p_process_id;
             
      END IF;

    -- Check threshold breach
    SELECT
    NVL(MIN(
        CASE
          WHEN THRESHOLD_IS_PERCENT = 'Y' THEN
            CASE
              WHEN (gv_error_row_count/decode(gv_total_row_count,0,1,gv_total_row_count))*100 > DQ_THRESHOLD THEN 'Y'
              ELSE 'N'
            END
          WHEN THRESHOLD_IS_PERCENT = 'N' THEN
            CASE
              WHEN gv_error_row_count > DQ_THRESHOLD THEN 'Y'
              ELSE 'N'
            END
        END)
    , 'N') AS THRESHOLD_BREACH
    INTO
      v_threshold_breach
    FROM T_DQ_THRESHOLD
    WHERE DQ_CONFIG_ID = p_dq_config_id;

    -- Fail/Hold entire session: if any errors and severity set to 4 (batch fail) or 5 (batch hold), or if the threshold is breached
    IF (p_severity_id = 4 AND gv_error_row_count > 0) OR v_threshold_breach = 'Y' OR (p_severity_id = 5 AND gv_error_row_count > 0)
    THEN
      EXECUTE IMMEDIATE 'UPDATE ' || p_table || ' SET EVENT_STATUS =
                           CASE WHEN EVENT_STATUS = ' || v_failed_event_status || ' THEN ' || v_failed_event_status || '
                              ELSE ' || v_event_status || '
                           END
                         WHERE  SESSION_ID   = ''' || p_session_id || '''
                           AND  lower(USE_CASE_ID)  = lower(''' || p_use_case_id || ''')';

      -- If a session fails the DQ checks, set the overall return code to error and the status to Failed
      gv_return_code := 1;
      gv_status_dq_check := 'FAILED';
    ELSE
      gv_status_dq_check := 'PASSED';
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    gv_error_msg := 'Failure in ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm;
    RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
END pr_dq_update_status;
/******************************************************************************
pr_dq_log_errors: Log errors in T_ERROR_LOG
*******************************************************************************/
PROCEDURE pr_dq_log_errors (  p_dq_config_id            IN NUMBER
                            , p_dq_rule_type            IN VARCHAR2
                            , p_process_id              IN NUMBER
                            , p_use_case_id             IN VARCHAR2
                            , p_session_id              IN VARCHAR2
                            , p_aptitude_project        IN VARCHAR2
                            , p_severity_id             IN NUMBER
                            , p_function                IN VARCHAR2
                            , p_table                   IN VARCHAR2
                            , p_column                  IN VARCHAR2
                            , p_legal_entity_column     IN VARCHAR2
                            , p_dq_update_sql           IN VARCHAR2
                            , p_dq_where_sql            IN VARCHAR2
                            , p_rule_category           IN VARCHAR2
                            , p_function_error_message  IN VARCHAR2 DEFAULT NULL
                           )
IS
  v_error_status               VARCHAR2(1);
  v_proc_name                  VARCHAR2(30) := 'pr_log_errors';
  v_sql                        CLOB;
BEGIN

    -- Set the Error Status to W(arning) for severity 1
    SELECT DECODE(p_severity_id,1,'W','E') INTO v_error_status FROM DUAL;

    -- Merge failed records in T_ERROR_LOG
    -- In case records already logged, update with new details
    -- If the dq rule category is totals, log only 1 error message
    IF p_rule_category = 'TOTALS'
    THEN
       v_sql:=
       'INSERT INTO T_ERROR_LOG (
          EVENT_DATETIME
        , ERROR_STATUS
        , ERROR_APTITUDE_PROJECT
        , ERROR_RULE_IDENT
        , ERROR_TEXT
        , BATCH_PROCESS_ID
        , USE_CASE_ID
        , SESSION_ID
        , ROW_IN_ERROR_KEY_ID
        , SOURCE_SYSTEM
        , TABLE_IN_ERROR_NAME
        , FIELD_IN_ERROR_NAME
        , ERROR_VALUE
        , SOURCE_SYSTEM_ID
        , PARENT_SOURCE_ID
        , LEGAL_ENTITY
        , SEVERITY
        , DQ_CONFIG_ID
        , DQ_RULE_TYPE
        , ERROR_ACTIVE_IND
        , NO_RETRIES
        , UPDATED_BY
        , UPDATED_TIME
        , AUTH_BY) '
        || ' SELECT
                 SYSDATE                                                           -- EVENT_DATETIME
               , ''' || v_error_status || '''                                      -- ERROR_STATUS
               , ''' || p_aptitude_project || '''                                  -- ERROR_APTITUDE_PROJECT
               , ''' || p_function || '''                                          -- ERROR_RULE_IDENT
               , ''' || NVL( p_function_error_message, 'DQ Rule Failed') || '''    -- ERROR_TEXT
               , '   || p_process_id || '                                          -- BATCH_PROCESS_ID
               , ''' || p_use_case_id || '''                                       -- USE_CASE_ID
               , ''' || p_session_id || '''                                        -- SESSION_ID
               , NULL                                                              -- ROW_IN_ERROR_KEY_ID
               , src.SOURCE_SYSTEM                                                 -- SOURCE_SYSTEM
               , ''' || p_table  || '''                                            -- TABLE_IN_ERROR_NAME
               , ''' || p_column || '''                                            -- FIELD_IN_ERROR_NAME
               , NULL                                                              -- ERROR_VALUE
               , NULL                                                              -- SOURCE_SYSTEM_ID
               , NULL                                                              -- PARENT_SOURCE_ID
               , NULL                                                              -- LEGAL_ENTITY
               , '   || p_severity_id || '                                         -- SEVERITY
               , '   || p_dq_config_id || '                                        -- DQ_CONFIG_ID
               , ''' || p_dq_rule_type || '''                                      -- DQ_RULE_TYPE
               , ''A''                                                             -- ERROR_ACTIVE_IND
               ,  0                                                                -- NO_RETRIES
               , USER                                                              -- UPDATED_BY
               , SYSDATE                                                           -- UPDATED_TIME
               , NULL                                                              -- AUTH_BY
       FROM ' || p_table || ' src ' ||
       p_dq_where_sql || ' AND rownum = 1 ';
       
    ELSE
      
      v_sql:= 'MERGE INTO T_ERROR_LOG target
        USING '
         ||
          '( SELECT
                 SYSDATE                                                           AS EVENT_DATETIME
               , ''' || v_error_status || '''                                      AS ERROR_STATUS
               , ''' || p_aptitude_project || '''                                  AS ERROR_APTITUDE_PROJECT
               , ''' || p_function || '''                                          AS ERROR_RULE_IDENT
               , ''' || NVL( p_function_error_message, 'DQ Rule Failed') || '''    AS ERROR_TEXT
               , '   || p_process_id || '                                          AS BATCH_PROCESS_ID
               , ''' || p_use_case_id || '''                                       AS USE_CASE_ID
               , ''' || p_session_id || '''                                        AS SESSION_ID
               , GATEWAY_ID                                                        AS ROW_IN_ERROR_KEY_ID
               , SOURCE_SYSTEM                                                     AS SOURCE_SYSTEM
               , ''' || p_table  || '''                                            AS TABLE_IN_ERROR_NAME
               , ''' || p_column || '''                                            AS FIELD_IN_ERROR_NAME
               , '   || p_table  || '.'|| fn_concat_columns(p_column) || '         AS ERROR_VALUE
               , SOURCE_SYSTEM_ID                                                  AS SOURCE_SYSTEM_ID
               , PARENT_SOURCE_ID                                                  AS PARENT_SOURCE_ID
               , '   || p_legal_entity_column || '                                 AS LEGAL_ENTITY
               , '   || p_severity_id || '                                         AS SEVERITY
               , '   || p_dq_config_id || '                                        AS DQ_CONFIG_ID
               , ''' || p_dq_rule_type || '''                                      AS DQ_RULE_TYPE
               , ''A''                                                             AS ERROR_ACTIVE_IND
               ,  0                                                                AS NO_RETRIES
               , USER                                                              AS UPDATED_BY
               , NULL                                                              AS AUTH_BY
       FROM ' || p_table || ' ' ||
       p_dq_where_sql || ') src
       ON (    target.ROW_IN_ERROR_KEY_ID = src.ROW_IN_ERROR_KEY_ID
           AND target.TABLE_IN_ERROR_NAME = src.TABLE_IN_ERROR_NAME
           AND target.DQ_CONFIG_ID = src.DQ_CONFIG_ID
          )
       WHEN MATCHED THEN UPDATE SET
             target.NO_RETRIES       = target.NO_RETRIES + 1
           , target.ERROR_ACTIVE_IND = ''A''
           , target.ERROR_STATUS     = src.ERROR_STATUS
           , target.BATCH_PROCESS_ID = src.BATCH_PROCESS_ID
           , target.SESSION_ID       = src.SESSION_ID
           , target.SEVERITY         = src.SEVERITY
           , target.ERROR_VALUE      = src.ERROR_VALUE
           , target.LAST_RETRY       = src.EVENT_DATETIME
           , target.UPDATED_BY       = src.UPDATED_BY
           , target.UPDATED_TIME     = src.EVENT_DATETIME
           , target.AUTH_BY          = src.AUTH_BY
       WHEN NOT MATCHED THEN INSERT
       (         target.EVENT_DATETIME
               , target.ERROR_STATUS
               , target.ERROR_APTITUDE_PROJECT
               , target.ERROR_RULE_IDENT
               , target.ERROR_TEXT
               , target.BATCH_PROCESS_ID
               , target.USE_CASE_ID
               , target.SESSION_ID
               , target.ROW_IN_ERROR_KEY_ID
               , target.SOURCE_SYSTEM
               , target.TABLE_IN_ERROR_NAME
               , target.FIELD_IN_ERROR_NAME
               , target.ERROR_VALUE
               , target.SOURCE_SYSTEM_ID
               , target.PARENT_SOURCE_ID
               , target.LEGAL_ENTITY
               , target.SEVERITY
               , target.DQ_CONFIG_ID
               , target.DQ_RULE_TYPE
               , target.ERROR_ACTIVE_IND
               , target.NO_RETRIES
               , target.UPDATED_BY
               , target.UPDATED_TIME
               , target.AUTH_BY
       )
       VALUES
       (         src.EVENT_DATETIME
               , src.ERROR_STATUS
               , src.ERROR_APTITUDE_PROJECT
               , src.ERROR_RULE_IDENT
               , src.ERROR_TEXT
               , src.BATCH_PROCESS_ID
               , src.USE_CASE_ID
               , src.SESSION_ID
               , src.ROW_IN_ERROR_KEY_ID
               , src.SOURCE_SYSTEM
               , src.TABLE_IN_ERROR_NAME
               , src.FIELD_IN_ERROR_NAME
               , src.ERROR_VALUE
               , src.SOURCE_SYSTEM_ID
               , src.PARENT_SOURCE_ID
               , src.LEGAL_ENTITY
               , src.SEVERITY
               , src.DQ_CONFIG_ID
               , src.DQ_RULE_TYPE
               , src.ERROR_ACTIVE_IND
               , src.NO_RETRIES
               , src.UPDATED_BY
               , src.EVENT_DATETIME
               , src.AUTH_BY
       )';
    END IF;
    
    EXECUTE IMMEDIATE v_sql;    

EXCEPTION
  WHEN OTHERS THEN
    gv_error_msg := 'Failure in ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm;
    RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
END pr_dq_log_errors;
/******************************************************************************
pr_dq_log: Log steps in DQ_LOG
*******************************************************************************/
PROCEDURE pr_dq_log (  p_process_id              IN NUMBER
                     , p_dq_config_id            IN NUMBER
                     , p_dq_purpose              IN VARCHAR2
                     , p_dq_corrective_action    IN VARCHAR2
                     , p_dq_contact_team         IN VARCHAR2
                     , p_use_case_id             IN VARCHAR2
                     , p_aptitude_project        IN VARCHAR2
                     , p_aptitude_microflow      IN VARCHAR2
                     , p_session_id              IN VARCHAR2
                     , p_severity_id             IN NUMBER
                     , p_table                   IN VARCHAR2
                     , p_column                  IN VARCHAR2
                     , p_dq_failed_data_sql      IN VARCHAR2  DEFAULT NULL
                     , p_total_row_count         IN NUMBER
                     , p_error_row_count         IN NUMBER
                     , p_status_dq_check         IN VARCHAR2
                    )
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_proc_name               VARCHAR2(30 BYTE) := 'pr_dq_log';
  v_severity                VARCHAR2(30 BYTE);
BEGIN

  SELECT DQ_SEVERITY 
    INTO v_severity 
    FROM T_DQ_SEVERITY 
   WHERE DQ_SEVERITY_ID = p_severity_id;

  INSERT INTO T_DQ_LOG
            ( DQ_CONFIG_ID
            , DQ_STATUS
            , DQ_TIMESTAMP
            , BATCH_PROCESS_ID
            , DQ_SESSION_ID
            , DQ_USE_CASE_ID
            , DQ_APTITUDE_PROJECT
            , DQ_APTITUDE_MICROFLOW
            , DQ_TABLE_NAME
            , DQ_COLUMN_NAME
            , DQ_PURPOSE
            , DQ_CORRECTIVE_ACTION
            , DQ_CONTACT_TEAM
            , DQ_RECORDS_PROCESSED
            , DQ_RECORDS_FAILED
            , DQ_SEVERITY
            , DQ_FAILED_DATA_SQL
            )
       VALUES
            ( p_dq_config_id
            , p_status_dq_check
            , SYSDATE
            , p_process_id
            , p_session_id
            , p_use_case_id
            , p_aptitude_project
            , p_aptitude_microflow
            , p_table
            , p_column
            , p_dq_purpose
            , case when p_error_row_count > 0
                   then p_dq_corrective_action
                   else null
               end
            , p_dq_contact_team
            , DECODE(p_status_dq_check, 'STARTED', NULL, p_total_row_count)
            , DECODE(p_status_dq_check, 'STARTED', NULL, p_error_row_count)
            , case when p_error_row_count > 0
                   then v_severity
                   else null
               end
            , case when p_error_row_count > 0
                   then p_dq_failed_data_sql
                   else null
               end
            );

   -- Commit the log message
   COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    gv_error_msg := 'Failure in ' || v_proc_name || ': '|| sqlcode || '-' || sqlerrm;
    RAISE_APPLICATION_ERROR(gv_ecode, gv_error_msg);
END pr_dq_log;
---------------------------------------------------------------------------------
END pkg_dq_rules;
/
