begin
execute immediate 'ALTER TABLE G77_CFG.T_BATCH_TASK_STATUS drop CONSTRAINT FK_T_META_BATCH_TASK';
exception
when others then null;
end;
/


@@t_batch_task_status.sql
