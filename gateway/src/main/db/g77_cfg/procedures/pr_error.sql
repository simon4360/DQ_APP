CREATE OR REPLACE PROCEDURE g77_cfg.pr_error
/****************************************************************************************************************************
* Description : Generic procedure to write errors and important information messages to the log table,
*               T_ERROR_LOG
*
*****************************************************************************************************************************/
(p_aptitude_project  IN T_ERROR_LOG.ERROR_APTITUDE_PROJECT%TYPE
,p_rule_ident        IN T_ERROR_LOG.ERROR_RULE_IDENT%TYPE
,p_text              IN T_ERROR_LOG.ERROR_TEXT%TYPE             
,p_source_system     IN T_ERROR_LOG.SOURCE_SYSTEM%TYPE := null
,p_row               IN T_ERROR_LOG.ROW_IN_ERROR_KEY_ID%TYPE := null
,p_batch_process_id  IN T_ERROR_LOG.BATCH_PROCESS_ID%TYPE := null
,p_use_case_id       in T_ERROR_LOG.USE_CASE_ID%type := null
,p_session_id        in T_ERROR_LOG.SESSION_ID%type := null
,p_table             IN T_ERROR_LOG.TABLE_IN_ERROR_NAME%TYPE := null
,p_field             IN T_ERROR_LOG.FIELD_IN_ERROR_NAME%TYPE := null
,p_value             IN T_ERROR_LOG.ERROR_VALUE%TYPE := null
,p_source_system_id  IN T_ERROR_LOG.SOURCE_SYSTEM_ID%TYPE := null
,p_parent_id         IN T_ERROR_LOG.PARENT_SOURCE_ID%TYPE := null
,p_severity          IN T_ERROR_LOG.SEVERITY%TYPE := null
)
as
-- This procedure is autonomous of database updates in the calling code.
PRAGMA AUTONOMOUS_TRANSACTION;

v_value                 T_ERROR_LOG.ERROR_VALUE%TYPE;
v_text                  T_ERROR_LOG.ERROR_TEXT%TYPE;
BEGIN

    IF p_value IS NOT NULL THEN
        v_value := p_value;
    ELSIF sqlcode != 0 THEN
        v_value := to_char(sqlcode);
    END IF;

    IF sqlcode = 0 THEN
        v_text := substr(p_text, 1, 2000);
    ELSE
        v_text := substr(sqlerrm || ': ' || p_text, 1, 2000);
    END IF;

    INSERT INTO T_ERROR_LOG
    ( EVENT_DATETIME
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
    , SEVERITY
    )
    VALUES
    (
      SYSDATE
    , 'E'
    , p_aptitude_project	
    , p_rule_ident
    , v_text
    , p_batch_process_id
    , p_use_case_id
    , p_session_id
    , p_row
    , p_source_system	
    , p_table
    , p_field
    , v_value
    , p_source_system_id
    , p_parent_id
    , p_severity
    );

    COMMIT;
END;
/
