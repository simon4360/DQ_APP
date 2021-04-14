alter table DQ_USER.t_meta_table_dq add constraint fk_tbl_dq_table foreign key(TABLE_ID) references DQ_USER.T_META_TABLE(TABLE_ID) ON DELETE CASCADE ENABLE;
alter table DQ_USER.t_meta_table_dq add constraint fk_dq_function foreign key(DQ_FUNCTION_ID) references DQ_USER.T_DQ_FUNCTION (DQ_FUNCTION_ID) ON DELETE CASCADE ENABLE;
alter table DQ_USER.t_meta_table_dq add constraint fk_dq_severity foreign key(DQ_SEVERITY_ID) references DQ_USER.T_DQ_SEVERITY (DQ_SEVERITY_ID) ON DELETE CASCADE ENABLE;
alter table DQ_USER.t_meta_table_dq add constraint fk_dq_condition foreign key(DQ_CONDITION_ID) references DQ_USER.T_DQ_CONDITION (DQ_CONDITION_ID) ON DELETE CASCADE ENABLE;