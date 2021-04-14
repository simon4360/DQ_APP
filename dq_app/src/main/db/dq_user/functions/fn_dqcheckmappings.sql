CREATE OR REPLACE FUNCTION DQ_USER.FN_DQCHECKMAPPINGS  ( p_mapping_type_id VARCHAR2,
                                                         p_match_key_1     VARCHAR2,
                                                         p_match_key_2     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_3     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_4     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_5     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_6     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_7     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_8     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_9     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_10    VARCHAR2 DEFAULT NULL)
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
       (map.MATCH_KEY_1           = p_match_key_1 OR MATCH_KEY_1 = '[ANY]') AND 
       (NVL(map.MATCH_KEY_2, 'N/A')  = CASE WHEN p_match_key_2  IS NULL THEN NVL(map.MATCH_KEY_2,'N/A') ELSE p_match_key_2 END OR MATCH_KEY_2 = '[ANY]') AND 
       (NVL(map.MATCH_KEY_3, 'N/A')  = CASE WHEN p_match_key_3  IS NULL THEN NVL(map.MATCH_KEY_3,'N/A') ELSE p_match_key_3 END OR MATCH_KEY_3 = '[ANY]') AND
       (NVL(map.MATCH_KEY_4, 'N/A')  = CASE WHEN p_match_key_4  IS NULL THEN NVL(map.MATCH_KEY_4,'N/A') ELSE p_match_key_4 END OR MATCH_KEY_4 = '[ANY]') AND
       (NVL(map.MATCH_KEY_5, 'N/A')  = CASE WHEN p_match_key_5  IS NULL THEN NVL(map.MATCH_KEY_5,'N/A') ELSE p_match_key_5 END OR MATCH_KEY_5 = '[ANY]') AND
       (NVL(map.MATCH_KEY_6, 'N/A')  = CASE WHEN p_match_key_6  IS NULL THEN NVL(map.MATCH_KEY_6,'N/A') ELSE p_match_key_6 END OR MATCH_KEY_6 = '[ANY]') AND
       (NVL(map.MATCH_KEY_7, 'N/A')  = CASE WHEN p_match_key_7  IS NULL THEN NVL(map.MATCH_KEY_7,'N/A') ELSE p_match_key_7 END OR MATCH_KEY_7 = '[ANY]') AND
       (NVL(map.MATCH_KEY_8, 'N/A')  = CASE WHEN p_match_key_8  IS NULL THEN NVL(map.MATCH_KEY_8,'N/A') ELSE p_match_key_8 END OR MATCH_KEY_8 = '[ANY]') AND
       (NVL(map.MATCH_KEY_9, 'N/A')  = CASE WHEN p_match_key_9  IS NULL THEN NVL(map.MATCH_KEY_9,'N/A') ELSE p_match_key_9 END OR MATCH_KEY_9 = '[ANY]') AND
       (NVL(map.MATCH_KEY_10, 'N/A') = CASE WHEN p_match_key_10 IS NULL THEN NVL(map.MATCH_KEY_10,'N/A') ELSE p_match_key_10 END OR MATCH_KEY_10 = '[ANY]') ;     
  
  IF v_count = 1 THEN
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