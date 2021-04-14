CREATE OR REPLACE PACKAGE BODY G77_CFG.pkg_partition IS

    c_log_message_type_error CONSTANT VARCHAR2(200) := 'error';
    c_log_message_type_info CONSTANT VARCHAR2(200) := 'info';

    c_first_range_partition_date CONSTANT DATE := to_date('2016-01-01','YYYY-MM-DD'); -- first partition for RANGE type, to partition data which are already in te system
    c_first_list_partition_num constant NUMBER := 1000;
    
    c_default_repartition_method constant varchar2(100) := 'RENAME'; --(valid values RENAME or REDEFINE_OR_DROP_CREATE_INSERT)

    c_tmp_name_prefix constant varchar2(100) := 'MIGR_PART_TMP_NAME_';

    c_schema_name constant varchar2(30) := 'G77_CFG';
    c_execute_immediate constant number := 1; -- default value for gv_enable_execute_immediate; enable (1) or disable (0) execute immediate
    c_execute_by_user constant varchar2(30) := 'G77_CFG'; -- entry procedure have to be executed by that user. If there is another user then raise exception

    gv_partition_group_log_id number;
    gv_release_version t_partition_cfg.release_version%type := null;
    gv_enable_execute_immediate number;
    
  ----------------------------------------------------------------------
  -- common utils routines  
  -- tools procedures and functions that do not have task specific and can be reusable
  -- candidate to common library
  ----------------------------------------------------------------------
  FUNCTION check_table_exists(p_schema_name varchar2, p_table_name VARCHAR2) RETURN BOOLEAN IS
    v_tmp PLS_INTEGER;
  BEGIN
    if (p_schema_name is null)
    then
      raise_application_error(-20011,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20012,'missing p_table_name');
    end if;
    select 1 into v_tmp from dual
      where exists (
        select 1 from all_tables left outer join all_mviews on all_tables.owner=all_mviews.owner and all_tables.table_name=all_mviews.mview_name
        where all_tables.table_name = p_table_name  
        and all_tables.owner = p_schema_name
        and all_mviews.mview_name is null
      );
    return true;
  exception
    when no_data_found then
    return false;
  END;
  
  FUNCTION check_mview_exists(p_schema_name varchar2, p_mview_name VARCHAR2) RETURN BOOLEAN IS
    v_tmp PLS_INTEGER;
  BEGIN
    if (p_schema_name is null)
    then
      raise_application_error(-20141,'missing p_schema_name');
    end if;
    if (p_mview_name is null)
    then
      raise_application_error(-20142,'missing p_mview_name');
    end if;
    select 1 into v_tmp from dual
      where exists (
        select 1 from all_mviews
        where mview_name = p_mview_name  
        and owner = p_schema_name
      );
    return true;
  exception
    when no_data_found then
    return false;
  END;
  
  FUNCTION check_column_in_table_exists(p_schema_name varchar2, p_table_name VARCHAR2, p_column_name VARCHAR2) RETURN BOOLEAN IS
    v_tmp PLS_INTEGER;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20021,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20022,'missing p_table_name');
    end if;
    if (p_column_name is null)
    then
      raise_application_error(-20023,'missing p_column_name');
    end if;

    --do main part
    select 1 into v_tmp from dual
      where exists (
        select 1 from all_tab_columns
        where table_name = p_table_name  
        and owner = p_schema_name
        and column_name = p_column_name
      );
    return true;
  exception
    when no_data_found then
    return false;
  END;

  FUNCTION check_is_table_empty(p_schema_name varchar2, p_table_name VARCHAR2) RETURN BOOLEAN IS
    v_tmp PLS_INTEGER;
    v_full_table_name varchar2(100);
    v_sql varchar2(32000);
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20151,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20152,'missing p_table_name');
    end if;

    --do main part
    v_full_table_name := p_schema_name||'.'||p_table_name;
    v_sql := 'select count(*) from '||v_full_table_name||' where rownum = 1';
    execute immediate v_sql into v_tmp;
    if (v_tmp=0)
    then
      return true;
    end if;
    return false;
  END;

  FUNCTION check_table_has_partitions(p_schema_name varchar2, p_table_name VARCHAR2) RETURN BOOLEAN IS
    v_tmp PLS_INTEGER;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20041,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20042,'missing p_table_name');
    end if;

    --do main part
    select 1 into v_tmp from dual
      where exists (
        select 1 from all_part_tables
        where table_name = p_table_name  
        and owner = p_schema_name
      );
    return true;
  exception
    when no_data_found then
    return false;
  END;

  PROCEDURE execute_immediate(p_str varchar2, p_enable_execute_immediate number default 3) IS
  begin
    if (p_enable_execute_immediate=1 or (p_enable_execute_immediate=2 and c_execute_immediate=1) or (p_enable_execute_immediate=3 and gv_enable_execute_immediate=1))
    then
      execute immediate p_str;
    end if;
  end;

  FUNCTION rename_owner_dot_name(p_str clob, p_keyword varchar2, p_owner_old varchar2, p_name_old varchar2, p_owner_new varchar2, p_name_new varchar2, p_end varchar2 default null) RETURN CLOB IS
    v_str clob;
    v_end varchar2(1000);
  begin
    v_str := p_str;
    v_end := p_end;
    
-- in case of having schema.table
    if (v_end is null)
    then
      v_end := '[[:space:]]{1,}';
    end if;
    v_str := regexp_replace(v_str,
    '([[:space:]]{1,}'||p_keyword||'[[:space:]]{1,}"{0,1})'||p_owner_old||'("{0,1}[[:space:]]{0,}\.{1}[[:space:]]{0,}"{0,1})'||p_name_old||'("{0,1}'||v_end||')',
    '\1'||p_owner_new||'\2'||p_name_new||'\3',1,1,'i'
    );
    
/*
[[:space:]] = whitespace = space,\t,\n,\r,\f,\v

1. ([[:space:]]{1,}'||p_keyword||'[[:space:]]{1,}"{0,1}) - whitespace, keyword, whitespace, optional double quotation mark
   p_owner_old
2. ("{0,1}[[:space:]]{0,}\.{1}[[:space:]]{0,}"{0,1}) - optional double quotation mark, optional whitespace, dot, optional whitespace, optional double quotation mark
   p_name_old
3. ("{0,1}[[:space:]]{1,}) - optional double quotation mark, whitespace
*/

-- in case of table without schema
    v_str := regexp_replace(v_str,
    '([[:space:]]{1,}'||p_keyword||'[[:space:]]{1,}"{0,1})'||p_name_old||'("{0,1}'||v_end||')',
    '\1'||p_name_new||'\2',1,1,'i'
    );
/*
1. ([[:space:]]{1,}'||p_keyword||'[[:space:]]{1,}"{0,1}) - whitespace, keyword, whitespace, optional double quotation mark
   p_name_old
2. ("{0,1}[[:space:]]{1,}) - optional double quotation mark, whitespace
*/

    write_log(c_log_message_type_info,'rename_owner_dot_name', 'rename_owner_dot_name','001','p_str='||p_str||chr(10)||'p_keyword='||p_keyword||chr(10)||'p_owner_old='||p_owner_old||chr(10)||'p_name_old='||p_name_old||chr(10)||'p_owner_new='||p_owner_new||chr(10)||'p_name_new='||p_name_new||chr(10)||'v_str='||v_str,0,'');
    return v_str;
  end;
  PROCEDURE enable_row_movement(p_schema_name varchar2, p_table_name VARCHAR2) IS
    v_full_table_name varchar2(100);
    v_sql varchar2(32000); 
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20221,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20222,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20223,'Table:'||v_full_table_name||' does not exists.');
    end if;

    --do main part
    v_sql := 'alter table '||v_full_table_name||' enable row movement';
    execute_immediate(v_sql);
    update_status(p_table_name,'IN_PROGRESS enable_row_movement','enable_row_movement: OK',null,chr(10)||'-- enable row movement'||chr(10)||v_sql||';','MERGE');
  END;

  FUNCTION get_identity_column_name(p_schema_name varchar2, p_table_name VARCHAR2) RETURN varchar2 IS
    v_identity_column_name varchar2(100);
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20161,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20162,'missing p_table_name');
    end if;

    --do main part
    begin
      select column_name into v_identity_column_name from all_tab_cols
        where table_name = p_table_name 
        and owner = p_schema_name
        and identity_column='YES';
    exception
      when no_data_found then
      v_identity_column_name := null;
    end;
    return v_identity_column_name;
  END;

  FUNCTION get_identity_nextval(p_schema_name varchar2, p_table_name VARCHAR2) RETURN number IS
    v_identity_nextval number;
    v_identity_sequence_name_long long;
    v_identity_sequence_name varchar2(4000);
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20171,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20172,'missing p_table_name');
    end if;

    --do main part

    if (get_identity_column_name(p_schema_name, p_table_name) is not null) -- table has identity column
    then
      select data_default into v_identity_sequence_name_long from all_tab_columns
      where table_name = p_table_name and owner = p_schema_name
      and identity_column='YES';
      v_identity_sequence_name := substr(v_identity_sequence_name_long,0,4000);
      v_identity_sequence_name := substr(v_identity_sequence_name, instr(v_identity_sequence_name, '.')+1, length(v_identity_sequence_name));
      v_identity_sequence_name := substr(v_identity_sequence_name,1,instr(v_identity_sequence_name, '.')-1);
      v_identity_sequence_name := replace(v_identity_sequence_name, '"');
      select last_number + increment_by into v_identity_nextval from all_sequences where sequence_owner = p_schema_name and sequence_name=v_identity_sequence_name;
    else
      v_identity_nextval := null;
    end if;
    return v_identity_nextval;
  end;

  FUNCTION get_sequence_nextval(p_schema_name varchar2, p_sequence_name VARCHAR2) RETURN number IS
    v_sequence_nextval number;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20301,'missing p_schema_name');
    end if;
    if (p_sequence_name is null)
    then
      raise_application_error(-20302,'missing p_sequence_name');
    end if;

    --do main part
    begin
      select last_number + increment_by into v_sequence_nextval from all_sequences where sequence_owner = p_schema_name and sequence_name=p_sequence_name;
    exception
    when no_data_found then
      v_sequence_nextval := null;
    end;
    return v_sequence_nextval;
  end;

  FUNCTION get_column_nextval(p_schema_name varchar2, p_table_name VARCHAR2, p_column_name VARCHAR2) RETURN number is
    v_column_nextval number;
    v_sql clob;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20311,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20312,'missing p_table_name');
    end if;
    if (p_column_name is null)
    then
      raise_application_error(-20313,'missing p_column_name');
    end if;

    --do main part
    begin
      v_sql := 'select nvl(max('||p_column_name||'),0)+1 column_nextval from '||p_schema_name||'.'||p_table_name;
      execute immediate v_sql into v_column_nextval;
    exception
    when no_data_found then
      v_column_nextval := null;
    end;
    return v_column_nextval;
  end;


  FUNCTION generate_tmp_name return varchar2 is
    v_tmp_name_num pls_integer;
  begin
    v_tmp_name_num := sq_t_partition_ddl.nextval;
    return c_tmp_name_prefix||v_tmp_name_num;
  end;


  FUNCTION generate_DDL(p_schema_name varchar2, p_table_name VARCHAR2) return number is
    v_proc_name t_partition_log.proc_name%type := 'generate_DDL';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_generate_ddl_status number;
    v_full_table_name varchar2(100);
    v_object_name_tmp varchar2(128);
    v_table_name_tmp varchar2(128);
    v_backup_table_name varchar2(128);
    v_oryginal_sql clob := null;
    v_sql clob := null;
    v_sql_tmp clob := null;
    v_sql_start number;
    v_sql_end number;
    v_sql_occurence number;
    v_index_name_tmp varchar2(128);
    v_start_time date;
    v_start_time_loop date;
    v_start_time_full date;
  begin
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20231,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20232,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20233,'Table:'||v_full_table_name||' does not exists.');
    end if;    

    -- do main part
    v_generate_ddl_status := 0;
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Generate DDL (including dependend objects) for table: '||v_full_table_name);
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,v_proc_name||': in progress',v_partition_log_id);
    
    -- Cleanup t_partition_ddl
    if (v_generate_ddl_status=0)
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Cleanup t_partition_ddl for table: '||p_table_name);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'cleanup t_partition_ddl: in progress',v_partition_log_id);
        v_start_time := sysdate;
        v_sql := 'delete from t_partition_ddl where table_name = '''||p_table_name||''' and release_version = '''||gv_release_version||'''';
        execute immediate v_sql;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Cleanup t_partition_ddl for table: '||v_full_table_name||' is successful.',v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'cleanup t_partition_ddl: OK',v_partition_log_id);
      exception
      when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Cleanup failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      update_status(p_table_name,'FAILED '||v_proc_name,'cleanup t_partition_ddl: NOK',v_partition_log_id);
      v_generate_ddl_status :=  1;
      end;
    end if;
    
    -- generate PARTITION clause DDL
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Generate PARTITION clause DDL table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'gen_partition_clause: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql_tmp := gen_partition_clause(p_schema_name => p_schema_name, p_table_name => p_table_name);
        insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE, OBJECT_NAME, OBJECT_NAME_TMP, OBJECT_NAME_OLD, OBJECT_DDL, RELEASE_VERSION)
        values (p_schema_name, p_table_name, 'PARTITION', p_table_name, v_table_name_tmp, v_backup_table_name, v_sql_tmp, gv_release_version);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Generate PARTITION clause DDL for table: '||v_full_table_name||' is successful.',v_start_time,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'gen_partition_clause: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'103','Generate PARTITION clause DDL for table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'gen_partition_clause: NOK',v_partition_log_id);
        v_generate_ddl_status := 2; -- gen_partition_clause error
      end;
    end if;

    -- generate TABLE DDL
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Generate DDL for table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_table_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_table_name_tmp := generate_tmp_name();
        v_backup_table_name := get_backup_table_name(p_table_name,v_table_name_tmp||'_OLD');
        update_partition_backup_table(p_table_name, v_backup_table_name);
        v_oryginal_sql := get_table_ddl(p_schema_name => p_schema_name, p_table_name => p_table_name, p_new_table_name => null, p_include_CONSTRAINTS => true, p_include_REF_CONSTRAINTS => true, p_include_PARTITIONING => true, p_include_SEGMENT_ATTRIBUTES => true, p_include_TABLESPACE => true, p_include_STORAGE => true, p_update_IDENTITY => false, p_identity_start => null);
        if (v_sql_tmp = 'STANDARDIZE_IDENTITY') -- if we do not repartition then get table DDL with oryginal partitioning clause
        then
          v_sql := get_table_ddl(p_schema_name => p_schema_name, p_table_name => p_table_name, p_new_table_name => v_table_name_tmp, p_include_CONSTRAINTS => false, p_include_REF_CONSTRAINTS => false, p_include_PARTITIONING => true, p_include_SEGMENT_ATTRIBUTES => false, p_include_TABLESPACE => false, p_include_STORAGE => false, p_update_IDENTITY => true, p_identity_start => null);
        else
          v_sql := get_table_ddl(p_schema_name => p_schema_name, p_table_name => p_table_name, p_new_table_name => v_table_name_tmp, p_include_CONSTRAINTS => false, p_include_REF_CONSTRAINTS => false, p_include_PARTITIONING => false, p_include_SEGMENT_ATTRIBUTES => false, p_include_TABLESPACE => false, p_include_STORAGE => false, p_update_IDENTITY => true, p_identity_start => null);
        end if;
        insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE ,OBJECT_NAME, OBJECT_NAME_TMP, OBJECT_NAME_OLD, OBJECT_DDL, ORYGINAL_OBJECT_DDL, RELEASE_VERSION)
          values (p_schema_name, p_table_name, 'TABLE', p_table_name, v_table_name_tmp, v_backup_table_name, v_sql, v_oryginal_sql, gv_release_version);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Generate DDL for table: '||v_full_table_name||' is successful.',v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_table_ddl: OK',v_partition_log_id);
      exception
      when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Table DDL: '||v_full_table_name||' cannot be generated due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      update_status(p_table_name,'FAILED '||v_proc_name,'get_table_ddl: NOK',v_partition_log_id);
      v_generate_ddl_status :=  1; -- get_table_ddl error
      end;
    end if;

    -- concatenate TABLE and PARTITION DDL
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'008','Concatenate TABLE and PARTITION DDL for table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'gen_partition_clause: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        if (v_sql_tmp != 'STANDARDIZE_IDENTITY') -- if we repartition table then concatenate table SQL (without partition clause) and partition clause based on t_partition_cfg
        then
          v_sql := v_sql||' '||v_sql_tmp;
        end if;
        insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE, OBJECT_NAME, OBJECT_NAME_TMP, OBJECT_NAME_OLD, OBJECT_DDL, RELEASE_VERSION)
        values (p_schema_name, p_table_name, 'TABLE AND PARTITION', p_table_name, v_table_name_tmp, v_backup_table_name, v_sql, gv_release_version);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'009','Concatenate TABLE and PARTITION DDL for table: '||v_full_table_name||' is successful.',v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'gen_partition_clause: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'104','Concatenate TABLE and PARTITION DDL table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'gen_partition_clause: NOK',v_partition_log_id);
        v_generate_ddl_status := 3;
      end;
    end if;

    -- generte constraints DDLs
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'010','Generate constraints DDLs for table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_constraint_ddl: in progress',v_partition_log_id);
      begin
        v_start_time_loop := sysdate;
        v_sql_tmp := null;
        for all_constraints_row in (
          select
          all_constraints.constraint_name,
          case
          when all_constraints.constraint_type = 'C' and all_tab_cols.nullable = 'N' and all_constraints.generated ='GENERATED NAME' then 'NN_GEN_NAME'
          when all_constraints.constraint_type = 'C' and all_tab_cols.nullable = 'N' and all_constraints.generated ='USER NAME' then 'NN_USER_NAME'
          when all_constraints.constraint_type = 'P' and all_constraints.generated ='GENERATED NAME' then 'P_GEN_NAME'
          when all_constraints.constraint_type = 'P' and all_constraints.generated ='USER NAME' then 'P_USER_NAME'
          when all_constraints.constraint_type = 'U' and all_constraints.generated ='GENERATED NAME' then 'U_GEN_NAME'
          when all_constraints.constraint_type = 'U' and all_constraints.generated ='USER NAME' then 'U_USER_NAME'
          else all_constraints.constraint_type
          end constr_type,
          all_tab_cols.column_name,
          all_constraints.index_name
          from all_constraints left outer join all_tab_cols
          on all_constraints.owner = all_tab_cols.owner and all_constraints.table_name = all_tab_cols.table_name and all_constraints.search_condition_vc = '"'||COLUMN_NAME||'" IS NOT NULL'
          where
          all_constraints.owner = p_schema_name and all_constraints.table_name = p_table_name  order by constraint_name
        )
        loop
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'011','Generate constraint DDLs for constraint: '||all_constraints_row.constraint_name||'.');
          v_start_time := sysdate;
          v_object_name_tmp := generate_tmp_name();
          v_oryginal_sql := get_constraint_ddl(p_schema_name => p_schema_name, p_constraint_name => all_constraints_row.constraint_name, p_new_constraint_name => null);
          v_sql := get_constraint_ddl(p_schema_name => p_schema_name, p_constraint_name => all_constraints_row.constraint_name, p_new_constraint_name => v_object_name_tmp);
          v_sql := rename_owner_dot_name(v_sql,'table',p_schema_name,p_table_name,p_schema_name,v_table_name_tmp);
          v_sql_tmp := v_sql_tmp||' '||v_sql;
          if (all_constraints_row.constr_type in ('P_USER_NAME','U_USER_NAME')) -- for CONSTRAINTS Primary key and Unique
          then
            if (all_constraints_row.constraint_name != all_constraints_row.index_name)
            then
              v_index_name_tmp := generate_tmp_name();
              v_sql := rename_owner_dot_name(v_sql,'index',p_schema_name,all_constraints_row.index_name,p_schema_name,v_index_name_tmp);
              v_sql := rename_owner_dot_name(v_sql,'on',p_schema_name,p_table_name,p_schema_name,v_table_name_tmp);
            else
              v_index_name_tmp := v_object_name_tmp;
            end if;
            insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE, OBJECT_NAME, OBJECT_NAME_TMP,OBJECT_NAME_OLD, COLUMN_NAME, OBJECT_DDL, RELEASE_VERSION)
            values (p_schema_name, p_table_name, 'INDEX_CONSTRAINT_'||all_constraints_row.constr_type, all_constraints_row.index_name, v_index_name_tmp, v_index_name_tmp||'_OLD', all_constraints_row.column_name, null, gv_release_version);
          end if;
          insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE, OBJECT_NAME, OBJECT_NAME_TMP,OBJECT_NAME_OLD, COLUMN_NAME, OBJECT_DDL, ORYGINAL_OBJECT_DDL, RELEASE_VERSION)
          values (p_schema_name, p_table_name, 'CONSTRAINT_'||all_constraints_row.constr_type, all_constraints_row.constraint_name, v_object_name_tmp, v_object_name_tmp||'_OLD', all_constraints_row.column_name, v_sql, v_oryginal_sql, gv_release_version);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'012','Generate constraint DDLs for constraint: '||all_constraints_row.constraint_name||' is successful.',v_start_time,v_sql);
        end loop;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'013','Generate constraints DDLs for table: '||v_full_table_name||' is successful.',v_start_time_loop,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_constraint_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'106','Generate constraints DDLs table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'get_constraint_ddl: NOK',v_partition_log_id);
        v_generate_ddl_status := 5;
      end;
    end if;
    
    
    -- generate indexes DDLs
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'014','Generate indexes DDLs for table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_index_ddl: in progress',v_partition_log_id);
      begin
        v_start_time_loop := sysdate;
        v_sql_tmp := null;
        for index_name_row in (
          select all_indexes.index_name
            from all_indexes
            left outer join all_constraints on all_indexes.owner = all_constraints.owner and all_indexes.table_name = all_constraints.table_name and all_indexes.index_name = all_constraints.index_name
            where all_constraints.constraint_type is null and all_indexes.owner = p_schema_name and all_indexes.table_name = p_table_name order by index_name
          )
        loop
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'015','Generate index DDLs for index: '||index_name_row.index_name||'.');
          v_start_time := sysdate;
          v_object_name_tmp := generate_tmp_name();
          v_oryginal_sql := get_index_ddl(p_schema_name => p_schema_name, p_index_name => index_name_row.index_name, p_new_index_name => null);
          v_sql := get_index_ddl(p_schema_name => p_schema_name, p_index_name => index_name_row.index_name, p_new_index_name => v_object_name_tmp);
          v_sql := rename_owner_dot_name(v_sql,'on',p_schema_name,p_table_name,p_schema_name,v_table_name_tmp);
          v_sql_tmp := v_sql_tmp||' '||v_sql;
          insert into t_partition_ddl(OWNER, TABLE_NAME,OBJECT_TYPE,OBJECT_NAME, OBJECT_NAME_TMP, OBJECT_NAME_OLD, OBJECT_DDL, ORYGINAL_OBJECT_DDL, RELEASE_VERSION)
          values (p_schema_name, p_table_name, 'INDEX', index_name_row.index_name, v_object_name_tmp, v_object_name_tmp||'_OLD', v_sql,v_oryginal_sql, gv_release_version);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'016','Generate index DDLs for index: '||index_name_row.index_name||' is successful.',v_start_time,v_sql);
        end loop;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'017','Generate indexes DDLs for table: '||v_full_table_name||' is successful.',v_start_time_loop,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_index_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'108','Generate indexes DDLs table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'get_index_ddl: NOK',v_partition_log_id);
        v_generate_ddl_status := 7;
      end;
    end if;
    
    -- generate triggers DDLs
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'018','Generate triggers DDLs for table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_trigger_ddl: in progress',v_partition_log_id);
      begin
        v_start_time_loop := sysdate;
        v_sql_tmp := null;
        for trigger_name_row in (
          select trigger_name
          from all_triggers
          where owner = p_schema_name and table_name = p_table_name order by trigger_name
        )
        loop
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'019','Generate trigger DDLs for trigger: '||trigger_name_row.trigger_name||'.');
          v_start_time := sysdate;
          v_object_name_tmp := generate_tmp_name();
          v_oryginal_sql := get_trigger_ddl(p_schema_name => p_schema_name, p_trigger_name => trigger_name_row.trigger_name, p_new_trigger_name => null);
          v_sql := get_trigger_ddl(p_schema_name => p_schema_name, p_trigger_name => trigger_name_row.trigger_name, p_new_trigger_name => v_object_name_tmp);
          v_sql := rename_owner_dot_name(v_sql,'on',p_schema_name,p_table_name,p_schema_name,v_table_name_tmp);
          v_sql_tmp := v_sql_tmp||' '||v_sql;
          insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE, OBJECT_NAME, OBJECT_NAME_TMP, OBJECT_NAME_OLD, OBJECT_DDL, ORYGINAL_OBJECT_DDL, RELEASE_VERSION)
          values (p_schema_name, p_table_name, 'TRIGGER', trigger_name_row.trigger_name, v_object_name_tmp, v_object_name_tmp||'_OLD',substr(v_sql,1,instr(v_sql,'ALTER TRIGGER ')-1), v_oryginal_sql, gv_release_version);
          
          insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE, OBJECT_NAME, OBJECT_DDL, RELEASE_VERSION)
          values (p_schema_name, p_table_name, 'ALTER_TRIGGER', trigger_name_row.trigger_name, substr(v_sql,instr(v_sql,'ALTER TRIGGER ')), gv_release_version);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'020','Generate trigger DDLs for trigger: '||trigger_name_row.trigger_name||' is successful.',v_start_time,v_sql);
        end loop;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'021','Generate triggers DDLs for table: '||v_full_table_name||' is successful.',v_start_time_loop,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_trigger_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'110','Generate triggers DDLs table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'get_trigger_ddl: NOK',v_partition_log_id);
        v_generate_ddl_status := 9;
      end;
    end if;
     
    
    -- generate comments DDLs
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'022','Generate comments DDL table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_comments_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql_tmp := get_comments_ddl(p_schema_name,p_table_name);
        if (v_sql_tmp is not null)
        then
          v_sql_occurence := 1;
          loop
            v_sql_start := instr(v_sql_tmp,'COMMENT ON',1,v_sql_occurence);
            v_sql_end := instr(v_sql_tmp,'COMMENT ON',1,v_sql_occurence+1);
            exit when v_sql_start = 0;
            if (v_sql_end=0)
            then
              v_sql := substr(v_sql_tmp,v_sql_start);
            else
              v_sql := substr(v_sql_tmp,v_sql_start,v_sql_end-v_sql_start);
            end if;
            v_sql := rename_owner_dot_name(v_sql,'table',p_schema_name,p_table_name,p_schema_name,v_table_name_tmp);
            v_sql := rename_owner_dot_name(v_sql,'column',p_schema_name,p_table_name,p_schema_name,v_table_name_tmp,'\.');
            insert into t_partition_ddl(OWNER, TABLE_NAME, OBJECT_TYPE, OBJECT_NAME, OBJECT_DDL, ORYGINAL_OBJECT_DDL, RELEASE_VERSION)
            values (p_schema_name, p_table_name,'COMMENT', 'COMMENT_'||v_sql_occurence, v_sql, v_sql_tmp, gv_release_version);
            v_sql_occurence := v_sql_occurence + 1;
          end loop;
        end if;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'023','Generate comments  DDL for table: '||v_full_table_name||' is successful.',v_start_time,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get_comments_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'111','Generate comments  DDL for table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'get_comments_ddl: NOK',v_partition_log_id);
        v_generate_ddl_status := 10;
      end;
    end if;
    if (v_generate_ddl_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'024','Generate DDL (including dependend objects) for table: '||v_full_table_name||' finished successfully.',v_start_time_full);
      update_status(p_table_name,'DONE generate_DDL','table successfully repartitioned using rename method in '||round((sysdate - v_start_time_full) * 24*60*60)||' seconds.',v_partition_log_id);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'025','Generate DDL (including dependend objects), redefinition status: '||v_generate_ddl_status);
    end if;
    return v_generate_ddl_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Generate DDL (including dependend objects) failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    update_status(p_table_name,'FAILED '||v_proc_name,v_proc_name||': NOK',v_partition_log_id);
    raise;
  END;
  
  FUNCTION repart_table_rename(p_schema_name varchar2, p_table_name VARCHAR2) return number is
    v_proc_name t_partition_log.proc_name%type := 'repart_table_rename';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_repart_table_rename_status number;
    v_full_table_name varchar2(100);
    v_sql clob := null;
    v_sql_tmp clob := null;
    v_sql_full clob;
    v_object_name varchar2(128);
    v_object_name_tmp varchar2(128);
    v_object_name_old varchar2(128);
    v_table_name_tmp varchar2(128);
    v_backup_table_name varchar2(128);
    v_comment varchar2(4000);
    v_start_time date;
    v_start_time_loop date;
    v_start_time_full date;
    v_column_already_not_null exception; -- ORA-01442: column to be modified to NOT NULL is already NOT NULL
    pragma exception_init(v_column_already_not_null, -01442);
  begin
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20241,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20242,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20243,'Table:'||v_full_table_name||' does not exists.');
    end if;    

    -- do main part
    v_repart_table_rename_status := 0;
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Repartition table using rename method for table: '||v_full_table_name);
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,v_proc_name||': in progress',v_partition_log_id);

    -- create table with partitioning (based on partitioning_cfg table)
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Create table with partitions: '||v_full_table_name||'.');
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'create table: in progress',v_partition_log_id);
    begin
      v_start_time := sysdate;
      select tbl.object_ddl, tbl.object_name_tmp, tbl.object_name_old into v_sql, v_table_name_tmp,v_backup_table_name from t_partition_ddl tbl
        where tbl.owner = p_schema_name and tbl.table_name=p_table_name and tbl.object_type = 'TABLE AND PARTITION' and release_version = gv_release_version;
      execute_immediate(v_sql);
      v_sql_full := v_sql_full||chr(10)||'-- create temporary table with partitions definition from t_partition_cfg';
      v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Create table with partitions: '||v_full_table_name||' is successful.',v_start_time,v_sql);
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'create table: OK',v_partition_log_id, v_sql_full);
    exception
    when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Create table with partitions: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      update_status(p_table_name,'FAILED '||v_proc_name,'create table: NOK',v_partition_log_id);
      v_repart_table_rename_status :=  1;
    end;

    -- copy data
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Copy data (insert+append) from: '||v_full_table_name||' to '||p_schema_name||'.'||v_table_name_tmp||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'copy data: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql := 'insert /*+ append */ into '||p_schema_name||'.'||v_table_name_tmp||' select * from '||p_schema_name||'.'||p_table_name;
        execute_immediate(v_sql);
        v_sql_full := v_sql_full||chr(10)||chr(10)||'-- copy data from source to temporary';
        v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Copy data (insert+append) from: '||v_full_table_name||' to '||p_schema_name||'.'||v_table_name_tmp||' is successful. Number of rows copied:'||SQL%ROWCOUNT,v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'copy data: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Copy data (insert+append) from: '||v_full_table_name||' to '||p_schema_name||'.'||v_table_name_tmp||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'copy data: NOK',v_partition_log_id);
        v_repart_table_rename_status := 2;
      end;
    end if;

    -- create all dependend objects (indexes, constraints, triggers, comments etc.)
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Create dependend objects for table: '||v_table_name_tmp||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'create dependend objects for new table: in progress',v_partition_log_id);
      begin
        v_start_time_loop := sysdate;
        v_sql_tmp := null;
        v_sql_full := v_sql_full||chr(10)||chr(10)||'-- create all dependend objects on temporary table';
        for object_ddl_row in (
          select object_ddl,object_type,column_name from t_partition_ddl 
          where owner = p_schema_name
            and table_name = p_table_name
            and object_type in ('CONSTRAINT_P_USER_NAME','CONSTRAINT_P_GEN_NAME','CONSTRAINT_U_USER_NAME','CONSTRAINT_U_GEN_NAME','CONSTRAINT_R','CONSTRAINT_C','INDEX','TRIGGER','ALTER_TRIGGER','CONSTRAINT_NN_USER_NAME','CONSTRAINT_NN_GEN_NAME','COMMENT')
            and release_version = gv_release_version
          order by 
          (
          case object_type
            when 'CONSTRAINT_P_USER_NAME' then 4
            when 'CONSTRAINT_P_GEN_NAME' then 5
            when 'CONSTRAINT_U_USER_NAME' then 6
            when 'CONSTRAINT_U_GEN_NAME' then 7
            when 'CONSTRAINT_R' then 8
            when 'CONSTRAINT_C' then 9
            when 'INDEX' then 10
            when 'TRIGGER' then 11
            when 'ALTER_TRIGGER' then 12
            when 'CONSTRAINT_NN_USER_NAME' then 13
            when 'CONSTRAINT_NN_GEN_NAME' then 14
            when 'COMMENT' then 15
          else 100
          end
          )
        )
        loop
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Create '||object_ddl_row.object_type||' for table: '||v_table_name_tmp||'.');
          v_start_time := sysdate;
          v_sql := object_ddl_row.object_ddl;
          begin
            v_sql_tmp := v_sql_tmp||' '||v_sql;
            execute_immediate(v_sql);
            v_sql_full := v_sql_full||chr(10)||chr(10)||'-- create object type:'||object_ddl_row.object_type||' on temporary table '||v_table_name_tmp;
            v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
          exception
          when v_column_already_not_null then -- in case of trying to create NOT NULL once more; ORA-01442: column to be modified to NOT NULL is already NOT NULL
            null;
          end;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'008','Create '||object_ddl_row.object_type||' for table: '||v_table_name_tmp||' is successful.',v_start_time,v_sql);
        end loop;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'009','Create dependend objects for table: '||v_table_name_tmp||' is successful.',v_start_time_loop,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'create dependend objects for new table: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'104','Create dependend objects for table: '||v_table_name_tmp||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'create dependend objects for new table: NOK',v_partition_log_id);
        v_repart_table_rename_status := 4;
      end;
    end if;

    -- rename original table objects to xxx_OLD name
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'010','Rename original table objects for table: '||p_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename original table objects',v_partition_log_id);
      begin
        v_start_time_loop := sysdate;
        v_sql_tmp := null;
        v_sql_full := v_sql_full||chr(10)||chr(10)||'-- rename oryginal table objects';
        for object_ddl_row in (
          select object_ddl,object_type,column_name,object_name,object_name_tmp,object_name_old from t_partition_ddl 
          where owner = p_schema_name
          and table_name = p_table_name
          and object_type in ('CONSTRAINT_P_USER_NAME','CONSTRAINT_U_USER_NAME','CONSTRAINT_R','CONSTRAINT_C','INDEX','TRIGGER','CONSTRAINT_NN_USER_NAME','INDEX_CONSTRAINT_P_USER_NAME','INDEX_CONSTRAINT_U_USER_NAME')
          and release_version = gv_release_version
          order by 
          (
          case object_type
          when 'CONSTRAINT_P_USER_NAME' then 3
          when 'CONSTRAINT_U_USER_NAME' then 4
          when 'CONSTRAINT_R' then 5
          when 'CONSTRAINT_C' then 6
          when 'INDEX' then 7
          when 'TRIGGER' then 8
          when 'CONSTRAINT_NN_USER_NAME' then 10
          when 'INDEX_CONSTRAINT_P_USER_NAME' then 13
          when 'INDEX_CONSTRAINT_U_USER_NAME' then 14
          else 100
          end
          )    
        )
        loop
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'011','Rename '||object_ddl_row.object_type||' for table: '||p_table_name||'.');
          v_start_time := sysdate;
          v_object_name := object_ddl_row.object_name;
          v_object_name_tmp := object_ddl_row.object_name_tmp;
          v_object_name_old := object_ddl_row.object_name_old;
          case
            when object_ddl_row.object_type in ('CONSTRAINT_P_USER_NAME', 'CONSTRAINT_U_USER_NAME', 'CONSTRAINT_R', 'CONSTRAINT_C', 'CONSTRAINT_NN_USER_NAME' ) then
              v_sql := 'alter table '||p_schema_name||'.'||p_table_name||' rename constraint '||v_object_name||' to '||v_object_name_old;
            when object_ddl_row.object_type in ('INDEX_CONSTRAINT_P_USER_NAME', 'INDEX_CONSTRAINT_U_USER_NAME') then
              v_sql := 'alter index '||p_schema_name||'.'||v_object_name||' rename to '||v_object_name_old;
            when object_ddl_row.object_type in ('INDEX') then
              v_sql := 'alter index '||p_schema_name||'.'||v_object_name||' rename to '||v_object_name_old;
            when object_ddl_row.object_type in ('TRIGGER') then
              v_sql := 'alter trigger '||p_schema_name||'.'||v_object_name||' rename to '||v_object_name_old;
          end case;
          if (v_sql is not null)
          then
            v_sql_tmp := v_sql_tmp||' '||v_sql;
            execute_immediate(v_sql);
            v_sql_full := v_sql_full||chr(10)||chr(10)||'-- rename '||object_ddl_row.object_type||' on oryginal table';
            v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
          end if;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'012','Rename '||object_ddl_row.object_type||' for table: '||p_table_name||' is successful.',v_start_time,v_sql);
        end loop;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'013','Rename original table objects for table: '||p_table_name||' is successful.',v_start_time_loop,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename original table objects: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'106','Rename original table objects for table: '||p_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'rename original table objects: NOK',v_partition_log_id);
        v_repart_table_rename_status :=6;
      end;
    end if;

    -- rename new table object to original names
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'010','Rename new table objects to original names for table: '||v_table_name_tmp||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table objects to original names',v_partition_log_id);
      begin
        v_start_time_loop := sysdate;
        v_sql_tmp := null;
        v_sql_full := v_sql_full||chr(10)||chr(10)||'-- rename temporary table objects';
        for object_ddl_row in (
          select object_ddl,object_type,column_name,object_name,object_name_tmp,object_name_old from t_partition_ddl 
          where owner = p_schema_name
          and table_name = p_table_name
          and object_type in ('CONSTRAINT_P_USER_NAME','CONSTRAINT_U_USER_NAME','CONSTRAINT_R','CONSTRAINT_C','INDEX','TRIGGER','CONSTRAINT_NN_USER_NAME','INDEX_CONSTRAINT_P_USER_NAME','INDEX_CONSTRAINT_U_USER_NAME')
          and release_version = gv_release_version
          order by 
          (
          case object_type
          when 'CONSTRAINT_P_USER_NAME' then 3
          when 'CONSTRAINT_U_USER_NAME' then 4
          when 'CONSTRAINT_R' then 5
          when 'CONSTRAINT_C' then 6
          when 'INDEX' then 7
          when 'TRIGGER' then 8
          when 'CONSTRAINT_NN_USER_NAME' then 10
          when 'INDEX_CONSTRAINT_P_USER_NAME' then 13
          when 'INDEX_CONSTRAINT_U_USER_NAME' then 14
          else 100
          end
          )    
        )
        loop
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'011','Rename '||object_ddl_row.object_type||' for table: '||p_table_name||'.');
          v_start_time := sysdate;
          v_object_name := object_ddl_row.object_name;
          v_object_name_tmp := object_ddl_row.object_name_tmp;
          v_object_name_old := object_ddl_row.object_name_old;
          case
            when object_ddl_row.object_type in ('CONSTRAINT_P_USER_NAME', 'CONSTRAINT_U_USER_NAME', 'CONSTRAINT_R', 'CONSTRAINT_C', 'CONSTRAINT_NN_USER_NAME' ) then
              v_sql := 'alter table '||p_schema_name||'.'||v_table_name_tmp||' rename constraint '||v_object_name_tmp||' to '||v_object_name;
            when object_ddl_row.object_type in ('INDEX_CONSTRAINT_P_USER_NAME', 'INDEX_CONSTRAINT_U_USER_NAME') then
              v_sql := 'alter index '||p_schema_name||'.'||v_object_name_tmp||' rename to '||v_object_name;
            when object_ddl_row.object_type in ('INDEX') then
              v_sql := 'alter index '||p_schema_name||'.'||v_object_name_tmp||' rename to '||v_object_name;
            when object_ddl_row.object_type in ('TRIGGER') then
              v_sql := 'alter trigger '||p_schema_name||'.'||v_object_name_tmp||' rename to '||v_object_name;
          end case;
          if (v_sql is not null)
          then
            v_sql_tmp := v_sql_tmp||' '||v_sql;
            execute_immediate(v_sql);
            v_sql_full := v_sql_full||chr(10)||chr(10)||'-- rename '||object_ddl_row.object_type||' on temporary table';
            v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
          end if;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'012','Rename '||object_ddl_row.object_type||' for table: '||p_table_name||' is successful.',v_start_time,v_sql);
        end loop;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'013','Rename new table objects to original names for table: '||v_table_name_tmp||' is successful.',v_start_time_loop,v_sql_tmp);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table objects to original names: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'106','Rename new table objects to original names for table: '||v_table_name_tmp||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'rename new table objects to original names: NOK',v_partition_log_id);
        v_repart_table_rename_status := 8;
      end;
    end if;
    
 
    -- rename original table name
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'014','Rename original table name from: '||v_full_table_name||' to '||v_backup_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename original table name: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql := 'alter table '||p_schema_name||'.'||p_table_name||' rename to '||v_backup_table_name;
        execute_immediate(v_sql);
        v_sql_full := v_sql_full||chr(10)||'-- rename oryginal table';
        v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'015','Rename original table name from: '||v_full_table_name||' to '||v_backup_table_name||' is successful.',v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename original table name: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'107','Rename original table name from: '||v_full_table_name||' to '||v_backup_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'rename original table name: NOK',v_partition_log_id);
        v_repart_table_rename_status := 9;
      end;
    end if;

    -- rename new table name to original name
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'016','Rename new table name to original from: '||p_schema_name||'.'||v_table_name_tmp||' to '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table name to original name: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql := 'alter table '||p_schema_name||'.'||v_table_name_tmp||' rename to '||p_table_name;
        execute_immediate(v_sql);
        v_sql_full := v_sql_full||chr(10)||chr(10)||'-- rename oryginal table';
        v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'017','Rename new table name to original from: '||p_schema_name||'.'||v_table_name_tmp||' to '||v_full_table_name||' is successful.',v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table name to original name: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'108','Rename new table name to original from: '||p_schema_name||'.'||v_table_name_tmp||' to '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'rename new table name to original name: NOK',v_partition_log_id);
        v_repart_table_rename_status := 10;
      end;
    end if;

    -- add comment to OLD original table name
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'018','Add comment to OLD original table name: '||p_schema_name||'.'||v_table_name_tmp||'_OLD.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table name to original name: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        select comments into v_comment from all_tab_comments where owner = p_schema_name and table_name = p_table_name; -- get table comment rom new created table (with comments)
        if (v_comment is not null)
        then
          v_comment := v_comment || chr(10) || 'Oryginal table name before migration: '||p_schema_name||'.'||p_table_name;
        else
          v_comment := 'Oryginal table name before migration: '||p_schema_name||'.'||p_table_name;
        end if;
        v_sql := 'COMMENT ON TABLE '||p_schema_name||'.'||v_backup_table_name||' IS '''||v_comment||'''';
        execute_immediate(v_sql);
        v_sql_full := v_sql_full||chr(10)||chr(10)||'-- add comment to old table';
        v_sql_full := v_sql_full||chr(10)||trim(v_sql)||';';
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'019','Add comment to OLD original table name: '||p_schema_name||'.'||v_table_name_tmp||'_OLD. is successful.',v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table name to original name: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'109','Add comment to OLD original table name: '||p_schema_name||'.'||v_table_name_tmp||'_OLD. failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'rename new table name to original name: NOK',v_partition_log_id);
        v_repart_table_rename_status := 11;
      end;
    end if;
    -- grant table priviledges
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'020','Grant priviledges.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'Grant priviledges: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        grant_table_privs(p_table_name);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'021','Grant priviledges.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'Grant priviledges: OK',v_partition_log_id,v_sql_full);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'110','Grant priviledges failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'Grant priviledges: NOK',v_partition_log_id);
        v_repart_table_rename_status := 12;
      end;
    end if;
    if (v_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'022','Repartition table using rename method for table: '||v_full_table_name||' finished successfully.',v_start_time_full);
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'table successfully repartitioned using rename method in '||round((sysdate - v_start_time_full) * 24*60*60)||' seconds.',v_partition_log_id,v_sql_full);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'021','Repartition table using rename method failed, redefinition status: '||v_repart_table_rename_status);
    end if;
    return v_repart_table_rename_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Repartition table using rename method failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    update_status(p_table_name,'FAILED '||v_proc_name,v_proc_name||': NOK',v_partition_log_id);
    raise;
  END;
  
  FUNCTION rollback_repart_table_rename(p_schema_name varchar2, p_table_name VARCHAR2, p_release_version varchar2) return number is
    v_proc_name t_partition_log.proc_name%type := 'rollback_repart_table_rename';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_r_repart_table_rename_status number;
    v_full_table_name varchar2(100);
    v_sql clob := null;
    v_sql_tmp clob;
    v_object_name varchar2(128);
    v_object_name_tmp varchar2(128);
    v_object_name_old varchar2(128);
    v_backup_table_name varchar2(128);
    v_comment varchar2(4000);
    v_start_time date;
    v_start_time_loop date;
    v_start_time_full date;
  begin
    v_object_info := p_table_name;
    gv_release_version := p_release_version;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20251,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20252,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;

    -- do main part
    v_r_repart_table_rename_status := 0;
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Rollback repartitioning table partitoned by rename method for table: '||v_full_table_name);
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,v_proc_name||': in progress',v_partition_log_id,'');

    -- select backup table name
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Select backup table name for table: '||v_full_table_name||'.');
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'select backup table name: in progress',v_partition_log_id);
    begin
      v_start_time := sysdate;
      v_sql := 'select tbl.object_name_old from t_partition_ddl tbl where tbl.owner = '''||p_schema_name||''' and tbl.table_name='''||p_table_name||''' and tbl.object_type = ''TABLE AND PARTITION'' and release_version='''||gv_release_version||'''';
      select tbl.object_name_old into v_backup_table_name from t_partition_ddl tbl
        where tbl.owner = p_schema_name and tbl.table_name=p_table_name and tbl.object_type = 'TABLE AND PARTITION' and release_version = gv_release_version;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Select backup table name for table: '||v_full_table_name||' is successful.',v_start_time,v_sql);
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'select backup table name: OK',v_partition_log_id);
    exception
    when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Select backup table name for table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      update_status(p_table_name,'FAILED '||v_proc_name,'select backup table name: NOK',v_partition_log_id);
      v_r_repart_table_rename_status := 1;
    end;

    if (v_r_repart_table_rename_status=0)
    then
      if (check_table_exists(p_schema_name,v_backup_table_name)) -- check wether backup table exists
      then
        -- drop original table wih data
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Drop original table: '||v_full_table_name||'.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'drop original table: in progress',v_partition_log_id);
        begin
          v_start_time := sysdate;
          do_drop_table(p_schema_name, p_table_name, p_drop_table_with_data => 1);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Drop original table: '||v_full_table_name||' is successful.',v_start_time,null);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'drop original table: OK',v_partition_log_id);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Drop original table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,null,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          update_status(p_table_name,'FAILED '||v_proc_name,'drop original table: NOK',v_partition_log_id);
          v_r_repart_table_rename_status := 2;
        end;

        -- rename backup table name to original name
        if (v_r_repart_table_rename_status=0)
        then
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Rename backup table to original from: '||p_schema_name||'.'||v_backup_table_name||' to '||p_table_name||'.');
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename backup table to original name: in progress',v_partition_log_id);
          begin
            v_start_time := sysdate;
            v_sql := 'alter table '||p_schema_name||'.'||v_backup_table_name||' rename to '||p_table_name;
            execute immediate (v_sql);
            v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Rename backup table to original from: '||p_schema_name||'.'||v_backup_table_name||' to '||p_table_name||' is successful.',v_start_time,v_sql);
            update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename backup table to original name: OK',v_partition_log_id);
          exception
          when others then
            v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'103','Rename backup table to original from: '||p_schema_name||'.'||v_backup_table_name||' to '||p_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
            update_status(p_table_name,'FAILED '||v_proc_name,'rename backup table to original name: NOK',v_partition_log_id);
            v_r_repart_table_rename_status := 3;
          end;
        end if;

        -- rename backup table objects to original name
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'008','Rename backup table objects to original names for table: '||v_backup_table_name||'.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename backup table objects to original names: in progress',v_partition_log_id);
        begin
          v_start_time_loop := sysdate;
          for object_ddl_row in (
            select object_ddl,object_type,column_name,object_name,object_name_tmp,object_name_old from t_partition_ddl 
            where owner = p_schema_name
            and table_name = p_table_name
            and object_type in ('CONSTRAINT_P_USER_NAME','CONSTRAINT_U_USER_NAME','CONSTRAINT_R','CONSTRAINT_C','INDEX','TRIGGER','CONSTRAINT_NN_USER_NAME','INDEX_CONSTRAINT_P_USER_NAME','INDEX_CONSTRAINT_U_USER_NAME')
            and release_version = gv_release_version
            order by 
            (
            case object_type
            when 'CONSTRAINT_P_USER_NAME' then 3
            when 'CONSTRAINT_U_USER_NAME' then 4
            when 'CONSTRAINT_R' then 5
            when 'CONSTRAINT_C' then 6
            when 'INDEX' then 7
            when 'TRIGGER' then 8
            when 'CONSTRAINT_NN_USER_NAME' then 10
            when 'INDEX_CONSTRAINT_P_USER_NAME' then 13
            when 'INDEX_CONSTRAINT_U_USER_NAME' then 14
            else 100
            end
            )    
          )
          loop
            v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'009','Rename '||object_ddl_row.object_type||' for table: '||v_backup_table_name||'.');
            v_start_time := sysdate;
            v_object_name := object_ddl_row.object_name;
            v_object_name_tmp := object_ddl_row.object_name_tmp;
            v_object_name_old := object_ddl_row.object_name_old;
            case
              when object_ddl_row.object_type in ('CONSTRAINT_P_USER_NAME', 'CONSTRAINT_U_USER_NAME', 'CONSTRAINT_R', 'CONSTRAINT_C', 'CONSTRAINT_NN_USER_NAME' ) then
                v_sql := 'alter table '||p_schema_name||'.'||p_table_name||' rename constraint '||v_object_name_old||' to '||v_object_name;
              when object_ddl_row.object_type in ('INDEX_CONSTRAINT_P_USER_NAME', 'INDEX_CONSTRAINT_U_USER_NAME') then
                v_sql := 'alter index '||p_schema_name||'.'||v_object_name_old||' rename to '||v_object_name;
              when object_ddl_row.object_type in ('INDEX') then
                v_sql := 'alter index '||p_schema_name||'.'||v_object_name_old||' rename to '||v_object_name;
              when object_ddl_row.object_type in ('TRIGGER') then
                v_sql := 'alter trigger '||p_schema_name||'.'||v_object_name_old||' rename to '||v_object_name;
            end case;
            if (v_sql is not null)
            then
              v_sql_tmp := v_sql_tmp||' '||v_sql;
              execute immediate(v_sql);
            end if;
            v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'010','Rename '||object_ddl_row.object_type||' for table: '||v_backup_table_name||' is successful.',v_start_time,v_sql);
          end loop;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'011','Rename backup table objects to original names for table: '||v_backup_table_name||' is successful.',v_start_time_loop,v_sql_tmp);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename backup table objects to original names: OK',v_partition_log_id);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'105','Rename backup table objects to original names for table: '||v_backup_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          update_status(p_table_name,'FAILED '||v_proc_name,'rename backup table objects to original names: NOK',v_partition_log_id);
          v_r_repart_table_rename_status := 5;
        end;
      end if;

      -- Modify comment (remove information about table name before partitioning)
      if (v_r_repart_table_rename_status=0)
      then
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'012','Modify comment for table name: '||p_schema_name||'.'||p_table_name||'.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table name to original name: in progress',v_partition_log_id);
        begin
          v_start_time := sysdate;
          select comments into v_comment from all_tab_comments where owner = p_schema_name and table_name = p_table_name;
          v_comment := replace(v_comment,chr(10) || 'Oryginal table name before migration: '||p_schema_name||'.'||p_table_name,'');
          v_comment := replace(v_comment,'Oryginal table name before migration: '||p_schema_name||'.'||p_table_name,'');
          v_sql := 'COMMENT ON TABLE '||p_schema_name||'.'||p_table_name||' IS '''||v_comment||'''';
          execute immediate (v_sql);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'013','Modify comment for table name: '||p_schema_name||'.'||p_table_name||'. is successful.',v_start_time,v_sql);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'rename new table name to original name: OK',v_partition_log_id);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'106','Modify comment for table name: '||p_schema_name||'.'||p_table_name||'_OLD. failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          update_status(p_table_name,'FAILED '||v_proc_name,'rename new table name to original name: NOK',v_partition_log_id);
          v_r_repart_table_rename_status := 6;
        end;
      end if;
    end if;

    if (v_r_repart_table_rename_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'014','Rollback repartitioning table partitoned by rename method for table: '||v_full_table_name||' finished successfully.',v_start_time_full);
      update_status(p_table_name,'DONE','Rollback repartitioning table partitoned by rename successfull in '||round((sysdate - v_start_time_full) * 24*60*60)||' seconds.',v_partition_log_id);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'015','Rollback repartitioning table partitoned by rename failed, redefinition status: '||v_r_repart_table_rename_status);
    end if;
    return v_r_repart_table_rename_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Rollback repartitioning table partitoned by rename failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    update_status(p_table_name,'FAILED '||v_proc_name,v_proc_name||': NOK',v_partition_log_id);
    raise;
  END;

  PROCEDURE cleanup_status(p_release_version varchar2, p_table_name VARCHAR2 default null) is
    v_sql clob := null;
  begin
    gv_release_version := p_release_version;
    if (p_table_name is null) then
      v_sql := 'delete from t_partition_status where release_version = '''||gv_release_version||'''';
    else
      v_sql := 'delete from t_partition_status where table_name like '''||p_table_name||''' and release_version = '''||gv_release_version||'''';
    end if;
    execute immediate v_sql;
  end;

  FUNCTION drop_backup_table(p_schema_name varchar2, p_table_name VARCHAR2) return number is
    v_proc_name t_partition_log.proc_name%type := 'drop_backup_table';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_drop_backup_table_status number;
    v_full_table_name varchar2(100);
    v_sql clob := null;
    v_backup_table_name varchar2(128);
    v_start_time date;
    v_start_time_full date;
  begin
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20261,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20262,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;

    -- do main part
    v_drop_backup_table_status := 0;
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Drop backup table for table: '||v_full_table_name);

    -- select backup table name
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Select backup table name for table: '||v_full_table_name||'.');
    begin
      v_start_time := sysdate;
      v_sql := 'select tbl.backup_table_name from t_partition_cfg tbl where tbl.table_name='''||p_table_name||''' and release_version = '''||gv_release_version||'''';
      select tbl.backup_table_name into v_backup_table_name from t_partition_cfg tbl
        where tbl.table_name=p_table_name and release_version = gv_release_version;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Select backup table name for table: '||v_full_table_name||' is successful.',v_start_time,v_sql);
    exception
    when no_data_found then
      v_backup_table_name := null;
    when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Select backup table name for table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      v_drop_backup_table_status := 1;
    end;

    if (v_drop_backup_table_status=0)
    then
      if (v_backup_table_name is not null) -- check wether backup table exists
      then
        -- drop original table wih data
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Drop backup table: '||v_backup_table_name||'.');
        begin
          v_start_time := sysdate;
          do_drop_table(p_schema_name, v_backup_table_name, p_drop_table_with_data => 1);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Drop backup table: '||v_backup_table_name||' is successful.',v_start_time,null);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Drop backup table: '||v_backup_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,null,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          v_drop_backup_table_status := 2;
        end;
      end if;
    end if;
    if (v_drop_backup_table_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'014','Drop backup table for table: '||v_full_table_name||' finished successfully.',v_start_time_full);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'015','Drop backup table failed, redefinition status: '||v_drop_backup_table_status);
    end if;
    return v_drop_backup_table_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Drop backup table failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise;
  END;

  -- drop backup table for all tables with 'DONE' status for provided release_version
  FUNCTION drop_backup_table_for_done(p_release_version varchar2) return number is
    v_proc_name t_partition_log.proc_name%type := 'drop_backup_table_for_done';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_drop_backup_table_status number;
    v_start_time date;
    v_start_time_full date;
    v_start_time_loop date;
  begin
    v_object_info := 'all_DONE_tables';
    --checking parameters

    -- do main part
    v_drop_backup_table_status := 0;
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Drop backup table for all DONE tables');
    
    begin
      gv_release_version := p_release_version;
      v_start_time_loop := sysdate;
      for object_table_name_row in (
        select table_name from t_partition_status where status = 'DONE' and release_version = gv_release_version
      )
      loop
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Drop backup table for table: '||object_table_name_row.table_name||'.');
        begin
          v_start_time := sysdate;
          v_drop_backup_table_status := drop_backup_table(c_schema_name, object_table_name_row.table_name);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Drop backup table for table: '||object_table_name_row.table_name||' is successful.',v_start_time);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Drop backup table for table: '||object_table_name_row.table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          v_drop_backup_table_status := 11;
          exit;
        end;
      end loop;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Drop backup table for all DONE tables is successful.',v_start_time_loop);
    exception
    when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Drop backup table for all DONE tables failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      v_drop_backup_table_status := 12;
    end;
    if (v_drop_backup_table_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Drop backup table for all DONE tables finished successfully.',v_start_time_full);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Drop backup table failed, status: '||v_drop_backup_table_status);
    end if;
    return v_drop_backup_table_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Drop backup table for all DONE tables failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise;
  END;

  -- drop MIGR_PART_TMP_% tables
  FUNCTION drop_migr_part_tmp_tables(p_schema_name varchar2) return number is
    v_proc_name t_partition_log.proc_name%type := 'drop_migr_part_tmp_tables';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_drop_migr_part_tmp_status number;
    v_start_time date;
    v_start_time_full date;
    v_start_time_loop date;
  begin
    v_object_info := 'all_MIGR_PART_TMP_%_tables';
    --checking parameters

    -- do main part
    v_drop_migr_part_tmp_status := 0;
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info, v_proc_name, v_object_info,'001','Drop all MIGR_PART_TMP_% tables');
    
    begin
      v_start_time_loop := sysdate;
      for object_table_name_row in (
        select table_name from all_tables where owner = 'G77_CFG' and table_name like 'MIGR\_PART\_TMP\_%' escape '\' order by table_name
      )
      loop
        -- drop original table wih data
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Drop MIGR_PART_TMP_ table: '||object_table_name_row.table_name||'.');
        begin
          v_start_time := sysdate;
          do_drop_table(p_schema_name, object_table_name_row.table_name, p_drop_table_with_data => 1);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Drop MIGR_PART_TMP_ table: '||object_table_name_row.table_name||' is successful.',v_start_time,null);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Drop MIGR_PART_TMP_ table: '||object_table_name_row.table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,null,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          v_drop_migr_part_tmp_status := 2;
        end;
      end loop;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Drop all MIGR_PART_TMP_% tables is successful.',v_start_time_loop);
    exception
    when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Drop all MIGR_PART_TMP_% tables failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      v_drop_migr_part_tmp_status := 12;
    end;
    if (v_drop_migr_part_tmp_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Drop all MIGR_PART_TMP_% tables finished successfully.',v_start_time_full);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Drop all MIGR_PART_TMP_% tables, status: '||v_drop_migr_part_tmp_status);
    end if;
    return v_drop_migr_part_tmp_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Drop all MIGR_PART_TMP_% tables failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise;
  END;

  
  FUNCTION get_table_ddl(p_schema_name varchar2, p_table_name VARCHAR2, p_new_table_name VARCHAR2 default null, p_include_CONSTRAINTS boolean default true, p_include_REF_CONSTRAINTS boolean default true, p_include_PARTITIONING boolean default true, p_include_SEGMENT_ATTRIBUTES boolean default true, p_include_TABLESPACE boolean default true, p_include_STORAGE boolean default true, p_update_IDENTITY boolean default true, p_identity_start number default null) RETURN clob IS
    v_proc_name t_partition_log.proc_name%type := 'get_table_ddl';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
   	v_start_time date;
    v_handle number;
    v_handle_transform number;
    v_full_table_name varchar2(100);
    v_sql clob := null;
    v_sql_tmp clob := null;
    v_identity_start number;
    v_identity_start_column number; -- identity start on column name from t_partition_cfg
    v_identity_column_tbl_ident varchar2(100); -- column name with identity property
    v_identity_column t_partition_cfg.identity_column%type;
    v_identity_trg_name t_partition_cfg.identity_trg_name%type;
    v_identity_seq_name t_partition_cfg.identity_seq_name%type;
    v_table_has_identity_trigger number := 0; -- table has identity trigger
    v_table_has_identity_column number := 0; -- table doesn't have identity trigger and we would like to add identity property on the identity column with START WITH 1
  BEGIN
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20051,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20052,'missing p_table_name');
    end if;
    if (length(nvl(p_new_table_name,'x')) > 30)
    then
      raise_application_error(-20053,'p_new_table_name='||p_new_table_name||' length is too long, max allowed is 30 characters.');
    end if;

    --do main part
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20054,'Table:'||v_full_table_name||' does not exists.');
    end if;
    
    v_handle := dbms_metadata.open('TABLE');
    dbms_metadata.set_filter(v_handle,'SCHEMA',p_schema_name);
    dbms_metadata.set_filter(v_handle,'NAME',p_table_name);
    if (p_new_table_name is not null)
    then
      v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'MODIFY');
      DBMS_METADATA.SET_REMAP_PARAM (v_handle_transform,'REMAP_NAME',p_table_name,p_new_table_name);
    end if;
    v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'DDL');
    dbms_metadata.set_transform_param (v_handle_transform,'CONSTRAINTS',p_include_CONSTRAINTS);
    dbms_metadata.set_transform_param (v_handle_transform,'REF_CONSTRAINTS',p_include_REF_CONSTRAINTS);
    dbms_metadata.set_transform_param (v_handle_transform,'PARTITIONING',p_include_PARTITIONING);
    dbms_metadata.set_transform_param (v_handle_transform,'SEGMENT_ATTRIBUTES',p_include_SEGMENT_ATTRIBUTES);
    dbms_metadata.set_transform_param (v_handle_transform,'TABLESPACE',p_include_TABLESPACE);
    dbms_metadata.set_transform_param (v_handle_transform,'STORAGE',p_include_STORAGE);
    v_sql := DBMS_METADATA.FETCH_CLOB(v_handle);
    if (p_update_IDENTITY = true) -- standardize identity
    then
      -- select "identity tigger" details
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Select identity_column, identity_trg_name, identity_seq_name from t_partition_cfg for table_name = '||p_table_name||' and release_version = '||gv_release_version||'.');
      begin
        v_start_time := sysdate;
        select identity_column, identity_trg_name, identity_seq_name into v_identity_column, v_identity_trg_name, v_identity_seq_name
        from g77_cfg.t_partition_cfg where table_name = p_table_name and release_version = gv_release_version;
        write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Selected values from t_partition_cfg for table_name = '||p_table_name||' are: identity_column='||nvl(v_identity_column,'NULL')||', identity_trg_name='||nvl(v_identity_trg_name,'NULL')||', identity_seq_name='||nvl(v_identity_seq_name,'NULL')||'.',v_start_time);
      exception
      when others then
        write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Select identity_column, identity_trg_name, identity_seq_name from t_partition_cfg for table_name = '||p_table_name||' and release_version = '||gv_release_version||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        raise;
      end;
     
      -- if in the t_partition_cfg identity_column, identity_trg_name, identity_seq_name are not null it means that there is "identity trigger" which we would like to replace by identity property on identity_column
      if (v_identity_column is not null and v_identity_trg_name is not null and v_identity_seq_name is not null)
      then
        v_table_has_identity_trigger := 1;
      else
        v_table_has_identity_trigger := 0;
      end if;
      
      -- if in the t_partition_cfg identity_column is not null it means that there is no "identity trigger" and we would like to add identity property on identity_column with start with = max(column_name) from table_name
      if (v_identity_column is not null and v_identity_trg_name is null and v_identity_seq_name is null)
      then
        v_table_has_identity_column := 1;
      else
        v_table_has_identity_column := 0;
      end if;
      
      /* Table has identity trigger then read value from sequence in that trigger */
      v_identity_start_column := 1;
      if (v_table_has_identity_trigger = 1)
      then
        v_identity_start_column := get_sequence_nextval(p_schema_name, v_identity_seq_name);
        write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Sequence nextval for "identity trigger": v_identity_start_column = '||nvl(to_char(v_identity_start_column),'NULL')||'.');
        if (v_identity_start_column is null)
        then
          v_identity_start_column := 1;
        end if;
      end if;
      if (v_table_has_identity_column = 1)
      then
        v_identity_start_column := get_column_nextval(p_schema_name, p_table_name, v_identity_column);
        write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','max('||v_identity_column||')+1: v_identity_start_column = '||nvl(to_char(v_identity_start_column),'NULL')||'.');
        if (v_identity_start_column is null)
        then
          v_identity_start_column := 1;
        end if;
      end if;

      v_identity_column_tbl_ident := get_identity_column_name(p_schema_name, p_table_name); -- detect whether table has identity property and if yes then return column name
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Column name in table '||p_table_name||' with identity property is '||v_identity_column_tbl_ident||'.');
      if (v_identity_column_tbl_ident is not null) -- table has identity column, then standardize identity definition
      then
        if (p_identity_start is null) -- if p_identity_start is null then get nextval from current identity sequence and "identity trigger" sequence and compare both number to choose higher one
        then
          v_identity_start := get_identity_nextval(p_schema_name, p_table_name); -- get nextval from sequence for identity property on the column
          write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Sequence nextval for "identity property": v_identity_start = '||nvl(to_char(v_identity_start),'NULL')||'.');
          if (v_identity_start_column > v_identity_start)
          then
            v_identity_start := v_identity_start_column;
          end if;
        else
          v_identity_start := p_identity_start;
          if (v_identity_start < 1)
          then
            v_identity_start := 1;
          end if;
        end if;
        write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Start value for identity property calculated from trigger,max,identity property = '||nvl(to_char(v_identity_start),'NULL')||'.');

        -- chage data type (remove precision) from " NUMBER(xxx) GENERATED " to " NUMBER GENERATED "
        v_sql := regexp_replace(v_sql,
            '([[:space:]]{1,})NUMBER([[:space:]]{0,}\(.{1,}\)[[:space:]]{1,})GENERATED([[:space:]]{1,})',
            '\1NUMBER GENERATED \3',1,1,'i');
        /*
        \1 - ([[:space:]]{1,})
        \2 - ([[:space:]]{0,}\(.{1,}\)[[:space:]]{1,})
        \3 - ([[:space:]]{1,})
        */
            
        -- update identity clause
        v_sql := regexp_replace(v_sql,
            '([[:space:]]{1,})NUMBER([[:space:]]{1,})GENERATED([^,\)]{1,})(,|\))',
            '\1NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY (START WITH '||v_identity_start||' CACHE 1000 NOORDER)\4',1,1,'i');
        /*
        \1 - ([[:space:]]{1,})
        \2 - ([[:space:]]{1,})
        \3 - ([^,\)]{1,})
        \4 - (,|\))
        */
      else -- table does not have identity column, then add IDENTITY property to the existing column
        if (v_table_has_identity_trigger = 1 or v_table_has_identity_column = 1) -- check whether table has "identity trigger" or should have identity on column without identity trigger and without identity property
        then
          -- chage data type (remove precision) from "COLUMN_NAME NUMBER(xxx) " to "COLUMN_NAME NUMBER" where COLUMN_NAME is column name used by "identity trigger"
          write_log(c_log_message_type_info,'add_identity_property', 'add_identity_property','001','v_sql='||v_sql,0,'');
          v_sql := regexp_replace(v_sql,
              '("{0,1})'||v_identity_column||'("{0,1})([[:space:]]{1,})NUMBER([[:space:]]{0,}\(.{1,}\))',
              '\1'||v_identity_column||'\2\3NUMBER',1,1,'i');
          write_log(c_log_message_type_info,'add_identity_property', 'add_identity_property','001','v_sql='||v_sql,0,'');
          /*
          \1 - ("{0,1})
          \2 - ("{0,1})
          \3 - ([[:space:]]{1,})
          \4 - ([[:space:]]{0,}\(.{1,}\))
          \5 - (,|\))
          */
              
          -- add identity clause
          v_sql := regexp_replace(v_sql,
              '("{0,1})'||v_identity_column||'("{0,1})([[:space:]]{1,})NUMBER',
              '\1'||v_identity_column||'\2\3NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY (START WITH '||v_identity_start_column||' CACHE 1000 NOORDER)',1,1,'i');
          /*
          \1 - ("{0,1})
          \2 - ("{0,1})
          \3 - ([[:space:]]{1,})
          \4 - ([[:space:]]{0,})
          \5 - (,|\))
          */
          write_log(c_log_message_type_info,'add_identity_property', 'add_identity_property','001','v_sql='||v_sql,0,'');
        end if;
      end if;
    end if;
    dbms_metadata.close(v_handle);
    return v_sql;
  END;

  FUNCTION get_indexes_ddl(p_schema_name varchar2, p_table_name VARCHAR2, p_include_PARTITIONING boolean default true, p_include_SEGMENT_ATTRIBUTES boolean default true, p_include_TABLESPACE boolean default true, p_include_STORAGE boolean default true) RETURN clob IS
    v_handle number;
    v_handle_transform number;
    v_full_table_name varchar2(100);
    v_sql clob := null;
    v_sql_tmp clob := null;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20201,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20202,'missing p_table_name');
    end if;

    --do main part
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20203,'Table:'||v_full_table_name||' does not exists.');
    end if;
    v_sql := null;
    v_handle := dbms_metadata.open('INDEX');
    dbms_metadata.set_filter(v_handle,'SCHEMA',p_schema_name);
    dbms_metadata.set_filter(v_handle,'NAME_EXPR','IN (select all_indexes.index_name from all_indexes left outer join all_constraints on all_indexes.owner = all_constraints.owner and all_indexes.table_name = all_constraints.table_name and all_indexes.index_name = all_constraints.index_name where all_constraints.constraint_type is null and all_indexes.owner = '''||p_schema_name||''' and all_indexes.table_name = '''||p_table_name||''')');
    v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'DDL');
    dbms_metadata.set_transform_param (v_handle_transform,'PARTITIONING',p_include_PARTITIONING);
    dbms_metadata.set_transform_param (v_handle_transform,'SEGMENT_ATTRIBUTES',p_include_SEGMENT_ATTRIBUTES);
    dbms_metadata.set_transform_param (v_handle_transform,'TABLESPACE',p_include_TABLESPACE);
    dbms_metadata.set_transform_param (v_handle_transform,'STORAGE',p_include_STORAGE);
    loop
      v_sql_tmp := DBMS_METADATA.FETCH_CLOB(v_handle);
      exit when v_sql_tmp is null;
      v_sql := v_sql||v_sql_tmp;
    end loop;
    dbms_metadata.close(v_handle);
    return v_sql;
  END;

  FUNCTION get_triggers_ddl(p_schema_name varchar2, p_table_name VARCHAR2) RETURN clob IS
    v_handle number;
    v_handle_transform number;
    v_full_table_name varchar2(100);
    v_sql clob := null;
    v_sql_tmp clob := null;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20211,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20212,'missing p_table_name');
    end if;

    --do main part
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20213,'Table:'||v_full_table_name||' does not exists.');
    end if;
    v_sql := null;
    v_handle := dbms_metadata.open('TRIGGER');
    dbms_metadata.set_filter(v_handle,'SCHEMA',p_schema_name);
    dbms_metadata.set_filter(v_handle,'NAME_EXPR','IN (select TRIGGER_NAME from all_triggers where table_name = '''||p_table_name||''')');
    v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'DDL');
    loop
      v_sql_tmp := DBMS_METADATA.FETCH_CLOB(v_handle);
      exit when v_sql_tmp is null;
      v_sql := v_sql||v_sql_tmp;
    end loop;
    dbms_metadata.close(v_handle);
    return v_sql;
  END;

  FUNCTION get_index_ddl(p_schema_name varchar2, p_index_name VARCHAR2, p_new_index_name VARCHAR2 default null, p_include_PARTITIONING boolean default true, p_include_SEGMENT_ATTRIBUTES boolean default true, p_include_TABLESPACE boolean default true, p_include_STORAGE boolean default true) RETURN clob IS
    v_handle number;
    v_handle_transform number;
    v_sql clob := null;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20031,'missing p_schema_name');
    end if;
    if (p_index_name is null)
    then
      raise_application_error(-20032,'missing p_index_name');
    end if;

    --do main part
    v_handle := dbms_metadata.open('INDEX');
    dbms_metadata.set_filter(v_handle,'SCHEMA',p_schema_name);
    dbms_metadata.set_filter(v_handle,'NAME',p_index_name);
    if (p_new_index_name is not null)
    then
      v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'MODIFY');
      DBMS_METADATA.SET_REMAP_PARAM (v_handle_transform,'REMAP_NAME',p_index_name,p_new_index_name);
    end if;
    v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'DDL');
    dbms_metadata.set_transform_param (v_handle_transform,'PARTITIONING',p_include_PARTITIONING);
    dbms_metadata.set_transform_param (v_handle_transform,'SEGMENT_ATTRIBUTES',p_include_SEGMENT_ATTRIBUTES);
    dbms_metadata.set_transform_param (v_handle_transform,'TABLESPACE',p_include_TABLESPACE);
    dbms_metadata.set_transform_param (v_handle_transform,'STORAGE',p_include_STORAGE);
    v_sql := DBMS_METADATA.FETCH_CLOB(v_handle);
    dbms_metadata.close(v_handle);
    return v_sql;
  END;

  FUNCTION get_trigger_ddl(p_schema_name varchar2, p_trigger_name VARCHAR2, p_new_trigger_name VARCHAR2 default null) RETURN clob IS
    v_handle number;
    v_handle_transform number;
    v_sql clob := null;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20271,'missing p_schema_name');
    end if;
    if (p_trigger_name is null)
    then
      raise_application_error(-20272,'missing p_trigger_name');
    end if;

    --do main part
    v_sql := null;
    v_handle := dbms_metadata.open('TRIGGER');
    dbms_metadata.set_filter(v_handle,'SCHEMA',p_schema_name);
    dbms_metadata.set_filter(v_handle,'NAME',p_trigger_name);
    if (p_new_trigger_name is not null)
    then
      v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'MODIFY');
      DBMS_METADATA.SET_REMAP_PARAM (v_handle_transform,'REMAP_NAME',p_trigger_name,p_new_trigger_name);
    end if;
    v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'DDL');
    v_sql := DBMS_METADATA.FETCH_CLOB(v_handle);
    dbms_metadata.close(v_handle);
    return v_sql;
  END;

  FUNCTION get_constraint_ddl(p_schema_name varchar2, p_constraint_name VARCHAR2, p_new_constraint_name VARCHAR2 default null) RETURN clob IS
    v_handle number;
    v_handle_transform number;
    v_sql clob := null;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20281,'missing p_schema_name');
    end if;
    if (p_constraint_name is null)
    then
      raise_application_error(-20282,'missing p_constraint_name');
    end if;
    --do main part
    v_sql := null;
    v_handle := dbms_metadata.open('CONSTRAINT');
    dbms_metadata.set_filter(v_handle,'SCHEMA',p_schema_name);
    dbms_metadata.set_filter(v_handle,'NAME',p_constraint_name);
    if (p_new_constraint_name is not null)
    then
      v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'MODIFY');
      DBMS_METADATA.SET_REMAP_PARAM (v_handle_transform,'REMAP_NAME',p_constraint_name,p_new_constraint_name);
    end if;
    v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'DDL');
    v_sql := DBMS_METADATA.FETCH_CLOB(v_handle);
    dbms_metadata.close(v_handle);
    
    if (v_sql is null)
    then
      v_handle := dbms_metadata.open('REF_CONSTRAINT');
      dbms_metadata.set_filter(v_handle,'SCHEMA',p_schema_name);
      dbms_metadata.set_filter(v_handle,'NAME',p_constraint_name);
      if (p_new_constraint_name is not null)
      then
        v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'MODIFY');
        DBMS_METADATA.SET_REMAP_PARAM (v_handle_transform,'REMAP_NAME',p_constraint_name,p_new_constraint_name);
      end if;
      v_handle_transform := DBMS_METADATA.ADD_TRANSFORM(v_handle,'DDL');
      v_sql := DBMS_METADATA.FETCH_CLOB(v_handle);
      dbms_metadata.close(v_handle);
    end if;
    return v_sql;
  END;

  FUNCTION get_comments_ddl(p_schema_name varchar2, p_table_name VARCHAR2) RETURN clob IS
    v_comment_not_found exception;
    pragma exception_init(v_comment_not_found, -31608);
    v_full_table_name varchar2(100);
    v_sql clob := null;
  BEGIN
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20291,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20292,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20293,'Table:'||v_full_table_name||' does not exists.');
    end if;
    --do main part
    begin
      v_sql := dbms_metadata.get_dependent_ddl('COMMENT',p_table_name,p_schema_name);
    exception
    when v_comment_not_found then
      v_sql := null;
    end;
    return v_sql;
  END;

  ----------------------------------------------------------------------
  -- Control tracting routines
  -- opeations with local operation/log tables 
  ----------------------------------------------------------------------
  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_runtime in number,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null) RETURN number IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    INSERT INTO t_partition_log (PARTITION_GROUP_LOG_ID, MESSAGE_TYPE, PROC_NAME, OBJECT_INFO, STEP, MESSAGE, RUNTIME, DETAILS, BACKTRACE) 
    VALUES (gv_partition_group_log_id, p_message_type, p_proc_name, p_object_info, p_step, p_message, p_runtime, p_details, p_backtrace)
    returning partition_log_id into v_partition_log_id;
    COMMIT;
    return v_partition_log_id;
  exception
  when others then
    return null;
  END;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_start_time in date,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null) return number IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message,(sysdate-p_start_time)*24*60*60,p_details,p_backtrace);
    return v_partition_log_id;
  exception
  when others then
    return null;
  END;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in CLOB) return number IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message,-1,p_details,null);
    return v_partition_log_id;
  exception
  when others then
    return null;
  END;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in VARCHAR2) return number IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message,to_clob(p_details));
    return v_partition_log_id;
  exception
  when others then
    return null;
  END;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2) return number IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message,-1,null,null);
    return v_partition_log_id;
  exception
  when others then
    return null;
  END;

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_runtime in number,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null) IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message,p_runtime,p_details,p_backtrace);
  exception
  when others then
    null;
  END;


  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_start_time in date,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null) IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message, p_start_time,p_details,p_backtrace);
  exception
  when others then
    null;
  END;

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in CLOB) IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message,p_details);
  exception
  when others then
    null;
  END;

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in VARCHAR2) IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message,p_details);
  exception
  when others then
    null;
  END;

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2) IS
    v_partition_log_id t_partition_log.partition_log_id%type;
  BEGIN
    v_partition_log_id := write_log(p_message_type,p_proc_name,p_object_info,p_step,p_message);
  exception
  when others then
    null;
  END;

  PROCEDURE update_status(p_table_name VARCHAR2, p_status varchar2, p_status_description varchar2, p_partition_log_id number default null, p_rename_ddl clob default null, p_rename_ddl_insert_merge varchar2 default 'INSERT') IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    merge into T_PARTITION_STATUS tps
    using (select p_table_name table_name from dual) p
    on (tps.table_name = p.table_name  and tps.release_version = gv_release_version)
    when matched then
    UPDATE 
      SET status = p_status, status_description = p_status_description,
      rename_ddl = case
                    when p_rename_ddl is null then rename_ddl
                    when p_rename_ddl_insert_merge = 'INSERT' then p_rename_ddl
                    when p_rename_ddl_insert_merge = 'MERGE' then rename_ddl||chr(10)||p_rename_ddl
                    else null
                    end,
      md_time=sysdate, partition_log_id=p_partition_log_id
    when not matched then
      insert (table_name, status, status_description, rename_ddl, md_time, partition_log_id, release_version)
      values (p_table_name, p_status, p_status_description, p_rename_ddl, sysdate, p_partition_log_id, gv_release_version);
    commit;
  exception
  when others then
    null;
  END;

  PROCEDURE update_partition_backup_table(p_table_name VARCHAR2, p_backup_table_name VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    update T_PARTITION_CFG
    set backup_table_name = p_backup_table_name
    where table_name = p_table_name and release_version = gv_release_version and nvl(backup_table_name,p_table_name) != p_backup_table_name;
    commit;
  exception
  when others then
    rollback;
    null;
  END;


  ----------------------------------------------------------------------
  -- Utils routines
  -- can access to local config tables if needed
  ----------------------------------------------------------------------
  procedure do_drop_table(p_schema_name varchar2, p_table_name VARCHAR2, p_drop_table_with_data number default 0) IS
    v_proc_name t_partition_log.proc_name%type := 'do_drop_table';
    v_object_info t_partition_log.object_info%type;
    v_full_table_name varchar2(100);
    v_table_is_empty boolean;
    v_sql varchar2(32767);
    v_start_time date;
  BEGIN
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20061,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20062,'missing p_table_name');
    end if;

    --do main part
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name, p_table_name))
    then
      v_table_is_empty := check_is_table_empty(p_schema_name, p_table_name);
      if ((p_drop_table_with_data=0) and (v_table_is_empty=false)) -- table should be empty (without data) and is not empty
      then -- check if table is empty
        raise_application_error(-20063,'There are data in '||v_full_table_name||' but table should be empty.');
      end if;
      v_sql := 'drop table '||v_full_table_name;
      write_log(c_log_message_type_info,v_proc_name,v_object_info,'001','Dropping table: '||v_full_table_name, 0, 'SQL stmnt: '||v_sql, null);
      v_start_time := sysdate;
      execute immediate v_sql;
      write_log(c_log_message_type_info,v_proc_name,v_object_info, '002','Table: '||v_full_table_name||' successfully dropped.',v_start_time);
    else
      if (check_mview_exists(p_schema_name, p_table_name))
      then
        v_sql := 'drop materialized view '||v_full_table_name;
        write_log(c_log_message_type_info,v_proc_name,v_object_info,'004','Dropping materialized view: '||v_full_table_name, 0, 'SQL stmnt: '||v_sql, null);
        v_start_time := sysdate;
        execute immediate v_sql;
        write_log(c_log_message_type_info,v_proc_name,v_object_info, '005','Table: '||v_full_table_name||' successfully dropped.',v_start_time);
      end if;
    end if;
  exception
  when others then
    write_log(c_log_message_type_error, v_proc_name, v_object_info, '100','Dropping table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise; -- to catch an error in calling procedure
  END;


  PROCEDURE do_backup_table(p_source_schema_name varchar2, p_source_table_name VARCHAR2, p_bkp_schema_name varchar2, p_bkp_table_name VARCHAR2) IS
    v_proc_name t_partition_log.proc_name%type := 'do_backup_table';
    v_object_info t_partition_log.object_info%type;
    v_full_source_table_name varchar2(100);
    v_full_bkp_table_name varchar2(100);
    v_sql varchar2(32767);
    v_start_time date;
  BEGIN
   v_object_info := p_source_table_name;
    --checking parameters
    if (p_source_schema_name is null)
    then
      raise_application_error(-20071,'missing p_source_schema_name');
    end if;
    if (p_source_table_name is null)
    then
      raise_application_error(-20072,'missing p_source_table_name');
    end if;
    if (p_bkp_schema_name is null)
    then
      raise_application_error(-20073,'missing p_bkp_schema_name');
    end if;
    if (p_bkp_table_name is null)
    then
      raise_application_error(-20074,'missing p_bkp_table_name');
    end if;

    --do main part
    v_full_source_table_name := p_source_schema_name||'.'||p_source_table_name;
    v_full_bkp_table_name := p_bkp_schema_name||'.'||p_bkp_table_name;

    if (check_table_exists(p_source_schema_name,p_source_table_name) = false) -- check whether source table does not exist
    then
      raise_application_error(-20075,'Source table '||v_full_source_table_name||' does not exist.');
    end if;

    if (check_table_exists(p_bkp_schema_name,p_bkp_table_name) = true) -- check whether backup table exists
    then
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'001','Backup table '||v_full_bkp_table_name||' exists then drop it.');
      do_drop_table(p_bkp_schema_name,p_bkp_table_name,p_drop_table_with_data=>0); -- drop table only when there are no data; p_drop_table_with_data=0
    end if;
    v_sql := 'create table '||v_full_bkp_table_name||' as select * from '||v_full_source_table_name;
    write_log(c_log_message_type_info, v_proc_name, v_object_info,'002','Creating backup table: '||v_full_bkp_table_name,v_sql);
    v_start_time := sysdate;
    execute immediate v_sql;
    update_partition_backup_table(p_source_table_name, p_bkp_table_name);
    write_log(c_log_message_type_info, v_proc_name, v_object_info,'003','Backup table: '||v_full_bkp_table_name||' successfully created.',v_start_time);
  exception
  when others then
    write_log(c_log_message_type_error, v_proc_name, v_object_info,'100','Error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise; -- to catch an error in calling procedure
  END;

  PROCEDURE grant_table_privs(p_table_name varchar2 default null) is
    v_proc_name t_partition_log.proc_name%type := 'grant_table_privs';
    v_object_info t_partition_log.object_info%type;
    v_sql varchar2(32767);
    v_start_time date;
  BEGIN
    v_object_info := p_table_name;
    write_log(c_log_message_type_info, v_proc_name, v_object_info,'001','Grant priviledges for: '||nvl(p_table_name,'ALL tables'));
    for obj in (
      select obj.object_name, config.privilege, config.user_or_role_name
      from t_privs_config config inner join user_objects obj on  
        (case
        when lower(config.object_name) = 'all' then lower(obj.object_name)
        else lower(config.object_name)
        end) = lower(obj.object_name)
        and lower(config.object_type) = lower(obj.object_type)
        where lower(config.object_type) = 'table'
        and nvl(p_table_name,obj.object_name) = obj.object_name 
    )
    loop 
      v_sql := 'grant ' || obj.privilege ||' on '|| c_schema_name ||'.'|| obj.object_name ||' to ' || obj.user_or_role_name;
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'002','grant ' || obj.privilege ||' on '|| c_schema_name ||'.'|| obj.object_name ||' to ' || obj.user_or_role_name,v_sql);
      v_start_time := sysdate;
      execute immediate v_sql;
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'003','grant finshed successfully.',v_start_time);
    end loop ; 
    write_log(c_log_message_type_info, v_proc_name, v_object_info,'001','Grant priviledges for: '||nvl(p_table_name,'ALL tables')||' finshed successfully.');
  exception
  when others then
    write_log(c_log_message_type_error, v_proc_name, v_object_info,'100','Error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise; -- to catch an error in calling procedure
  END;

  FUNCTION recompile_invalid_objects(p_schema_name varchar2) return number is
    v_proc_name t_partition_log.proc_name%type := 'recompile_invalid_objects';
    v_object_info t_partition_log.object_info%type;
    v_sql varchar2(32767);
    v_start_time date;
    v_error_cnt number := 0;
  BEGIN
    v_object_info := p_schema_name;
    write_log(c_log_message_type_info, v_proc_name, v_object_info,'001','Recompile invalid objects for schema: '||p_schema_name);
    for obj in (
      select owner,
        object_name,
        object_type,
        decode(object_type, 'PACKAGE', 1,
                            'PACKAGE BODY', 2, 2) as recompile_order
        FROM   all_objects
        WHERE  status != 'VALID'
        and nvl(p_schema_name,owner) = owner 
        ORDER BY 4,object_type
    )
    loop
      if (obj.object_type = 'PACKAGE BODY') then
        v_sql :=  'ALTER PACKAGE "' || obj.owner || '"."' || obj.object_name || '" COMPILE BODY';
      else
        v_sql :=  'ALTER ' || obj.object_type || ' "' || obj.owner || '"."' || obj.object_name || '" COMPILE';
      end if;
      v_object_info := obj.object_type||' '||obj.object_name;
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'002','Recompile '|| obj.object_type ||' '|| obj.object_name,v_sql);
      v_start_time := sysdate;
      begin
        execute immediate v_sql;
        write_log(c_log_message_type_info, v_proc_name, v_object_info,'003','Recompilation for: ' || obj.object_type ||' '|| obj.object_name||' finshed successfully.',v_start_time,v_sql);
      exception
      when others then
        v_error_cnt := v_error_cnt + 1;
        write_log(c_log_message_type_error, v_proc_name, v_object_info,'101','Recompilation for: ' || obj.object_type ||' '|| obj.object_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      end;
    end loop ; 
    if (v_error_cnt=0)
    then
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'004','Recompile invalid objects for schema: '||p_schema_name||' finshed successfully.');
    else
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'004','Recompile invalid objects for schema: '||p_schema_name||' finshed with '||v_error_cnt||' error(s), check t_partition_log for details.');
    end if;
    return v_error_cnt;
  exception
  when others then
    write_log(c_log_message_type_error, v_proc_name, v_object_info,'100','Error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise; -- to catch an error in calling procedure
  END;

  FUNCTION disable_inmemory(p_schema_name varchar2, p_table_name varchar2 default null) return number is
    v_proc_name t_partition_log.proc_name%type := 'disable_inmemory';
    v_object_info t_partition_log.object_info%type;
    v_sql varchar2(32767);
    v_start_time date;
    v_error_cnt number := 0;
  BEGIN
    if (p_table_name is null)
    then
      write_log(c_log_message_type_info, v_proc_name, p_schema_name,'001','Disable INMEMORY for all tables in schema: '||p_schema_name);
    else
      write_log(c_log_message_type_info, v_proc_name, p_table_name,'001','Disable INMEMORY for table: '||p_schema_name||'.'||p_table_name);
    end if;
    
    for obj in (
      select table_name from all_tables where owner = p_schema_name and p_table_name is null union all
      select p_table_name table_name from dual where p_table_name is not null
    )
    loop
      v_object_info := obj.table_name;
      v_sql := 'ALTER TABLE '||p_schema_name||'.'||v_object_info||'  NO INMEMORY';
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'002','Disable INMEMORY for table: '||p_schema_name||'.'||v_object_info,v_sql);
      v_start_time := sysdate;
      begin
        execute immediate v_sql;
        write_log(c_log_message_type_info, v_proc_name, v_object_info,'003','Disable INMEMORY for table: '||p_schema_name||'.'||v_object_info||' finshed successfully.',v_start_time,v_sql);
      exception
      when others then
        v_error_cnt := v_error_cnt + 1;
        write_log(c_log_message_type_error, v_proc_name, v_object_info,'101','Disable INMEMORY for table: '||p_schema_name||'.'||v_object_info||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      end;
    end loop;
    
    if (v_error_cnt=0)
    then
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'004','Disable INMEMORY finshed successfully.');
    else
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'004','Disable INMEMORY finshed with '||v_error_cnt||' error(s), check t_partition_log for details.');
    end if;
    return v_error_cnt;
  exception
  when others then
    write_log(c_log_message_type_error, v_proc_name, v_object_info,'100','Error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise; -- to catch an error in calling procedure
  END;

  
  function get_interim_table_name(p_table_name VARCHAR2) return varchar2 is
    v_interim_table_name t_partition_cfg.interim_table_name%type;
  begin
    begin
      select interim_table_name into v_interim_table_name from t_partition_cfg where table_name = p_table_name and release_version = gv_release_version;
    exception
    when others then
      v_interim_table_name := null;
    end;
    if (v_interim_table_name is null)
    then
      v_interim_table_name := generate_tmp_name(); 
    end if;
    return v_interim_table_name;
  end;

  function get_backup_table_name(p_table_name VARCHAR2, p_old_table_name VARCHAR2 default null) return varchar2 is
    v_backup_table_name t_partition_cfg.backup_table_name%type;
  begin
    begin
      select backup_table_name into v_backup_table_name from t_partition_cfg where table_name = p_table_name and release_version = gv_release_version;
    exception
    when others then
      v_backup_table_name := null;
    end;
    if (v_backup_table_name is null)
    then
      if (p_old_table_name is null) then
        v_backup_table_name := generate_tmp_name();
      else
        v_backup_table_name := p_old_table_name;
      end if;
    end if;
    return v_backup_table_name;
  end;


  function calc_redefinition_method(p_schema_name varchar2, p_table_name VARCHAR2) RETURN varchar2 IS
    v_proc_name t_partition_log.proc_name%type :=  'calc_redefinition_method';
    v_object_info t_partition_log.object_info%type;
    v_full_table_name varchar2(100);
    v_start_time date;
    v_redefinition_method varchar2(10);
    v_err_msg clob;
  BEGIN
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20081,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20082,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;
    --do main part
    
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20083,'Table:'||v_full_table_name||' does not exists.');
    end if;

    v_redefinition_method := null;
    
    --check whether table has identity column, if yes then table cannot be redefined using dbms_redefinition package and do_drop_create_insert should be used
    write_log(c_log_message_type_info, v_proc_name, v_object_info,'001','Check whether table: '||v_full_table_name||' has identity column.');
    if (get_identity_column_name(p_schema_name, p_table_name) is not null) -- table has identity column
    then
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'002','Table: '||v_full_table_name||' has identity column then should be redefined using do_drop_create_insert function and cannot be redefined using dbms_redefinition.', v_start_time);
      v_redefinition_method := 'IDENTITY';
    end if;

    -- check whether table can be redefined using PK method
    if (v_redefinition_method is null)
    then
      v_redefinition_method := 'PK';
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'003','Check whether table: '||v_full_table_name||' can be redefined using PK redefinition method.');
      begin
        v_start_time := sysdate;
        DBMS_REDEFINITION.can_redef_table(p_schema_name, p_table_name);
        write_log(c_log_message_type_info, v_proc_name, v_object_info,'004','Table: '||v_full_table_name||' can be redefined using PK redefinition method.', v_start_time);
      exception
      when others then
        v_err_msg := 'Table: '||v_full_table_name||' cannot be redefined using PK redefinition method due to error: '||sqlcode||'('||sqlerrm||').';
        write_log(c_log_message_type_info, v_proc_name, v_object_info,'005','Table: '||v_full_table_name||' cannot be redefined using PK redefinition method due to error: '||sqlcode||'('||sqlerrm||').', v_start_time);
        v_redefinition_method := 'ROWID';
      end;
    end if;

    -- if table cannot be redefined using PK method then check whether table canbe redefined using ROWID method
    if (v_redefinition_method = 'ROWID')
    then
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'006','Table '||v_full_table_name||' cannot be redefined using PK redefinition method then check whether it can be redefined using ROWID redefinition method.');
      begin
        v_start_time := sysdate;
        DBMS_REDEFINITION.can_redef_table(p_schema_name, p_table_name,dbms_redefinition.cons_use_rowid);
        write_log(c_log_message_type_info, v_proc_name, v_object_info,'007','Table: '||v_full_table_name||' can be redefined using ROWID redefinition method.', v_start_time);
      exception
      when others then
        write_log(c_log_message_type_info, v_proc_name, v_object_info,'008','Table: '||v_full_table_name||' cannot be redefined using ROWID redefinition method due to error: '||sqlcode||'('||sqlerrm||').', v_start_time);
        v_redefinition_method := null;
      end;
    end if;
    
    if (v_redefinition_method is null)
    then
      write_log(c_log_message_type_error, v_proc_name, v_object_info,'101','Table: '||v_full_table_name||' cannot be redefined using PK and ROWID redefinition methods and does not have IDENTITY column. For detailed reason check '||c_log_message_type_info||' logs for proc_name:'||v_proc_name||', object_info:'||v_object_info||', steps 003 and 006.');
      raise_application_error(-20084,'Table: '||v_full_table_name||' cannot be redefined using PK and ROWID redefinition methods. For detailed reason check '||c_log_message_type_info||' logs for proc_name:'||v_proc_name||', object_info:'||v_object_info||', steps 003 and 006.');
    end if;
    return v_redefinition_method;
  END;

  function gen_partition_clause(p_schema_name varchar2, p_table_name VARCHAR2) return clob AS
    v_proc_name t_partition_log.proc_name%type := 'gen_partition_clause';
    v_object_info t_partition_log.object_info%type;
    v_partition_column t_partition_cfg.partition_column%type;
    v_partition_type t_partition_cfg.partition_type%type;
    v_partition_value t_partition_cfg.partition_value%type;
    v_partition_count t_partition_cfg.partition_count%type;
    v_partition_period t_partition_cfg.partition_period%type;
    v_partition_cnt pls_integer;
    v_partition_ddl t_partition_cfg.partition_ddl%type;
    v_partition_sql clob;
    v_partition_name varchar2(100);
    v_partition_less_then_value varchar2(100);
    v_full_table_name varchar2(100);
  BEGIN
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20091,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20092,'missing p_table_name');
    end if;

    --do main part
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20093,'Table:'||v_full_table_name||' does not exists.');
      null;
    end if;

    begin
      select partition_column,upper(partition_type),upper(nvl(partition_value,'')),partition_count,upper(nvl(partition_period,'')),partition_ddl into v_partition_column,v_partition_type,v_partition_value,v_partition_count,v_partition_period,v_partition_ddl from t_partition_cfg where table_name = p_table_name and release_version = gv_release_version;
      write_log(c_log_message_type_info, v_proc_name, v_object_info,'001','Partition configuration for table: '||p_table_name||' is: partition_column='||v_partition_column||', partition_type='||v_partition_type||', partition_value='||nvl(v_partition_value,'-')||', v_partition_count='||v_partition_count||', v_partition_period='||v_partition_period);
    exception
    when no_data_found then
      write_log(c_log_message_type_error, v_proc_name, v_object_info,'104','Partition configuration for table: '||p_table_name||' not found.');
      raise_application_error(-20094,'Partition configuration for table: '||p_table_name||' not found.');
    end;
    if (v_partition_type is null) -- if PARTITION_TYPE is null then remove partitions
    then
      v_partition_sql := null;
    else
      if (v_partition_type='DDL' or v_partition_type='STANDARDIZE_IDENTITY')
      then
        if (v_partition_type='DDL')
        then
          v_partition_sql := v_partition_ddl;
        else
          v_partition_sql := 'STANDARDIZE_IDENTITY';
        end if;
      else
        if (v_partition_column is null)
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'105','Empty PARTITION_COLUMN in configuration for table which is required.'||p_table_name||'.');
          raise_application_error(-20095,'Empty PARTITION_COLUMN in configuration for table'||p_table_name||'.');
        end if;
        if (check_column_in_table_exists(p_schema_name, p_table_name, v_partition_column) = false)
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'106','Column: '||v_partition_column||' does not exists in table '||p_table_name);
          raise_application_error(-20096,'Column: '||v_partition_column||' does not exists in table '||p_table_name);
        end if;
        if (v_partition_type not in ('RANGE','INTERVAL','LIST','STANDARDIZE_IDENTITY'))
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'107','Partition type: '||v_partition_type||' for table '||p_table_name||' is incorect. Allowed types are: RANGE,INTERVAL,LIST,STANDARDIZE_IDENTITY');
          raise_application_error(-20097,'Partition type: '||v_partition_type||' for table '||p_table_name||' is incorect. Allowed types are: RANGE,INTERVAL,LIST,STANDARDIZE_IDENTITY');
        end if;
      end if;
      if (v_partition_type='RANGE')
      then
        if (v_partition_count is null)
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'108','Empty PARTITION_COUNT (which is required for PARTITION_TYPE=RANGE) in configuration for table'||p_table_name||'.');
          raise_application_error(-20098,'Empty PARTITION_COUNT (which is required for PARTITION_TYPE=RANGE) in configuration for table'||p_table_name||'.');
        end if;
        if (v_partition_period is null)
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'109','Empty PARTITION_PERIOD (which is required for PARTITION_TYPE=RANGE) in configuration for table'||p_table_name||'.');
          raise_application_error(-20099,'Empty PARTITION_PERIOD (which is required for PARTITION_TYPE=RANGE) in configuration for table'||p_table_name||'.');
        end if;
        if (v_partition_period not in ('MONTH','DAY'))
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'110','Incorrect PARTITION_PERIOD='||v_partition_period||' in configuration for table'||p_table_name||'. Allowed PERIODs are: DAY or MONTH.');
          raise_application_error(-20100,'Incorrect PARTITION_PERIOD='||v_partition_period||' in configuration for table'||p_table_name||'. Allowed PERIODs are: DAY or MONTH.');
        end if;
        v_partition_sql := ' partition by RANGE ('||v_partition_column||')';
        v_partition_sql := v_partition_sql || '(PARTITION P'||to_char(c_first_range_partition_date,'YYYYMMDD')||' VALUES LESS THAN (TO_DATE('''||to_char(c_first_range_partition_date,'YYYY-MM-DD HH24:MI:SS')||''', ''YYYY-MM-DD HH24:MI:SS''))';
        for v_i in 1..v_partition_count
        loop
          if (v_partition_period='DAY')
          then
            v_partition_name := 'P'||to_char(c_first_range_partition_date+v_i,'YYYYMMDD');
            v_partition_less_then_value := to_char(c_first_range_partition_date+v_i,'YYYY-MM-DD HH24:MI:SS');
          end if;
          if (v_partition_period='MONTH')
          then
            v_partition_name := 'P'||to_char(add_months(c_first_range_partition_date,v_i),'YYYYMMDD');
            v_partition_less_then_value := to_char(add_months(c_first_range_partition_date,v_i),'YYYY-MM-DD HH24:MI:SS');
          end if;
          v_partition_sql := v_partition_sql || ' ,PARTITION '||v_partition_name||' VALUES LESS THAN (TO_DATE('''||v_partition_less_then_value||''', ''YYYY-MM-DD HH24:MI:SS''))';
        end loop;
        v_partition_sql := v_partition_sql || ' ,PARTITION PMAX VALUES LESS THAN (MAXVALUE)';
        v_partition_sql := v_partition_sql || ')';
      end if;
      if (v_partition_type='INTERVAL')
      then
        if (v_partition_period not in ('MONTH','DAY'))
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'111','Incorrect PARTITION_PERIOD='||v_partition_period||' in configuration for table'||p_table_name||'. Allowed PERIODs are: DAY or MONTH.');
          raise_application_error(-20101,'Incorrect PARTITION_PERIOD='||v_partition_period||' in configuration for table'||p_table_name||'. Allowed PERIODs are: DAY or MONTH.');
        end if;
        v_partition_sql := ' partition by RANGE ('||v_partition_column||')';
        if (v_partition_value='DAY')
        then
          v_partition_sql := v_partition_sql || ' INTERVAL( NUMTODSINTERVAL(1,''DAY''))';
        else -- v_partition_value=MONTH
          v_partition_sql := v_partition_sql || ' INTERVAL( NUMTOYMINTERVAL(1,''MONTH''))';
        end if;
        v_partition_sql := v_partition_sql || '(PARTITION P19000101 VALUES LESS THAN (TO_DATE(''1900-01-01 00:00:00'', ''YYYY-MM-DD HH24:MI:SS'')))';
      end if;
      if (v_partition_type='LIST')
      then
        if (v_partition_value is null)
        then
          write_log(c_log_message_type_error, v_proc_name, v_object_info,'112','Empty PARTITION_VALUE (which is required for PARTITION_TYPE=LIST) in configuration for table'||p_table_name||'.');
          raise_application_error(-20102,'Empty PARTITION_VALUE (which is required for PARTITION_TYPE=LIST) in configuration for table'||p_table_name||'.');
        end if;
        v_partition_sql := ' partition by LIST('||v_partition_column||')';
        v_partition_cnt := c_first_list_partition_num;
        v_partition_sql := v_partition_sql || ' (';
        for c_partition_value in
          (
            select regexp_substr (v_partition_value, '[^,]+',1, rownum) partition_value
            from dual
            connect by level <= regexp_count (v_partition_value, '[^,]+')
          )
        loop
          v_partition_sql := v_partition_sql || ' PARTITION P_'||v_partition_cnt||' VALUES ('''||c_partition_value.partition_value||'''),';
          v_partition_cnt := v_partition_cnt + 1;
        end loop;
        v_partition_sql := v_partition_sql || ' PARTITION P_DEFAULT VALUES (DEFAULT)';
        v_partition_sql := v_partition_sql || ' )';
      end if;
    end if;
    write_log(c_log_message_type_info, v_proc_name, v_object_info,'002','Generation partition clause for table: '||p_table_name||' successfull',v_partition_sql);
    return v_partition_sql;
  exception
  when others then
    write_log(c_log_message_type_error, v_proc_name, v_object_info,'100','Generation partition clause for table: '||p_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',-1,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise; -- to catch an error in calling procedure
  END;

  function gen_interm_table(p_schema_name varchar2, p_table_name VARCHAR2, p_new_table_name VARCHAR2 default null) RETURN clob IS
    v_proc_name t_partition_log.proc_name%type := 'gen_interm_table';
    v_object_info t_partition_log.object_info%type;
    v_sql clob;
    v_partition_sql clob;
    v_start_time date;
    v_full_table_name varchar2(100);
  BEGIN
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20111,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20112,'missing p_table_name');
    end if;
    if (length(nvl(p_new_table_name,'x')) > 30)
    then
      raise_application_error(-20113,'p_new_table_name='||p_new_table_name||' length is too long, max allowed is 30 characters.');
    end if;

    --do main part
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20114,'Table:'||v_full_table_name||' does not exists.');
    end if;
    write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Generate DDL without PARTITION clause for table: '||p_table_name||'.');
    v_start_time := sysdate;
    v_sql := get_table_ddl(p_schema_name, p_table_name, p_new_table_name, p_include_CONSTRAINTS => false, p_include_REF_CONSTRAINTS=>false, p_include_PARTITIONING=>false, p_include_SEGMENT_ATTRIBUTES=>true, p_include_TABLESPACE=>true, p_include_STORAGE=>true);
    write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','DDL without PARTITION clause for table: '||p_table_name||' is successfully created.',v_start_time,v_sql);

    write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Generate PARTITION DDL for table: '||p_table_name||'.');
    v_start_time := sysdate;
    v_partition_sql := gen_partition_clause (p_schema_name, p_table_name);
    write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','PARTITION DDL for table: '||p_table_name||' is successfully created.',v_start_time,v_partition_sql);
    v_sql := v_sql || ' ' || v_partition_sql;
    write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Full DDL script for: '||p_table_name||' is successfully created.',v_sql);
    return v_sql;
  EXCEPTION
  when others then
    write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','PARTITION DDL for table: '||p_table_name||' is not created due to error: '||sqlcode||'('||sqlerrm||')',-1,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    raise;
  END;

  function do_redefine_table(p_schema_name varchar2, p_table_name VARCHAR2) return number AS
  --https://docs.oracle.com/database/121/ADMIN/tables.htm#GUID-3C702CE8-9676-4825-B92A-D4AFE78FE402  
    v_proc_name t_partition_log.proc_name%type := 'do_redefine_table';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_full_table_name varchar2(100);
    v_full_table_name_int varchar2(100);
    v_redefinition_method varchar2(10);
    v_redefinition_status number;
    v_sql clob;
    v_tbl_int varchar2(30);
    v_cp_tbl_depend_num_errors pls_integer;
    v_start_time date;
    v_start_time_full date;
  BEGIN
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20121,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20122,'missing p_table_name');
    end if;
    v_full_table_name := p_schema_name||'.'||p_table_name;
    if (check_table_exists(p_schema_name,p_table_name)=false)
    then
      raise_application_error(-20123,'Table:'||v_full_table_name||' does not exists.');
    end if;
    v_redefinition_status := 0;
    v_tbl_int := get_interim_table_name(p_table_name); 
    v_full_table_name_int := p_schema_name||'.'||v_tbl_int;

    --do main part
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Redefining table: '||v_full_table_name);
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,v_proc_name||': in progress',v_partition_log_id);
    
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Check whether table: '||v_full_table_name||' and caculate redefinition method.');
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'calc_redefinition_method: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_redefinition_method := calc_redefinition_method(p_schema_name, p_table_name);
        if (v_redefinition_method = 'PK' or v_redefinition_method = 'ROWID')
        then
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Table: '||v_full_table_name||' can be repartitioned using '||v_redefinition_method||' redefinition method.',v_start_time);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'calc_redefinition_method: OK',v_partition_log_id);
        else
          raise_application_error(-20124,'Table cannot be redefined by dbms_redefinition using '||v_redefinition_method||' method. Allowed methods are PK and ROWID.');
        end if;
      exception
      when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Table: '||v_full_table_name||' cannot be repartitioned due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      update_status(p_table_name,'FAILED '||v_proc_name,'calc_redefinition_method: NOK',v_partition_log_id);
      v_redefinition_status :=  1; -- cannot be redefined due to error from can_redef_table
      end;
    
    if (v_redefinition_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Generate interim table DDL for table: '||v_full_table_name||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'gen_interm_table: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql := gen_interm_table(p_schema_name,p_table_name,v_tbl_int);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Generate interim table DDL for table: '||v_full_table_name||' is successful.',v_start_time,v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'gen_interm_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Generate interim table DDL for table: '||v_full_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'gen_interm_table: NOK',v_partition_log_id);
        v_redefinition_status := 2; -- cannot be redefined due to error from gen_interm_table
      end;
    end if;
    if (v_redefinition_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Dropping interim table: '||v_tbl_int||'.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_drop_table: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        do_drop_table(p_schema_name, v_tbl_int, 1);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Table: '||v_tbl_int||' successfully dropped.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_drop_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'103','Table: '||v_tbl_int||' cannot be drop due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'do_drop_table: NOK',v_partition_log_id);
        v_redefinition_status := 3; -- cannot be redefined due to error from do_drop_table
      end;
    end if;

    if (v_redefinition_status=0)
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'008','Create intermediate table: '||v_tbl_int||' by execute intermediate DDL script.',v_sql);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'create intermediate table: in progress',v_partition_log_id);
        v_start_time := sysdate;
        execute immediate v_sql;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'009','Intermediate table: '||v_tbl_int||' successfully created.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'create intermediate table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'104','Intermediate table: '||v_tbl_int||' cannot be created due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'create intermediate table: NOK',v_partition_log_id);
        v_redefinition_status := 4;
      end;
    end if;

    if (v_redefinition_status=0 and v_redefinition_method='ROWID')
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'010','Due to ROWID redefinition method enable row movement for intermediate table: '||v_tbl_int||'.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'enable_row_movement: in progress',v_partition_log_id);
        v_start_time := sysdate;
        enable_row_movement(p_schema_name, v_tbl_int);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'011','Row movement for intermediate table: '||v_tbl_int||' successfully enabled.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'enable_row_movement: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'105','Row movement for intermediate table: '||v_tbl_int||' cannot be enabled due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'enable_row_movement: NOK',v_partition_log_id);
        v_redefinition_status := 5;
      end;
    end if;

    if (v_redefinition_status=0)
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'012','Abort previously executed redefinition.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'abort_redef_table: in progress',v_partition_log_id);
        v_start_time := sysdate;
        DBMS_REDEFINITION.abort_redef_table(
          uname      => p_schema_name,        
          orig_table => p_table_name,
          int_table  => v_tbl_int);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'013','Previously executed redefinition aborted.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'abort_redef_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'106','Previously executed redefinition cannot be aborted due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'abort_redef_table: NOK',v_partition_log_id);
        v_redefinition_status := 6; -- cannot be redefined due to error
      end;
    end if;


    if (v_redefinition_status=0)
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'014','Start redefinition.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'start_redef_table: in progress');
        v_start_time := sysdate;
        if (v_redefinition_method='PK')
        then
          DBMS_REDEFINITION.start_redef_table(
            uname      => p_schema_name,        
            orig_table => p_table_name,
            int_table  => v_tbl_int);
        else --ROWID
          DBMS_REDEFINITION.start_redef_table(
            uname      => p_schema_name,        
            orig_table => p_table_name,
            int_table  => v_tbl_int,
            options_flag => dbms_redefinition.cons_use_rowid);
        end if;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'015','Redefinition started successfully.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'start_redef_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'107','Redefinition cannot be started due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'start_redef_table: NOK',v_partition_log_id);
        v_redefinition_status := 7;
      end;
    end if;
    
    if (v_redefinition_status=0)
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'016','Copy table dependents.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'copy_table_dependents: in progress',v_partition_log_id);
        v_start_time := sysdate;
        DBMS_REDEFINITION.copy_table_dependents(
          uname            => p_schema_name,
          orig_table       => p_table_name,
          int_table        => v_tbl_int,
          copy_indexes     => DBMS_REDEFINITION.cons_orig_params,
          copy_triggers    => TRUE,
          copy_constraints => TRUE,
          copy_privileges  => TRUE,
          ignore_errors    => FALSE,
          num_errors       => v_cp_tbl_depend_num_errors,
          copy_statistics  => FALSE,
          copy_mvlog       => FALSE);
        if (v_cp_tbl_depend_num_errors = 0)
        then
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'017','Copy table dependents finished successfully.',v_start_time);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'copy_table_dependents: OK',v_partition_log_id);
        else
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'108','Copy table dependents finished unsuccessful due to '||v_cp_tbl_depend_num_errors||' errors.',v_start_time);
          update_status(p_table_name,'FAILED '||v_proc_name,'copy_table_dependents: NOK',v_partition_log_id);
          v_redefinition_status := 8;
        end if;
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'109','Table dependents cannot by copied due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'copy_table_dependents: NOK',v_partition_log_id);
        v_redefinition_status := 9;
      end;
    end if;

    if (v_redefinition_status=0)
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'018','Sync interim table.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'sync_interim_table: in progress',v_partition_log_id);
        v_start_time := sysdate;
        DBMS_REDEFINITION.sync_interim_table(
          uname            => p_schema_name,
          orig_table       => p_table_name,
          int_table        => v_tbl_int);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'019','Sync interim table successfull.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'sync_interim_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'110','Sync interim table failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'sync_interim_table: NOK',v_partition_log_id);
        v_redefinition_status := 10;
      end;
    end if;

    if (v_redefinition_status=0)
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'020','Finish redefinition.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'finish_redef_table: in progress',v_partition_log_id);
        v_start_time := sysdate;
        DBMS_REDEFINITION.finish_redef_table(
          uname            => p_schema_name,
          orig_table       => p_table_name,
          int_table        => v_tbl_int);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'021','Finish redefinition successfull.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'finish_redef_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'111','Finish redefinition failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'finish_redef_table: NOK',v_partition_log_id);
        v_redefinition_status := 11;
      end;
    end if;

    if (v_redefinition_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'022','Dropping interim table: '||v_tbl_int||' after redefine.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'interim table do_drop_table: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        do_drop_table(p_schema_name, v_tbl_int, 1);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'023','Table: '||v_tbl_int||' successfully dropped.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'interim table do_drop_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'112','Table: '||v_tbl_int||' cannot be drop due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'interim table do_drop_table: NOK',v_partition_log_id);
        v_redefinition_status := 12; -- cannot be redefined due to error from do_drop_table
      end;
    end if;
    if (v_redefinition_status=0 and v_redefinition_method='ROWID')
    then
      begin
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'024','Due to ROWID redefinition method drop unused columns.');
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'drop unused columns: in progress',v_partition_log_id);
        v_sql := 'alter table '||v_full_table_name||' DROP UNUSED COLUMNS';
        v_start_time := sysdate;
        execute immediate v_sql;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'025','Unused columns successfully dropped.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'drop unused columns: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'113','Unused columns cannot be drop due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'drop unused columns: NOK',v_partition_log_id);
        v_redefinition_status := 13;
      end;
    end if;
    -- grant table priviledges
    if (v_redefinition_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'026','Grant priviledges.');
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'Grant priviledges: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        grant_table_privs(p_table_name);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'027','Grant priviledges.',v_start_time);
        update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'Grant priviledges: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'114','Grant priviledges failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_table_name,'FAILED '||v_proc_name,'Grant priviledges: NOK',v_partition_log_id);
        v_redefinition_status := 14;
      end;
    end if;

    if (v_redefinition_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'026','Redefinition finshed successfully.',v_start_time_full);
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'table successfully redefined in '||round((sysdate - v_start_time_full) * 24*60*60)||' seconds.',v_partition_log_id);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'034','Redefinition failed, redefinition status: '||v_redefinition_status);
    end if;
    return v_redefinition_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Redefinition failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    update_status(p_table_name,'FAILED '||v_proc_name,v_proc_name||': NOK',v_partition_log_id);
    raise;
  END;

  function do_drop_create_insert(p_dst_schema_name varchar2, p_dst_table_name VARCHAR2, p_src_schema_name varchar2, p_src_table_name VARCHAR2) return number is -- insert into dst select * from src
    v_proc_name t_partition_log.proc_name%type := 'do_drop_create_insert';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_full_dst_table_name varchar2(100);
    v_full_src_table_name varchar2(100);
    v_status number;
    v_sql clob;
    v_partition_sql clob;
    v_indexes_sql clob;
    v_triggers_sql clob;
    v_comments_sql clob;
    v_sql_insert_into clob;
    v_start_time date;
    v_start_time_full date;
    v_indexes_start number;
    v_indexes_end number;
    v_indexes_occurrence number;
    v_triggers_start number;
    v_triggers_alter_start number;
    v_triggers_end number;
    v_triggers_occurrence number;
    v_comments_start number;
    v_comments_end number;
    v_comments_occurrence number;

  BEGIN
    v_object_info := nvl(p_dst_table_name,'NULL');
    --checking parameters
    if (p_dst_schema_name is null)
    then
      raise_application_error(-20181,'missing p_dst_schema_name');
    end if;
    if (p_dst_table_name is null)
    then
      raise_application_error(-20182,'missing p_dst_table_name');
    end if;
    if (p_src_schema_name is null)
    then
      raise_application_error(-20183,'missing p_src_schema_name');
    end if;
    if (p_src_table_name is null)
    then
      raise_application_error(-20184,'missing p_src_table_name');
    end if;
    v_full_dst_table_name := p_dst_schema_name||'.'||p_dst_table_name;
    v_full_src_table_name := p_src_schema_name||'.'||p_src_table_name;
    if (check_table_exists(p_src_schema_name,p_src_table_name)=false)
    then
      raise_application_error(-20185,'Source table:'||v_full_src_table_name||' does not exists.');
    end if;
    v_status := 0;
    v_start_time_full := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Drop/Create/Insert for table: '||p_dst_table_name);
    update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,v_proc_name||': in progress',v_partition_log_id);

    -- generate destination table DDL
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Generate DDL without PARTITION clause for destination table: '||p_dst_table_name||'.');
    update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_ddl: in progress',v_partition_log_id);
    begin
      v_start_time := sysdate;
      v_sql := get_table_ddl(p_schema_name => p_dst_schema_name, p_table_name => p_dst_table_name, p_new_table_name => null, p_include_CONSTRAINTS => true, p_include_REF_CONSTRAINTS=>true, p_include_PARTITIONING=>false, p_include_SEGMENT_ATTRIBUTES=>true, p_include_TABLESPACE=>true, p_include_STORAGE=>true, p_update_IDENTITY => true, p_identity_start => null);
      if (v_sql is null)
      then
        raise_application_error(-20186,'generated DDL for destination table is empty (is NULL)');
      end if;
      if (length(v_sql)<10)
      then
        raise_application_error(-20187,'generated DDL for destination table is too short (length<10)');
      end if;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','DDL without PARTITION clause for destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_sql);
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_ddl: OK',v_partition_log_id);
    exception
    when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Generate interim table DDL for table: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      update_status(p_dst_table_name,'FAILED '||v_proc_name,'gen_dst_table_ddl: NOK',v_partition_log_id);
      v_status := 1; -- error during generating DDL
    end;
      
    if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Generate PARTITION DDL for destination table: '||p_dst_table_name||'.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_partition_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_partition_sql := gen_partition_clause (p_dst_schema_name, p_dst_table_name);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','PARTITION DDL for destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_partition_sql);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_partition_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Generate PARTITION DDL for destination table: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'gen_dst_table_partition_ddl: NOK',v_partition_log_id);
        v_status := 2; -- error during generating partition DDL
      end;
    end if;

   if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Generate Indexes DDL for destination table: '||p_dst_table_name||'.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'get_indexes_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_indexes_sql := get_indexes_ddl(p_dst_schema_name, p_dst_table_name);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Indexes DDL for destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_indexes_sql);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'get_indexes_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'103','Generate Indexes DDL for destination table: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'get_indexes_ddl: NOK',v_partition_log_id);
        v_status := 3; -- error during generating indexes DDL
      end;
    end if;

   if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'008','Generate Triggers DDL for destination table: '||p_dst_table_name||'.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'get_triggers_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_triggers_sql := get_triggers_ddl (p_dst_schema_name, p_dst_table_name);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'009','Triggers DDL for destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_triggers_sql);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'get_triggers_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'104','Generate Triggers DDL for destination table: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'get_triggers_ddl: NOK',v_partition_log_id);
        v_status := 4; -- error during generating triggers DDL
      end;
    end if;

   if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'010','Generate Comments DDL for destination table: '||p_dst_table_name||'.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'get_comments_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_comments_sql := get_comments_ddl (p_dst_schema_name, p_dst_table_name);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'011','Comments DDL for destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_comments_sql);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'get_comments_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'105','Comments Triggers DDL for destination table: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'get_comments_ddl: NOK',v_partition_log_id);
        v_status := 5; -- error during generating comments DDL
      end;
    end if;

    if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'012','Generate full DDL (table+partitions) for destination table: '||p_dst_table_name||'.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_full_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql := v_sql || ' ' || v_partition_sql;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'013','full DDL (table+partitions) for destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_sql);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_full_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'106','Generate full DDL (table+partitions) for destination table: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'gen_dst_table_full_ddl: NOK',v_partition_log_id);
        v_status := 6; -- error during generating full DDL
      end;
    end if;

    -- generate insert into...
    if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'014','Generate insert into destination table SQL script: '||p_dst_table_name||'.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_partition_ddl: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_sql_insert_into := 'insert /*+ append */ into '||v_full_dst_table_name||' select * from '||v_full_src_table_name;
        if (v_sql_insert_into is null)
        then
          raise_application_error(-20188,'generated insert into destination table SQL script is empty (is NULL)');
        end if;
        if (length(v_sql_insert_into)<45)
        then
          raise_application_error(-20189,'generated insert into destination table SQL script ('||v_sql_insert_into||') for destination table is too short (length<45)');
        end if;
        
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'015','Insert into destination table SQL script: '||p_dst_table_name||' is successfully created.',v_start_time,v_sql_insert_into);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'gen_dst_table_partition_ddl: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'107','Generation insert into destination table SQL script: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'gen_dst_table_partition_ddl: NOK',v_partition_log_id);
        v_status := 7; -- error during generating insert into SQL script
      end;
    end if;
    
    -- drop destination table
    if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'016','Drop destination table: '||p_dst_table_name||'.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'drop_dst_table: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        do_drop_table(p_dst_schema_name,p_dst_table_name,p_drop_table_with_data=>1); -- drop destination table even there are data; p_drop_table_with_data=1
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'017','Destination table: '||p_dst_table_name||' is successfully dropped.',v_start_time);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'drop_dst_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'108','Drop destination: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'drop_dst_table: NOK',v_partition_log_id);
        v_status := 8; -- error during dropping destination table
      end;
    end if;

    -- create destination table
    if (v_status=0)
    then
      v_start_time := sysdate;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'018','Create destination table: '||p_dst_table_name||'.',v_start_time,v_sql);
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_dst_table: in progress',v_partition_log_id);
      begin
        execute immediate v_sql;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'019','Destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_sql);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_dst_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'109','Creating destination: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'create_dst_table: NOK',v_partition_log_id);
        v_status := 9; -- error during creating destination table
      end;
    end if;

    -- create destination table indexes
    if (v_status=0 and v_indexes_sql is not null)
    then
      v_start_time := sysdate;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'020','Create indexes on destination table: '||p_dst_table_name||'.',v_start_time,v_indexes_sql);
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_indexes_on_dst_table: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_indexes_occurrence := 1;
        loop
          v_indexes_start := instr(v_indexes_sql,'CREATE ',1,v_indexes_occurrence);
          v_indexes_end := instr(v_indexes_sql,'CREATE ',1,v_indexes_occurrence+1);
          exit when v_indexes_start = 0;
          if (v_indexes_end>0)
          then
            v_sql := substr(v_indexes_sql,v_indexes_start,v_indexes_end-v_indexes_start);
          else
            v_sql := substr(v_indexes_sql,v_indexes_start);
          end if;
          v_start_time := sysdate;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'021/'||v_indexes_occurrence,'Create index on destination table: '||p_dst_table_name||'.',v_start_time,v_sql);
          execute immediate v_sql;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'022/'||v_indexes_occurrence,'Index on destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_sql);
          v_indexes_occurrence := v_indexes_occurrence + 1;
        end loop;
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_indexes_on_dst_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'110','Creating indexes on destination: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'create_indexes_on_dst_table: NOK',v_partition_log_id);
        v_status := 10; -- error during creating indexes
      end;
    end if;

    -- create destination table triggers
    if (v_status=0 and v_triggers_sql is not null)
    then
      v_start_time := sysdate;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'023','Create triggers on destination table: '||p_dst_table_name||'.',v_start_time,v_triggers_sql);
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_triggers_on_dst_table: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_triggers_occurrence := 1;
        loop
          v_triggers_start := instr(v_triggers_sql,'CREATE OR REPLACE ',1,v_triggers_occurrence);
          v_triggers_alter_start := instr(v_triggers_sql,'ALTER TRIGGER ',1,v_triggers_occurrence);
          v_triggers_end := instr(v_triggers_sql,'CREATE OR REPLACE ',1,v_triggers_occurrence+1);
          exit when v_triggers_start = 0;
          if (v_triggers_alter_start>0)
          then
            v_sql := substr(v_triggers_sql,v_triggers_start,v_triggers_alter_start-v_triggers_start);
          else
            v_sql := substr(v_triggers_sql,v_triggers_start);
          end if;
          v_start_time := sysdate;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'024/'||v_triggers_occurrence||'_trg','Create trigger on destination table: '||p_dst_table_name||'.',v_start_time,v_sql);
          execute immediate v_sql;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'025/'||v_triggers_occurrence||'_trg','Trigger on destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_sql);
          if (v_triggers_end>0)
          then
            v_sql := substr(v_triggers_sql,v_triggers_alter_start,v_triggers_end-v_triggers_alter_start);
          else
            v_sql := substr(v_triggers_sql,v_triggers_alter_start);
          end if;
          v_start_time := sysdate;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'026/'||v_triggers_occurrence||'_alter_trg','Alter trigger on destination table: '||p_dst_table_name||'.',v_start_time,v_sql);
          execute immediate v_sql;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'027/'||v_triggers_occurrence||'_alter_trg','Alter trigger on destination table: '||p_dst_table_name||' is successfull.',v_start_time,v_sql);
          v_triggers_occurrence := v_triggers_occurrence + 1;
        end loop;
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_indexes_on_dst_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'111','Creating triggers on destination: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'create_indexes_on_dst_table: NOK',v_partition_log_id);
        v_status := 11; -- error during creating triggers on destination table
      end;
    end if;

    -- create destination table comments
    if (v_status=0 and v_comments_sql is not null)
    then
      v_start_time := sysdate;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'028','Create comments on destination table: '||p_dst_table_name||'.',v_start_time,v_comments_sql);
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_comments_on_dst_table: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        v_comments_occurrence := 1;
        loop
          v_comments_start := instr(v_comments_sql,'COMMENT ON',1,v_comments_occurrence);
          v_comments_end := instr(v_comments_sql,'COMMENT ON',1,v_comments_occurrence+1);
          exit when v_comments_start = 0;
          if (v_comments_end>0)
          then
            v_sql := substr(v_comments_sql,v_comments_start,v_comments_end-v_comments_start);
          else
            v_sql := substr(v_comments_sql,v_comments_start);
          end if;
          v_start_time := sysdate;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'029/'||v_comments_occurrence,'Create comment on destination table: '||p_dst_table_name||'.',v_start_time,v_sql);
          execute immediate v_sql;
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'030/'||v_comments_occurrence,'Comments on destination table: '||p_dst_table_name||' is successfully created.',v_start_time,v_sql);
          v_comments_occurrence := v_comments_occurrence + 1;
        end loop;
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'create_comments_on_dst_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'112','Creating comments on destination: '||v_full_dst_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,v_sql,DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'create_comments_on_dst_table: NOK',v_partition_log_id);
        v_status := 12; -- error during creating comments
      end;
    end if;

    -- execute SQL: insert into destination select * from source
    if (v_status=0)
    then
      v_start_time := sysdate;
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'031','Execute insert into destination table SQL script: '||p_dst_table_name||'.',v_start_time,v_sql_insert_into);
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'insert_into_dst_table: in progress',v_partition_log_id);
      begin
        execute immediate v_sql_insert_into;
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'032','insert into destination table SQL script: '||p_dst_table_name||' is successfully executed. Number of rows copied:'||SQL%ROWCOUNT,v_start_time,v_sql_insert_into);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'insert_into_dst_table: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'113','insert into destination table: '||v_full_dst_table_name||' SQL script failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'insert_into_dst_table: NOK',v_partition_log_id);
        v_status := 13; -- error during insert into...
      end;
    end if;
    -- grant table priviledges
    if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'033','Grant priviledges.');
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'Grant priviledges: in progress',v_partition_log_id);
      begin
        v_start_time := sysdate;
        grant_table_privs(p_dst_table_name);
        v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'034','Grant priviledges.',v_start_time);
        update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'Grant priviledges: OK',v_partition_log_id);
      exception
      when others then
        v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'114','Grant priviledges failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        update_status(p_dst_table_name,'FAILED '||v_proc_name,'Grant priviledges: NOK',v_partition_log_id);
        v_status := 14;
      end;
    end if;

    if (v_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'033','Drop/Create/Insert finished sucessfully.',v_start_time_full);
      update_status(p_dst_table_name,'IN_PROGRESS '||v_proc_name,'Drop/Create/Insert finished sucessfully in '||round((sysdate - v_start_time_full) * 24*60*60)||' seconds.',v_partition_log_id);
    else
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'034','Drop/Create/Insert insertion failed, status: '||v_status);
    end if;
    return v_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Drop/Create/Insert failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    update_status(p_dst_table_name,'FAILED '||v_proc_name,v_proc_name||': NOK',v_partition_log_id);
    raise;
  END;

  -- repartition one table
  function repartition_table(p_schema_name varchar2, p_table_name VARCHAR2, p_repartition_method varchar2 default null) return number is
    v_proc_name t_partition_log.proc_name%type := 'repartition_table';
    v_object_info t_partition_log.object_info%type;
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_full_table_name varchar2(100);
    v_redefinition_status pls_integer;
    v_repartition_table_status pls_integer;
    v_repartition_method varchar2(100);
    v_full_bkp_table_name varchar2(100);
    v_schema_name_bkp varchar2(100);
    v_table_name_bkp varchar2(100);
    v_start_time date;
    v_start_time_full date;
    v_enable_row_movement t_partition_cfg.enable_row_movement%type;
  BEGIN
    v_object_info := p_table_name;
    --checking parameters
    if (p_schema_name is null)
    then
      raise_application_error(-20131,'missing p_schema_name');
    end if;
    if (p_table_name is null)
    then
      raise_application_error(-20132,'missing p_table_name');
    end if;

    --do main part
    v_start_time_full := sysdate;
    v_full_table_name := p_schema_name||'.'||p_table_name;
    v_repartition_table_status := 0;
    v_repartition_method := nvl(p_repartition_method,c_default_repartition_method);
    
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Repartitioning table: '||v_full_table_name||' using '||v_repartition_method||' method');
    update_status(p_table_name,'IN_PROGRESS '||v_proc_name,v_proc_name||': in progress',v_partition_log_id);

    begin
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Get backup table name for table: '||v_full_table_name);
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get backup table name: in progress',v_partition_log_id);
      v_start_time := sysdate;
      v_schema_name_bkp := p_schema_name;
      v_table_name_bkp := get_backup_table_name(p_table_name);
      v_full_bkp_table_name := v_schema_name_bkp||'.'||v_table_name_bkp;
      update_partition_backup_table(p_table_name, v_table_name_bkp);
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Get backup table name successfull.',v_start_time);
      update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'get backup table name: OK',v_partition_log_id);
    exception
    when others then
      v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'101','Get backup table name failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
      update_status(p_table_name,'FAILED '||v_proc_name,'get backup table name: NOK',v_partition_log_id);
      v_repartition_table_status := 1;
    end;

    if (v_repartition_table_status=0)
    then
      if (v_repartition_method = 'REDEFINE_OR_DROP_CREATE_INSERT')
      then
        begin
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Backup table: '||v_full_table_name||' as table: '||v_full_bkp_table_name);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_backup_table: in progress',v_partition_log_id);
          v_start_time := sysdate;
          do_backup_table(p_schema_name, p_table_name, v_schema_name_bkp, v_table_name_bkp);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Backup created successfully.',v_start_time);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_backup_table: OK',v_partition_log_id);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'102','Backup failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          update_status(p_table_name,'FAILED '||v_proc_name,'do_backup_table: NOK',v_partition_log_id);
          v_repartition_table_status := 1;
        end;
        if (v_repartition_table_status=0)
        then
          if (get_identity_column_name(p_schema_name, p_table_name) is null) -- table without identity column
          then
            begin
              v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Redefine table: '||v_full_table_name);
              update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_redefine_table: in progress',v_partition_log_id);
              v_start_time := sysdate;
              v_redefinition_status := do_redefine_table(p_schema_name, p_table_name);
              if (v_redefinition_status=0)
              then
                v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Redefinition finshed successfully.',v_start_time);
                update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_redefine_table: OK',v_partition_log_id);
              else
                v_repartition_table_status := 2;
              end if;
            exception
            when others then
              v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'103','Redefinition failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
              update_status(p_table_name,'FAILED '||v_proc_name,'do_redefine_table: NOK',v_partition_log_id);
              v_repartition_table_status := 3;
            end;
          else
            begin
              v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'008','Drop, create, insert into table: '||v_full_table_name);
              update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_drop_create_insert: in progress',v_partition_log_id);
              v_start_time := sysdate;
              v_redefinition_status := do_drop_create_insert(p_schema_name, p_table_name, v_schema_name_bkp, v_table_name_bkp);
              if (v_redefinition_status=0)
              then
                v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'009','Drop, create, insert into table finshed successfully.',v_start_time);
                update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'do_drop_create_insert: OK',v_partition_log_id);
              else
                v_repartition_table_status := 4;
              end if;
            exception
            when others then
              v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'104','Drop, create, insert into table failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
              update_status(p_table_name,'FAILED '||v_proc_name,'do_drop_create_insert: NOK',v_partition_log_id);
              v_repartition_table_status := 5;
            end;
          end if;
        end if;
      end if;
      if (v_repartition_method = 'RENAME')
      then
        if (v_repartition_table_status=0)
        then
          begin
            v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'010','Generate DDL (including dependend objects) for table: '||v_full_table_name);
            update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'generate_ddl: in progress',v_partition_log_id);
            v_start_time := sysdate;
            v_redefinition_status := generate_DDL(p_schema_name, p_table_name);
            if (v_redefinition_status=0)
            then
              v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'011','Generate DDL (including dependend objects) finshed successfully.',v_start_time);
              update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'generate_ddl: OK',v_partition_log_id);
            else
              v_repartition_table_status := 6;
            end if;
          exception
          when others then
            v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'105','Generate DDL (including dependend objects) failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
            update_status(p_table_name,'FAILED '||v_proc_name,'generate_ddl: NOK',v_partition_log_id);
            v_repartition_table_status := 7;
          end;
        end if;
        if (v_repartition_table_status=0)
        then
          begin
            v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'012','Repartition table using rename method for table: '||v_full_table_name);
            update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'repartirion using rename method: in progress',v_partition_log_id);
            v_start_time := sysdate;
            v_redefinition_status := repart_table_rename(p_schema_name, p_table_name);
            if (v_redefinition_status=0)
            then
              v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'013','Repartition table using rename method finshed successfully.',v_start_time);
              update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'repartirion using rename method: OK',v_partition_log_id);
            else
              v_repartition_table_status := 4;
            end if;
          exception
          when others then
            v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'106','Repartition table using rename method failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
            update_status(p_table_name,'FAILED '||v_proc_name,'repartirion using rename method: NOK',v_partition_log_id);
            v_repartition_table_status := 5;
          end;
        end if;
      end if;
    end if;
    -- enable row movement based on configuation
    if (v_repartition_table_status=0)
    then
      begin
        select nvl(upper(enable_row_movement),'N') into v_enable_row_movement from t_partition_cfg where table_name = p_table_name and release_version = gv_release_version;
      exception
      when others then
        v_enable_row_movement := 'N';
      end;
      if (v_enable_row_movement='Y')
      then
        begin
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'014','Enable row movement for table: '||p_table_name||'.');
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'enable_row_movement: in progress',v_partition_log_id);
          v_start_time := sysdate;
          enable_row_movement(p_schema_name, p_table_name);
          v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'015','Row movement for table: '||p_table_name||' successfully enabled.',v_start_time);
          update_status(p_table_name,'IN_PROGRESS '||v_proc_name,'enable_row_movement: OK',v_partition_log_id);
        exception
        when others then
          v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'107','Row movement for table: '||p_table_name||' cannot be enabled due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
          update_status(p_table_name,'FAILED '||v_proc_name,'enable_row_movement: NOK',v_partition_log_id);
          v_repartition_table_status := 6;
        end;
      end if;
    end if;
    if (v_repartition_table_status=0)
    then
      v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'016','Repartitioning finshed successfully.',v_start_time_full);
      commit;
      update_status(p_table_name,'DONE','table successfully backuped and repartitioned in '||round((sysdate - v_start_time_full) * 24*60*60)||' seconds.',v_partition_log_id);
    else
      write_log(c_log_message_type_error,v_proc_name, v_object_info,'105','Repartitioning failed, repartition status: '||v_repartition_table_status);
      rollback;
    end if;
    return v_repartition_table_status;
  EXCEPTION
  when others then
    v_partition_log_id := write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Repartitioning failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time_full,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
    update_status(p_table_name,'FAILED '||v_proc_name,v_proc_name||': NOK',v_partition_log_id);
    rollback;
    raise;
  END;


  --Main external interface procedure
  --loop configuration and call partitioning per choosen table_id 
  PROCEDURE run_partitioning(p_enable_execute_immediate number, p_release_version varchar2)
   AS
    v_proc_name t_partition_log.proc_name%type := 'run_partitioning';
    v_partition_log_id t_partition_log.partition_log_id%type;
    v_object_info t_partition_log.object_info%type;
    v_table_name t_partition_cfg.table_name%type;
    v_start_time date;
    v_noerror_cnt pls_integer := 0;
    v_error_cnt pls_integer := 0;
    v_error_recompilation pls_integer := 0;
    v_error_disable_inmemory pls_integer := 0;
    v_repartition_table_status number;

      -- cursor with tables to do partitioning
    cursor c_partition_cfg is
        select t_partition_cfg.table_name
        from t_partition_cfg
        where not exists (select 1 from t_partition_status where t_partition_status.table_name=t_partition_cfg.table_name and t_partition_status.release_version = t_partition_cfg.release_version)
        and release_version = gv_release_version
        order by t_partition_cfg.table_name;
  BEGIN
    if (user != c_execute_by_user)
    then
      raise_application_error(-20311,'Wrong user ('||user||') used to execute pkg_partition.run_partitioning(...). Please execute as '||c_execute_by_user||' instead of '||user);
    end if;
    gv_enable_execute_immediate := p_enable_execute_immediate;
    gv_release_version := p_release_version;
    v_start_time := sysdate;
    v_partition_log_id := write_log(c_log_message_type_info,v_proc_name, v_object_info,'001','Run repartitioning for tables in t_partition_cfg and not in t_partition_status as user: '||user||' for release_version='||gv_release_version||'.');
    gv_partition_group_log_id := (v_partition_log_id * 1000)+1;
    for partition_cfg_row in c_partition_cfg
    loop
      v_table_name := partition_cfg_row.table_name;
      begin
        v_repartition_table_status := repartition_table(c_schema_name,v_table_name,null);
        if (v_repartition_table_status = 0)
        then
          v_noerror_cnt := v_noerror_cnt+1;
        else
          v_error_cnt := v_error_cnt+1;
        end if;
      exception
      when others then
        -- Log information about failure but do not stop redefinition for other tables.
        v_object_info := v_table_name;
        write_log(c_log_message_type_error,v_proc_name, v_object_info,'100','Repartitioning for table '||v_table_name||' failed due to error: '||sqlcode||'('||sqlerrm||')',v_start_time,'',DBMS_UTILITY.FORMAT_ERROR_BACKTRACE());
        v_object_info := null;
        v_error_cnt := v_error_cnt + 1;
      end;
      gv_partition_group_log_id := gv_partition_group_log_id + 1;
    end loop;
    gv_partition_group_log_id := null;
    v_error_recompilation := recompile_invalid_objects(c_schema_name);
    v_error_disable_inmemory := disable_inmemory(c_schema_name);
    if (v_error_cnt=0 and v_error_recompilation=0 and v_error_disable_inmemory=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'002','Repartitioning finished without errors. Number of repartitioned tables: '||v_noerror_cnt||'.',v_start_time);
    end if;

    if (v_error_cnt!=0 and v_error_recompilation=0 and v_error_disable_inmemory=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'003','Repartitioning finished with errors. Number of repartitioned tables without errors: '||v_noerror_cnt||'. Number of tables not repartitioned due to errors (check details in t_partition_status and t_partition_log): '||v_error_cnt||'.' ,v_start_time);
    end if;

    if (v_error_cnt=0 and v_error_recompilation!=0 and v_error_disable_inmemory=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'004','Repartitioning finished without errors. Number of repartitioned tables: '||v_noerror_cnt||'. Recompilation finished with: '||v_error_recompilation||' error(s).',v_start_time);
    end if;

    if (v_error_cnt!=0 and v_error_recompilation!=0 and v_error_disable_inmemory=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'005','Repartitioning finished with errors. Number of repartitioned tables without errors: '||v_noerror_cnt||'. Number of tables not repartitioned due to errors (check details in t_partition_status and t_partition_log): '||v_error_cnt||'. Recompilation finished with: '||v_error_recompilation||' error(s).' ,v_start_time);
    end if;

    if (v_error_cnt=0 and v_error_recompilation=0 and v_error_disable_inmemory!=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'006','Repartitioning finished without errors. Number of repartitioned tables: '||v_noerror_cnt||'. Disabling INMEMORY finished with: '||v_error_disable_inmemory||' error(s).',v_start_time);
    end if;

    if (v_error_cnt!=0 and v_error_recompilation=0 and v_error_disable_inmemory!=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'007','Repartitioning finished with errors. Number of repartitioned tables without errors: '||v_noerror_cnt||'. Number of tables not repartitioned due to errors (check details in t_partition_status and t_partition_log): '||v_error_cnt||'. Disabling INMEMORY finished with: '||v_error_disable_inmemory||' error(s).',v_start_time);
    end if;

    if (v_error_cnt=0 and v_error_recompilation!=0 and v_error_disable_inmemory!=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'008','Repartitioning finished without errors. Number of repartitioned tables: '||v_noerror_cnt||'. Recompilation finished with: '||v_error_recompilation||' error(s). Disabling INMEMORY finished with: '||v_error_disable_inmemory||' error(s).',v_start_time);
    end if;

    if (v_error_cnt!=0 and v_error_recompilation!=0 and v_error_disable_inmemory!=0)
    then
      write_log(c_log_message_type_info,v_proc_name, v_object_info,'009','Repartitioning finished with errors. Number of repartitioned tables without errors: '||v_noerror_cnt||'. Number of tables not repartitioned due to errors (check details in t_partition_status and t_partition_log): '||v_error_cnt||'. Recompilation finished with: '||v_error_recompilation||' error(s). Disabling INMEMORY finished with: '||v_error_disable_inmemory||' error(s).',v_start_time);
    end if;


  end;

END PKG_PARTITION;
/
