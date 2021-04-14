create or replace FUNCTION G77_CFG.FN_DA_PROD_HUB_SDL (p_table_name IN VARCHAR2
                                                      ,p_key_column IN VARCHAR2
                                                      )
RETURN T_PROD_HUB_SDL
IS
v_prod_hub_sdl T_PROD_HUB_SDL := T_PROD_HUB_SDL();
v_sql VARCHAR2(4000);

BEGIN
--p_table_name needs to be a table which contains all of line_bus_sdl, contr_nbr, src_sys_cd, bus_partic_typ_sdl, typ_agrmnt_sdl, prft_cntr_l5_cli_mgmnt_cd, igr_ind, lgl_enty_sdl
--p_key_column is the column you intend to join to the result of this function by

          v_sql := ' SELECT O_PROD_HUB_SDL( result.'||p_key_column || ', rca.sdl_id)'                                                                             || chr(10)
               ||     'FROM (                     SELECT CASE WHEN NVL(TO_NUMBER(hub_co.priority),-1) > NVL(TO_NUMBER(hub.priority),-1)'                          || chr(10)
                                      ||                     'THEN hub_co.prod_hub'                                                                               || chr(10)
                                      ||                     'ELSE hub.prod_hub'                                                                                  || chr(10)
                                      ||                 'END                                                     AS prod_hub_cd'                                 || chr(10)
                                      ||              ', GREATEST(NVL(TO_NUMBER(hub_co.priority),-1)'                                                             || chr(10)
                                      ||                        ',NVL(TO_NUMBER(hub.priority),-1))                AS prio'                                        || chr(10)
                                      ||              ', ROW_NUMBER() OVER (PARTITION BY t.BDGT_UNT_KEY'                                                          || chr(10)
                                      ||                'ORDER BY GREATEST(NVL(TO_NUMBER(hub_co.priority),-1)'                                                    || chr(10)
                                      ||                                 ',NVL(TO_NUMBER(hub.priority),-1)) DESC) AS rnk'                                         || chr(10)
                                      ||              ', t.' ||p_key_column                                                                                       || chr(10)
                                      ||              'from '||p_table_name ||' t'                                                                                || chr(10)
                                      ||  'LEFT OUTER JOIN ref_line_of_business rlob'                                                                             || chr(10)
                                      ||               'ON rlob.line_bus_sdl                = t.line_bus_sdl'                                                     || chr(10)
                                      ||  'LEFT OUTER JOIN v_gm107_trst_tran trst'                                                                                || chr(10)
                                      ||               'ON t.contr_nbr                      = trst.contr_nbr'                                                     || chr(10)
                                      ||              'AND t.src_sys_cd                     = trst.src_sys'                                                       || chr(10)
                                      ||  'LEFT OUTER JOIN v_gm013_typ_bus_grp_finc tobh1'                                                                        || chr(10)
                                      ||               'ON t.bus_partic_typ_sdl             = tobh1.bus_partic_typ'                                               || chr(10)
                                      ||              'AND TO_CHAR(t.typ_agrmnt_sdl)        = tobh1.typ_agrmnt'                                                   || chr(10)
                                      ||  'LEFT OUTER JOIN v_gm013_typ_bus_grp_finc tobh2'                                                                        || chr(10)
                                      ||               'ON t.bus_partic_typ_sdl             = tobh2.bus_partic_typ'                                               || chr(10)
                                      ||              'AND  tobh2.typ_agrmnt                = ''[ALL]'''                                                          || chr(10)
                                      ||  'LEFT OUTER JOIN v_gm111_prod_hub_tech_co hub_co'                                                                       || chr(10)
                                      ||               'ON t.contr_nbr                      = hub_co.contr_nbr'                                                   || chr(10)
                                      ||  'LEFT OUTER JOIN v_gm112_prod_hub_tech hub'                                                                             || chr(10)
                                      ||               'ON (t.lgl_enty_sdl                    BETWEEN to_number(hub.lgl_enty_from) AND to_number(hub.lgl_enty_to)'|| chr(10)
                                      ||              'AND  NVL(trst.trst_tran,''NONE'')      BETWEEN hub.trst_tran_from           AND hub.trst_tran_to'          || chr(10)
                                      ||              'AND  NVL(tobh1.typ_bus'                                                                                    || chr(10)
                                      ||                      ',tobh2.typ_bus)                BETWEEN hub.tobh_from                AND hub.tobh_to'               || chr(10)
                                      ||              'AND  t.prft_cntr_l5_cli_mgmnt_cd       BETWEEN hub.prft_cntr_from           AND hub.prft_cntr_to'          || chr(10)
                                      ||              'AND  rlob.line_bus_cd                  BETWEEN hub.line_bus_from            AND hub.line_bus_to'           || chr(10)
                                      ||              'AND  SUBSTR(NVL(t.igr_ind,''NO''),1,1) BETWEEN hub.igr_ind_from             AND hub.igr_ind_to'            || chr(10) 
                                      ||              'AND  hub.pol_type_from = ''01'')'                                                                          || chr(10)
                                      ||      ') result'                                                                                                          || chr(10)
               ||'LEFT JOIN ref_combined_accordion                       rca'                                                                                     || chr(10)
               ||       'ON rca.domain_code        = result.prod_hub_cd'                                                                                          || chr(10)
               ||      'AND rca.master_data_id     = ''1023069'''                                                                                                 || chr(10)
               ||    'WHERE result.rnk             = 1';
                                              
EXECUTE IMMEDIATE v_sql BULK COLLECT into v_prod_hub_sdl;

RETURN v_prod_hub_sdl;
END;
/