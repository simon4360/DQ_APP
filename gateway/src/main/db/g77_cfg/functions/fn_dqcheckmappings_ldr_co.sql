CREATE OR REPLACE FUNCTION G77_CFG.FN_DQCHECKMAPPINGS_LDR_CO  ( p_mapping_type_id VARCHAR2,
                                                                p_match_key_3     VARCHAR2
                                                              )
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
        COUNT(*) INTO v_count
      FROM V_GENERAL_MAPPINGS_ACTIVE map WHERE
       map.MAPPING_TYPE_ID        = p_mapping_type_id AND
       map.MATCH_KEY_3           = p_match_key_3;
  
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