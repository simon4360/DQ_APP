create or replace PROCEDURE G77_CFG.PR_JAVA_DROP
IS
v_sql                   VARCHAR2(32000);

BEGIN
FOR row in 
    (select object_name 
       from all_objects
      where owner='G77_CFG'
        and OBJECT_TYPE = 'JAVA SOURCE') 

    LOOP
    BEGIN

          v_sql:='drop java source "'||row.object_name||'"';
          dbms_output.put_line(v_sql);
          EXECUTE IMMEDIATE v_sql;

    EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -24344 THEN
        dbms_output.put_line(SQLCODE);
      ELSIF SQLCODE = -29537 THEN
        dbms_output.put_line(SQLCODE);
      ELSIF SQLCODE = -04043 THEN
        dbms_output.put_line(SQLCODE);
      ELSE
         RAISE;
      END IF;
    END;  
   END LOOP;   
   
FOR row in 
    (select object_name 
       from all_objects
      where owner='G77_CFG'
        and OBJECT_TYPE = 'JAVA CLASS') 

    LOOP
    BEGIN
          v_sql:='drop java class "'||row.object_name||'"';
          dbms_output.put_line(v_sql);
          EXECUTE IMMEDIATE v_sql;

    EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -24344 THEN
        dbms_output.put_line(SQLCODE);
      ELSIF SQLCODE = -29537 THEN
        dbms_output.put_line(SQLCODE);
      ELSIF SQLCODE = -04043 THEN
        dbms_output.put_line(SQLCODE);
      ELSE
         RAISE;
      END IF;
    END;  
   END LOOP;   

    commit;

END;
/