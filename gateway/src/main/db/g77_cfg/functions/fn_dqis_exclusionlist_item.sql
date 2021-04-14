create or replace function g77_cfg.fn_dqis_exclusionlist_item 
( p_item          varchar2
 ,p_exclusionlist varchar2
) return varchar2
   deterministic
   parallel_enable
is
  pragma autonomous_transaction;
begin

  -- select regexp_substr ( 'A, B, C', 'B' ) from dual = 'B'
  
  if regexp_substr ( p_exclusionlist, p_item ) = p_item then
    return 'DQERROR';
  else
    return 'SUCCESS';
  end if;
  
exception
when others then
   return 'DQERROR';
end ;
/