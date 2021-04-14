create or replace function g77_cfg.fn_nvl_lfd ( pTranslatedAttribute in varchar2)
  return varchar2 
  DETERMINISTIC
  is
BEGIN 
  RETURN nvl ( pTranslatedAttribute, '<NA>');
END fn_nvl_lfd;
/
