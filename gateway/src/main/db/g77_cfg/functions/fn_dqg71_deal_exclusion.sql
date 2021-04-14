create or replace function g77_cfg.fn_dqg71_deal_exclusion 
( p_deal_typ_sdl  varchar2
 ,p_deal_nm       varchar2
 ,p_src_sys_cd    varchar2
) return varchar2
   deterministic
   parallel_enable
is
  pragma autonomous_transaction;
  p_include_deals    varchar2(300);
  p_include_systems  varchar2(300);
begin
	
	p_include_deals   := '2003539, 2003542, 2003547, 2003905';
	p_include_systems := 'DAM';

  -- select regexp_substr ( 'A, B, C', 'B' ) from dual = 'B'
  
  if p_deal_typ_sdl is null then
    return 'DQERROR';
  end if;
  
  -- delegated deals
  if regexp_substr ( p_include_deals , p_deal_typ_sdl ) = p_deal_typ_sdl and regexp_substr ( p_include_systems , p_src_sys_cd ) = p_src_sys_cd then
    return 'SUCCESS';
  end if;
  
  -- Legacy Segment Deals 
  if p_deal_typ_sdl = '12116887' and upper(p_deal_nm) in ( upper ( 'Finance Legacy Segment' ) , upper ( 'Finance Legacy Policy Budget Unit' ) ) then
    return 'SUCCESS';
  end if;
  
  return 'DQERROR';
  
exception
when others then
   return 'DQERROR';
end ;
/