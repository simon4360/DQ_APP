create or replace FUNCTION G77_CFG.FN_DA_UWRT_PF_SDL (p_table_name             IN VARCHAR2
                                                     ,p_key_column             IN VARCHAR2
                                                  --   ,p_session_id             IN VARCHAR2
                                                  --   ,p_derived_attribute_flag IN VARCHAR2
                                                  --   ,p_target                 IN VARCHAR2
                                                      )
RETURN T_UWRT_PF_SDL
IS
v_uwrt_pf_sdl T_UWRT_PF_SDL := T_UWRT_PF_SDL();
v_sql CLOB;

BEGIN
--p_table_name needs to be a table which contains all of line_bus_sdl, contr_nbr, src_sys_cd, bus_partic_typ_sdl, typ_agrmnt_sdl, prft_cntr_l5_cli_mgmnt_cd, igr_ind, lgl_enty_sdl
--p_key_column is the column you intend to join to the result of this function by

          v_sql := TO_CLOB(
                    'with t as (select distinct 
                                      '||p_key_column||'
                                     , contr_nbr
                                     , src_sys_cd
                                     , line_bus_sdl
                                     , bus_partic_typ_sdl
                                     , lgl_enty_sdl
                                     , typ_agrmnt_sdl
                                     , prft_cntr_l5_cli_mgmnt_cd 
                                     , igr_ind
                                  FROM '||p_table_name||'
                              )    
                    , result as   (   SELECT result.prod_hub_cd
                                               , rca.sdl_id as prod_hub_sdl
                                               , result.'||p_key_column||'
                                            FROM (          SELECT CASE WHEN NVL(TO_NUMBER(hub_co.priority),-1) > NVL(TO_NUMBER(hub.priority),-1)
                                                                        THEN hub_co.prod_hub
                                                                        ELSE hub.prod_hub
                                                                      END                                                                          AS prod_hub_cd
                                                                , ROW_NUMBER() OVER (PARTITION BY t.'||p_key_column||'
                                                                  ORDER BY GREATEST(NVL(TO_NUMBER(hub_co.priority),-1)
                                                                                   ,NVL(TO_NUMBER(hub.priority),-1)) DESC)                         AS rnk
                                                                , t.'||p_key_column||'                  
                                                             FROM t
                                                  LEFT OUTER JOIN ref_line_of_business     rlob
                                                               ON rlob.line_bus_sdl                = t.line_bus_sdl
                                                  LEFT OUTER JOIN v_gm107_trst_tran        trst
                                                               ON t.contr_nbr                      = trst.contr_nbr
                                                              AND t.src_sys_cd                     = trst.src_sys
                                                  LEFT OUTER JOIN v_gm013_typ_bus_grp_finc tobh1
                                                               ON t.bus_partic_typ_sdl             = tobh1.bus_partic_typ
                                                              AND TO_CHAR(t.typ_agrmnt_sdl)        = tobh1.typ_agrmnt
                                                  LEFT OUTER JOIN v_gm013_typ_bus_grp_finc tobh2
                                                               ON t.bus_partic_typ_sdl             = tobh2.bus_partic_typ
                                                              AND  tobh2.typ_agrmnt                = ''[ALL]''
                                                  LEFT OUTER JOIN v_gm111_prod_hub_tech_co hub_co
                                                               ON t.contr_nbr                      = hub_co.contr_nbr
                                                  LEFT OUTER JOIN v_gm112_prod_hub_tech hub
                                                               ON (t.lgl_enty_sdl                    BETWEEN to_number(hub.lgl_enty_from) AND to_number(hub.lgl_enty_to)
                                                              AND  NVL(trst.trst_tran,''NONE'')      BETWEEN hub.trst_tran_from           AND hub.trst_tran_to
                                                              AND  NVL(tobh1.typ_bus
                                                                      ,tobh2.typ_bus)                BETWEEN hub.tobh_from                AND hub.tobh_to
                                                              AND  t.prft_cntr_l5_cli_mgmnt_cd       BETWEEN hub.prft_cntr_from           AND hub.prft_cntr_to
                                                              AND  rlob.line_bus_cd                  BETWEEN hub.line_bus_from            AND hub.line_bus_to
                                                              AND  SUBSTR(NVL(t.igr_ind,''NO''),1,1) BETWEEN hub.igr_ind_from             AND hub.igr_ind_to
                                                              AND  hub.pol_type_from = ''01'')
                                              ) result
                                       LEFT JOIN ref_combined_accordion                       rca
                                              ON rca.domain_code        = result.prod_hub_cd
                                             AND rca.master_data_id     = ''1023069''
                                           WHERE rnk =1
                                      )
                     ,div_grp_finc as (SELECT gm19.div_grp_finc
                                            , t.'||p_key_column||'
                                         FROM t
                                         JOIN v_gm019_div_grp_finc gm19
                                           ON gm19.prft_cntr_l2_div = substr(t.prft_cntr_l5_cli_mgmnt_cd,1,4)
                                      )
                     ,lob_grp_finc as (SELECT lb.line_bus_grp_finc_cd
                                            , t.'||p_key_column||'
                                         FROM t
                                         JOIN ref_line_of_business lb
                                           ON lb.line_bus_sdl = t.line_bus_sdl
                                      )
                     , rankings as   (select distinct uwrt_pf_sdl
                                           , prod_hub_sdl
                                           , '||p_key_column||'
                                           , ROW_NUMBER() OVER (PARTITION BY '||p_key_column||' ORDER BY (priority)) AS rnk
                                        FROM (select ''1''                                 as priority                      
                                                   , gm131.uwrt_pf                         as uwrt_pf_sdl 
                                                   , result.'||p_key_column||'
                                                   , result.prod_hub_cd
                                                   , result.prod_hub_sdl
                                                FROM V_GM131_LOB_GRP_FINC_UWRT_PF gm131
                                                JOIN result
                                                  ON gm131.prod_hub                  = result.prod_hub_cd
                                                JOIN lob_grp_finc
                                                  ON gm131.lob_grp_finc              = lob_grp_finc.line_bus_grp_finc_cd
                                                 AND result.'||p_key_column||'       =  lob_grp_finc.'||p_key_column||'
                                                JOIN div_grp_finc
                                                  ON result.'||p_key_column||'       = div_grp_finc.'||p_key_column||'
                                                 AND div_grp_finc.'||p_key_column||' =  lob_grp_finc.'||p_key_column||' 
                                                 AND div_grp_finc.div_grp_finc in (''1A'',''1B'',''1C'',''1D'' )

                                              UNION

                                              select ''2''                                 as priority                      
                                                   , gm131.uwrt_pf                         as uwrt_pf_sdl 
                                                   , result.'||p_key_column||'
                                                   , result.prod_hub_cd
                                                   , result.prod_hub_sdl
                                                FROM V_GM131_LOB_GRP_FINC_UWRT_PF gm131
                                                JOIN result
                                                  ON gm131.prod_hub                  = result.prod_hub_cd
                                                JOIN lob_grp_finc
                                                  ON gm131.lob_grp_finc              = substr(lob_grp_finc.line_bus_grp_finc_cd,1,3)
                                                 AND result.'||p_key_column||'       =  lob_grp_finc.'||p_key_column||'
                                                JOIN div_grp_finc
                                                  ON result.'||p_key_column||'       = div_grp_finc.'||p_key_column||'
                                                 AND div_grp_finc.'||p_key_column||' =  lob_grp_finc.'||p_key_column||' 
                                                 AND div_grp_finc.div_grp_finc in (''1A'',''1B'',''1C'',''1D'' )

                                              UNION

                                              select ''3''                                   as priority                      
                                                   , gm131.uwrt_pf                         as uwrt_pf_sdl 
                                                   , result.'||p_key_column||'
                                                   , result.prod_hub_cd
                                                   , result.prod_hub_sdl
                                                FROM V_GM131_LOB_GRP_FINC_UWRT_PF gm131
                                                JOIN result
                                                  ON gm131.prod_hub            = result.prod_hub_cd
                                                JOIN lob_grp_finc
                                                  ON gm131.lob_grp_finc        = ''[ANY]''
                                                 AND result.'||p_key_column||' =  lob_grp_finc.'||p_key_column||'

                                              UNION

                                              select ''4''                                   as priority                      
                                                   , ''4000542''                             as uwrt_pf_sdl 
                                                   , result.'||p_key_column||'
                                                   , result.prod_hub_cd
                                                   , result.prod_hub_sdl
                                                FROM result
                                                JOIN div_grp_finc
                                                  ON result.'||p_key_column||'     = div_grp_finc.'||p_key_column||'
                                                 AND div_grp_finc.div_grp_finc not in (''1A'',''1B'',''1C'',''1D'' )
                                             )
                                     )
                     SELECT O_UWRT_PF_SDL( r.'||p_key_column||', r.prod_hub_sdl, r.uwrt_pf_sdl)
                       FROM rankings r
                      WHERE r.rnk=1'
                      );

EXECUTE IMMEDIATE v_sql BULK COLLECT into v_uwrt_pf_sdl;

RETURN v_uwrt_pf_sdl;
END;
/