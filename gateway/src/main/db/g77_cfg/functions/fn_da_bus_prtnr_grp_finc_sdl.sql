create or replace FUNCTION G77_CFG.FN_DA_BUS_PRTNR_GRP_FINC_SDL(p_table_name IN VARCHAR2
                                                               ,p_key_column IN VARCHAR2
                                                               )
RETURN T_BUS_PRTNR_GRP_FINC_SDL
IS
v_bus_prtnr_grp_finc_sdl T_BUS_PRTNR_GRP_FINC_SDL := T_BUS_PRTNR_GRP_FINC_SDL();
v_sql VARCHAR2(4000);
BEGIN
--p_table_name needs to be a table which contains prtnr_sdl
--p_key_column is the column you intend to join to the result of this function by

           v_sql := 'with t as (SELECT DISTINCT
                                       '||p_key_column||'
                                  FROM '||p_table_name||'
                               )
                   SELECT O_BUS_PRTNR_GRP_FINC_SDL(t.'||p_key_column||', ca.sdl_id)
                     FROM t
                     JOIN v_gm016_tran_prtnr                        gm16
                       ON t.prtnr_sdl = gm16.bus_prtnr
                     JOIN v_gm010_bus_prtnr_grp_finc                gm10
                       ON gm16.tran_prtnr = gm10.tran_prtnr
                     JOIN ref_combined_accordion                    ca 
                       ON ca.domain_code = gm10.bus_prtnr_grp_finc
                      AND master_data_id = ''1022655''
                    ';
                                
EXECUTE IMMEDIATE v_sql BULK COLLECT into v_bus_prtnr_grp_finc_sdl;

RETURN v_bus_prtnr_grp_finc_sdl;
END;
/