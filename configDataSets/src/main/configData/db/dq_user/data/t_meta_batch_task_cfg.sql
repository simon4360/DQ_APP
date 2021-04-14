-- Data Load Tool
-- Template Version 1.30
-- Generated on 2020/07/16 14:55:29 in 0.43 second(s)
-- Parameters:
--   Product = Other
--   Database = Oracle
--   S/W Version = 0-1-0
--   Order Data Load = Yes
--   Default Rows = Yes
--   Pre-Load SQL = Yes
--   Post-Load SQL = Yes
--   Table Pre-Load SQL = Yes
--   Table Post-Load SQL = Yes
--   Include Remarks = Yes
--   Empty Table Data = No
--   Script Type = Insert
--   Data Validation = Yes
--   Ignore Suffix = x
--   Escape Character = **

set define off

-- Pre-Load SQL
Prompt Pre-Load SQL
/* From the file https://shp.swissre.com/sites/corsofinanceit/Data Management Library/0. CorFinGateway/05. Build/02. CorFinGateway Configuration Metadata/ */

-- Pre-Load SQL T_META_BATCH_TASK_CFG
Prompt Pre-Load SQL T_META_BATCH_TASK_CFG
Prompt drop and create empty configuration table for DQ_USER.t_meta_batch_task_cfg

declare
  c int;
  target_table_name varchar(28) := 't_meta_batch_task';
  merge_table_name varchar2(32) := target_table_name || '_cfg';
  target_schema varchar(32) := 'DQ_USER';
begin

  -- Tidy up and create merge table
  --
  select count(*) into c from all_tables
    where lower(table_name) = merge_table_name
    and lower(owner) = 'DQ_USER';
  if c = 1 then
    execute immediate('drop table ' || target_schema || '.' || merge_table_name);
  end if;
  execute immediate('create table ' || target_schema || '.' || merge_table_name ||
                    ' as select interface_id, process_type, process_name, process_description, error_threshold, threshold_is_percent, run_control,active_indicator from ' || target_schema || '.' ||
                    target_table_name || ' where 1=0');
end;
/

-- Populate DQ_USER.T_META_BATCH_TASK_CFG
Prompt Populate DQ_USER.T_META_BATCH_TASK_CFG
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g71_remittance_tran_outward_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g71_remittance_tran_outward_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_remittance_tran_outward_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_remittance_tran_outward_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g77_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g77_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','mdm_vendor_delta','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','mdm_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','mdm_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vms_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vms_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g71_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g71_remittance_tran_inward_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g71_remittance_tran_inward_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g71_remittance_tran_status_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g71_remittance_tran_status_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_remittance_tran_inward_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_remittance_tran_inward_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_remittance_tran_status_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','g72_remittance_tran_status_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g72_tgt_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','finc_tran_jrnl_x_transfer','Transfers transaction-journal crosswalk from G74 to CRR',1,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g74_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','finc_tran_transfer','Transfers financial transactions from G74 to CRR',1,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g74_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_movement_booking_journal_x_transfer','Transfers IGR movement booking journal Xwalk data to CRR',1,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g74_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_movement_bookings_transfer','Transfers IGR movement booking data from G74 to CRR',1,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g74_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','sl_balance_ext_transfer','Transfers extended balance data from G74 to CRR',1,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g74_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','sl_balance_transfer','Transfers balance data from G74 to CRR',1,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g74_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','sl_journal_transfer','Transfers journal data to CRR',1,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g74_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','archive_data','gateway internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_housekeeping'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','execute_worker','gateway internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_housekeeping'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','mark_as_processed','gateway internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_maintain_data'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ref_table_delta','delta indentification',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_maintain_data'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','set_maintain_data_id','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_maintain_data'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','xa2_call','UC4 invocation',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_maintain_data'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_src_movement_bookings_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_src_current_balance_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_src_current_cashflow_stream_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_src_target_balance_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_src_target_cashflow_stream_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_movement_bookings_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_subject_balance_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_subject_cashflow_stream_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_coverage_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_coverage_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_deal_calc_condn_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_deal_calc_condn_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_deal_calc_conf_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_deal_calc_conf_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g73_tgt_tc_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_src_current_balance_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_src_current_cashflow_stream_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_src_subject_balance_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_src_subject_cashflow_stream_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_movement_bookings_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_currency_block_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_currency_block_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_exclusions_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_exclusions_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_inclusions_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_inclusions_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_order_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_g74_tgt_tc_order_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_retro'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ady'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ady'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','payroll_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ady'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','payroll_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ady'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','discount_factors_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_asl'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','discount_factors_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_asl'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ers_employee_bank_accounts_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ers'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ers_employee_bank_accounts_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ers'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ers_invoice_payments_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ers'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ers_invoice_payments_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_ers'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','aggr_g74_investment_transactions','investment transactions',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_fa0'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','balance_g74_investment_transactions','investment transactions',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_fa0'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','investment_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_fa0'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','investment_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_fa0'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_patterns_headers_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_patterns_headers_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_patterns_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_patterns_rules_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_patterns_rules_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_patterns_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','data_to_distribute_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','fetch_portfolio_properties','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','fetch_xml_files','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ibnr_round_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ibnr_round_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','lag_factor_patterns_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','lag_factor_patterns_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','request_statkeys','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_composition_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_composition_set_event_status','gateway internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_composition_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_loadings_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_properties_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_status_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_status_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_calc_configuration_cond_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_calc_configuration_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_factual_export_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_movement_bookings_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_deal_calcdata_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_request_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_request_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_tc_coverage_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_tc_currency_block_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_tc_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_tc_exclusions_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_tc_inclusions_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_cash_flow_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contracts_plan_complete','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contracts_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contracts_projection_complete','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contracts_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsagrmnt_x_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsagrmnt_x_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsagrmnt_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_plan_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_projection_transform','transforms data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','transactions_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','transactions_plan_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','transactions_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','transactions_projection_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_publish_ap','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g61'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_publish_ar','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g61'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g61'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ratio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_instalments_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_instalments_wrapper','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_publish','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_pol_insrd_det_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_pol_insrd_det_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsurance_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pol_insrd_det_reinsagrmnt_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pol_insrd_det_reinsagrmnt_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_reinsurance_agreement_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_scenario_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_scenario_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_receipts_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_receipts_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_clm_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_cov_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_deal_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_deal_prc_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_deal_prtnrrl_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_insobj_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_instalment_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_pol_deal_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_pol_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_pol_prc_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_pol_prtnrrl_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_polinsrddtl_clm_trx_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_polinsrddtl_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_polinsrddtl_reinsagrmntdtl_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_polinsrddtl_trx_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_prclossscen_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_prtnr_addr_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_prtnr_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_ra_prtnrrl_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_reinsagrmnt_clm_trx_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_reinsagrmnt_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_reinsagrmnt_breakdown_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_reinsagrmnt_s4p_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_reinsagrmnt_prc_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_reinsagrmnt_trx_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_reinsagrmntdtl_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_remit_pair_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_remit_receipts_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_pol_vector_stream_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','v_radtl_vector_stream_extract','extracts data source',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g71'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cash_phoenix_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cash_phoenix_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_request_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_request_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','event_code_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','event_code_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_balance_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_balance_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ledger_company_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ledger_company_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','sub_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','sub_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','trans_partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','trans_partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_pattern_type_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_pattern_type_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_pattern_status_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_pattern_status_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balance_request_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balance_request_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','proc_bal_lgl_enty_req_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','proc_bal_lgl_enty_req_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_parameter_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_parameter_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_cashflow_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_cashflows_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_cashflow_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_fsa_mv_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_fsa_mv_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_local_stat_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_local_stat_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_balances_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_journal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_journal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_entry_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_entry_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','plan_proj_amounts_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','plan_proj_amounts_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','plan_proj_bdgt_unt_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','plan_proj_bdgt_unt_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_economic_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_economic_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_economic_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_trad_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_trad_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_journal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_journal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','expense_factors_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','expense_factors_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ibnr_stat_portfolio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ibnr_stat_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_economic_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_economic_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reserving_balances_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reserving_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_budget_unit_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_budget_unit_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_movement_bookings_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_movement_bookings_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_entry_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_entry_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_wrapper','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ratio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ratio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','clear_down_session_id','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_transaction_journal_xwalk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_balance_entry_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_balance_ext_entry_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_journal_entry_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_corfah_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_corfah_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_uvm_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_uvm_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_mvmt_bkngs_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_mvmt_bkngs_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','investment_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','investment_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_entry_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_entry_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsagrmnt_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsagrmnt_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','q4_profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','q4_profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','sl_journal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','sl_journal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','hist_statis_pf_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','hist_statis_pf_transfer','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_g7m'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_delta','delta indentification, Cross Currency Rates',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_delta','delta indentification',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','intercompany_vendor_delta','delta indentification',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','intercompany_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','intercompany_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_remit_email_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_remit_email_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_address_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_address_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_delta','delta indentification',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_hierarchy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_hierarchy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_rating_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_rating_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_rating_delta','delta indentification',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','province_state_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','province_state_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','signing_authority_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','signing_authority_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','non_tech_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','non_tech_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_bank_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_bank_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_mdm'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pil_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_pil'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pil_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_pil'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_q0t'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_src_q0t'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_cashflow_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_cashflow_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_fsa_mv_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_fsa_mv_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_local_stat_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_local_stat_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_request_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_ady'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_request_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_ady'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','corso_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_general_codes_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_general_mapping_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_general_mapping_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_gm_metadata_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_gm_metadata_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_gsub_matrix_metadata_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_gsub_matrix_metadata_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_gsub_matrix_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_gsub_matrix_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_investment_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_investment_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_manual_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_manual_transaction_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_payroll_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','dwh_payroll_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_event_code_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_ledger_company_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_sub_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_trans_partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','glob_loss_evt_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','glob_loss_evt_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_journal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_journal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_journal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_journal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_crr'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_pattern_status_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_b_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_current_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_current_cashflow_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_factual_import_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_order_status_update','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_target_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_target_cashflow_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g32'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','act_contract_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','act_contract_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','act_volume_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','act_volume_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','init_contract_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','init_contract_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','init_volume_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','init_volume_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_hierarchy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ref_data_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','valuated_contract_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','valuated_contract_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','valuated_volume_plan_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','valuated_volume_projection_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','valuated_volume_set_event_status','gateway internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','volume_set_event_status','gateway internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','volume_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','valuated_volume_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g51'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_ap_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_ar_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','intercompany_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','intercompany_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','signing_authority_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','signing_authority_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','t_journal_entry_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','t_journal_entry_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_expenses_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_expenses_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','non_tech_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','non_tech_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_address_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_address_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_remit_email_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_remit_email_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_bank_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_bank_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g72'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_user_roles_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_user_roles_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_users_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_users_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_pattern_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_pattern_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_pttrn_rule_set_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_pttrn_rule_set_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_instalments_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_instalments_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_dp_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_dp_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','discount_factors_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','discount_factors_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','expense_factors_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','expense_factors_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_codes_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gm_metadata_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gm_metadata_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_balances_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_xwlk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_xwlk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_xwlk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_xwlk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_xwlk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_xwlk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsurance_xwlk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsurance_xwlk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_rating_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_rating_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_economic_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_economic_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_trad_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_trad_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reserving_balances_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reserving_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g73'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','adjustment_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','book_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_dist_to_contract_part_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','instalment_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_to_contract_part_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cashflow_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_history_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_history_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_part_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_part_relation_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_part_relation_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_relation_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_relation_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','contract_transaction_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_relation_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','fx_rate_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_codes_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_lookup_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mappings_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_event_code_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_ledger_company_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_sub_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_trans_prtnr_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_matrix_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gsub_matrix_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','industry_category_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','investment_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','journal_entry_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','migration_investment_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','migration_journal_entry_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','party_business_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','party_legal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','payroll_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_relation_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_request_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balances_request_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','proc_bal_lgl_enty_req_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','proc_bal_lgl_enty_req_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_relation_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','remittance_pair_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vector_stream_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g74'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_user_roles_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_user_roles_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_users_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_users_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_policy_insured_detail_reinsurance_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_policy_insured_detail_reinsurance_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ratio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ratio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_ref_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','financial_transaction_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_codes_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gm_metadata_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gm_metadata_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ibnr_round_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ibnr_round_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','lag_factor_patterns_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','lag_factor_patterns_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_xwlk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_xwlk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_xwlk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_xwlk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsurance_xwlk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsurance_xwlk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_reinsurance_agreement_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_reinsurance_agreement_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_scenario_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_scenario_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','proc_bal_lgl_enty_req_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','proc_bal_lgl_enty_req_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balance_request_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','processing_balance_request_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_cmpstn_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_cmpstn_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_ldngs_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_ldngs_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_stat_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_stat_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g76'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_pid_reins_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_pid_reins_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','business_date_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','business_date_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','business_partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','business_partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','business_partner_rating_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','business_partner_rating_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','employee_bank_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_event_code_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_event_code_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_ldgr_company_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_ldgr_company_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_sub_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_sub_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_trans_prtnr_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_trans_prtnr_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_trm_cond_deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','igr_trm_cond_deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','intercompany_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','intercompany_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_hierarchy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_hierarchy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsagrmnt_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsagrmnt_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pol_insrd_det_reins_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pol_insrd_det_reins_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_deal_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_budget_unit_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_scenario_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pricing_scenario_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','province_state_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','province_state_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reserving_balances_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reserving_balances_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','signing_authority_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','signing_authority_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_status_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statistical_portfolio_status_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','workforce_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_remit_email_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_remit_email_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_address_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_address_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','non_tech_vendor_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','non_tech_vendor_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_bank_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','vendor_bank_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g77'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_user_roles_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_user_roles_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_users_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','app_users_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_distribution_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','budget_unit_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_event_code_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_event_code_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_ledger_company_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_ledger_company_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_sub_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_sub_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsurance_agreement_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reinsurance_agreement_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_ext_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_ext_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_reinsurance_agreement_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_insured_detail_reinsurance_agreement_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_extension_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsurance_agreement_extension_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','transaction_partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','transaction_partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g79'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','bdgt_unt_ext_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','bdgt_unt_ext_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','bdgt_unt_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','bdgt_unt_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','combined_accordion_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','currency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','deal_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','exchange_rate_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_codes_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_metadata_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_metadata_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','general_mapping_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_account_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','global_loss_event_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','jrnl_lines_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','jrnl_lines_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','legal_entity_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','line_of_business_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_xwalk_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_deal_xwalk_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_policy_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reins_x_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_reins_x_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','partner_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pol_insrd_det_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','pol_insrd_det_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','policy_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','profit_centre_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsagrmnt_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reinsagrmnt_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statis_pf_cmpstn_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','statis_pf_cmpstn_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','underwriting_portfolio_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g7c'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cash_phoenix_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_pho'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cash_phoenix_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_pho'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_balance_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_pho'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','gl_balance_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_pho'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_rvl'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_rvl'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','reset_events_on_hold','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','run_automated_submission','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','run_dq_rules_row','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','run_dq_rules_total','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','run_file_control','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','run_use_case_derivation','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','start_batch_task','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','get_logs','internal processing',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_utils'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','claim_frequency_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','group_loss_reserve_transfer','translates and publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','loss_development_triangle_transfer','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_a38'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlbip_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlbip_transfer','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlced_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlced_transfer','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlcip_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlcip_transfer','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlfac_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlfac_transfer','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlkey_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlkey_transfer','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlpck_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','ticdlpck_transfer','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g7c_tgt_g24'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_publish','publishes data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g60'));
INSERT INTO DQ_USER.T_META_BATCH_TASK_CFG ("PROCESS_TYPE","PROCESS_NAME","PROCESS_DESCRIPTION","ERROR_THRESHOLD","THRESHOLD_IS_PERCENT","RUN_CONTROL","ACTIVE_INDICATOR","INTERFACE_ID")
  VALUES ('microflow','cost_transparency_wrapper','translates data',0,'N','N','A',(select interface_id from t_meta_interface where aptitude_project = 'g77_tgt_g60'));

-- Post-Load SQL T_META_BATCH_TASK_CFG
Prompt Post-Load SQL T_META_BATCH_TASK_CFG
prompt merge to t_meta_batch_task

delete from DQ_USER.t_meta_batch_task target
where not exists (select 1 from DQ_USER.t_meta_batch_task_cfg cfg where target.INTERFACE_ID = cfg.INTERFACE_ID and target.PROCESS_NAME = cfg.PROCESS_NAME);

merge
 into
   DQ_USER.t_meta_batch_task target
   using
     ( select   
            cfg.interface_id,
            cfg.process_type,
            cfg.process_name,
            cfg.process_description,
            cfg.error_threshold,
            cfg.threshold_is_percent,
            cfg.run_control,
            cfg.active_indicator
         from DQ_USER.t_meta_batch_task_cfg cfg
         inner join DQ_USER.t_meta_batch_task target
         on target.interface_id = cfg.interface_id  and target.PROCESS_NAME = cfg.PROCESS_NAME 
         and (
             nvl(target.process_type, '~') <>  nvl(cfg.process_type, '~') or
            nvl(target.process_description, '~') <> nvl(cfg.process_description, '~') or
            nvl(target.error_threshold, '~') <> nvl(cfg.error_threshold, '~') or
            nvl(target.threshold_is_percent, '~') <> nvl(cfg.threshold_is_percent, '~') or
            nvl(target.run_control, '~') <> nvl(cfg.run_control, '~') or
            nvl(target.active_indicator, '~') <> nvl(cfg.active_indicator, '~') 
              )
        union all
         select   
            cfg.interface_id,
            cfg.process_type,
            cfg.process_name,
            cfg.process_description,
            cfg.error_threshold,
            cfg.threshold_is_percent,
            cfg.run_control,
            cfg.active_indicator
         from DQ_USER.t_meta_batch_task_cfg cfg
         where not exists (select 1 from DQ_USER.t_meta_batch_task target where target.interface_id = cfg.interface_id and target.process_name = cfg.process_name )
         ) cfg
  on ( target.interface_id = cfg.interface_id and target.process_name = cfg.process_name  )
  when matched 
  then 
    update set 
             target.process_type =  cfg.process_type
           , target.process_description = cfg.process_description
           , target.error_threshold  = cfg.error_threshold
           , target.threshold_is_percent  = cfg.threshold_is_percent
           , target.run_control  = cfg.run_control
           , target.active_indicator  = cfg.active_indicator
           
    when not matched then insert 
    (       target.interface_id,
            target.process_type,
            target.process_name,
            target.process_description,
            target.error_threshold,
            target.threshold_is_percent,
            target.run_control,
            target.active_indicator
      ) values 
         (
            cfg.interface_id,
            cfg.process_type,
            cfg.process_name,
            cfg.process_description,
            cfg.error_threshold,
            cfg.threshold_is_percent,
            cfg.run_control,
            cfg.active_indicator
         );
commit;

Prompt dropping temporary config table DQ_USER.t_meta_batch_task_cfg

begin
  execute immediate 'drop table DQ_USER.t_meta_batch_task_cfg';
end;
/

commit;





set define on

commit;