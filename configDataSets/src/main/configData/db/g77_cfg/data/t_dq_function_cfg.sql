declare
  c int;
  target_table_name varchar2(30) := 't_dq_function';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'g77_cfg';
begin

  -- Tidy up and create merge table
  select count(*) into c 
    from all_tables
   where lower(table_name) = merge_table_name
     and lower(owner)      = target_schema;
  if c = 1 then
    execute immediate('drop table ' || target_schema || '.' || merge_table_name);
  end if;
  execute immediate('create table ' || target_schema || '.' || merge_table_name ||
                    ' as select * from ' || target_schema || '.' ||
                    target_table_name || ' where 1=0');
end;
/

-- Insert configuration
SET DEFINE OFF;
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (1,'FN_DQISNOTNULL_STRING','Standard function to check if value is not null.',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('03-MAY-17 00:00:00','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (3,'FN_DQFA0_ROLLFRWD_BALANCE','SRAM function to check if transactions on roll forward id level net to 0',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('15-MAY-17 00:00:00','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (5,'FN_DQIS_DATE','Standard Function to check if date format is valid ',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S4Z4ZX');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (6,'FN_DQIS_NUMBER','Standard Function to check if number format is valid ',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S4Z4ZX');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (8,'FN_DQIS_MDMVALUE','Standard function to check MDM values',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('28-JUN-17 00:00:00','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (9,'FN_DQFA0_BALANCE','SRAM function to check if balances/transactions net to 0',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('28-JUN-17 00:00:00','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (11,'FN_DQCHECKMAPPINGS','Standard function to check mappings',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('28-JUN-17 00:00:00','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (12,'FN_DQ_VALIDATE_FILE_LOAD','Standard Function to compare expected and actual records count ',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S4Z4ZX');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (13,'FN_DQ_DEBIT_CREDIT_AMOUNT','Standard Function to check DR and CR amounts are balanced to zero',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S4Z4ZX');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (14,'FN_DQCHECK_G77CONFIG','Standard Function to check for missing CorFinGateway Reference Data',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (15,'FN_DQIS_G72VALUE','Standard Function to check for missing CorFinOracle Reference Data',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (16,'FN_DQQ0T_BALANCE','Quantum Function to check if amounts are balanced',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (17,'FN_DQCHECKMAPPINGS_LDR_CO','Standard function to check ledger company mappings',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('28-JUN-17 00:00:00','DD-MON-RR HH24:MI:SS'),'S0HYF2');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (18,'FN_DQG72_CHECKMAPPINGS_CP','Oracle function to check carrier partner mappings',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('28-JUN-17 00:00:00','DD-MON-RR HH24:MI:SS'),'S63YTE');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (19,'FN_DQMDM_EXCHG_RATE','Standard function to check daily MDM exchange rates are transferred to GW using percentage based approach',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S89W7G');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (20,'FN_DQCHECK_G77LOOKUP','Standard Function to lookup a value using ref data to check it has not changed from a previous value',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S149NT');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (21,'FN_DQIS_MDMVALUEEXISTS','Function to check MDM values are present',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S149NT');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (22,'FN_DQIS_EXCLUSIONLIST_ITEM','Exclude record if a value is in an exclusion list.',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S149NT');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (23,'FN_DQMAPPINGINGENCODES','Check is mapping lookup is valid and the result if found in the MDM',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S3D865');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (24,'FN_DQG71_DEAL_EXCLUSION','Exclude non-delegated deals, except Reference Deals / Finance Legacy Segment.',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S2EW36');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (25,'FN_DQIS_EXCLUDE_CONDITIONAL','Exclude data based on a custom where clause',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S149NT');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (26,'FN_DQ_GM_AND_ACCORDION_MAPPING','Standard Function to check if we have a combined accordion mapping which is looked up using a general mapping',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S149NT');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (27,'FN_DQIS_EXCLUDE_G71_DATA','Standard Function to stop data from adminhub entering the landscape',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S149NT');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (28,'FN_DQG32_ORDER_REQUEST','Validate G32 order request parameters',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S2EW36');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (29,'FN_DQIS_SINGLEVAL_NULLABLE','Function to check if value occurs in table once or is null',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S0SVGU');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (30,'FN_DQIS_MULTIVAL_NULLABLE','Function to check if value occurs in table one or multiple times or is null',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S0SVGU');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (31,'FN_DQIS_SINGLEVAL_NOTNULL','Function to check if value occurs in table once and is not null',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S0SVGU');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (32,'FN_DQIS_MULTIVAL_NOTNULL','Function to check if value occurs in table one or multiple times and is not null',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S0SVGU');
Insert into G77_CFG.T_DQ_FUNCTION_CFG (DQ_FUNCTION_ID,DQ_FUNCTION,DQ_FUNCTION_DESC,CREATE_DATE,LAST_UPDATED,USER_ID) values (33,'FN_DQ_TM1CONTRACTS','Function to perform DQ checks on TM1 contracts from CorFAH by contract type',to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),to_date('12-JUN-20 18:05:40','DD-MON-RR HH24:MI:SS'),'S149NT');

commit;

declare
  target_table_name varchar2(30) := 't_dq_function';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'g77_cfg';
begin
  -- Delete removed configuration
  execute immediate '
  delete from '                     || target_schema || '.'  || target_table_name || ' target 
  where not exists (select 1 from ' || target_schema || ' .' || merge_table_name  || ' cfg 
                     where     target.dq_function_id   = cfg.dq_function_id 
                   )';
                   
  -- Merge cfg with target table
  execute immediate '
  merge
   into
     ' || target_schema || '.' || target_table_name || ' target
  using
    (select   
       cfg.dq_function_id
      ,cfg.dq_function
      ,cfg.dq_function_desc
      ,cfg.create_date
      ,cfg.last_updated
      ,cfg.user_id
     from ' || target_schema || '.' || merge_table_name || ' cfg
     ) cfg
  on (    target.dq_function_id   = cfg.dq_function_id
     )
  when matched 
  then 
    update set 
        target.dq_function = cfg.dq_function
      , target.dq_function_desc = cfg.dq_function_desc
      , target.create_date = cfg.create_date
      , target.last_updated = cfg.last_updated
      , target.user_id = cfg.user_id       
  when not matched then insert 
    (  target.dq_function_id           
      ,target.dq_function              
      ,target.dq_function_desc         
      ,target.last_updated             
      ,target.user_id                  
    ) 
    values 
    (  cfg.dq_function_id           
      ,cfg.dq_function              
      ,cfg.dq_function_desc         
      ,cfg.last_updated             
      ,cfg.user_id                  

    )';
  commit; 
  
  -- Drop temp table
  execute immediate 'drop table ' || target_schema || '.' || merge_table_name;
end;
/

commit;
