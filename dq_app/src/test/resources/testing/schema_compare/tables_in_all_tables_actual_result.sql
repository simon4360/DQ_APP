(
select 'Table exists in T_META_TABLE but does not exist in the database.' error_msg, table_name from user_tables
)
