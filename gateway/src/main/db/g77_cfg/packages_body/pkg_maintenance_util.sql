CREATE OR REPLACE PACKAGE BODY g77_cfg.pkg_maintenance_util AS

  gc_bl_msg_error   VARCHAR2(10) := 'ERROR';
  gc_bl_msg_info    VARCHAR2(10) := 'INFO';
  gc_bl_msg_warning VARCHAR2(10) := 'WARNING';

  FUNCTION gen_log_call_id RETURN VARCHAR2 IS
  BEGIN
    RETURN to_char(systimestamp, 'YYYY.MM.DD.HH.MM.SSFF3');
  END;
    
  
  function create_audit_trigger_dml (
            p_driving_table VARCHAR2
          , p_audit_table VARCHAR2) RETURN CLOB 
  is
    audit_column_list_all clob;
    audit_column_list_new clob;
    audit_column_list_old clob;
    trigger_name varchar2(30);
    
    trigger_dml clob := 
  q'[
create or replace trigger g77_cfg.REGEX_TRIGGERNAME
after insert or update or delete
on g77_cfg.REGEX_DRIVINGTABLE referencing old as old new as new
for each row
begin
  case
    when inserting then
      insert into g77_cfg.REGEX_AUDITTABLE (REGEX_COLUMLIST, ACTION, ACTION_TIMESTAMP
      ) values (REGEX_AUDITEDCOLUMNSNEW
      , 'I' 
      , sysdate 
      );
     when updating then
      insert into g77_cfg.REGEX_AUDITTABLE (REGEX_COLUMLIST, ACTION, ACTION_TIMESTAMP
      ) values (REGEX_AUDITEDCOLUMNSNEW 
      , 'U' 
      , sysdate 
      );
     when deleting then
      insert into g77_cfg.REGEX_AUDITTABLE (REGEX_COLUMLIST, ACTION, ACTION_TIMESTAMP
      ) values (REGEX_AUDITEDCOLUMNSOLD 
      , 'D' 
      , sysdate 
      );
    end case;
end;
]';

  begin
  
  select 'TR_'||substr (p_driving_table, 1, 23) || '_AUD' into trigger_name from dual; 
  
  select listagg(CHR(10)||'        '||column_name, ', ') within group (order by column_name) 
    into audit_column_list_all
    from user_tab_columns aud
   where identity_column = 'NO' 
     and column_name not in ('ACTION_TIMESTAMP', 'ACTION', 'GATEWAY_IDA')
     and table_name = p_audit_table
     and exists (select null from user_tab_columns driving where driving.table_name = aud.table_name and driving.column_name = aud.column_name)
   group by table_name;  
   
  select listagg(CHR(10)||'        '||':new.'||column_name, ', ') within group (order by column_name) 
    into audit_column_list_new
    from user_tab_columns aud
   where identity_column = 'NO' 
     and column_name not in ('ACTION_TIMESTAMP', 'ACTION', 'GATEWAY_IDA')
     and table_name = p_audit_table
     and exists (select null from user_tab_columns driving where driving.table_name = aud.table_name and driving.column_name = aud.column_name)
   group by table_name; 
   
  select listagg(CHR(10)||'        '||':old.'||column_name, ', ') within group (order by column_name) 
    into audit_column_list_old
    from user_tab_columns aud
   where identity_column = 'NO' 
     and column_name not in ('ACTION_TIMESTAMP', 'ACTION', 'GATEWAY_IDA')
     and table_name = p_audit_table
     and exists (select null from user_tab_columns driving where driving.table_name = aud.table_name and driving.column_name = aud.column_name)
   group by table_name;  
  
  
  return regexp_replace (regexp_replace (regexp_replace (regexp_replace (regexp_replace ( regexp_replace ( trigger_dml
                        , 'REGEX_TRIGGERNAME', trigger_name)
                        , 'REGEX_DRIVINGTABLE', p_driving_table)
                        , 'REGEX_AUDITTABLE', p_audit_table)
                        , 'REGEX_COLUMLIST', audit_column_list_all)
                        , 'REGEX_AUDITEDCOLUMNSNEW', audit_column_list_new)
                        , 'REGEX_AUDITEDCOLUMNSOLD', audit_column_list_old);
    
  end;

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
                        p_tag4      VARCHAR2 := NULL) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    --insert is done dynamicaly to avoid compilation issues during initial installation ( t_build_log would be missing until upgrade step)
    --in next releases can be replaced to static call
    EXECUTE IMMEDIATE 'INSERT INTO t_build_log
      (bl_group,
       bl_msg_type,
       bl_proc_name,
       bl_message,
       bl_backtrace,
       bl_callstack,
       bl_tagname,
       bl_tag,
       bl_tag1name,
       bl_tag1,
       bl_tag2name,
       bl_tag2,
       bl_tag3name,
       bl_tag3,
       bl_tag4name,
       bl_tag4)
    VALUES
      (:1,
       :2,
       :3,
       :4,
       :5,
       :6,
       :7,
       :8,
       :9,
       :10,
       :11,
       :12,
       :13,
       :14,
       :15,
       :16)'
      USING substr(p_group, 1, 255), substr(p_msg_type, 1, 255), substr(p_proc_name, 1, 255), substr(p_message, 1, 4000), substr(p_backtrace, 1, 4000), substr(p_callstack, 1, 4000), substr(p_tagname, 1, 4000), substr(p_tag, 1, 4000), substr(p_tag1name, 1, 4000), substr(p_tag1, 1, 4000), substr(p_tag2name, 1, 4000), substr(p_tag2, 1, 4000), substr(p_tag3name, 1, 4000), substr(p_tag3, 1, 4000), substr(p_tag4name, 1, 4000), substr(p_tag4, 1, 4000);

    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- Ignoring exceptions only for in case issues with tracelog, as it is not main fuctionality
  END;

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
                      p_tag4      VARCHAR2 := NULL) IS
  BEGIN
    log_message(p_msg_type  => gc_bl_msg_error,
                p_proc_name => p_proc_name,
                p_message   => p_message,
                p_backtrace => p_backtrace,
                p_callstack => substr(dbms_utility.format_call_stack,
                                      1,
                                      4000),
                p_group     => p_group,
                p_tagname   => p_tagname,
                p_tag       => p_tag,
                p_tag1name  => p_tag1name,
                p_tag1      => p_tag1,
                p_tag2name  => p_tag2name,
                p_tag2      => p_tag2,
                p_tag3name  => p_tag3name,
                p_tag3      => p_tag3,
                p_tag4name  => p_tag4name,
                p_tag4      => p_tag4);
  END;

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
                     p_tag4      VARCHAR2 := NULL) IS
  BEGIN
    log_message(p_msg_type  => gc_bl_msg_info,
                p_proc_name => p_proc_name,
                p_message   => p_message,
                p_backtrace => NULL,
                p_group     => p_group,
                p_tagname   => p_tagname,
                p_tag       => p_tag,
                p_tag1name  => p_tag1name,
                p_tag1      => p_tag1,
                p_tag2name  => p_tag2name,
                p_tag2      => p_tag2,
                p_tag3name  => p_tag3name,
                p_tag3      => p_tag3,
                p_tag4name  => p_tag4name,
                p_tag4      => p_tag4);
  END;

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
                        p_tag4      VARCHAR2 := NULL) IS
  BEGIN
    log_message(p_msg_type  => gc_bl_msg_warning,
                p_proc_name => p_proc_name,
                p_message   => p_message,
                p_backtrace => NULL,
                p_group     => p_group,
                p_tagname   => p_tagname,
                p_tag       => p_tag,
                p_tag1name  => p_tag1name,
                p_tag1      => p_tag1,
                p_tag2name  => p_tag2name,
                p_tag2      => p_tag2,
                p_tag3name  => p_tag3name,
                p_tag3      => p_tag3,
                p_tag4name  => p_tag4name,
                p_tag4      => p_tag4);
  END;

  PROCEDURE p_add_column_if_not_exists(p_table_name  VARCHAR2,
                                       p_column_name VARCHAR2,
                                       p_column_type VARCHAR2) AS
    v_table_count  NUMBER;
    v_column_count NUMBER;
    lv_proc_name   VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id     VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'table_name',
             p_tag       => p_table_name,
             p_tag1name  => 'column_name',
             p_tag1      => p_column_name,
             p_tag2name  => 'column_type',
             p_tag2      => p_column_type);

    SELECT COUNT(1)
      INTO v_column_count
      FROM user_tab_cols
     WHERE column_name = upper(p_column_name)
       AND table_name = upper(p_table_name);

    SELECT COUNT(1)
      INTO v_table_count
      FROM user_tables
     WHERE table_name = upper(p_table_name);

    IF (v_column_count = 0 AND v_table_count = 1) THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' ADD ' ||
                        p_column_name || ' ' || p_column_type;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'table_name',
               p_tag       => p_table_name,
               p_tag1name  => 'column_name',
               p_tag1      => p_column_name,
               p_tag2name  => 'column_type',
               p_tag2      => p_column_type);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_column_count',
               p_tag       => v_column_count,
               p_tag1name  => 'v_table_count',
               p_tag1      => v_table_count);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_add_column_if_not_exists;

  PROCEDURE p_alter_column(p_table_name  VARCHAR2,
                           p_column_name VARCHAR2,
                           p_new_column_type VARCHAR2) AS
    v_sql clob;
    v_column_exists  NUMBER;
    lv_proc_name   VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id     VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'table_name',
             p_tag       => p_table_name,
             p_tag1name  => 'column_name',
             p_tag1      => p_column_name,
             p_tag2name  => 'new_column_type',
             p_tag2      => p_new_column_type);

    v_column_exists := f_is_column_in_table_exists(p_table_name,p_column_name);
    
    IF (v_column_exists > 0 ) THEN
      v_sql := 'ALTER TABLE ' || p_table_name || ' MODIFY (' || p_column_name || ' ' || p_new_column_type || ')';
      EXECUTE IMMEDIATE v_sql;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'table_name',
               p_tag       => p_table_name,
               p_tag1name  => 'column_name',
               p_tag1      => p_column_name,
               p_tag2name  => 'new_column_type',
               p_tag2      => p_new_column_type,
               p_tag3name  => 'SQL',
               p_tag3      => v_sql);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_column_exists',
               p_tag       => v_column_exists);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_alter_column;

  
  
  PROCEDURE p_drop_table_column_if_exists(p_table_name  VARCHAR2,
                                          p_column_name VARCHAR2) AS
    v_table_count  NUMBER;
    v_column_count NUMBER;
    lv_proc_name   VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id     VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'table_name',
             p_tag       => p_table_name,
             p_tag1name  => 'column_name',
             p_tag1      => p_column_name);

    SELECT COUNT(1)
      INTO v_column_count
      FROM user_tab_cols
     WHERE column_name = upper(p_column_name)
       AND table_name = upper(p_table_name);

    SELECT COUNT(1)
      INTO v_table_count
      FROM user_tables
     WHERE table_name = upper(p_table_name);

    IF (v_column_count = 1 AND v_table_count = 1) THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' DROP COLUMN ' ||
                        p_column_name;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'table_name',
               p_tag       => p_table_name,
               p_tag1name  => 'column_name',
               p_tag1      => p_column_name);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_column_count',
               p_tag       => v_column_count,
               p_tag1name  => 'v_table_count',
               p_tag1      => v_table_count);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_drop_table_column_if_exists;

  FUNCTION f_is_table_exists(p_table_name VARCHAR2) return number IS
  /* check whether table p_table_name exists and it is table not materialized view */
    v_tmp number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  begin
    select 1 into v_tmp from dual
      where exists (
        select 1 from user_tables ut left outer join user_mviews umv on ut.table_name=umv.mview_name
        where ut.table_name = p_table_name
        and umv.mview_name is null
      );
    return 1;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
      return 0;
  WHEN OTHERS THEN
    log_error(p_proc_name => lv_proc_name,
              p_message   => SQLERRM,
              p_group     => lv_call_id,
              p_backtrace => dbms_utility.format_error_backtrace);
    ROLLBACK;
    RAISE;
  END f_is_table_exists;
  
FUNCTION f_is_view_exists(p_view_name VARCHAR2) return number IS
  /* check whether table p_view_name exists and it is table not materialized view */
    v_tmp number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  begin
    select 1 into v_tmp from dual
      where exists (
        select 1 from user_views ut left outer join user_mviews umv on ut.view_name=umv.mview_name
        where ut.view_name = p_view_name
        and umv.mview_name is null
      );
    return 1;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
      return 0;
  WHEN OTHERS THEN
    log_error(p_proc_name => lv_proc_name,
              p_message   => SQLERRM,
              p_group     => lv_call_id,
              p_backtrace => dbms_utility.format_error_backtrace);
    ROLLBACK;
    RAISE;
  END f_is_view_exists;

  FUNCTION f_is_column_in_table_exists(p_table_name VARCHAR2,
                                       p_column_name VARCHAR2) return number IS
  /* check whether column p_column_name exists in table p_table_name */
    v_table_exists number;
    v_tmp number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  begin
    v_table_exists := f_is_table_exists(p_table_name);
    if (v_table_exists=0)
    then
      /* table doesn't exists then column doesn't exists as well */
      return 0;
    end if;
  
    select 1 into v_tmp from dual
      where exists (
        select 1 from user_tab_cols
        where column_name = upper(p_column_name)
        and table_name = upper(p_table_name)
      );
    return 1;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
      return 0;
  WHEN OTHERS THEN
    log_error(p_proc_name => lv_proc_name,
              p_message   => SQLERRM,
              p_group     => lv_call_id,
              p_backtrace => dbms_utility.format_error_backtrace);
    ROLLBACK;
    RAISE;
  END f_is_column_in_table_exists;
  
  
  
  PROCEDURE p_drop_table_if_exists(p_table_name VARCHAR2) AS
    v_table_exists number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'table_name',
             p_tag       => p_table_name);
    v_table_exists := f_is_table_exists(p_table_name);
    IF (v_table_exists > 0) THEN
      EXECUTE IMMEDIATE 'DROP TABLE ' || p_table_name;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'table_name',
               p_tag       => p_table_name);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_table_exists',
               p_tag       => v_table_exists);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_drop_table_if_exists;
  
  PROCEDURE p_drop_view_if_exists(p_view_name VARCHAR2) AS
    v_view_exists number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'view_name',
             p_tag       => p_view_name);
    v_view_exists := f_is_view_exists(p_view_name);
    IF (v_view_exists > 0) THEN
      EXECUTE IMMEDIATE 'DROP VIEW ' || p_view_name;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'view_name',
               p_tag       => p_view_name);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_view_exists',
               p_tag       => v_view_exists);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_drop_view_if_exists;
  
  PROCEDURE p_rename_table_column(p_table_name  VARCHAR2,
                                  p_column_from VARCHAR2,
                                  p_column_to   VARCHAR2) AS
    v_table_count  NUMBER;
    v_column_count NUMBER;
    lv_proc_name   VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id     VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'table_name',
             p_tag       => p_table_name,
             p_tag1name  => 'column_from',
             p_tag1      => p_column_from,
             p_tag2name  => 'column_to',
             p_tag2      => p_column_to);

    SELECT COUNT(1)
      INTO v_column_count
      FROM user_tab_cols
     WHERE column_name = upper(p_column_from)
       AND table_name = upper(p_table_name);

    SELECT COUNT(1)
      INTO v_table_count
      FROM user_tables
     WHERE table_name = upper(p_table_name);

    IF (v_column_count = 1 AND v_table_count = 1) THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' RENAME COLUMN ' ||
                        p_column_from || ' TO ' || p_column_to;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'table_name',
               p_tag       => p_table_name,
               p_tag1name  => 'column_from',
               p_tag1      => p_column_from,
               p_tag2name  => 'column_to',
               p_tag2      => p_column_to);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_column_count',
               p_tag       => v_column_count,
               p_tag1name  => 'v_table_count',
               p_tag1      => v_table_count);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_rename_table_column;

  PROCEDURE p_set_unused_column_if_exists(p_table_name  VARCHAR2,
                                          p_column_name VARCHAR2) AS
    v_table_count NUMBER;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'table_name',
             p_tag       => p_table_name,
             p_tag1name  => 'column_name',
             p_tag1      => p_column_name);

    SELECT COUNT(1)
      INTO v_table_count
      FROM user_tab_cols
     WHERE column_name = upper(p_column_name)
       AND table_name = upper(p_table_name);

    IF (v_table_count = 1) THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' SET UNUSED (' ||
                        p_column_name || ')';
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'table_name',
               p_tag       => p_table_name,
               p_tag1name  => 'column_name',
               p_tag1      => p_column_name);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_table_count',
               p_tag       => v_table_count);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_set_unused_column_if_exists;

  FUNCTION f_is_sequence_exists(p_sequence_name VARCHAR2) return number IS
  /* check whether sequence p_sequence_name exists */
    v_tmp number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  begin
    select 1 into v_tmp from dual
      where exists (
        select 1 from user_sequences us
        where us.sequence_name = p_sequence_name
      );
    return 1;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
      return 0;
  WHEN OTHERS THEN
    log_error(p_proc_name => lv_proc_name,
              p_message   => SQLERRM,
              p_group     => lv_call_id,
              p_backtrace => dbms_utility.format_error_backtrace);
    ROLLBACK;
    RAISE;
  END f_is_sequence_exists;

  PROCEDURE p_drop_sequence_if_exists(p_sequence_name VARCHAR2) AS
    v_sequence_exists number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'sequence_name',
             p_tag       => p_sequence_name);
    v_sequence_exists := f_is_sequence_exists(p_sequence_name);
    IF (v_sequence_exists > 0) THEN
      EXECUTE IMMEDIATE 'DROP SEQUENCE ' || p_sequence_name;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'sequence_name',
               p_tag       => p_sequence_name);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_sequence_exists',
               p_tag       => v_sequence_exists);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_drop_sequence_if_exists;
  
  
    FUNCTION f_is_cnstraint_in_table_exists(p_table_name VARCHAR2,
                                            p_constraint_name VARCHAR2) return number IS
  /* check whether column p_constraint_name exists in table p_table_name */
    v_table_exists number;
    v_tmp number;
    lv_proc_name  VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id    VARCHAR2(255) := gen_log_call_id;
  begin
    v_table_exists := f_is_table_exists(p_table_name);
    if (v_table_exists=0)
    then
      return 0;
    end if;
  
    select 1 into v_tmp from dual
      where exists (
        select 1 from user_constraints
        where constraint_name = upper(p_constraint_name)
        and   table_name      = upper(p_table_name)
      );
    return 1;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
      return 0;
  WHEN OTHERS THEN
    log_error(p_proc_name => lv_proc_name,
              p_message   => SQLERRM,
              p_group     => lv_call_id,
              p_backtrace => dbms_utility.format_error_backtrace);
    ROLLBACK;
    RAISE;
  END f_is_cnstraint_in_table_exists;
  
  
  PROCEDURE p_drop_constraint_if_exists(p_table_name  VARCHAR2,
                                          p_constraint_name VARCHAR2) AS
    v_constraint_exists NUMBER;
    lv_proc_name   VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id     VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'table_name',
             p_tag       => p_table_name,
             p_tag1name  => 'constraint_name',
             p_tag1      => p_constraint_name);

    v_constraint_exists := f_is_cnstraint_in_table_exists(p_table_name , p_constraint_name);

    IF ( v_constraint_exists = 1 ) THEN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' DROP CONSTRAINT ' ||
                        p_constraint_name;
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Executed',
               p_group     => lv_call_id,
               p_tagname   => 'table_name',
               p_tag       => p_table_name,
               p_tag1name  => 'constraint_name',
               p_tag1      => p_constraint_name);
    ELSE
      log_info(p_proc_name => lv_proc_name,
               p_message   => 'Skipped',
               p_group     => lv_call_id,
               p_tagname   => 'v_constraint_exists',
               p_tag       => v_constraint_exists,
               p_tag1name  => 'v_table_exists',
               p_tag1      => p_table_name);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_drop_constraint_if_exists;
  

  PROCEDURE p_register_g77_db_install(p_version_to  VARCHAR2,
                                      p_script_path VARCHAR2) AS
    lv_branch VARCHAR2(100);

    lv_proc_name VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id   VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'version_to',
             p_tag       => p_version_to,
             p_tag1name  => 'script_path',
             p_tag1      => p_script_path);
    lv_branch := regexp_replace(regexp_replace(regexp_replace(p_version_to,
                                                              '^G77-',
                                                              ''),
                                               '-[[:digit:]]*$',
                                               ''),
                                '_',
                                '/');

    MERGE INTO g77_cfg.t_build_history tgt
    USING (SELECT p_version_to build,
                  lv_branch branch,
                  'https://git.swissre.com/projects/G77/repos/g77/browse/' ||
                  p_script_path || '.sql?at=refs%2Fheads%2F' ||
                  regexp_replace(lv_branch, '/', '%2F') script
             FROM dual) src
    ON (src.build = tgt.build AND src.branch = tgt.branch AND src.script = tgt.script)
    WHEN MATCHED THEN
      UPDATE SET tgt.release_date = SYSDATE
    WHEN NOT MATCHED THEN
      INSERT
        (build, branch, script, release_date)
      VALUES
        (src.build, src.branch, src.script, SYSDATE);

  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_register_g77_db_install;

  PROCEDURE p_register_g77_version(p_version_to VARCHAR2) AS
    lv_proc_name VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id   VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'version_to',
             p_tag       => p_version_to);
    MERGE INTO g77_cfg.t_build_version
    USING dual
    ON (1 = 1)
    WHEN MATCHED THEN
      UPDATE SET current_build = p_version_to, build_date = SYSDATE
    WHEN NOT MATCHED THEN
      INSERT (current_build, build_date) VALUES (p_version_to, SYSDATE);

  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_register_g77_version;

  PROCEDURE p_check_g77_version(p_version_from VARCHAR2,
                                p_version_to   VARCHAR2) AS
    lv_proc_name     VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    versionfromfound INT;
    lv_call_id       VARCHAR2(255) := gen_log_call_id;
  BEGIN
    log_info(p_proc_name => lv_proc_name,
             p_message   => 'Started',
             p_group     => lv_call_id,
             p_tagname   => 'version_from',
             p_tag       => p_version_from,
             p_tag1name  => 'version_to',
             p_tag1      => p_version_to);
    SELECT COUNT(*)
      INTO versionfromfound
      FROM g77_cfg.t_build_version
     WHERE current_build LIKE p_version_from;
    IF (versionfromfound = 0) THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => 'System not at version ' || p_version_from ||
                               '. Cannot upgrade database to ' ||
                               p_version_to ||
                               '. Verify [RepositoryRoot].version_properties File',
                p_group     => lv_call_id);
      raise_application_error(-20000,
                              'System not at version ' || p_version_from ||
                              '. Cannot upgrade database to ' ||
                              p_version_to ||
                              '. Verify [RepositoryRoot].version_properties File');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;
  END p_check_g77_version;
  
PROCEDURE pr_stats (  p_table_name         IN VARCHAR2,
                      p_gather_after_x_min IN NUMBER
                    )
AS
    lv_proc_name   VARCHAR2(100) := utl_call_stack.subprogram(1)(2);
    lv_call_id     VARCHAR2(255) := gen_log_call_id;
    
    minutes_since_gather number;

BEGIN
  BEGIN
        WITH src AS (
        SELECT table_name,
               stats_update_time,
               stats_update_time - TO_TIMESTAMP(TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS') AS diff,
               ROW_NUMBER() OVER (PARTITION BY table_name ORDER BY stats_update_time DESC) rn
        FROM user_tab_stats_history
        WHERE 1=1
        AND table_name = p_table_name
        ORDER BY 1 ASC,2 DESC
        )
        SELECT
           ABS(24*EXTRACT(DAY FROM diff)+EXTRACT(HOUR FROM diff))*60 + ABS(24*EXTRACT(DAY FROM diff)+EXTRACT(MINUTE FROM diff)) min
           INTO minutes_since_gather
        FROM src
        WHERE rn=1
        ;

  EXCEPTION
  WHEN NO_DATA_FOUND
  THEN
    minutes_since_gather := p_gather_after_x_min + 1;
  END;

IF minutes_since_gather > p_gather_after_x_min THEN

   log_info(p_proc_name => lv_proc_name,
            p_message   => 'Started',
            p_group     => lv_call_id,
            p_tagname   => 'table_name',
            p_tag       => p_table_name,
            p_tag1name  => 'minutes since last gathered',
            p_tag1      => to_char ( minutes_since_gather )
            );

   DBMS_STATS.GATHER_TABLE_STATS (
            OwnName            => 'G77_CFG',
            TabName            => p_table_name,
            CASCADE            => DBMS_STATS.AUTO_CASCADE,
            DEGREE             => NULL,
            ESTIMATE_PERCENT   => DBMS_STATS.AUTO_SAMPLE_SIZE,
            METHOD_OPT         => 'FOR ALL COLUMNS SIZE AUTO',
            NO_INVALIDATE      => DBMS_STATS.AUTO_INVALIDATE,
            GRANULARITY        => 'ALL');

   log_info(p_proc_name => lv_proc_name,
            p_message   => 'Completed',
            p_group     => lv_call_id,
            p_tagname   => 'table_name',
            p_tag       => p_table_name
            );

END IF;
  EXCEPTION
    WHEN OTHERS THEN
      log_error(p_proc_name => lv_proc_name,
                p_message   => SQLERRM,
                p_group     => lv_call_id,
                p_backtrace => dbms_utility.format_error_backtrace);
      ROLLBACK;
      RAISE;

END pr_stats;

  
END pkg_maintenance_util;
/
