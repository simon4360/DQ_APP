alter table DQ_USER.t_meta_batch_task_table_x add constraint fk_bttx_batch_task foreign key(BATCH_TASK_ID) references DQ_USER.T_META_BATCH_TASK(BATCH_TASK_ID) ON DELETE CASCADE ENABLE;
alter table DQ_USER.t_meta_batch_task_table_x add constraint fk_bttx_table foreign key(TABLE_ID) references DQ_USER.T_META_TABLE(TABLE_ID) ON DELETE CASCADE ENABLE;