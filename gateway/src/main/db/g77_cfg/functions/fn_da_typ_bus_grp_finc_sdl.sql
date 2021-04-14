create or replace FUNCTION G77_CFG.FN_DA_TYP_BUS_GRP_FINC_SDL(p_table_name IN VARCHAR2
                                                             ,p_key_column IN VARCHAR2
                                                             )
RETURN T_TYP_BUS_GRP_FINC_SDL
IS
v_typ_bus_grp_finc_sdl T_TYP_BUS_GRP_FINC_SDL := T_TYP_BUS_GRP_FINC_SDL();
v_sql VARCHAR2(4000);

BEGIN
--p_table_name needs to be a table which contains bus_partic_typ_sdl and typ_agrmnt_sdl
--p_key_column is the column you intend to join to the result of this function by

           v_sql := 'with t as (SELECT DISTINCT
                                       '||p_key_column||'
                                     , bus_partic_typ_sdl
                                     , typ_agrmnt_sdl
                                  FROM '||p_table_name||'
                               )
                   SELECT O_TYP_BUS_GRP_FINC_SDL( t.'||p_key_column ||', ca.SDL_ID)      
                     FROM t                                         
                     JOIN V_GM013_TYP_BUS_GRP_FINC                                 gm13  
                       ON  to_char(t.bus_partic_typ_sdl) = gm13.BUS_PARTIC_TYP           
                      AND (to_char(t.typ_agrmnt_sdl)     = gm13.TYP_AGRMNT               
                            OR gm13.TYP_AGRMNT           = ''[ALL]'')                    
                     JOIN ref_combined_accordion                                   ca    
                       ON gm13.typ_bus                   = ca.domain_code                
                      AND ca.master_data_id              = ''11152996''
                    ';
                                
EXECUTE IMMEDIATE v_sql BULK COLLECT into v_typ_bus_grp_finc_sdl;

RETURN v_typ_bus_grp_finc_sdl;
END;
/