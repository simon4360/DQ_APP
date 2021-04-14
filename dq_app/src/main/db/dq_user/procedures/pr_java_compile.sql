create or replace PROCEDURE DQ_USER.PR_JAVA_COMPILE
IS
v_sql                   VARCHAR2(32000);
     
BEGIN
FOR row in 
    (select object_name 
       from all_objects
      where owner='DQ_USER'
        and OBJECT_TYPE='JAVA CLASS'
        and status='INVALID') 

    LOOP
    BEGIN
          v_sql:='alter java class "'||row.object_name||'" resolve';
          dbms_output.put_line(v_sql);
          EXECUTE IMMEDIATE v_sql;

    EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -24344 THEN
        Null;
      ELSE
         RAISE;
      END IF;
    END;  
   END LOOP;

    commit;
    
END;
/