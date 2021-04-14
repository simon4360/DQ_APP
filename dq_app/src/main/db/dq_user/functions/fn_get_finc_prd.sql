create or replace function DQ_USER.fn_get_finc_prd ( p_datestr in varchar2 )
  return varchar2 is
  v_finc_prd date;
BEGIN

  begin 
      SELECT to_date(substr ( p_datestr, 1,6), 'YYYYMM')
        INTO v_finc_prd
        FROM dual;
  exception
  when others 
  then null;
  end;
  
  begin 
      SELECT to_date(substr ( p_datestr, 1,4), 'YYYYMM')
        INTO v_finc_prd
        FROM dual;
        exception
  when others 
  then null;
  end;
  
  RETURN to_char (v_finc_prd, 'YYYY-MM');
END FN_GET_FINC_PRD;
/