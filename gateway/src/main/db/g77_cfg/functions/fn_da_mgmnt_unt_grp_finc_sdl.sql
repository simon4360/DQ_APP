create or replace FUNCTION G77_CFG.FN_DA_MGMNT_UNT_GRP_FINC_SDL(p_table_name IN VARCHAR2
                                                               ,p_key_column IN VARCHAR2
                                                               )
RETURN T_MGMNT_UNT_GRP_FINC_SDL
IS
v_mgmnt_unt_grp_finc_sdl T_MGMNT_UNT_GRP_FINC_SDL := T_MGMNT_UNT_GRP_FINC_SDL();
v_sql VARCHAR2(4000);
BEGIN
--p_table_name needs to be a table which contains prft_cntr_cd
--p_key_column is the column you intend to join to the result of this function by

           v_sql := 'with t as (SELECT DISTINCT
                                       '||p_key_column||'
                                     , prft_cntr_cd
                                  FROM '||p_table_name||'
                               )
                   SELECT O_MGMNT_UNT_GRP_FINC_SDL(t.'||p_key_column||', ca.sdl_id)
                     FROM t
                     JOIN v_gm020_mgmnt_unt_grp_finc                                gm20
                       ON substr(t.prft_cntr_cd,1,6) = gm20.prft_cntr_l3_mgmnt_unt
                     JOIN ref_combined_accordion                                    ca
                       ON ca.domain_code = gm20.mgmnt_unt_grp_finc
                      AND ca.master_data_id = ''101204''
                    ';
                                
EXECUTE IMMEDIATE v_sql BULK COLLECT into v_mgmnt_unt_grp_finc_sdl;

RETURN v_mgmnt_unt_grp_finc_sdl;
END;
/