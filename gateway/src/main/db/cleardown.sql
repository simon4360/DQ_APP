set pagesize 500
set linesize 500
set echo on

WHENEVER SQLERROR EXIT SQL.SQLCODE

@connG77@

delete from t_info_log;
delete from t_error_log;
delete from t_batch_task_status;
delete from t_dq_log;
delete from t_file_control;
delete from t_run_parameters_config;

commit;

exit;
