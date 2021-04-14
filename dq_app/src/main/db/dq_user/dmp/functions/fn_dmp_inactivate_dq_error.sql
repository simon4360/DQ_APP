create or replace FUNCTION DQ_USER.FN_DMP_INACTIVATE_DQ_ERROR (json_data in clob)
  RETURN       NUMBER
IS
  exec_stat    NUMBER(2, 0);
  v_rule_name  VARCHAR2(30) := 'fn_dmp_inactivate_error';
  v_msg                       T_ERROR_LOG.ERROR_TEXT%TYPE;
BEGIN
  FOR data_param_row IN (SELECT *
                           FROM json_table(json_data
                                          ,'$.data[*]' COLUMNS("BATCH_PROCESS_ID" PATH '$.param1'
                                                              ,"DQ_CONFIG_ID"     PATH '$.param2')
                                          )
                        )
  LOOP

      UPDATE T_DQ_LOG 
         SET DQ_ACTIVE_INDICATOR = 'I'
       WHERE BATCH_PROCESS_ID    = data_param_row.BATCH_PROCESS_ID
         AND DQ_CONFIG_ID        = data_param_row.DQ_CONFIG_ID
         AND DQ_ACTIVE_INDICATOR = 'A';

  END LOOP;

  COMMIT;

  exec_stat := 0;
  RETURN(exec_stat);
EXCEPTION
  WHEN OTHERS THEN
    v_msg := 'Unexpected Failure inactivating Error Message';
    ROLLBACK;
    pr_error('DMP Front End', v_rule_name, v_msg, p_use_case_id => 'DMP');
    RAISE;
    exec_stat := 1;
end FN_DMP_INACTIVATE_DQ_ERROR;
/