Delete from DQ_USER.t_file_config;

Insert Into  DQ_USER.t_file_config (file_id, use_case_id, source_system, file_name_pattern, file_path, header_footer,file_desc, tgt_charset)    
 Values (1, 'UCN1011', 'Q0T', 'AGT_CorSo_GLCashflows_*.txt','Q0T','N','AGT Quantum Cashflows', 'n/a' );
Insert Into  DQ_USER.t_file_config (file_id, use_case_id, source_system, file_name_pattern, file_path, header_footer,file_desc, tgt_charset)    
 Values (2, 'UCN1043', 'ADY', 'WT_*.enc','ADY','Y','ADP Payroll File', 'utf-8' );
insert into t_file_config (file_id,use_case_id,source_system,file_name_pattern,file_path,header_footer,file_desc, tgt_charset) 
 Values (3, 'UCN3009a','SAP','*_ORA_CORFIT_AP*.csv','G61','N','CT AP Invoice File', 'n/a');
insert into t_file_config (file_id,use_case_id,source_system,file_name_pattern,file_path,header_footer,file_desc, tgt_charset) 
 Values (4, 'UCN3009b','SAP','*_ORA_CORFIT_AR*.csv','G61','N','CT AR Invoice File', 'n/a'); 
insert into t_file_config (file_id,use_case_id,source_system,file_name_pattern,file_path,header_footer,file_desc, tgt_charset) 
 Values (5, 'UCN1033b','SAP','ERS_CORFACTS*.csv','ERS','N','ERS Invoice Payments File', 'n/a');

Commit;
