@@fn_generate_key.sql
@@fn_get_session_id.sql
@@fn_get_finc_prd.sql
@@fn_get_hash.sql
@@fn_nvl_cordl.sql
@@fn_nvl_lfd.sql
@@fn_concatenate_columns.sql

--Data Quality
--Generic
@@fn_dq_tm1contracts.sql
@@fn_dqisnotnull_string.sql
@@fn_dqis_date.sql
@@fn_dqis_number.sql
@@fn_dq_validate_file_load.sql
@@fn_dqcheckmappings.sql
@@fn_dqis_mdmvalue.sql
@@fn_dq_debit_credit_amount.sql
@@fn_dqcheck_g77config.sql
@@fn_dqcheckmappings_ldr_co.sql
@@fn_gsub_matrix_lookup.sql
@@fn_dqcheck_g77lookup.sql
@@fn_dqis_mdmvalueexists.sql
@@fn_dqis_exclusionlist_item.sql
@@fn_dqmdm_exchg_rate.sql
@@fn_dqis_exclude_conditional.sql
@@fn_dq_gm_and_accordion_mapping.sql
@@fn_dqis_exclude_g71_data.sql
@@fn_dqis_multival_notnull.sql
@@fn_dqis_multival_nullable.sql
@@fn_dqis_singleval_notnull.sql
@@fn_dqis_singleval_nullable.sql

--SRAM
@@fn_dqfa0_rollfrwd_balance.sql
@@fn_dqfa0_balance.sql

--Quantum
@@fn_dqis_g72value.sql
@@fn_dqq0t_balance.sql

--Oracle
@@fn_dqg72_checkmappings_cp.sql

--Use case derivation
@@fn_get_todays_business_date.sql
@@fn_dqmappingingencodes.sql


--g71
@@fn_dqg71_deal_exclusion.sql

--g32
@@fn_dqg32_order_request.sql
@@fn_g32_get_cashflow.sql