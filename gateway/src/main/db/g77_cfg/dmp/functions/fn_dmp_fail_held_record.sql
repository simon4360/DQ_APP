create or replace FUNCTION G77_CFG.FN_DMP_FAIL_HELD_RECORD (json_data in clob)
  RETURN       NUMBER
IS
  exec_stat               NUMBER(2, 0);
  v_rule_name             VARCHAR2(30) := 'fn_dmp_fail_held_record';
  v_msg                   T_ERROR_LOG.ERROR_TEXT%TYPE;
  v_failed_event_status   NUMBER(1)    := 5;
  v_hold_event_status     NUMBER(1)    := 9;
BEGIN
  FOR data_param_row IN (SELECT *
                           FROM json_table(json_data,
                                           '$.data[*]'
                                           COLUMNS("USE_CASE_ID"     PATH '$.param1',
                                                   "SESSION_ID"      PATH '$.param2',
                                                   "ERROR_EVENT_ID"  PATH '$.param3',
                                                   "SEVERITY_ID"     PATH '$.param4',
                                                   "ROW_IN_ERROR_ID" PATH '$.param5',
                                                   "ORACLE_TABLE"    PATH '$.param6'
                                                    )))
  LOOP


    -- If held events get cleared, set the event status from 9 to 5
    IF data_param_row.SEVERITY_ID IN (2,5)
    THEN
     EXECUTE IMMEDIATE '
      UPDATE ' || data_param_row.ORACLE_TABLE || ' SET
        EVENT_STATUS = ' || v_failed_event_status || '
       WHERE GATEWAY_ID   = ' || data_param_row.ROW_IN_ERROR_ID || '   AND
             EVENT_STATUS = ' || v_hold_event_status || '              AND
             lower(USE_CASE_ID)  = lower(''' || data_param_row.USE_CASE_ID || ''')   AND
             SESSION_ID   = ''' || data_param_row.SESSION_ID  || '''';

      UPDATE T_ERROR_LOG SET
       ERROR_ACTIVE_IND = 'I'
      WHERE lower(USE_CASE_ID)      = lower(data_param_row.USE_CASE_ID)    AND
            SESSION_ID       = data_param_row.SESSION_ID     AND
            EVENT_ID         = data_param_row.ERROR_EVENT_ID AND
            ERROR_ACTIVE_IND = 'A';

    END IF;

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
end FN_DMP_FAIL_HELD_RECORD;
/