CREATE TABLE DQ_USER.T_META_TABLE_DQ_AUD
(
  DQ_CONFIG_IDA          NUMBER              GENERATED BY DEFAULT ON NULL AS IDENTITY (START WITH 1 CACHE 1000 NOORDER)  
 ,DQ_CONFIG_ID           NUMBER(12)  
 ,TABLE_ID               NUMBER 
 ,DQ_PURPOSE             VARCHAR2(1000 BYTE)
 ,DQ_CORRECTIVE_ACTION   VARCHAR2(1000 BYTE)
 ,DQ_CONTACT_TEAM        VARCHAR2(1000 BYTE)
 ,DQ_USE_CASE_ID         VARCHAR2(200 BYTE)
 ,DQ_SEVERITY_ID         NUMBER(12)       
 ,DQ_RULE_TYPE           VARCHAR2(1 BYTE)  
 ,DQ_RULE_CATEGORY       VARCHAR2(50 BYTE) 
 ,DQ_METHOD              VARCHAR2(50 BYTE)
 ,DQ_MESSAGE_ID          NUMBER(12)  
 ,DQ_FUNCTION_ID         NUMBER(12)
 ,DQ_FUNCTION_PARAMETERS VARCHAR2(4000 BYTE)
 ,DQ_WHERE_CLAUSE        VARCHAR2(4000 BYTE)
 ,DQ_JOIN                VARCHAR2(4000 BYTE)
 ,DQ_CONDITION_ID        NUMBER(12)         
 ,DQ_COLUMN_NAME         VARCHAR2(500 BYTE)  
 ,DQ_ACTIVE_INDICATOR    VARCHAR2(1 BYTE)    
 ,DQ_USER_ROLE           VARCHAR2(50 BYTE)
 ,CREATE_DATE            DATE                
 ,LAST_UPDATED           DATE              
 ,USER_ID                VARCHAR2(50 BYTE) 
 ,ACTION                 VARCHAR2(1 BYTE)
 ,ACTION_TIMESTAMP       TIMESTAMP 
 ,CONSTRAINT PK_META_TABLE_DQ_AUD PRIMARY KEY (DQ_CONFIG_IDA)               
);  