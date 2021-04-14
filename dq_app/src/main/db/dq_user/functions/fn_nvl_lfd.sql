create or replace function DQ_USER.fn_nvl_lfd ( pTranslatedAttribute in varchar2)
  return varchar2 
  DETERMINISTIC
  is
BEGIN 
  RETURN nvl ( pTranslatedAttribute, '<NA>');
END fn_nvl_lfd;
/
