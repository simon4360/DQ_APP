create or replace PROCEDURE DQ_USER.PR_CREATE_VIEWS
(o_return_code OUT NUMBER)
AUTHID current_user
AS
  v_proc_name VARCHAR2(30) := 'PR_CREATE_VIEWS';
  v_msg       VARCHAR2(32000);

cursor c1 is
     SELECT MIDDLE_TABLE_NAME
          , SQL               as stmnt
       FROM V_META_MIDDLE_VIEWS;

cursor c2 is
     SELECT 'V_G71_COUNTS' as view_name
          , stmt           as stmnt
       FROM V_META_G71_COUNTS;
BEGIN

BEGIN
   dbms_output.put_line(v_proc_name ||' Started at '|| sysdate);

      FOR row in c1
      LOOP
         v_msg := row.middle_table_name;

         EXECUTE IMMEDIATE row.stmnt;

      END LOOP;
EXCEPTION
when others then
    rollback;
    PR_ERROR(P_APTITUDE_PROJECT => v_proc_name
            ,P_RULE_IDENT       => v_proc_name
            ,P_TEXT             => 'There has been an error while creating the view over '||v_msg
            ,P_SOURCE_SYSTEM    => 'G77'
            ,P_ROW              => v_msg
            );
    PR_INFO(P_APTITUDE_PROJECT => v_proc_name
           ,P_RULE_IDENT       => v_proc_name
           ,P_TEXT             => 'There has been an error while creating the view over '||v_msg
           ,P_SOURCE_SYSTEM    => 'G77'
           );
    raise;
    o_return_code := 1;
END;

BEGIN
      FOR row in c2
      LOOP
         v_msg := row.view_name;

         EXECUTE IMMEDIATE row.stmnt;

      END LOOP;

   dbms_output.put_line(v_proc_name || ' Ended at '|| sysdate);
   o_return_code := 0;
   commit;

EXCEPTION
when others then
    rollback;
    PR_ERROR(P_APTITUDE_PROJECT => v_proc_name
            ,P_RULE_IDENT       => v_proc_name
            ,P_TEXT             => 'There has been an error while creating the view over '||v_msg
            ,P_SOURCE_SYSTEM    => 'G77'
            ,P_ROW              => v_msg
            );
    PR_INFO(P_APTITUDE_PROJECT => v_proc_name
           ,P_RULE_IDENT       => v_proc_name
           ,P_TEXT             => 'There has been an error while creating the view over '||v_msg
           ,P_SOURCE_SYSTEM    => 'G77'
           );
    raise;
    o_return_code := 1;
END;

END;
/
