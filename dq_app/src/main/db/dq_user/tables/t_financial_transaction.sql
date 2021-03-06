CREATE TABLE DQ_USER.T_FINANCIAL_TRANSACTION
    (TRAN_ID                       NUMBER
    ,SRC_SYS_CD                    VARCHAR2 (100 BYTE)
    ,PRCDNG_SRC_SYS_TRAN_ID        NUMBER
    ,PRCDNG_SRC_SYS_CD             VARCHAR2 (100 BYTE)
    ,ROOT_SRC_SYS_TRAN_ID          VARCHAR2 (200 BYTE)
    ,ROOT_SRC_SYS_CD               VARCHAR2 (100 BYTE)
    ,REINS_AGRMNT_KEY              VARCHAR (40)
    ,POL_INSRD_DET_KEY             VARCHAR (40)
    ,BUS_EVT_TRAN_TYP_SDL          NUMBER (10)
    ,TRAN_AMT_ORIG_CRNCY           NUMBER (30, 10)
    ,ACCD_YR                       VARCHAR2 (100 BYTE)
    ,CLM_ID                        VARCHAR2 (200 BYTE)
    ,CLM_KEY                       VARCHAR (40)
    ,GLOB_LOSS_EVT_SDL             NUMBER (10)
    ,MNMD_NAT_LOSS_IND             VARCHAR2 (200 BYTE)
    ,VAL_TYP                       VARCHAR2 (200 BYTE)
    ,ORIG_ACCT_DT                  DATE
    ,ORIG_ACCT_PRD                 VARCHAR2 (100 BYTE)
    ,ORIG_ACCT_YR                  VARCHAR2 (4 BYTE)
    ,TRAN_DT                       DATE
    ,ORIG_CRNCY_ISO_CD             VARCHAR2 (50 BYTE)
    ,TECH_TRAN_DUE_DT              DATE
    ,CMN_AUDIT_TRAN_IND            VARCHAR2 (200 BYTE)
    ,TRAN_EFF_DT                   DATE
    ,ACCD_QTR                      VARCHAR2 (100 BYTE)
    ,ACCD_MNTH                     VARCHAR2 (100 BYTE)
    ,TRAN_CMT                      VARCHAR2 (1000 BYTE)
    ,US_SCHED_P_CATG_CD            VARCHAR2 (100 BYTE)
    ,ONE_OFF_EVT_IND               VARCHAR2 (3 BYTE)
    ,PLAN_PROJ_WLK_ELMNT           VARCHAR2 (200 BYTE)
    ,PROC_CLOSE_PRD                VARCHAR2 (100 BYTE)
    ,LFD_ACCT_DESC_CD              VARCHAR2 (100 BYTE)
    ,PLAN_CYC                      VARCHAR2 (200 BYTE)
    ,PROJ_VER                      VARCHAR2 (100 BYTE)
    ,ACCD_DT                       DATE
    ,BDGT_UNT_KEY                  VARCHAR2 (40)
    ,BDGT_UNT_DISTR_KEY            VARCHAR2 (40)
    ,FINC_TRAN_RSN_SDL             NUMBER(10)
    ,INCEPT_TRAN_FLAG              VARCHAR2 (3 BYTE)
    ,INIT_TRAN_FLAG                VARCHAR2 (3 BYTE)
    ,UV_SRC_TYP_CD                 NUMBER
    ,MNUL_ENT_FLAG                 VARCHAR2 (3 BYTE)
    ,ERNNG_PTRN_TRNCH_STRT_DT      DATE
    ,ERNNG_PTRN_TRNCH_END_DT       DATE
    ,WRT_PTRN_TRNCH_STRT_DT        DATE
    ,WRT_PTRN_TRNCH_END_DT         DATE
    ,LAST_UPD_USER_ID              VARCHAR2 (100)
    ,MIGRT_DATA_FLAG               VARCHAR2 (3  BYTE)
    ,RVRSNG_MNUL_ENT_ID            VARCHAR2 (200 BYTE)
    ,RVRSNG_MNUL_ENT_IND           VARCHAR2 (100 BYTE)   
    ,MNUL_ENT_RVRSL_PRD            VARCHAR2 (100 BYTE)
    ,MNUL_ENT_CMT                  VARCHAR2 (50 BYTE)
    ,MNUL_ENT_DOC_ID               VARCHAR2(200 BYTE)
    ,RSTRCTD_ASSET_SDL             NUMBER(10)
    ,MNUL_ENT_CRTE_BY              VARCHAR2(100 BYTE)
    ,MNUL_ENT_DESC                 VARCHAR2(200 BYTE)
	,ADMN_SYS_ACCT_VALN_BASIS_CD   VARCHAR2 (50 BYTE)
    ,SESSION_ID                    VARCHAR2 (200 BYTE)
    ,USE_CASE_ID                   VARCHAR2 (200 BYTE)
    ,TARGET                        VARCHAR2 (50 BYTE)
    ,SOURCE_SYSTEM                 VARCHAR2 (50 BYTE)
    ,SOURCE_DEVICE_NAME            VARCHAR2 (50 BYTE)
    ,SOURCE_SYSTEM_ID              VARCHAR2 (50 BYTE)
    ,PARENT_SOURCE_ID              VARCHAR2 (50 BYTE)
    ,ARRIVAL_TIME                  DATE                DEFAULT SYSDATE
    ,EVENT_STATUS                  NUMBER (2)          DEFAULT 0
    ,GATEWAY_ID                    NUMBER              GENERATED BY DEFAULT ON NULL AS IDENTITY (CACHE 1000 NOORDER)
    ,CONSTRAINT PK_T_FINANCIAL_TRANSACTION PRIMARY KEY (GATEWAY_ID)
)
PARTITION BY LIST (TARGET)
SUBPARTITION BY LIST (EVENT_STATUS)
(
 PARTITION P_G24 VALUES ('G24')
(SUBPARTITION P_G24_1000 VALUES ('3'), SUBPARTITION P_G24_DEFAULT VALUES (DEFAULT)),
PARTITION P_G73 VALUES ('G73')
(SUBPARTITION P_G73_1000 VALUES ('3'), SUBPARTITION P_G73_DEFAULT VALUES (DEFAULT)),
PARTITION P_G74 VALUES ('G74')
(SUBPARTITION P_G74_1000 VALUES ('3'), SUBPARTITION P_G74_DEFAULT VALUES (DEFAULT)),
PARTITION P_G76 VALUES ('G76')
(SUBPARTITION P_G76_1000 VALUES ('3'), SUBPARTITION P_G76_DEFAULT VALUES (DEFAULT)),
PARTITION OTHER VALUES (DEFAULT)
(SUBPARTITION OTHER_1000 VALUES ('3'), SUBPARTITION OTHER_DEFAULT VALUES (DEFAULT)) 
)
ENABLE ROW MOVEMENT
;
