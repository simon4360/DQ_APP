create or replace PACKAGE BODY G77_CFG.pkg_pipeline_fn AS
lb_FSIC BOOLEAN := FALSE;
--lb_FSIC BOOLEAN := TRUE;

TYPE tab_count IS TABLE OF NUMBER  -- Associative array type
    INDEX BY VARCHAR2(64);            --  indexed by string


FUNCTION replace_FSIC (p_in VARCHAR2)
RETURN VARCHAR2 AS
BEGIN
  RETURN
REPLACE(
  REPLACE(
    REPLACE(
      REPLACE(
        REPLACE(
          REPLACE(
            REPLACE(
              REPLACE(
                REPLACE(
                  REPLACE(
                    REPLACE(
                      REPLACE(
                        REPLACE(
                          REPLACE(
                            REPLACE(
                              REPLACE(p_in,'T_G71_PRTNR_POL_INSRD_DET_X_IN','T_G71_PNR_POL_INS_DET_X_IN_FSC')
                                ,'T_G71_PRICING_CNTRCT_X_IN','T_G71_PRICING_CNTRCT_X_IN_FSIC')
                                ,'T_G71_POLICY_REINSURANCE_X_IN','T_G71_POL_REINSURANCE_X_IN_FSC')
                                ,'T_G71_POLICY_DEAL_X_IN','T_G71_POLICY_DEAL_X_IN_FSIC')
                                ,'T_G71_PARTNER_REINSRNCE_X_IN','T_G71_PART_REINSRNCE_X_IN_FSIC')
                                ,'T_G71_PARTNER_POLICY_X_IN','T_G71_PARTNER_POLICY_X_IN_FSIC')
                                ,'T_G71_PARTNER_DEAL_X_IN','T_G71_PARTNER_DEAL_X_IN_FSIC')
                                ,'T_G71_REINSAGRMNT_PRICING_IN','T_G71_REINSAGRMNT_PRIC_IN_FSIC')
                                ,'T_G71_REINSURANCE_IN','T_G71_REINSURANCE_IN_FSIC')
                                ,'T_G71_POLINSRDDTL_IN','T_G71_POLINSRDDTL_IN_FSIC')
                                ,'T_G71_POLICY_PRICING_IN','T_G71_POLICY_PRICING_IN_FSIC')
                                ,'T_G71_POLICY_IN','T_G71_POLICY_IN_FSIC')
                                ,'T_G71_FINANCIAL_TRANSACTION_IN','T_G71_FINANCIAL_TRANS_IN_FSIC')
                                ,'T_G71_DEAL_PRICING_IN','T_G71_DEAL_PRICING_IN_FSIC')
                                ,'T_G71_DEAL_IN','T_G71_DEAL_IN_FSIC'),
                                'T_G71_CLAIM_IN','T_G71_CLAIM_IN_FSIC')
                                ;

END replace_FSIC;

FUNCTION get_use_case
RETURN ty_pf_usecase_tab PIPELINED IS
lr_row  ty_pf_usecase_row;
tab_count_aat  tab_count;        -- Associative array variable

BEGIN
FOR c1 IN
  (
   SELECT
     uc_use_case_id,
     uc_staging_table,
     uc_order,
     use_case_sql
   FROM
   (
     SELECT
        uc_use_case_id,
        uc_staging_table,
        uc_order,
        'SELECT COUNT(*)'||CHR(13)||
        'FROM '||uc_staging_table||' '||CHR(13)||
           CASE
             WHEN pkg_uc_derivation.fn_uc_join_condition ( cfg.uc_config_id, cfg.uc_staging_table)  IS NULL THEN NULL
             ELSE pkg_uc_derivation.fn_uc_join_condition ( cfg.uc_config_id, cfg.uc_staging_table)||CHR(13)
           END||
           'WHERE '||
           replace(replace(REPLACE ( pkg_uc_derivation.fn_uc_where_clause ( cfg.uc_use_case_id
                                                          , cfg.uc_where_clause
                                                          , cfg.uc_staging_table
                                                          , cfg.uc_bus_evt_tran_typ_filter
                                                          , 'IS'
                                                          , cfg.uc_override_existing_flag
                                                           ), uc_staging_table||'.UC_SESSION_ID = :p_uc_session_id', '1=1'), uc_staging_table||'.EVENT_STATUS = 0', '1=1')
                                                          ,'AND '||uc_staging_table||'.UC_SESSION_ID = ''REGEX_UC_SESSION''') as use_case_sql
     FROM v_meta_uc_config cfg
   )
  )
LOOP
   -- The rename of the landing table to a FSIC equivilent will be removed for production
   IF NOT lb_FSIC THEN
   lr_row.uc_staging_table       := c1.uc_staging_table;
   ELSE
   lr_row.uc_staging_table       := replace_FSIC(c1.uc_staging_table);
   END IF;

   IF NOT tab_count_aat.EXISTS(lr_row.uc_staging_table) THEN
      EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||lr_row.uc_staging_table INTO tab_count_aat(lr_row.uc_staging_table);
   END IF;

   lr_row.use_case         := c1.uc_use_case_id;
   lr_row.use_case_order   := c1.uc_order;
   lr_row.src_table_count  := tab_count_aat(lr_row.uc_staging_table);
   lr_row.use_case_sql_err := NULL;
   BEGIN
   IF NOT lb_FSIC THEN
      EXECUTE IMMEDIATE c1.use_case_sql INTO lr_row.use_case_count;
   ELSE
      EXECUTE IMMEDIATE replace_FSIC(c1.use_case_sql) INTO lr_row.use_case_count;
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         lr_row.use_case_count := -1;
         lr_row.use_case_sql_err := SQLERRM;
   END;

   IF NOT lb_FSIC THEN
   lr_row.use_case_sql := c1.use_case_sql;
   ELSE
   lr_row.use_case_sql := replace_FSIC(c1.use_case_sql);
   END IF;

   PIPE ROW (lr_row);
END LOOP;
    RETURN;
END get_use_case;
END pkg_pipeline_fn;
/