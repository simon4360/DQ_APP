CREATE OR REPLACE PACKAGE G77_CFG.pkg_pipeline_fn AS
  TYPE ty_pf_usecase_row IS RECORD (
    uc_staging_table VARCHAR2(30),
    use_case         VARCHAR2(10),
    use_case_order   NUMBER,
    use_case_count   NUMBER,
    use_case_sql     CLOB,
    src_table_count  NUMBER,
    use_case_sql_err VARCHAR2(200)
    
  );

  TYPE ty_pf_usecase_tab IS TABLE OF ty_pf_usecase_row;

  FUNCTION get_use_case 
  RETURN ty_pf_usecase_tab PIPELINED;
END pkg_pipeline_fn;
/
