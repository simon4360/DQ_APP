CREATE OR REPLACE FUNCTION DQ_USER.FN_DQMAPPINGINGENCODES  
                                                       ( p_mapping_type_id VARCHAR2,
                                                         p_match_key_1     VARCHAR2,
                                                         p_match_key_2     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_3     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_4     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_5     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_6     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_7     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_8     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_9     VARCHAR2 DEFAULT NULL,
                                                         p_match_key_10    VARCHAR2 DEFAULT NULL,
                                                         p_output_column   VARCHAR2,
                                                         p_master_data_ID  VARCHAR2)
RETURN VARCHAR2
   DETERMINISTIC
   PARALLEL_ENABLE
IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  v_return_code VARCHAR2(50);
  v_sql         VARCHAR2(4000);
  v_count       NUMBER(12);
  v_return_value_1  VARCHAR2(500);
  v_return_value_2  VARCHAR2(500);
  v_return_value_3  VARCHAR2(500);
  v_return_value_4  VARCHAR2(500);
  v_return_value_5  VARCHAR2(500);
  v_return_value_6  VARCHAR2(500);
  v_return_value_7  VARCHAR2(500);
  v_return_value_8  VARCHAR2(500);
  v_return_value_9  VARCHAR2(500);
  v_return_value_10 VARCHAR2(500);
BEGIN 
			--Check if the mapping lookup value even exists and store that value
     SELECT 
        COUNT(*), LOOKUP_VALUE_1  , LOOKUP_VALUE_2  , LOOKUP_VALUE_3  , LOOKUP_VALUE_4  , LOOKUP_VALUE_5  , LOOKUP_VALUE_6  , LOOKUP_VALUE_7  , LOOKUP_VALUE_8  , LOOKUP_VALUE_9  , LOOKUP_VALUE_10 
   INTO v_count , v_return_value_1, v_return_value_2, v_return_value_3, v_return_value_4, v_return_value_5, v_return_value_6, v_return_value_7, v_return_value_8, v_return_value_9, v_return_value_10
      FROM V_GENERAL_MAPPINGS_ACTIVE map  WHERE
       map.MAPPING_TYPE_ID        = p_mapping_type_id AND
       (map.MATCH_KEY_1           = p_match_key_1 OR MATCH_KEY_1 = '[ANY]') AND 
       (NVL(map.MATCH_KEY_2, 'N/A')  = CASE WHEN p_match_key_2  IS NULL THEN NVL(map.MATCH_KEY_2,'N/A')  ELSE p_match_key_2  END OR MATCH_KEY_2  = '[ANY]'  OR MATCH_KEY_2  = '[ALL]') AND 
       (NVL(map.MATCH_KEY_3, 'N/A')  = CASE WHEN p_match_key_3  IS NULL THEN NVL(map.MATCH_KEY_3,'N/A')  ELSE p_match_key_3  END OR MATCH_KEY_3  = '[ANY]'  OR MATCH_KEY_3  = '[ALL]') AND
       (NVL(map.MATCH_KEY_4, 'N/A')  = CASE WHEN p_match_key_4  IS NULL THEN NVL(map.MATCH_KEY_4,'N/A')  ELSE p_match_key_4  END OR MATCH_KEY_4  = '[ANY]'  OR MATCH_KEY_4  = '[ALL]') AND
       (NVL(map.MATCH_KEY_5, 'N/A')  = CASE WHEN p_match_key_5  IS NULL THEN NVL(map.MATCH_KEY_5,'N/A')  ELSE p_match_key_5  END OR MATCH_KEY_5  = '[ANY]'  OR MATCH_KEY_5  = '[ALL]') AND
       (NVL(map.MATCH_KEY_6, 'N/A')  = CASE WHEN p_match_key_6  IS NULL THEN NVL(map.MATCH_KEY_6,'N/A')  ELSE p_match_key_6  END OR MATCH_KEY_6  = '[ANY]'  OR MATCH_KEY_6  = '[ALL]') AND
       (NVL(map.MATCH_KEY_7, 'N/A')  = CASE WHEN p_match_key_7  IS NULL THEN NVL(map.MATCH_KEY_7,'N/A')  ELSE p_match_key_7  END OR MATCH_KEY_7  = '[ANY]'  OR MATCH_KEY_7  = '[ALL]') AND
       (NVL(map.MATCH_KEY_8, 'N/A')  = CASE WHEN p_match_key_8  IS NULL THEN NVL(map.MATCH_KEY_8,'N/A')  ELSE p_match_key_8  END OR MATCH_KEY_8  = '[ANY]'  OR MATCH_KEY_8  = '[ALL]') AND
       (NVL(map.MATCH_KEY_9, 'N/A')  = CASE WHEN p_match_key_9  IS NULL THEN NVL(map.MATCH_KEY_9,'N/A')  ELSE p_match_key_9  END OR MATCH_KEY_9  = '[ANY]'  OR MATCH_KEY_9  = '[ALL]') AND
       (NVL(map.MATCH_KEY_10,'N/A')  = CASE WHEN p_match_key_10 IS NULL THEN NVL(map.MATCH_KEY_10,'N/A') ELSE p_match_key_10 END OR MATCH_KEY_10 = '[ANY]'  OR MATCH_KEY_10 = '[ALL]') 
       	GROUP BY LOOKUP_VALUE_1  , LOOKUP_VALUE_2  , LOOKUP_VALUE_3  , LOOKUP_VALUE_4  , LOOKUP_VALUE_5  , LOOKUP_VALUE_6  , LOOKUP_VALUE_7  , LOOKUP_VALUE_8  , LOOKUP_VALUE_9  , LOOKUP_VALUE_10;     
  
  IF v_count = 1 THEN
    v_count := 0;
    --Check that the lookup value is found in the ref_combined_accordion
    SELECT COUNT(1) into v_count from ref_combined_accordion where DOMAIN_CODE = 
    CASE WHEN p_output_column = 'LOOKUP_VALUE_1' THEN v_return_value_1
         WHEN p_output_column = 'LOOKUP_VALUE_2' THEN v_return_value_2
         WHEN p_output_column = 'LOOKUP_VALUE_3' THEN v_return_value_3
         WHEN p_output_column = 'LOOKUP_VALUE_4' THEN v_return_value_4
         WHEN p_output_column = 'LOOKUP_VALUE_5' THEN v_return_value_5
         WHEN p_output_column = 'LOOKUP_VALUE_6' THEN v_return_value_6
         WHEN p_output_column = 'LOOKUP_VALUE_7' THEN v_return_value_7
         WHEN p_output_column = 'LOOKUP_VALUE_8' THEN v_return_value_8
         WHEN p_output_column = 'LOOKUP_VALUE_9' THEN v_return_value_9
         WHEN p_output_column = 'LOOKUP_VALUE_10' THEN v_return_value_10 
         ELSE NULL END
         AND MASTER_DATA_ID = p_master_data_ID
         AND ACTIVE_INDICATOR = 'Active' ;
      
    IF v_count = 1 THEN      
        v_return_code := 'SUCCESS';
    ELSE 
        v_return_code := 'DQERROR';
    END IF;
    
    
  ELSE
    v_return_code := 'DQERROR';
  END IF;
  
  RETURN v_return_code;
EXCEPTION
WHEN OTHERS THEN
   RETURN 'DQERROR';   
END;
/
