CREATE OR REPLACE FUNCTION DQ_USER.FN_DQG32_order_request  ( p_request_type VARCHAR2,
                                                             p_igr_calc     VARCHAR2,
                                                             p_igr_inward   VARCHAR2,
                                                             p_igr_outward  VARCHAR2)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_return_code VARCHAR2(50);
  v_sql         VARCHAR2(4000);
  v_count       NUMBER(12);
BEGIN 

  select 
     case
       when p_request_type = 'CALCULATE' and p_igr_calc = 'N' and p_igr_inward = 'N' and p_igr_outward = 'N' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'CALCULATE' and p_igr_calc = 'Y' and p_igr_inward = 'Y' and p_igr_outward = 'N' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'CALCULATE' and p_igr_calc = 'Y' and p_igr_inward = 'N' and p_igr_outward = 'N' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'CALCULATE' and p_igr_calc = 'N' and p_igr_inward = 'Y' and p_igr_outward = 'Y' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'CALCULATE' and p_igr_calc = 'N' and p_igr_inward = 'N' and p_igr_outward = 'Y' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'PROCESS'   and p_igr_calc = 'Y' and p_igr_inward = 'N' and p_igr_outward = 'N' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'PROCESS'   and p_igr_calc = 'N' and p_igr_inward = 'N' and p_igr_outward = 'N' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'PROCESS'   and p_igr_calc = 'Y' and p_igr_inward = 'Y' and p_igr_outward = 'Y' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'PROCESS'   and p_igr_calc = 'Y' and p_igr_inward = 'Y' and p_igr_outward = 'N' then 'DQERROR' -- combination invalid or not supported.
       when p_request_type = 'PROCESS'   and p_igr_calc = 'Y' and p_igr_inward = 'N' and p_igr_outward = 'Y' then 'DQERROR' -- combination invalid or not supported.
       else 'SUCCESS'
     end into v_return_code 
   from dual;
  
  RETURN v_return_code;

EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';   
END;
/