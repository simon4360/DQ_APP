create or replace FUNCTION G77_CFG.FN_DA_BUS_SGMT_PRTNR_SDL(p_table_name IN VARCHAR2
                                                           ,p_key_column IN VARCHAR2
                                                           )
RETURN T_BUS_SGMT_PRTNR_SDL
IS
v_bus_sgmt_prtnr_sdl T_BUS_SGMT_PRTNR_SDL := T_BUS_SGMT_PRTNR_SDL();
v_sql VARCHAR2(4000);
BEGIN
--p_table_name needs to be a table which contains prtnr_sdl
--p_key_column is the column you intend to join to the result of this function by

           v_sql := 'with t as (SELECT DISTINCT
                                       '||p_key_column||'
                                  FROM '||p_table_name||'
                               )
                   SELECT O_BUS_SGMT_PRTNR_SDL(t.'||p_key_column||', ca.sdl_id)
                     FROM t
                     JOIN v_gm016_tran_prtnr                    gm16
                       ON t.prtnr_sdl = gm16.bus_prtnr
                     JOIN v_gm051_bus_sgmt_prtnr                gm51
                       ON gm16.tran_prtnr = gm51.tran_prtnr
                     JOIN ref_combined_accordion                ca
                       ON ca.domain_code = gm51.bus_sgmt_prtnr
                      AND master_data_id = ''1022655''
                    ';
                                
EXECUTE IMMEDIATE v_sql BULK COLLECT into v_bus_sgmt_prtnr_sdl;

RETURN v_bus_sgmt_prtnr_sdl;
END;
/
