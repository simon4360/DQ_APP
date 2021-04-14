Delete from G77_CFG.T_DMP_DQ_RULES_MD;

SET DEFINE OFF;
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-HEADER','DQ Config ID');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL10-HEADER','Aptitude Project Description');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL11-HEADER','Table Name');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL12-HEADER','DQ Column');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL13-HEADER','Active Indicator');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL13-TYPE','ICON');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL13-TYPE-RES-MAP','{
    "Active": {
        "iconName": "check_circle",
        "iconColor": "green",
        "tooltipText": "Active"
    },
    "Inactive": {
        "iconName": "report_problem",
        "iconColor": "orange",
        "tooltipText": "Inactive"
    }
}');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL2-HEADER','Rule Type');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-HEADER','DQ Purpose');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-HEADER','DQ Rule Error Message');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL5-HEADER','DQ Severity');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL6-HEADER','DQ Severity');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-HEADER','Use Case ID');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL8-HEADER','Use Case Description');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('COL9-HEADER','Aptitude Project');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('HIDDEN-COLS','1,5,10');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-EXEC-DATA-1','{
    "paramCols": "1",
    "actionBtnText": "Activate DQ Rule",
    "icon": "check",
    "dbFunctionName": "FN_DMP_ACTIVATE_DQ_RULE"
}');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-EXEC-DATA-2','{
    "paramCols": "1",
    "actionBtnText": "Deactivate DQ Rule",
    "icon": "check",
    "dbFunctionName": "FN_DMP_INACTIVATE_DQ_RULE"
}');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-PAGE-SIZE','25');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-TITLE','Data Quality Rules - Gateway');
Insert into T_DMP_DQ_RULES_MD (COL_IDENTIFIER,COL_METADATA) values ('SQL-CLAUSE','WHERE dq_use_case_id = ?');

COMMIT;