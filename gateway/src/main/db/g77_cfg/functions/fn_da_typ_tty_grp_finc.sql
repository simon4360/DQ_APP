create or replace FUNCTION G77_CFG.FN_DA_TYP_TTY_GRP_FINC(p_table_name IN VARCHAR2
                                                         ,p_key_column IN VARCHAR2
                                                         )
RETURN T_TYP_TTY_GRP_FINC
IS
v_typ_tty_grp_finc T_TYP_TTY_GRP_FINC := T_TYP_TTY_GRP_FINC();
v_sql VARCHAR2(4000);

BEGIN
--p_table_name needs to be a table which contains typ_tran_sdl
--p_key_column is the column you intend to join to the result of this function by

           v_sql := 'with t as (SELECT DISTINCT
                                       '||p_key_column||'
                                     , typ_tran_sdl
                                  FROM '||p_table_name||'
                               )
                      SELECT O_TYP_TTY_GRP_FINC(t.'||p_key_column||', gm98.TYP_TTY_GRP_FINC) 
                        FROM t  
                        JOIN V_GM098_TYP_TTY_GRP_FINC           gm98
                          ON t.typ_tran_sdl = gm98.typ_tran_sdl
                    ';
                                
EXECUTE IMMEDIATE v_sql BULK COLLECT into v_typ_tty_grp_finc;

RETURN v_typ_tty_grp_finc;
END;
/