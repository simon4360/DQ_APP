--Generic Triggers
@@tr_t_error_log_aud.sql
@@tr_t_error_log_activ_ind.sql
@@tr_t_meta_table_dq_aud.sql
@@tr_t_meta_interface_aud.sql

--CorDL
@@tr_t_batch_status_aud.sql

--CorDL Ref Tables
begin
for trigger_ddl in (
select pkg_maintenance_util.create_audit_trigger_dml ( ref.table_name , aud.table_name  ) stmt
from t_meta_table ref 
inner join t_meta_table aud on aud.table_id = ref.audit_table_id
)
loop 
  execute immediate trigger_ddl.stmt;
end loop;
end;
/
