(
select 'Table exists in T_META_TABLE but does not exist in the database.' error_msg, table_name from g77_cfg.t_meta_table
	where
		schema_name = 'G77_CFG'
		and category in ('AUDIT','REFERENCE','INTERFACE','OPERATIONAL')
		and ACTIVE_INDICATOR = 'A'
)
