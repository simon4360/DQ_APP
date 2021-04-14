create or replace function g77_cfg.fn_nvl_cordl ( pTranslatedAttribute in varchar2)
  return varchar2 
  DETERMINISTIC
  is
BEGIN 
  RETURN case  pTranslatedAttribute 
           when '<NA>' then '' 
           else  pTranslatedAttribute 
         end;
END fn_nvl_cordl;
/
