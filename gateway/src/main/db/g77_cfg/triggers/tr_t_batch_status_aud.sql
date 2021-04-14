CREATE OR REPLACE TRIGGER G77_CFG.TR_T_BATCH_STATUS_aud
AFTER INSERT OR UPDATE OR DELETE 
ON G77_CFG.T_BATCH_TASK_STATUS
REFERENCING OLD AS OLD NEW AS NEW
for each row
begin
  case
    when inserting then
      insert into g77_cfg.T_BATCH_TASK_STATUS_AUD
      (
                  BATCH_TASK_PROCESS_ID
                , BATCH_TASK_UC4_RUN_ID
                , BATCH_TASK_APTITUDE_PROJECT
                , BATCH_TASK_APTITUDE_MICROFLOW
                , BATCH_TASK_SESSION_ID
                , BATCH_TASK_USE_CASE_ID
                , BATCH_TASK_STATUS
                , BATCH_TASK_COMPLETED
                , BATCH_TASK_RECORDS_PROCESSED
                , BATCH_TASK_RECORDS_SUCCESSFUL
                , BATCH_TASK_RECORDS_IN_ERROR
                , BATCH_TASK_START_TIMESTAMP
                , BATCH_TASK_END_TIMESTAMP
                , DMP_ERROR_ACTIVE_INDICATOR
                , ACTION
                , ACTION_TIMESTAMP
      )
      values(
                  :new.BATCH_TASK_PROCESS_ID
                , :new.BATCH_TASK_UC4_RUN_ID
                , :new.BATCH_TASK_APTITUDE_PROJECT
                , :new.BATCH_TASK_APTITUDE_MICROFLOW
                , :new.BATCH_TASK_SESSION_ID
                , :new.BATCH_TASK_USE_CASE_ID
                , :new.BATCH_TASK_STATUS
                , :new.BATCH_TASK_COMPLETED
                , :new.BATCH_TASK_RECORDS_PROCESSED
                , :new.BATCH_TASK_RECORDS_SUCCESSFUL
                , :new.BATCH_TASK_RECORDS_IN_ERROR
                , :new.BATCH_TASK_START_TIMESTAMP
                , :new.BATCH_TASK_END_TIMESTAMP
                , :new.DMP_ERROR_ACTIVE_INDICATOR
                , 'I'
                , SYSDATE
            );
     when updating then
      insert into g77_cfg.T_BATCH_TASK_STATUS_AUD
      (
                  BATCH_TASK_PROCESS_ID
                , BATCH_TASK_UC4_RUN_ID
                , BATCH_TASK_APTITUDE_PROJECT
                , BATCH_TASK_APTITUDE_MICROFLOW
                , BATCH_TASK_SESSION_ID
                , BATCH_TASK_USE_CASE_ID
                , BATCH_TASK_STATUS
                , BATCH_TASK_COMPLETED
                , BATCH_TASK_RECORDS_PROCESSED
                , BATCH_TASK_RECORDS_SUCCESSFUL
                , BATCH_TASK_RECORDS_IN_ERROR
                , BATCH_TASK_START_TIMESTAMP
                , BATCH_TASK_END_TIMESTAMP
                , DMP_ERROR_ACTIVE_INDICATOR
                , ACTION
                , ACTION_TIMESTAMP
      )
      values(
                  :new.BATCH_TASK_PROCESS_ID
                , :new.BATCH_TASK_UC4_RUN_ID
                , :new.BATCH_TASK_APTITUDE_PROJECT
                , :new.BATCH_TASK_APTITUDE_MICROFLOW
                , :new.BATCH_TASK_SESSION_ID
                , :new.BATCH_TASK_USE_CASE_ID
                , :new.BATCH_TASK_STATUS
                , :new.BATCH_TASK_COMPLETED
                , :new.BATCH_TASK_RECORDS_PROCESSED
                , :new.BATCH_TASK_RECORDS_SUCCESSFUL
                , :new.BATCH_TASK_RECORDS_IN_ERROR
                , :new.BATCH_TASK_START_TIMESTAMP
                , :new.BATCH_TASK_END_TIMESTAMP
                , :new.DMP_ERROR_ACTIVE_INDICATOR
                , 'U'
                , SYSDATE
            );
     when deleting then
      insert into g77_cfg.T_BATCH_TASK_STATUS_AUD
      (
                  BATCH_TASK_PROCESS_ID
                , BATCH_TASK_UC4_RUN_ID
                , BATCH_TASK_APTITUDE_PROJECT
                , BATCH_TASK_APTITUDE_MICROFLOW
                , BATCH_TASK_SESSION_ID
                , BATCH_TASK_USE_CASE_ID
                , BATCH_TASK_STATUS
                , BATCH_TASK_COMPLETED
                , BATCH_TASK_RECORDS_PROCESSED
                , BATCH_TASK_RECORDS_SUCCESSFUL
                , BATCH_TASK_RECORDS_IN_ERROR
                , BATCH_TASK_START_TIMESTAMP
                , BATCH_TASK_END_TIMESTAMP
                , DMP_ERROR_ACTIVE_INDICATOR
                , ACTION
                , ACTION_TIMESTAMP
      )
      values(
                  :old.BATCH_TASK_PROCESS_ID
                , :old.BATCH_TASK_UC4_RUN_ID
                , :old.BATCH_TASK_APTITUDE_PROJECT
                , :old.BATCH_TASK_APTITUDE_MICROFLOW
                , :old.BATCH_TASK_SESSION_ID
                , :old.BATCH_TASK_USE_CASE_ID
                , :old.BATCH_TASK_STATUS
                , :old.BATCH_TASK_COMPLETED
                , :old.BATCH_TASK_RECORDS_PROCESSED
                , :old.BATCH_TASK_RECORDS_SUCCESSFUL
                , :old.BATCH_TASK_RECORDS_IN_ERROR
                , :old.BATCH_TASK_START_TIMESTAMP
                , :old.BATCH_TASK_END_TIMESTAMP
                , :old.DMP_ERROR_ACTIVE_INDICATOR
                , 'D'
                , SYSDATE
            );
    end case;
end;
/
