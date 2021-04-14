create or replace FUNCTION g77_cfg.fn_gsub_matrix_lookup ( p_status IN  VARCHAR2 )
RETURN VARCHAR2
IS
  o_new_status VARCHAR2(200);
BEGIN

SELECT DECODE(lookup_value_1,'blank',NULL,lookup_value_1) INTO o_new_status FROM g77_cfg.t_general_mappings WHERE mapping_type_id = '87' AND match_key_1 = p_status;

RETURN o_new_status;

EXCEPTION WHEN NO_DATA_FOUND THEN
 RETURN p_status;

END;
/