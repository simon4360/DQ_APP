CREATE OR REPLACE TRIGGER DQ_USER.TR_T_META_TABLE_DQ_AUD
AFTER INSERT OR UPDATE
ON DQ_USER.T_META_TABLE_DQ REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
	 CASE
	   WHEN INSERTING THEN
	     INSERT INTO DQ_USER.T_META_TABLE_DQ_AUD (
 
             DQ_CONFIG_ID          
            ,TABLE_ID
            ,DQ_PURPOSE
            ,DQ_CORRECTIVE_ACTION
            ,DQ_CONTACT_TEAM
            ,DQ_SEVERITY_ID        
            ,DQ_RULE_TYPE          
            ,DQ_RULE_CATEGORY      
            ,DQ_FUNCTION_ID        
            ,DQ_MESSAGE_ID
            ,DQ_METHOD
            ,DQ_WHERE_CLAUSE
            ,DQ_JOIN
            ,DQ_CONDITION_ID       
            ,DQ_COLUMN_NAME        
            ,DQ_ACTIVE_INDICATOR   
            ,DQ_USER_ROLE          
            ,CREATE_DATE           
            ,LAST_UPDATED          
            ,USER_ID               
            ,ACTION                
            ,ACTION_TIMESTAMP)    
         VALUES (
           :new.DQ_CONFIG_ID             
          ,:new.TABLE_ID          
          ,:new.DQ_PURPOSE
          ,:new.DQ_CORRECTIVE_ACTION
          ,:new.DQ_CONTACT_TEAM
          ,:new.DQ_SEVERITY_ID           
          ,:new.DQ_RULE_TYPE             
          ,:new.DQ_RULE_CATEGORY         
          ,:new.DQ_FUNCTION_ID
          ,:new.DQ_MESSAGE_ID
          ,:new.DQ_METHOD
          ,:new.DQ_WHERE_CLAUSE  
          ,:new.DQ_JOIN 
          ,:new.DQ_CONDITION_ID          
          ,:new.DQ_COLUMN_NAME           
          ,:new.DQ_ACTIVE_INDICATOR      
          ,:new.DQ_USER_ROLE             
          ,:new.CREATE_DATE              
          ,:new.LAST_UPDATED             
          ,:new.USER_ID                 
          , 'I'
          , sysdate
         );
	   WHEN UPDATING THEN
	     -- Only log when the status changes
          INSERT INTO DQ_USER.T_META_TABLE_DQ_AUD (
             DQ_CONFIG_ID          
            ,TABLE_ID          
            ,DQ_PURPOSE
            ,DQ_CORRECTIVE_ACTION
            ,DQ_CONTACT_TEAM                           
            ,DQ_SEVERITY_ID        
            ,DQ_RULE_TYPE          
            ,DQ_RULE_CATEGORY      
            ,DQ_FUNCTION_ID 
            ,DQ_MESSAGE_ID
            ,DQ_METHOD
            ,DQ_WHERE_CLAUSE
            ,DQ_JOIN 
            ,DQ_CONDITION_ID       
            ,DQ_COLUMN_NAME        
            ,DQ_ACTIVE_INDICATOR   
            ,DQ_USER_ROLE          
            ,CREATE_DATE           
            ,LAST_UPDATED          
            ,USER_ID               
            ,ACTION                
            ,ACTION_TIMESTAMP)    
         VALUES (
           :new.DQ_CONFIG_ID             
          ,:new.TABLE_ID
          ,:new.DQ_PURPOSE
          ,:new.DQ_CORRECTIVE_ACTION                  
          ,:new.DQ_CONTACT_TEAM
          ,:new.DQ_SEVERITY_ID           
          ,:new.DQ_RULE_TYPE             
          ,:new.DQ_RULE_CATEGORY         
          ,:new.DQ_FUNCTION_ID
          ,:new.DQ_MESSAGE_ID
          ,:new.DQ_METHOD
          ,:new.DQ_WHERE_CLAUSE 
          ,:new.DQ_JOIN   
          ,:new.DQ_CONDITION_ID          
          ,:new.DQ_COLUMN_NAME           
          ,:new.DQ_ACTIVE_INDICATOR      
          ,:new.DQ_USER_ROLE             
          ,:new.CREATE_DATE              
          ,:new.LAST_UPDATED             
          ,:new.USER_ID       
          , 'U'
          , sysdate
         );
   END CASE;
END;
/