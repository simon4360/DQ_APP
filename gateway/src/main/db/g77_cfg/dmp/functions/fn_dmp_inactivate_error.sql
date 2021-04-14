create or replace FUNCTION G77_CFG.FN_DMP_INACTIVATE_ERROR (json_data in clob)
  RETURN       NUMBER
IS
  exec_stat    NUMBER(2, 0);
  v_rule_name  VARCHAR2(30) := 'fn_dmp_inactivate_error';
  v_msg                       T_ERROR_LOG.ERROR_TEXT%TYPE;
BEGIN
  FOR data_param_row IN (SELECT *
                           FROM json_table(json_data
                                          ,'$.data[*]' COLUMNS("BATCH_PROCESS_ID" PATH '$.param1')
                                          )
                        )
  LOOP

      UPDATE T_ERROR_LOG 
         SET ERROR_ACTIVE_IND = 'I'
       WHERE BATCH_PROCESS_ID = data_param_row.BATCH_PROCESS_ID
         AND ERROR_ACTIVE_IND = 'A';

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
end FN_DMP_INACTIVATE_ERROR;
/