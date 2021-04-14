CREATE OR REPLACE TRIGGER G77_CFG.TR_T_META_INTERFACE_AUD
AFTER INSERT OR UPDATE OR DELETE
ON G77_CFG.T_META_INTERFACE REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
  CASE
    WHEN INSERTING THEN
      INSERT INTO G77_CFG.T_META_INTERFACE_AUD
            (
             INTERFACE_ID
            ,TECHNOLOGY
            ,APTITUDE_PROJECT
            ,APTITUDE_PROJECT_DESC
            ,COUNTERPARTY_SYSTEM
            ,COUNTERPARTY_ROLE
            ,STOP_PROJECT_FLAG
            ,RESET_EVENTS_FLAG
            ,IS_ACTIVE
            ,ACTION
            ,ACTION_TIMESTAMP
            )
      VALUES(
              :new.INTERFACE_ID
            , :new.TECHNOLOGY
            , :new.APTITUDE_PROJECT
            , :new.APTITUDE_PROJECT_DESC
            , :new.COUNTERPARTY_SYSTEM
            , :new.COUNTERPARTY_ROLE
            , :new.STOP_PROJECT_FLAG
            , :new.RESET_EVENTS_FLAG
            , :new.IS_ACTIVE
            , 'I'
            , sysdate
            );
     WHEN UPDATING THEN
      INSERT INTO G77_CFG.T_META_INTERFACE_AUD
            (
             INTERFACE_ID
            ,TECHNOLOGY
            ,APTITUDE_PROJECT
            ,APTITUDE_PROJECT_DESC
            ,COUNTERPARTY_SYSTEM
            ,COUNTERPARTY_ROLE
            ,STOP_PROJECT_FLAG
            ,RESET_EVENTS_FLAG
            ,IS_ACTIVE
            ,ACTION
            ,ACTION_TIMESTAMP
            )
      VALUES(
              :new.INTERFACE_ID
            , :new.TECHNOLOGY
            , :new.APTITUDE_PROJECT
            , :new.APTITUDE_PROJECT_DESC
            , :new.COUNTERPARTY_SYSTEM
            , :new.COUNTERPARTY_ROLE
            , :new.STOP_PROJECT_FLAG
            , :new.RESET_EVENTS_FLAG
            , :new.IS_ACTIVE
            , 'U'
            , sysdate
            );
     WHEN DELETING THEN
      INSERT INTO G77_CFG.T_META_INTERFACE_AUD
            (
             INTERFACE_ID
            ,TECHNOLOGY
            ,APTITUDE_PROJECT
            ,APTITUDE_PROJECT_DESC
            ,COUNTERPARTY_SYSTEM
            ,COUNTERPARTY_ROLE
            ,STOP_PROJECT_FLAG
            ,RESET_EVENTS_FLAG
            ,IS_ACTIVE
            ,ACTION
            ,ACTION_TIMESTAMP
            )
      VALUES(
              :old.INTERFACE_ID
            , :old.TECHNOLOGY
            , :old.APTITUDE_PROJECT
            , :old.APTITUDE_PROJECT_DESC
            , :old.COUNTERPARTY_SYSTEM
            , :old.COUNTERPARTY_ROLE
            , :old.STOP_PROJECT_FLAG
            , :old.RESET_EVENTS_FLAG
            , :old.IS_ACTIVE
            , 'D'
            , sysdate
            );
    END CASE;
END;
/