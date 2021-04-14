create or replace function g77_cfg.fn_g32_get_cashflow (p_session_id varchar2, p_vctr_strm_key varchar2)
  RETURN  CLOB
IS
  v_return  CLOB;

BEGIN

  for cashflow in (
        select /*+ PARALLEL */
                to_char ( to_date(cashflow.evm_exptd_cf_date, 'YYYYMMDD'), 'DD/MM/YYYY') ||':'|| cashflow.mvmt_amt_orig_crncy as elem
          from T_G32_CASH_FLOW_CORDL_IN  cashflow
         where cashflow.vctr_strm_key = p_vctr_strm_key
           and cashflow.session_id = p_session_id
           and event_status = 0
           order by cashflow.evm_exptd_cf_date
                  )
  LOOP
     v_return := v_return || ';' || cashflow.elem;
  END LOOP;

  RETURN LTRIM(v_return, ';');
END;
/
