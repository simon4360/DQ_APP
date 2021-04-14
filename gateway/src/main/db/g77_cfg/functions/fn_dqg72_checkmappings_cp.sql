CREATE OR REPLACE FUNCTION G77_CFG.FN_DQG72_CHECKMAPPINGS_CP  ( p_mapping_type_id_a VARCHAR2,
                                                                p_match_key_a       VARCHAR2,
                                                                p_mapping_type_id_b VARCHAR2,
                                                                p_mapping_type_id_c VARCHAR2,
                                                                p_match_key_c       VARCHAR2)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_return_code VARCHAR2(50);
  v_sql         VARCHAR2(4000);
  v_count       NUMBER(12);
BEGIN 
      SELECT 
        COUNT(*) INTO v_count FROM (
      SELECT 1
      FROM V_GENERAL_MAPPINGS_ACTIVE map_a
      WHERE map_a.MATCH_KEY_1     = p_match_key_a       AND 
            map_a.MAPPING_TYPE_ID = p_mapping_type_id_a
      UNION ALL
      SELECT 1
      FROM V_GENERAL_MAPPINGS_ACTIVE map_b,
           V_GENERAL_MAPPINGS_ACTIVE map_c
      WHERE map_b.MATCH_KEY_1 = map_c.LOOKUP_VALUE_1 AND 
      map_b.MAPPING_TYPE_ID = p_mapping_type_id_b AND 
      map_c.MAPPING_TYPE_ID = p_mapping_type_id_c AND 
      map_c.MATCH_KEY_1 = p_match_key_c);
  
  IF v_count > 0 THEN
    v_return_code := 'SUCCESS';
  ELSE
    v_return_code := 'DQERROR';
  END IF;
  
  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';   
END;
/