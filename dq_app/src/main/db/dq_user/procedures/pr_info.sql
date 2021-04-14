create or replace procedure DQ_USER.pr_info
/****************************************************************************************************************************
* description : generic procedure to write important information messages to the log table,
*               t_info_log
*
*****************************************************************************************************************************/
(p_aptitude_project  in t_info_log.aptitude_project%type
,p_rule_ident        in t_info_log.rule_ident%type
,p_text 		         in t_info_log.message_text%type             
,p_source_system     in t_info_log.source_system%type := null
,p_target_system     in t_info_log.target_system%type := null
,p_table             in t_info_log.source_table%type := null
,p_batch_process_id  in t_info_log.batch_process_id%type := null
,p_use_case_id       in t_info_log.use_case_id%type := null
,p_session_id        in t_info_log.session_id%type := null
,p_gateway_id        in t_info_log.gateway_id%type := null
,p_source_system_id  in t_info_log.source_system_id%type := null
,p_parent_id         in t_info_log.parent_source_id%type := null
)


as
-- This procedure is autonomous of database updates in the calling code.
pragma autonomous_transaction;

begin

    insert into t_info_log
    ( event_datetime	
    , aptitude_project
    , rule_ident	    
    , message_text	  
    , source_system	  
    , target_system	  
    , source_table	  
    , batch_process_id
    , use_case_id
    , session_id
    , gateway_id	    
    , source_system_id
    , parent_source_id
    )
    values
    (
      sysdate
    , p_aptitude_project	
    , p_rule_ident
    , p_text
    , p_source_system	
    , p_target_system	
    , p_table
    , p_batch_process_id
    , p_use_case_id
    , p_session_id
    , p_gateway_id
    , p_source_system_id
    , p_parent_id
    );

    commit;
end;
/
