create or replace PACKAGE g77_cfg.pkg_dq_rules
AS

FUNCTION fn_concat_columns ( p_string_in IN VARCHAR2 )
RETURN VARCHAR2;

PROCEDURE pr_dq_wrapper (  p_process_id         IN    NUMBER
                         , p_use_case_id        IN    VARCHAR2
                         , p_session_id         IN    VARCHAR2
                         , p_aptitude_project   IN    VARCHAR2
                         , p_rule_category      IN    VARCHAR2
                         , p_microflow          IN    VARCHAR2
                         , p_is_restart         IN    VARCHAR2
                         , o_return_code        OUT   NUMBER
                        );

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
                           );

PROCEDURE pr_dq_update_status (  p_dq_config_id    IN VARCHAR2
                               , p_use_case_id     IN VARCHAR2
                               , p_session_id      IN VARCHAR2
                               , p_process_id      IN NUMBER
                               , p_severity_id     IN NUMBER
                               , p_table           IN VARCHAR2
                               , p_dq_update_sql   IN VARCHAR2
                              );

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
                           );

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
                    );
END pkg_dq_rules;
/