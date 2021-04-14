CREATE OR REPLACE PACKAGE g77_cfg.pkg_maintenance_util AS


function create_audit_trigger_dml (
            p_driving_table VARCHAR2
          , p_audit_table VARCHAR2) RETURN CLOB ;
          
  PROCEDURE p_add_column_if_not_exists(p_table_name  VARCHAR2,
                                       p_column_name VARCHAR2,
                                       p_column_type VARCHAR2);

  PROCEDURE p_alter_column(p_table_name  VARCHAR2,
                           p_column_name VARCHAR2,
                           p_new_column_type VARCHAR2);

  PROCEDURE p_drop_table_column_if_exists(p_table_name  VARCHAR2,
                                          p_column_name VARCHAR2);
                                          
  PROCEDURE p_drop_constraint_if_exists(p_table_name  VARCHAR2,
                                          p_constraint_name VARCHAR2);

  FUNCTION f_is_table_exists(p_table_name VARCHAR2) return number;
  FUNCTION f_is_view_exists(p_view_name VARCHAR2) return number;

  FUNCTION f_is_column_in_table_exists(p_table_name VARCHAR2,
                                       p_column_name VARCHAR2) return number;

  PROCEDURE p_drop_table_if_exists(p_table_name VARCHAR2);
  PROCEDURE p_drop_view_if_exists(p_view_name VARCHAR2);

  PROCEDURE p_rename_table_column(p_table_name  VARCHAR2,
                                  p_column_from VARCHAR2,
                                  p_column_to   VARCHAR2);

  PROCEDURE p_set_unused_column_if_exists(p_table_name  VARCHAR2,
                                          p_column_name VARCHAR2);

  FUNCTION f_is_sequence_exists(p_sequence_name VARCHAR2) return number;

  PROCEDURE p_drop_sequence_if_exists(p_sequence_name VARCHAR2);

  PROCEDURE p_register_g77_db_install(p_version_to  VARCHAR2,
                                      p_script_path VARCHAR2);

  PROCEDURE p_register_g77_version(p_version_to VARCHAR2);

  PROCEDURE p_check_g77_version(p_version_from VARCHAR2,
                                p_version_to   VARCHAR2);
                                
 PROCEDURE pr_stats (  p_table_name         IN VARCHAR2,
                       p_gather_after_x_min IN NUMBER
                     );
 FUNCTION f_is_cnstraint_in_table_exists(p_table_name VARCHAR2,
                                         p_constraint_name VARCHAR2) return number;
                                
  --shared log functionality
  PROCEDURE log_message(p_msg_type  VARCHAR2,
                        p_proc_name VARCHAR2,
                        p_message   VARCHAR2,
                        p_backtrace VARCHAR2 := NULL,
                        p_callstack VARCHAR2 := NULL,
                        p_group     VARCHAR2 := NULL,
                        p_tagname   VARCHAR2 := NULL,
                        p_tag       VARCHAR2 := NULL,
                        p_tag1name  VARCHAR2 := NULL,
                        p_tag1      VARCHAR2 := NULL,
                        p_tag2name  VARCHAR2 := NULL,
                        p_tag2      VARCHAR2 := NULL,
                        p_tag3name  VARCHAR2 := NULL,
                        p_tag3      VARCHAR2 := NULL,
                        p_tag4name  VARCHAR2 := NULL,
                        p_tag4      VARCHAR2 := NULL);

  PROCEDURE log_error(p_proc_name VARCHAR2,
                      p_message   VARCHAR2,
                      p_backtrace VARCHAR2 := NULL,
                      p_group     VARCHAR2 := NULL,
                      p_tagname   VARCHAR2 := NULL,
                      p_tag       VARCHAR2 := NULL,
                      p_tag1name  VARCHAR2 := NULL,
                      p_tag1      VARCHAR2 := NULL,
                      p_tag2name  VARCHAR2 := NULL,
                      p_tag2      VARCHAR2 := NULL,
                      p_tag3name  VARCHAR2 := NULL,
                      p_tag3      VARCHAR2 := NULL,
                      p_tag4name  VARCHAR2 := NULL,
                      p_tag4      VARCHAR2 := NULL);

  PROCEDURE log_info(p_proc_name VARCHAR2,
                     p_message   VARCHAR2,
                     p_group     VARCHAR2 := NULL,
                     p_tagname   VARCHAR2 := NULL,
                     p_tag       VARCHAR2 := NULL,
                     p_tag1name  VARCHAR2 := NULL,
                     p_tag1      VARCHAR2 := NULL,
                     p_tag2name  VARCHAR2 := NULL,
                     p_tag2      VARCHAR2 := NULL,
                     p_tag3name  VARCHAR2 := NULL,
                     p_tag3      VARCHAR2 := NULL,
                     p_tag4name  VARCHAR2 := NULL,
                     p_tag4      VARCHAR2 := NULL);

  PROCEDURE log_warning(p_proc_name VARCHAR2,
                        p_message   VARCHAR2,
                        p_group     VARCHAR2 := NULL,
                        p_tagname   VARCHAR2 := NULL,
                        p_tag       VARCHAR2 := NULL,
                        p_tag1name  VARCHAR2 := NULL,
                        p_tag1      VARCHAR2 := NULL,
                        p_tag2name  VARCHAR2 := NULL,
                        p_tag2      VARCHAR2 := NULL,
                        p_tag3name  VARCHAR2 := NULL,
                        p_tag3      VARCHAR2 := NULL,
                        p_tag4name  VARCHAR2 := NULL,
                        p_tag4      VARCHAR2 := NULL);

END pkg_maintenance_util;
/
