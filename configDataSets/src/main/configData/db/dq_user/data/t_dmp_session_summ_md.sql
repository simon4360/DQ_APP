Delete from DQ_USER.T_DMP_SESSION_SUMM_MD;

SET DEFINE OFF;
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-HEADER','Use Case ID');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL2-HEADER','Session ID');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-HEADER','Batch Status');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-TYPE','ICON');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-TYPE-RES-MAP','{
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
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-HEADER','DQ Status');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-TYPE','ICON');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-TYPE-RES-MAP','{
    "C": {
        "iconName": "check_circle",
        "iconColor": "green",
        "tooltipText": "Succeeded"
    },
    "W": {
        "iconName": "report_problem",
        "iconColor": "yellow",
        "tooltipText": "Warning"
    },
    "E": {
        "iconName": "info",
        "iconColor": "red",
        "tooltipText": "Failed"
    },
    "R": {
        "iconName": "cached",
        "iconColor": "steelblue",
        "tooltipText": "Running"
    }
}');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL5-HEADER','Start Time');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL6-HEADER','End Time');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-HEADER','IT Errors');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-TYPE','ACTION');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-TYPE-ACT-MAP','{
    "conditionType": "NUM",
    "condition": "GT",
    "values": [
        0
    ],
    "actionLink": "errorLogGW"
}');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL8-HEADER','Technical DQ Errors');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL8-TYPE','ACTION');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL8-TYPE-ACT-MAP','{
    "conditionType": "NUM",
    "condition": "GT",
    "values": [
        0
    ],
    "actionLink": "dqLogGW"
}');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL9-HEADER','Business DQ Errors');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL9-TYPE','ACTION');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('COL9-TYPE-ACT-MAP','{
    "conditionType": "NUM",
    "condition": "GT",
    "values": [
        0
    ],
    "actionLink": "dqLogGW"
}');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('DD-REPORT-PARAM-COLS','2');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-EXEC-DATA-1','{
    "paramCols": "2",
    "actionBtnText": "Deactivate Session",
    "icon": "check",
    "dbFunctionName": "FN_DMP_INACTIVATE_ERR_SESSION"
}');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-TITLE','Interface Session Monitor Report - Gateway');
Insert into T_DMP_SESSION_SUMM_MD (COL_IDENTIFIER,COL_METADATA) values ('SQL-CLAUSE','WHERE use_case_id = ?');

COMMIT;