Delete from G77_CFG.T_DMP_ERROR_MD;

SET DEFINE OFF;
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-HEADER','Error Status');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-TYPE','ICON');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-TYPE-RES-MAP','{
    "C": {
        "iconName": "check_circle",
        "iconColor": "green",
        "tooltipText": "Succeeded"
    },
    "E": {
        "iconName": "report_problem",
        "iconColor": "red",
        "tooltipText": "Failed"
    },
    "R": {
        "iconName": "cached",
        "iconColor": "steelblue",
        "tooltipText": "Running"
    }
}');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL10-HEADER','Error Message');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL11-HEADER','Severity');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL12-HEADER','Active Indicator');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL13-HEADER','SQL Query');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL13-TYPE','LOB');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL2-HEADER','Error Count');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-HEADER','UC4 Run ID');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-HEADER','Timestamp');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL5-HEADER','Use Case ID');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL6-HEADER','Session ID');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-HEADER','Aptitude Project');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL8-HEADER','Aptitude Microflow');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('COL9-HEADER','Table Name');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('HIDDEN-COLS','12');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-EXEC-DATA-1','{
    "paramCols": "3",
    "actionBtnText": "Deactivate Error",
    "icon": "check",
    "dbFunctionName": "FN_DMP_INACTIVATE_ERROR"
}');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-TITLE','Gateway Error Log');
Insert into T_DMP_ERROR_MD (COL_IDENTIFIER,COL_METADATA) values ('SQL-CLAUSE','WHERE session_id = ?');


COMMIT;