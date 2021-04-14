CREATE OR REPLACE FUNCTION DQ_USER.FN_CONCATENATE_COLUMNS (
                    p_delta_view   IN VARCHAR2
                  , p_middle_table IN VARCHAR2)
  RETURN VARCHAR2 IS
  v_concat_str VARCHAR2(4000);
BEGIN
SELECT SUBSTR (SYS_CONNECT_BY_PATH (COLUMN_NAME , ','), 2) csv
  INTO v_concat_str
      FROM (
            select COLUMN_NAME
                 , ROW_NUMBER () OVER (ORDER BY COLUMN_NAME ) rn
                 , COUNT (*) OVER () cnt
              from all_tab_cols
            where owner='DQ_USER'
              and table_name = p_delta_view
              and column_name in (select column_name
                                    from all_tab_cols
                                   where table_name = p_middle_table
                                 )
              and column_name not in ('SESSION_ID','USE_CASE_ID','ARRIVAL_TIME')
           )
     WHERE rn = cnt
START WITH rn = 1
CONNECT BY rn = PRIOR rn + 1;

  RETURN v_concat_str;
END FN_CONCATENATE_COLUMNS;
/
