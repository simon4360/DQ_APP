create or replace function DQ_USER.fn_nvl_cordl ( pTranslatedAttribute in varchar2)
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
