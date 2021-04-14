CREATE OR REPLACE FUNCTION G77_CFG.FN_GET_HASH(p_column_list IN sys.odcivarchar2list)
  RETURN VARCHAR2 IS
  v_hask_key VARCHAR2(1024);
BEGIN

  SELECT STANDARD_HASH(replace(listagg(nvl(column_value, '$'), '-') within
                               group(order by rownum),
                               '$',
                               ''),
                       'SHA1') as hash_key
    INTO v_hask_key
    FROM table(p_column_list);

  RETURN v_hask_key;
END FN_GET_HASH;
/