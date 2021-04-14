CREATE OR REPLACE PACKAGE G77_CFG.pkg_partition AUTHID CURRENT_USER AS
  --  AUTHID CURRENT_USER

  -- Author  : S3PP5N
  -- Created : 17/08/2018
  -- Purpose : 

  FUNCTION check_table_exists(p_schema_name varchar2, p_table_name VARCHAR2) RETURN BOOLEAN;
  /*
    Function checks whether p_schema_name.p_table_name exists and is not materialized view. To check it, function uses all_tables (and all_mviews to exclude materialized views).
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Output value:
    -true - table exists
    -false - table does not exist
    Exceptions:
    -20011 - p_schema_name is null
    -20012 - p_table_name is null
    and all Oracle exceptions
  */

  FUNCTION check_mview_exists(p_schema_name varchar2, p_mview_name VARCHAR2) RETURN BOOLEAN;
  /*
    Function checks whether materialized view p_schema_name.p_mview_name exists. To check it uses all_mviews.
    Input values:
    -p_schema_name - schema
    -p_mview_name - materialized view name
    Output value:
    -true - table exists
    -false - table does not exist
    Exceptions:
    -20141 - p_schema_name is null
    -20142 - p_mview_name is null
    and all Oracle exceptions
  */

  FUNCTION check_column_in_table_exists(p_schema_name varchar2, p_table_name VARCHAR2, p_column_name VARCHAR2) RETURN BOOLEAN;
  /*
    Function checks whether p_column_name exists in table p_schema_name.p_table_name.
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    -p_column_name - column name 
    Output value:
    -true - column in table exists
    -false - column in table does not exist
    Exceptions:
    -20021 - p_schema_name is null
    -20022 - p_table_name is null
    -20023 - p_column_name is null
    and all Oracle exceptions
  */
  
  FUNCTION check_is_table_empty(p_schema_name varchar2, p_table_name VARCHAR2) RETURN BOOLEAN;
  /*
    Function checks whether table p_schema_name.p_table_name is empty.
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Output value:
    -true - table is empty
    -false - table is nt empty
    Exceptions:
    -20151 - p_schema_name is null
    -20152 - p_table_name is null
    and all Oracle exceptions
  */

  FUNCTION check_table_has_partitions(p_schema_name varchar2, p_table_name VARCHAR2) RETURN BOOLEAN;
  /*
    Function checks whether table p_schema_name.p_table_name has partitions.
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Output value:
    -true - table has at least one partition
    -false - table doesn't have partitions
    Exceptions:
    -20041 - p_schema_name is null
    -20042 - p_table_name is null
    and all Oracle exceptions
  */

  PROCEDURE execute_immediate(p_str varchar2, p_enable_execute_immediate number default 3);
  /*
    procedure to: "execute immediate v_str"
    p_enable_execute_immediate = 0 then procedure does nothing (execute immediate is disabled)
    p_enable_execute_immediate = 1 then procedure "execute immediate p_str"
    p_enable_execute_immediate = 2 then p_enable_execute_immediate = c_execute_immediate
    p_enable_execute_immediate = 3 then p_enable_execute_immediate = gv_enable_execute_immediate (global variable)
    p_enable_execute_immediate != 0,1,2,3 then p_enable_execute_immediate=0
  */

  FUNCTION rename_owner_dot_name(p_str clob, p_keyword varchar2, p_owner_old varchar2, p_name_old varchar2, p_owner_new varchar2, p_name_new varchar2, p_end varchar2 default null) RETURN CLOB;
  /*
    Function renames:
    p_keyword table
    p_keyword "table"
    p_keyword schema . table
    p_keyword "schema" . table
    p_keyword schema . "table"
    p_keyword "schema" . "table"
    p_end - optional end of string, required for comment on column to provide "dot" as a end of string
  */
  
  PROCEDURE enable_row_movement(p_schema_name varchar2, p_table_name VARCHAR2);
  /*
    Function enables row movement.
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Exceptions:
    -20221 - p_schema_name is null
    -20222 - p_table_name is null
    -20223 - p_table_name does not exist
    and all Oracle exceptions
  */


  FUNCTION get_identity_column_name(p_schema_name varchar2, p_table_name VARCHAR2) RETURN varchar2;
  /*
    Function return identity column name or if table doesn't have identity column then return null
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Output value:
    -column name - if table has identity column
    -null - table doesn't have identity column
    Exceptions:
    -20161 - p_schema_name is null
    -20162 - p_table_name is null
    and all Oracle exceptions
  */

  FUNCTION get_identity_nextval(p_schema_name varchar2, p_table_name VARCHAR2) RETURN number;
  /*
    Function return identity nextval (from sequence on which identity base)
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Output value:
    -sequence.nextval
    -null - table doesn't have identity column
    Exceptions:
    -20171 - p_schema_name is null
    -20172 - p_table_name is null
    and all Oracle exceptions
  */

  FUNCTION get_sequence_nextval(p_schema_name varchar2, p_sequence_name VARCHAR2) RETURN number;
  /*
    Function return sequence nextval
    Input values:
    -p_schema_name - schema
    -p_sequence_name - sequence name
    Output value:
    -sequence.nextval
    -null - table doesn't have identity column
    Exceptions:
    -20301 - p_schema_name is null
    -20302 - p_sequence_name is null
    and all Oracle exceptions
  */

  FUNCTION get_column_nextval(p_schema_name varchar2, p_table_name VARCHAR2, p_column_name VARCHAR2) RETURN number;
  /*
    Function returns max(column_name)+1 from table
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    -p_column_name - column name
    Output value:
    -max(column_name)+1
    -null - table doesn't have identity column
    Exceptions:
    -20311 - p_schema_name is null
    -20312 - p_table_name is null
    -20313 - p_column_name is null
    and all Oracle exceptions
  */

  FUNCTION generate_tmp_name return varchar2;
  /*
    Function generates temporary name as c_tmp_name_prefix || sq_t_partition_ddl.nextval
  */

  FUNCTION generate_DDL(p_schema_name varchar2, p_table_name VARCHAR2) return number;
  /*
    Function generates DDL script for table (including all depended objects).
    Rename all objects to temporary name.
    Store this script in t_partition_ddl.
    Function is executed in separated session (PRAGMA AUTONOMOUS_TRANSACTION;)
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Output value:
    status
    Exceptions:
    -20231 - p_schema_name is null
    -20232 - p_table_name is null
    -20233 - p_table_name does not exist
    and all Oracle exceptions
  */

  FUNCTION repart_table_rename(p_schema_name varchar2, p_table_name VARCHAR2) return number;
  /*
    Function to repartition table using "rename method".
    It means that function uses DDL generated by generate_DDL() and rename all dependend objects of oryginal table and rename new table mwith dependend object to look like oryginal one but with partitioning defined in partition_cfg
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    Output value:
    status
    Exceptions:
    -20241 - p_schema_name is null
    -20242 - p_table_name is null
    -20243 - p_table_name does not exist
    and all Oracle exceptions
  */

  FUNCTION rollback_repart_table_rename(p_schema_name varchar2, p_table_name VARCHAR2, p_release_version varchar2) return number;
  /*
  Function to rollback table repartition done by repart_table_rename.
  Function drop table which was created after partitioning and rename back oryginal table and all dependend objects.
    Input values:
    -p_schema_name - schema
    -p_table_name - table name
    p_release_version - release version to rollback
    Output value:
    status
    Exceptions:
    -20251 - p_schema_name is null
    -20252 - p_table_name is null
    and all Oracle exceptions
  */

  PROCEDURE cleanup_status(p_release_version varchar2, p_table_name VARCHAR2 default null);
  /*
    procedure to cleanup t_partition_status for provided release_version and p_table_name or all tables if p_table_name is null
  */
  
  FUNCTION drop_backup_table(p_schema_name varchar2, p_table_name VARCHAR2) return number;
  /*
  Function to drop backup table
    Input values:
    -p_schema_name - schema
    -p_table_name - table name for which we would like to drop backup table
    Output value:
    status
    Exceptions:
    -20261 - p_schema_name is null
    -20262 - p_table_name is null
    and all Oracle exceptions
  */

  FUNCTION drop_backup_table_for_done(p_release_version varchar2) return number;
  /*
  Function to drop backup table for all tables with 'DONE' status
    Input values:
    p_release_version - drop backup tables for that release version
    Output value:
    status
    Exceptions:
    and all Oracle exceptions
  */

  FUNCTION drop_migr_part_tmp_tables(p_schema_name varchar2) return number;
  /*
  Function to drop MIGR_PART_TMP_% tables
    Input values:
    -p_schema_name - schema
    Output value:
    status
    Exceptions:
    and all Oracle exceptions
  */


  FUNCTION get_table_ddl(p_schema_name varchar2, p_table_name VARCHAR2, p_new_table_name VARCHAR2 default null, p_include_CONSTRAINTS boolean default true, p_include_REF_CONSTRAINTS boolean default true, p_include_PARTITIONING boolean default true, p_include_SEGMENT_ATTRIBUTES boolean default true, p_include_TABLESPACE boolean default true, p_include_STORAGE boolean default true, p_update_IDENTITY boolean default true, p_identity_start number default null) RETURN clob;
  /*
    Function generates DDL script.
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_table_name - table to generate DDL
    -p_new_table_name - change "create table p_table_name" to "create table p_new_table_name", if NULL then do not change, default=NULL  
    -p_include_CONSTRAINTS - include CONTRAINTS in DDL (default = true) 
    -p_include_REF_CONSTRAINTS - include REF_CONSTRAINTS in DDL (default = true) 
    -p_include_PARTITIONING - include PARTITIONING in DDL (default = true) 
    -p_include_SEGMENT_ATTRIBUTES - include SEGMENT_ATTRIBUTES in DDL (default = true) 
    -p_include_TABLESPACE - include TABLESPACE in DDL (default = true) 
    -p_include_STORAGE - include STORAGE in DDL (default = true)
    -p_update_IDENTITY - standardize identity: GENERATED BY DEFAULT ON NULL AS IDENTITY (START WITH v_identity_start)
    -p_identity_start - value for START WITH for identity 
https://docs.oracle.com/database/121/ARPLS/d_metada.htm#BGBJBFGE
    Output values:
    DDL script
    Exceptions:
    -20051 - p_schema_name is null
    -20052 - p_table_name is null
    -20053 - p_new_table_name length is too long, max allowed is 30 characters
    -20054 - p_table_name does not exist
    and all Oracle exceptions
  */

  FUNCTION get_indexes_ddl(p_schema_name varchar2, p_table_name VARCHAR2, p_include_PARTITIONING boolean default true, p_include_SEGMENT_ATTRIBUTES boolean default true, p_include_TABLESPACE boolean default true, p_include_STORAGE boolean default true) RETURN clob;
  /*
    Function generates indexes DDL script excluding indexes for constraints PK and Unique
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_table_name - table for which we want to to generate inexes DDL
    -p_include_PARTITIONING - include PARTITIONING in DDL (default = true) 
    -p_include_SEGMENT_ATTRIBUTES - include SEGMENT_ATTRIBUTES in DDL (default = true) 
    -p_include_TABLESPACE - include TABLESPACE in DDL (default = true) 
    -p_include_STORAGE - include STORAGE in DDL (default = true) 
    Output values:
    indexes DDL script, this is one script with multiple CREATE INDEX statements. To execute script divide it to separate CREATE INDEX... and execute immediate(...)
    Exceptions:
    -20201 - p_schema_name is null
    -20202 - p_table_name is null
    -20203 - p_table_name does not exist
    and all Oracle exceptions
  */

  FUNCTION get_triggers_ddl(p_schema_name varchar2, p_table_name VARCHAR2) RETURN clob;
  /*
    Function generates indexes DDL script.
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_table_name - table to generate DDL, this is one script with multiple CREATE OR REPLACE TRIGGER and ALTER TRIGGER statements. To execute script divide it to separate CREATE OR UPDATE TRIGGER... and ALTER TRIGGER and execute immediate(...)
    Output values:
    triggers DDL script
    Exceptions:
    -20211 - p_schema_name is null
    -20212 - p_table_name is null
    -20213 - p_table_name does not exist
    and all Oracle exceptions
  */
  
  FUNCTION get_index_ddl(p_schema_name varchar2, p_index_name VARCHAR2, p_new_index_name VARCHAR2 default null, p_include_PARTITIONING boolean default true, p_include_SEGMENT_ATTRIBUTES boolean default true, p_include_TABLESPACE boolean default true, p_include_STORAGE boolean default true) RETURN clob;
  /*
    Function generates index DDL script.
    Input values:
    -p_schema_name - schema where index is located
    -p_index_name - index name
    -p_new_index_name - new index name (if it is required to rename index)
    -p_include_PARTITIONING
    -p_include_SEGMENT_ATTRIBUTES
    -p_include_TABLESPACE
    -p_include_STORAGE
    p_include_STORAGE
    Output values:
    index DDL script
    Exceptions:
    -20031 - p_schema_name is null
    -20032 - p_index_name is null
    and all Oracle exceptions
  */

  FUNCTION get_trigger_ddl(p_schema_name varchar2, p_trigger_name VARCHAR2, p_new_trigger_name VARCHAR2 default null) RETURN clob;
  /*
    Function generates trigger DDL script.
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_trigger_name - trigger name
    -p_new_trigger_name - new trigger name (if it is required to rename trigger)
    Output values:
    triggers DDL script
    Exceptions:
    -20271 - p_schema_name is null
    -20272 - p_trigger_name is null
    and all Oracle exceptions
  */
  
  FUNCTION get_constraint_ddl(p_schema_name varchar2, p_constraint_name VARCHAR2, p_new_constraint_name VARCHAR2 default null) RETURN clob;
  /*
    Function generates constraint DDL script.
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_constraint_name - constraint name
    -p_new_trigger_name - new constraint name (if it is required to rename constraint)
    Output values:
    triggers DDL script
    Exceptions:
    -20281 - p_schema_name is null
    -20282 - p_constraint_name is null
    and all Oracle exceptions
  */
  
  FUNCTION get_comments_ddl(p_schema_name varchar2, p_table_name VARCHAR2) RETURN clob;
  /*
    Function return comment for table and all comments for columns
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_table_name - table to generate comments DDL, this is one script with multiple COMMENT ON statements.
    Output values:
    triggers DDL script
    Exceptions:
    -20291 - p_schema_name is null
    -20292 - p_table_name is null
    -20293 - p_table_name does not exist
    and all Oracle exceptions
    
  */
  

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_runtime in number,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null) RETURN number;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_start_time in date,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null) return number;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in CLOB) return number;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in VARCHAR2) return number;

  FUNCTION write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2) return number;

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_runtime in number,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null);

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_start_time in date,
                      p_details in CLOB default null,
                      p_backtrace in CLOB default null);

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in CLOB);

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2,
                      p_details in VARCHAR2);

  PROCEDURE write_log(p_message_type in VARCHAR2,
                      p_proc_name in VARCHAR2,
                      p_object_info in VARCHAR2,
                      p_step in VARCHAR2,
                      p_message in VARCHAR2);
/*
    Procedures/functions stores information to t_log table in AUTONOMOUS_TRANSACTION mode.
    Input values:
    -p_message_type - message type
      -p_message_type := c_log_message_type_error - ERROR
      -p_message_type := c_log_message_type_info - INFO
    -p_proc_name - procedure/function name
    -p_step - step description inside procedure/function
    -p_message - message  
    -p_runtime - run time 
    -p_start_time - start_time to calulate runtime by sysdate-start_time
    -p_details - detailed explantation 
    -p_backtrace - Oracle backtrace - DBMS_UTILITY.FORMAT_ERROR_BACKTRACE()
    Exceptions:
    No exceptions
  */

  PROCEDURE update_status(p_table_name VARCHAR2, p_status varchar2, p_status_description varchar2, p_partition_log_id number default null, p_rename_ddl clob default null, p_rename_ddl_insert_merge varchar2 default 'INSERT');
  /*
    Procedure update status in t_partition_cfg for table being processed.
    Input values:
    -p_table_name - table name
    -p_status - status
    -p_status_description - status description
    -p_partition_log_id - partition_log_id from partition_log table
    -p_rename_ddl - DDL used to rename table using "rename" method
    Exceptions:
    No exceptions
  */

  PROCEDURE update_partition_backup_table(p_table_name VARCHAR2, p_backup_table_name VARCHAR2);
  /*
    Procedure update partition_table_name in t_partition_backup_table
    Input values:
    -p_table_name - table name
    -p_backup_table_name - backup table name
    Exceptions:
    No exceptions
  */
  

  procedure do_drop_table(p_schema_name varchar2, p_table_name VARCHAR2, p_drop_table_with_data number default 0);
  /*
    Procedure drops table.
    Input values:
    -p_schema_name - schema of table to drop
    -p_table_name - table to drop
    -p_drop_table_with_data - decide whether drop table with data. p_drop_table_with_data=0 - do not drop table with data, p_drop_table_with_data=1 - drop table with data
    Exceptions:
    -20061 - p_schema_name is null
    -20062 - p_table_name is null
    -20063 - data in table to drop exists but table should be empty
    and all Oracle exceptions
    Logging to log table is implemented.
    
  */

  PROCEDURE do_backup_table(p_source_schema_name varchar2, p_source_table_name VARCHAR2, p_bkp_schema_name varchar2, p_bkp_table_name VARCHAR2);
  /*
    Procedure creates copy of source table as bkp_table (create table bkp_table as select * from source)
    Input values:
    -p_source_schema_name - source table schema
    -p_source_table_name - source table
    -p_bkp_schema_name - backup table schema
    -p_bkp_table_name - backup table
    Exceptions:
    -20071 - p_source_schema_name is null
    -20072 - p_source_table_name is null
    -20073 - p_bkp_schema_name is null
    -20074 - p_bkp_table_name is null
    -20075 - source table does not exist
    and all Oracle exceptions
    Logging to log table is implemented.
  */

  PROCEDURE grant_table_privs(p_table_name varchar2 default null);
  /*
  procedure to grant priviledges to p_table_name or if p_table_name is null then to all tables
  It is copy of script from GIT repo: g77\configDataSets\src\main\g77_cfgGrantPrivileges\db\g77_cfg\grants\grant_table_privs.sql
  */

  FUNCTION recompile_invalid_objects(p_schema_name varchar2) return number;
  /*
  function to recompile invalid objects in p_schema_name schema
  return number of failures during recompilation
  */

  FUNCTION disable_inmemory(p_schema_name varchar2, p_table_name varchar2 default null) return number;
  /*
  function to disable inmemory for one table p_table_name or all tables in schema p_schema_name if p_table_name is not provided or is null
  return number of failures
  */

  function get_interim_table_name(p_table_name VARCHAR2) return varchar2;
  /*
    Function return interim table name for provided p_table_name.
    It searchs interim table name in t_partition_cfg or if not available then adds c_interim_table_name_suffix suffix at the end
    Input values:
    -p_table_name - table name
    Output value:
    -intermediate table name
    Exceptions:
    in case of error function return p_table_name + c_interim_table_name_suffix
    
  */

  function get_backup_table_name(p_table_name VARCHAR2, p_old_table_name VARCHAR2 default null) return varchar2;
  /*
    Function return backup table name for provided p_table_name.
    It search backup table name in t_partition_cfg or if not available then adds c_backup_table_name_suffix suffix at the end
    Input values:
    -p_table_name - table name
    Output value:
    -backup table name
    Exceptions:
    in case of error function return p_table_name + c_backup_table_name_suffix
    
  */


  function calc_redefinition_method(p_schema_name varchar2, p_table_name VARCHAR2) RETURN varchar2;
  /*
    Function checks whether table can be repartitioned using dbms_redefinition
    Input values:
    -p_schema_name - table schema
    -p_table_name - table
    Output value:
    -'PK' - can be repartitioned using Primary Key method
    -'ROWID' -  can be repartitioned using ROWID method
    -'IDENTITY' - table has identity column then should be repartitioned using do_drop_create_insert function
    -null - cannot be repartitioned
    Exceptions:
    -20081 - p_schema_name is null
    -20082 - p_table_name is null
    -20083 - p_table_name does not exist
    -20084 - p_table_name cannot be redefined using PK and ROWID redefinition methods
    and all Oracle exceptions
    Logging to log table is implemented.
  */

  function gen_partition_clause (p_schema_name varchar2, p_table_name VARCHAR2) return clob;
  /*
    Function generates sub query for Partitioning based on configuration table
    Input values:
    -p_schema_name - table schema
    -p_table_name - table
    Output value:
    -Partitioning sql script to add at the end of "create table..." statement
    -null in case of disabled partitioning
    Exceptions:
    -20091 - p_schema_name is null
    -20092 - p_table_name is null
    -20093 - p_table_name does not exist
    -20094 - Partition configuration for table p_table_name does not exist (in table t_partition_cfg)
    -20095 - Empty PARTITION_COLUMN in configuration table for table p_table_name
    -20096 - Column defnined in PARTITION_COLUMN does not exists in p_table_name
    -20097 - Partition type for table p_table_name is incorect. Allowed types are: RANGE,INTERVAL,LIST
    -20098 - Empty PARTITION_COUNT (which is required for PARTITION_TYPE=RANGE)
    -20099 - Empty PARTITION_PERIOD (which is required for PARTITION_TYPE=RANGE)
    -20100 - Incorrect PARTITION_PERIOD table p_table_name. Allowed PERIODs are: DAY or MONTH.
    -20101 - Incorrect PARTITION_PERIOD table p_table_name. Allowed PERIODs are: DAY or MONTH.
    -20102 - Empty PARTITION_VALUE (which is required for PARTITION_TYPE=LIST)
    and all Oracle exceptions
    Logging to log table is implemented.
  */
 
  function gen_interm_table(p_schema_name varchar2, p_table_name VARCHAR2, p_new_table_name VARCHAR2 default null) RETURN clob;
  /*
    Function generates DDL script for new table with partition clause (like defined in cofiguration table).
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_table_name - table to generate DDL
    -p_new_table_name - change "create table p_table_name" to "create table p_new_table_name", if NULL then do not change, default=NULL  
    Output values:
    DDL script or NULL in case of error.
    Exceptions:
    -20111 - p_schema_name is null
    -20112 - p_table_name is null
    -20113 - p_new_table_name length is too long, max allowed is 30 characters
    -20114 - p_table_name does not exist
    and all Oracle exceptions
    Logging to log table is implemented.
  */

function do_redefine_table(p_schema_name varchar2, p_table_name VARCHAR2)  return number;
  /*
    Function redefines table.
    Input values:
    -p_schema_name - schema of table to generate DDL
    -p_table_name - table to generate DDL
    Output values:
    status:
    0 - redefinition without errors
    !=0 - there were error during redefinition
    Exceptions:
    -20121 - p_schema_name is null
    -20122 - p_table_name is null
    -20123 - p_table_name does not exist
    and all Oracle exceptions
    Logging to log table is implemented.
  */

  function do_drop_create_insert(p_dst_schema_name varchar2, p_dst_table_name VARCHAR2, p_src_schema_name varchar2, p_src_table_name VARCHAR2) return number;
  /*
    Function repartition table p_dst_schema_name.p_dst_table_name
    Input values:
    -p_dst_schema_name - schema of table to repartition
    -p_dst_table_name - table to repartition
    -p_src_schema_name - backup table schema (backup created before call do_drop_create_insert)
    -p_src_table_name - backup table (backup created before call do_drop_create_insert)
    Output values:
    status:
    0 - repartition without errors
    !=0 - there were error during repartition
    Exceptions:
    -20181 - p_dst_schema_name is null
    -20182 - p_dst_table_name is null
    -20183 - p_src_schema_name is null
    -20184 - p_src_table_name is null
    -20185 - p_src_table_name does not exist
    -20186 - generated DDL for destination table is empty (is NULL)
    -20187 - generated DDL for destination table is too short (length<10)
    -20188 - generated insert into destination table SQL script is empty (is NULL)
    -20189 - generated insert into destination table SQL script ('||v_sql_insert_into||') for destination table is too short (length<45)
    and all Oracle exceptions
  */

  function repartition_table(p_schema_name varchar2, p_table_name VARCHAR2, p_repartition_method varchar2 default null) return number;
  /*
    Function do backup and redefinition of the table.
    Input values:
    -p_schema_name - table schema
    -p_table_name - table
    -p_repartition_method - repartition method, RENAME or REDEFINE_OR_DROP_CREATE_INSERT if=null then default is defined as c_default_repartition_method
    Output values:
    status:
    0 - repartition without errors
    !=0 - there were error during repartition
    Exceptions:
    -20131 - p_source_schema_name is null
    -20132 - p_source_table_name is null
    -20133 - p_bkp_schema_name is null
    -20134 - p_bkp_table_name is null
    and all Oracle exceptions
    Logging to log table is implemented.
    
  */
  
  PROCEDURE run_partitioning(p_enable_execute_immediate number, p_release_version varchar2);
/*
    -p_enable_execute_immediate - control execution of DDL code ONLY for RENAME repartition method.
    p_enable_execute_immediate = 0 then procedure does not do "execute immediate"
    p_enable_execute_immediate = 1 then procedure does "execute immediate"
    p_enable_execute_immediate = 2 then p_enable_execute_immediate = c_execute_immediate
    
    -p_release_version - to control which configuration set should be used
*/
END pkg_partition;
/
