Delete from DQ_USER.T_DMP_DQ_LOG_MD;

SET DEFINE OFF;
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-HEADER','DQ Status');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-TYPE','ICON');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-TYPE-RES-MAP','{
    "PASSED": {
        "iconName": "check_circle",
        "iconColor": "green",
        "tooltipText": "Succeeded"
    },
    "FAILED": {
        "iconName": "report_problem",
        "iconColor": "red",
        "tooltipText": "Failed"
    }
}');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL10-HEADER','DQ Config ID');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL11-HEADER','DQ Purpose');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL11-WIDTH','500px');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL12-HEADER','Corrective Action');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL12-TYPE','LOB');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL13-HEADER','Contact Team');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL14-HEADER','Records Processed');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL15-HEADER','Records Failed');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL16-HEADER','SQL Query');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL16-TYPE','LOB');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL17-HEADER','Rule Type');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL2-HEADER','Rule Type');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-HEADER','UC4 Run ID');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-HEADER','Timestamp');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL5-HEADER','Use Case ID');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL6-HEADER','Session ID');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-HEADER','Aptitude Project');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL8-HEADER','Aptitude Microflow');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('COL9-HEADER','Table Name');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('HIDDEN-COLS','10,13,17');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-EXEC-DATA-1','{
    "paramCols": "3,10",
    "actionBtnText": "Deactivate Error",
    "icon": "check",
    "dbFunctionName": "FN_DMP_INACTIVATE_DQ_ERROR"
}');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-TITLE','Gateway DQ Failures');
Insert into T_DMP_DQ_LOG_MD (COL_IDENTIFIER,COL_METADATA) values ('SQL-CLAUSE','WHERE session_id = ?');

COMMIT;