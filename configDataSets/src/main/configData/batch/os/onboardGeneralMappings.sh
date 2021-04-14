#!/bin/bash

# This script extracts general mappings from @GenMapMasterUserName@ ... typically UAT and loads to @env@


mknod gm.extract p

nohup gzip -c < gm.extract > gm_out.dat.gz &

sqlplus -s @GenMapMasterUserName@/@GenMapMasterPassword@@@GenMapMasterConnectString@ 1>/dev/null << _EOF
set escape on
set termout off
set heading off
set underline "_"
set pagesize 0 embedded on
set linesize 32000
set LONG 50000
set colsep '"|"'
set feedback off
set trimspool on
spool gm.extract
select
   GATEWAY_ID || '|'
|| '"'|| MAPPING_TYPE_ID || '"|'
|| '"'|| MAPPING_TYPE_GROUP || '"|'
|| '"'|| SOURCE_SYSTEM_CODE || '"|'
|| case nvl ( MATCH_KEY_1, '~') when '~' then '|' else '"'|| MATCH_KEY_1 || '"|' end
|| case nvl ( MATCH_KEY_1_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_1_DESC || '"|' end
|| case nvl ( MATCH_KEY_2, '~') when '~' then '|' else '"'|| MATCH_KEY_2 || '"|' end
|| case nvl ( MATCH_KEY_2_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_2_DESC || '"|' end
|| case nvl ( MATCH_KEY_3, '~') when '~' then '|' else '"'|| MATCH_KEY_3 || '"|' end
|| case nvl ( MATCH_KEY_3_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_3_DESC || '"|' end
|| case nvl ( MATCH_KEY_4, '~') when '~' then '|' else '"'|| MATCH_KEY_4 || '"|' end
|| case nvl ( MATCH_KEY_4_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_4_DESC || '"|' end
|| case nvl ( MATCH_KEY_5, '~') when '~' then '|' else '"'|| MATCH_KEY_5 || '"|' end
|| case nvl ( MATCH_KEY_5_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_5_DESC || '"|' end
|| case nvl ( MATCH_KEY_6, '~') when '~' then '|' else '"'|| MATCH_KEY_6 || '"|' end
|| case nvl ( MATCH_KEY_6_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_6_DESC || '"|' end
|| case nvl ( MATCH_KEY_7, '~') when '~' then '|' else '"'|| MATCH_KEY_7 || '"|' end
|| case nvl ( MATCH_KEY_7_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_7_DESC || '"|' end
|| case nvl ( MATCH_KEY_8, '~') when '~' then '|' else '"'|| MATCH_KEY_8 || '"|' end
|| case nvl ( MATCH_KEY_8_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_8_DESC || '"|' end
|| case nvl ( MATCH_KEY_9, '~') when '~' then '|' else '"'|| MATCH_KEY_9 || '"|' end
|| case nvl ( MATCH_KEY_9_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_9_DESC || '"|' end
|| case nvl ( MATCH_KEY_10, '~') when '~' then '|' else '"'|| MATCH_KEY_10 || '"|' end
|| case nvl ( MATCH_KEY_10_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_10_DESC || '"|' end
|| case nvl ( MATCH_KEY_11, '~') when '~' then '|' else '"'|| MATCH_KEY_11 || '"|' end
|| case nvl ( MATCH_KEY_11_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_11_DESC || '"|' end
|| case nvl ( MATCH_KEY_12, '~') when '~' then '|' else '"'|| MATCH_KEY_12 || '"|' end
|| case nvl ( MATCH_KEY_12_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_12_DESC || '"|' end
|| case nvl ( MATCH_KEY_13, '~') when '~' then '|' else '"'|| MATCH_KEY_13 || '"|' end
|| case nvl ( MATCH_KEY_13_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_13_DESC || '"|' end
|| case nvl ( MATCH_KEY_14, '~') when '~' then '|' else '"'|| MATCH_KEY_14 || '"|' end
|| case nvl ( MATCH_KEY_14_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_14_DESC || '"|' end
|| case nvl ( MATCH_KEY_15, '~') when '~' then '|' else '"'|| MATCH_KEY_15 || '"|' end
|| case nvl ( MATCH_KEY_15_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_15_DESC || '"|' end
|| case nvl ( MATCH_KEY_16, '~') when '~' then '|' else '"'|| MATCH_KEY_16 || '"|' end
|| case nvl ( MATCH_KEY_16_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_16_DESC || '"|' end
|| case nvl ( MATCH_KEY_17, '~') when '~' then '|' else '"'|| MATCH_KEY_17 || '"|' end
|| case nvl ( MATCH_KEY_17_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_17_DESC || '"|' end
|| case nvl ( MATCH_KEY_18, '~') when '~' then '|' else '"'|| MATCH_KEY_18 || '"|' end
|| case nvl ( MATCH_KEY_18_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_18_DESC || '"|' end
|| case nvl ( MATCH_KEY_19, '~') when '~' then '|' else '"'|| MATCH_KEY_19 || '"|' end
|| case nvl ( MATCH_KEY_19_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_19_DESC || '"|' end
|| case nvl ( MATCH_KEY_20, '~') when '~' then '|' else '"'|| MATCH_KEY_20 || '"|' end
|| case nvl ( MATCH_KEY_20_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_20_DESC || '"|' end
|| case nvl ( MATCH_KEY_21, '~') when '~' then '|' else '"'|| MATCH_KEY_21 || '"|' end
|| case nvl ( MATCH_KEY_21_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_21_DESC || '"|' end
|| case nvl ( MATCH_KEY_22, '~') when '~' then '|' else '"'|| MATCH_KEY_22 || '"|' end
|| case nvl ( MATCH_KEY_22_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_22_DESC || '"|' end
|| case nvl ( MATCH_KEY_23, '~') when '~' then '|' else '"'|| MATCH_KEY_23 || '"|' end
|| case nvl ( MATCH_KEY_23_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_23_DESC || '"|' end
|| case nvl ( MATCH_KEY_24, '~') when '~' then '|' else '"'|| MATCH_KEY_24 || '"|' end
|| case nvl ( MATCH_KEY_24_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_24_DESC || '"|' end
|| case nvl ( MATCH_KEY_25, '~') when '~' then '|' else '"'|| MATCH_KEY_25 || '"|' end
|| case nvl ( MATCH_KEY_25_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_25_DESC || '"|' end
|| case nvl ( MATCH_KEY_26, '~') when '~' then '|' else '"'|| MATCH_KEY_26 || '"|' end
|| case nvl ( MATCH_KEY_26_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_26_DESC || '"|' end
|| case nvl ( MATCH_KEY_27, '~') when '~' then '|' else '"'|| MATCH_KEY_27 || '"|' end
|| case nvl ( MATCH_KEY_27_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_27_DESC || '"|' end
|| case nvl ( MATCH_KEY_28, '~') when '~' then '|' else '"'|| MATCH_KEY_28 || '"|' end
|| case nvl ( MATCH_KEY_28_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_28_DESC || '"|' end
|| case nvl ( MATCH_KEY_29, '~') when '~' then '|' else '"'|| MATCH_KEY_29 || '"|' end
|| case nvl ( MATCH_KEY_29_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_29_DESC || '"|' end
|| case nvl ( MATCH_KEY_30, '~') when '~' then '|' else '"'|| MATCH_KEY_30 || '"|' end
|| case nvl ( MATCH_KEY_30_DESC, '~') when '~' then '|' else '"'|| MATCH_KEY_30_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_1, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_1 || '"|' end
|| case nvl ( LOOKUP_VALUE_1_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_1_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_2, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_2 || '"|' end
|| case nvl ( LOOKUP_VALUE_2_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_2_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_3, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_3 || '"|' end
|| case nvl ( LOOKUP_VALUE_3_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_3_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_4, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_4 || '"|' end
|| case nvl ( LOOKUP_VALUE_4_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_4_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_5, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_5 || '"|' end
|| case nvl ( LOOKUP_VALUE_5_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_5_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_6, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_6 || '"|' end
|| case nvl ( LOOKUP_VALUE_6_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_6_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_7, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_7 || '"|' end
|| case nvl ( LOOKUP_VALUE_7_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_7_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_8, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_8 || '"|' end
|| case nvl ( LOOKUP_VALUE_8_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_8_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_9, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_9 || '"|' end
|| case nvl ( LOOKUP_VALUE_9_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_9_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_10, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_10 || '"|' end
|| case nvl ( LOOKUP_VALUE_10_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_10_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_11, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_11 || '"|' end
|| case nvl ( LOOKUP_VALUE_11_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_11_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_12, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_12 || '"|' end
|| case nvl ( LOOKUP_VALUE_12_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_12_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_13, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_13 || '"|' end
|| case nvl ( LOOKUP_VALUE_13_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_13_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_14, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_14 || '"|' end
|| case nvl ( LOOKUP_VALUE_14_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_14_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_15, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_15 || '"|' end
|| case nvl ( LOOKUP_VALUE_15_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_15_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_16, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_16 || '"|' end
|| case nvl ( LOOKUP_VALUE_16_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_16_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_17, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_17 || '"|' end
|| case nvl ( LOOKUP_VALUE_17_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_17_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_18, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_18 || '"|' end
|| case nvl ( LOOKUP_VALUE_18_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_18_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_19, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_19 || '"|' end
|| case nvl ( LOOKUP_VALUE_19_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_19_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_20, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_20 || '"|' end
|| case nvl ( LOOKUP_VALUE_20_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_20_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_21, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_21 || '"|' end
|| case nvl ( LOOKUP_VALUE_21_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_21_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_22, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_22 || '"|' end
|| case nvl ( LOOKUP_VALUE_22_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_22_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_23, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_23 || '"|' end
|| case nvl ( LOOKUP_VALUE_23_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_23_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_24, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_24 || '"|' end
|| case nvl ( LOOKUP_VALUE_24_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_24_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_25, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_25 || '"|' end
|| case nvl ( LOOKUP_VALUE_25_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_25_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_26, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_26 || '"|' end
|| case nvl ( LOOKUP_VALUE_26_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_26_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_27, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_27 || '"|' end
|| case nvl ( LOOKUP_VALUE_27_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_27_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_28, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_28 || '"|' end
|| case nvl ( LOOKUP_VALUE_28_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_28_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_29, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_29 || '"|' end
|| case nvl ( LOOKUP_VALUE_29_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_29_DESC || '"|' end
|| case nvl ( LOOKUP_VALUE_30, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_30 || '"|' end
|| case nvl ( LOOKUP_VALUE_30_DESC, '~') when '~' then '|' else '"'|| LOOKUP_VALUE_30_DESC || '"|' end
|| '"'|| ACTIVE_INDICATOR || '"|'
|| '"'||  INPUT_BY || '"|'
|| '"'|| to_char ( INPUT_TIME , 'YYYY-MM-DD HH24:MI:SS' ) || '"|'
|| '"'|| to_char ( INPUT_TIME_GMT , 'YYYY-MM-DD HH24:MI:SS' ) || '"|'
|| '"'|| APPROVED_BY || '"|'
|| '"'|| AUTH_BY || '"|'
|| '"'|| AUTH_STATUS  || '"|'
|| '"'|| to_char ( EFFECTIVE_FROM , 'YYYY-MM-DD HH24:MI:SS' )  || '"|'
|| '"'|| to_char ( EFFECTIVE_TO , 'YYYY-MM-DD HH24:MI:SS' )  || '"{EOL}'
from g77_cfg.t_general_mappings where active_indicator = 'A';
spool off
set termout on


_EOF

rm gm.extract


sqlplus -s @g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@  << _EOF

alter table @g77_cfgUsername@.t_general_mappings drop column gateway_id;

alter trigger @g77_cfgUsername@.tr_t_general_mappings_change disable;

alter table @g77_cfgUsername@.t_general_mappings add (gateway_id number generated by default as identity );

alter table @g77_cfgUsername@.t_general_mappings add constraint PK_T_GENERAL_MAPPINGS primary key("GATEWAY_ID");

commit;

_EOF



gunzip -c < gm_out.dat.gz >  gm.load
sqlldr userid=@g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@ control=gm.ctl log=results.log bad=results.bad discard=results.dsc data=gm.load errors=999 1>/dev/null

rm gm.load
rm gm_out.dat.gz

sqlplus -s @g77_cfgUsername@/@g77_cfgPassword@@@oracleServiceName@  << _EOF

alter table @g77_cfgUsername@.t_general_mappings modify gateway_id  generated by default as identity ( start with limit value );

alter trigger @g77_cfgUsername@.tr_t_general_mappings_change enable;

exec g77_cfg.pr_gm_views_repoint ( p_source_table => 't_general_mappings');

exec dbms_utility.compile_schema(schema => upper('@g77_cfgUsername@'));

exec g77_cfg.pr_meta_validate_config;

commit;
_EOF

exit;

