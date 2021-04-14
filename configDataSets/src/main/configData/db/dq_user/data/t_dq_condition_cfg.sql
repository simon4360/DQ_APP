declare
  c int;
  target_table_name varchar2(30) := 't_dq_condition';
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

-- Insert configuration
set define off    
insert into DQ_USER.t_dq_condition_cfg ( dq_condition_id, dq_table_name, dq_condition, dq_condition_desc, create_date, last_updated, user_id ) 
  values (1, 'T_FA0_INVESTMENT_IN', '(ROLL_FORWARD_CODE_ID = ''11137'' OR ROLL_FORWARD_CODE_ID = ''11139'') AND ACCOUNT_FSA_CODE_ID  = ''2502005''', 'Apply rule only to roll forwards 11137 (Other Movements) and 11139 (Reclassifications) on GFD Account 2502005 "Retained Earnings"', TO_DATE('20170515','YYYYMMDD'), TO_DATE('20170515','YYYYMMDD'), 'S0HYF2' );
insert into DQ_USER.t_dq_condition_cfg ( dq_condition_id, dq_table_name, dq_condition, dq_condition_desc, create_date, last_updated, user_id ) 
  values (2, 'T_FA0_INVESTMENT_IN', 'ROLL_FORWARD_CODE_ID in (''12114'',''11139'',''12214'')', 'Apply rule only to roll forwards - 11139 (Transfer/reclassification), 12114 (Transfer Unrealized Gains) and 12214 (Transfer Unrealized Losses)', TO_DATE('20170515','YYYYMMDD'), TO_DATE('20170515','YYYYMMDD'), 'S0HYF2' );
insert into DQ_USER.t_dq_condition_cfg ( dq_condition_id, dq_table_name, dq_condition, dq_condition_desc, create_date, last_updated, user_id )
  values (3, 'T_G71_V_PRTNR_IN',    'SRC_SYS_CD != ''CQP''','PRTNR_SDL can be null for CQP Partners, they instead have BUS_PRTNR_ID',to_date('10-SEP-18 10:15:06','DD-MON-RR HH24:MI:SS'),to_date('10-SEP-18 10:15:06','DD-MON-RR HH24:MI:SS'),'S149NT');
insert into DQ_USER.t_dq_condition_cfg ( dq_condition_id, dq_table_name, dq_condition, dq_condition_desc, create_date, last_updated, user_id )
  values (4, 'T_MDM_PROFIT_CENTRE_IN', 'PROFIT_CENTER_LEVEL >= 4', 'PROFIT CENTER LEVEL >= 4 for level 4 and above DIV_GRP_FINC should be provided.', TO_DATE('2019-04-10 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-04-10 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'S3PP5N');  
insert into DQ_USER.t_dq_condition_cfg ( dq_condition_id, dq_table_name, dq_condition, dq_condition_desc, create_date, last_updated, user_id )
  values (5, 'T_MDM_PROFIT_CENTRE_IN', 'PROFIT_CENTER_LEVEL >= 6', 'PROFIT CENTER LEVEL >= 6 for level 6 and above MGMNT_UNT_GRP_FINC should be provided.', TO_DATE('2019-04-10 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-04-10 17:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'S3PP5N');
insert into DQ_USER.t_dq_condition_cfg ( dq_condition_id, dq_table_name, dq_condition, dq_condition_desc, create_date, last_updated, user_id )
  values (6, 'T_G72_GL_ACCOUNT_IN', 'ENABLED_FLAG = ''Y''', 'Enabled Flag is Active.', TO_DATE('2020-02-27 13:25:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2020-02-27 13:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'S4TCBF');
commit;

declare
  target_table_name varchar2(30) := 't_dq_condition';
  merge_table_name  varchar2(30) := target_table_name || '_cfg';
  target_schema     varchar2(30) := 'DQ_USER';
begin
  -- Delete removed configuration
  execute immediate '
  delete from '                     || target_schema || '.'  || target_table_name || ' target 
  where not exists (select 1 from ' || target_schema || ' .' || merge_table_name  || ' cfg 
                     where     target.dq_condition_id   = cfg.dq_condition_id 
                   )';
                   
  -- Merge cfg with target table
  execute immediate '
  merge
   into
     ' || target_schema || '.' || target_table_name || ' target
  using
    (select   
       cfg.dq_condition_id
      ,cfg.dq_table_name
      ,cfg.dq_condition
      ,cfg.dq_condition_desc
      ,cfg.create_date
      ,cfg.last_updated
      ,cfg.user_id
     from ' || target_schema || '.' || merge_table_name || ' cfg
     ) cfg
  on (    target.dq_condition_id   = cfg.dq_condition_id
     )
  when matched 
  then 
    update set 
        target.dq_table_name = cfg.dq_table_name
      , target.dq_condition = cfg.dq_condition
      , target.dq_condition_desc = cfg.dq_condition_desc
      , target.last_updated = cfg.last_updated
      , target.user_id = cfg.user_id
  when not matched then insert 
    (  target.dq_condition_id
      ,target.dq_table_name
      ,target.dq_condition
      ,target.dq_condition_desc
      ,target.create_date
      ,target.last_updated
      ,target.user_id
    ) 
    values 
    (  cfg.dq_condition_id
      ,cfg.dq_table_name
      ,cfg.dq_condition
      ,cfg.dq_condition_desc
      ,cfg.create_date
      ,cfg.last_updated
      ,cfg.user_id
    )';
  commit; 
  
  -- Drop temp table
  execute immediate 'drop table ' || target_schema || '.' || merge_table_name;
end;
/

commit;