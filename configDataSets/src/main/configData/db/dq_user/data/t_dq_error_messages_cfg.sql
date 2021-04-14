declare
  c int;
  target_table_name varchar2(30) := 't_dq_error_messages';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'DQ_USER';
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

SET DEFINE OFF;
insert into DQ_USER.t_dq_error_messages_cfg ( dq_message_id, dq_message, last_updated, user_id ) 
  values (1, 'Mandatory field not populated', SYSDATE, 'S0HYF2' );
insert into DQ_USER.t_dq_error_messages_cfg ( dq_message_id, dq_message, last_updated, user_id ) 
  values (3, 'SRAM transactions not netting to 0 on roll forward level', sysdate, 'S0HYF2' );
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(5, 'Date format not valid', SYSDATE, 'S4Z4ZX');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(6, 'Number format not valid', SYSDATE,  'S4Z4ZX');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(8, 'Invalid MDM value', sysdate, 'S0HYF2');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(9, 'SRAM balances/transactions not netting to 0 on valuation basis', sysdate, 'S0HYF2');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(11, 'Mapping does not exist in T_GENERAL_MAPPINGS or exists multiple times', sysdate, 'S0HYF2');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(12, 'Expected record count and actual record count does not match' , SYSDATE,  'S4Z4ZX');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(13, 'Debit and Credit amount not netting to 0 on currency, legal entity and effective date' , SYSDATE, 'S4Z4ZX');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(14, 'Reference data missing from CorFinGateway' , SYSDATE,  'S0HYF2');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(15, 'Oracle Reference data missing from CorFinGateway' , SYSDATE,  'S0HYF2');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(16, 'Quantum amounts not netting to 0 on currency, ledger company and effective date' , SYSDATE, 'S0HYF2');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(17, 'Ledger Company Mapping does not exist in T_GENERAL_MAPPINGS', sysdate, 'S0HYF2');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id, dq_message, LAST_UPDATED, USER_ID) 
  Values(18, 'Carrier Partner Mapping does not exist in T_GENERAL_MAPPINGS', sysdate, 'S63YTE');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values(19,'MDM daily exchange rates are missing in GW',sysdate,'S89W7G');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values(20,'Reference data has been changed where a change is not allowed',sysdate,'S149NT');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values(21,'No values present',sysdate,'S149NT');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values(22,'Record is excluded based on business exclusion criteria',sysdate,'S149NT');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values(23,'Referenced mapping lookup value cannot be found in the MDM',sysdate,'S3D865');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values(24,'Record is excluded based on business exclusion criteria',sysdate,'S2EW36');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (25,'Record is excluded based on business exclusion criteria',sysdate,'S149NT');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (26,'Mapping is not found',sysdate,'S149NT');
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (27,'Data has been excluded',sysdate,'S149NT');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (28,'Unsupported combination of IGR parameters',sysdate,'S2EW36');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (29,'Value not exists or occurs more than once',sysdate,'S0SVGU');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (30,'Value not exists in table',sysdate,'S0SVGU');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (31,'Value not exists or occurs more than once or is null',sysdate,'S0SVGU');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (32,'Value not exists in table or is null',sysdate,'S0SVGU');  
Insert into DQ_USER.t_dq_error_messages_cfg (dq_message_id,dq_message,LAST_UPDATED,USER_ID) 
  values (33,'Value not exists',sysdate,'S149NT');  

commit;

declare
  target_table_name varchar2(30) := 't_dq_error_messages';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'DQ_USER';
begin
  -- Delete removed configuration
  execute immediate '
  delete from '                     || target_schema || '.'  || target_table_name || ' target 
  where not exists (select 1 from ' || target_schema || ' .' || merge_table_name  || ' cfg 
                     where     target.dq_message_id   = cfg.dq_message_id 
                   )';
                   
  -- Merge cfg with target table
  execute immediate '
  merge
   into
     ' || target_schema || '.' || target_table_name || ' target
  using
    (select   
       cfg.dq_message_id
      ,cfg.dq_message
      ,cfg.last_updated
      ,cfg.user_id
     from ' || target_schema || '.' || merge_table_name || ' cfg
     ) cfg
  on (    target.dq_message_id   = cfg.dq_message_id
     )
  when matched 
  then 
    update set 
        target.dq_message = cfg.dq_message
      , target.last_updated = cfg.last_updated
      , target.user_id = cfg.user_id       
  when not matched then insert 
    (  target.dq_message_id           
      ,target.dq_message         
      ,target.last_updated             
      ,target.user_id                  
    ) 
    values 
    (  cfg.dq_message_id           
      ,cfg.dq_message         
      ,cfg.last_updated             
      ,cfg.user_id                  

    )';
  commit; 
  
  -- Drop temp table
  execute immediate 'drop table ' || target_schema || '.' || merge_table_name;
end;
/

commit;
