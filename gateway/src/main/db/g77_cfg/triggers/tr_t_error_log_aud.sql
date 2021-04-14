CREATE OR REPLACE TRIGGER G77_CFG.TR_T_ERROR_LOG_AUD
AFTER INSERT OR UPDATE
ON G77_CFG.T_ERROR_LOG REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
	 CASE
	   WHEN INSERTING THEN
	     INSERT INTO G77_CFG.T_ERROR_LOG_AUD (
             EVENT_ID              
           , EVENT_DATETIME        
           , ERROR_STATUS          
           , ERROR_APTITUDE_PROJECT
           , ERROR_RULE_IDENT      
           , ERROR_TEXT            
           , BATCH_PROCESS_ID      
           , ROW_IN_ERROR_KEY_ID   
           , SOURCE_SYSTEM         
           , TABLE_IN_ERROR_NAME   
           , FIELD_IN_ERROR_NAME   
           , ERROR_VALUE           
           , SOURCE_SYSTEM_ID      
           , PARENT_SOURCE_ID 
           , LEGAL_ENTITY     
           , SEVERITY              
           , DQ_CONFIG_ID          
           , DQ_RULE_ID            
           , DQ_RULE_TYPE          
           , ERROR_ACTIVE_IND      
           , NO_RETRIES            
           , LAST_RETRY
           , UPDATED_BY  
           , UPDATED_TIME
           , AUTH_BY
           , ACTION
           , ACTION_TIMESTAMP
         )    
         VALUES (
             :new.EVENT_ID              
           , :new.EVENT_DATETIME        
           , :new.ERROR_STATUS          
           , :new.ERROR_APTITUDE_PROJECT
           , :new.ERROR_RULE_IDENT      
           , :new.ERROR_TEXT            
           , :new.BATCH_PROCESS_ID      
           , :new.ROW_IN_ERROR_KEY_ID   
           , :new.SOURCE_SYSTEM         
           , :new.TABLE_IN_ERROR_NAME   
           , :new.FIELD_IN_ERROR_NAME   
           , :new.ERROR_VALUE           
           , :new.SOURCE_SYSTEM_ID      
           , :new.PARENT_SOURCE_ID   
           , :new.LEGAL_ENTITY   
           , :new.SEVERITY              
           , :new.DQ_CONFIG_ID          
           , :new.DQ_RULE_ID            
           , :new.DQ_RULE_TYPE          
           , :new.ERROR_ACTIVE_IND      
           , :new.NO_RETRIES            
           , :new.LAST_RETRY 
           , :new.UPDATED_BY  
           , :new.UPDATED_TIME
           , :new.AUTH_BY     
           , 'I'
           , sysdate
         );
	   WHEN UPDATING THEN
	     -- Only log when the status changes
	     IF :old.ERROR_ACTIVE_IND <> :new.ERROR_ACTIVE_IND THEN
         INSERT INTO G77_CFG.T_ERROR_LOG_AUD (
             EVENT_ID              
           , EVENT_DATETIME        
           , ERROR_STATUS          
           , ERROR_APTITUDE_PROJECT
           , ERROR_RULE_IDENT      
           , ERROR_TEXT            
           , BATCH_PROCESS_ID      
           , ROW_IN_ERROR_KEY_ID   
           , SOURCE_SYSTEM         
           , TABLE_IN_ERROR_NAME   
           , FIELD_IN_ERROR_NAME   
           , ERROR_VALUE           
           , SOURCE_SYSTEM_ID      
           , PARENT_SOURCE_ID 
           , LEGAL_ENTITY     
           , SEVERITY              
           , DQ_CONFIG_ID          
           , DQ_RULE_ID            
           , DQ_RULE_TYPE          
           , ERROR_ACTIVE_IND      
           , NO_RETRIES            
           , LAST_RETRY
           , UPDATED_BY  
           , UPDATED_TIME
           , AUTH_BY
           , ACTION
           , ACTION_TIMESTAMP
         )    
         VALUES (
             :new.EVENT_ID              
           , :new.EVENT_DATETIME        
           , :new.ERROR_STATUS          
           , :new.ERROR_APTITUDE_PROJECT
           , :new.ERROR_RULE_IDENT      
           , :new.ERROR_TEXT            
           , :new.BATCH_PROCESS_ID      
           , :new.ROW_IN_ERROR_KEY_ID   
           , :new.SOURCE_SYSTEM         
           , :new.TABLE_IN_ERROR_NAME   
           , :new.FIELD_IN_ERROR_NAME   
           , :new.ERROR_VALUE           
           , :new.SOURCE_SYSTEM_ID      
           , :new.PARENT_SOURCE_ID   
           , :new.LEGAL_ENTITY   
           , :new.SEVERITY              
           , :new.DQ_CONFIG_ID          
           , :new.DQ_RULE_ID            
           , :new.DQ_RULE_TYPE          
           , :new.ERROR_ACTIVE_IND      
           , :new.NO_RETRIES            
           , :new.LAST_RETRY 
           , :new.UPDATED_BY  
           , :new.UPDATED_TIME
           , :new.AUTH_BY     
           , 'U'
           , sysdate
         );
       END IF;
   END CASE;
END;
/