DELETE FROM G77_CFG.T_DMP_INTERFACE_DETAILS;

SET DEFINE OFF;
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL1-HEADER','Use Case ID');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL1-WIDTH','10%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL10-HEADER','Number of DQ Rules');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL10-TYPE','ACTION');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL10-TYPE-ACT-MAP','{
     "conditionType": "NUM",
     "condition": "GT",
     "values": [
         0
     ],
     "actionLink": "dqRulesGw"
}');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL10-WIDTH','10%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL2-HEADER','Description');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL2-WIDTH','5%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL3-HEADER','Frequency');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL3-WIDTH','5%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL4-HEADER','Last start time (CET)');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL4-WIDTH','5%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL5-HEADER','UC4 Gateway Batch Status');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL5-TYPE','ICON');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL5-TYPE-RES-MAP','{
    "3": {
        "iconName": "check_circle",
        "iconColor": "green",
        "tooltipText": "Succeeded"
    },
    "2": {
        "iconName": "report_problem",
        "iconColor": "grey",
        "tooltipText": "Not Yet Run"
    },
    "1": {
        "iconName": "info",
        "iconColor": "red",
        "tooltipText": "Failed"
    }
}');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL5-WIDTH','5%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL6-HEADER','DQ Status');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL6-TYPE','ICON');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL6-TYPE-RES-MAP','{
    "3": {
        "iconName": "check_circle",
        "iconColor": "green",
        "tooltipText": "Succeeded"
    },
    "2": {
        "iconName": "report_problem",
        "iconColor": "grey",
        "tooltipText": "Not Yet Run"
    },
    "1": {
        "iconName": "info",
        "iconColor": "red",
        "tooltipText": "Failed"
    }
}');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL6-WIDTH','5%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL7-HEADER','IT Errors');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL7-WIDTH','10%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL8-HEADER','Technical DQ Errors');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL8-WIDTH','10%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL9-HEADER','Business DQ Errors');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('COL9-WIDTH','10%');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('DD-REPORT-PARAM-COLS','1');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('DD-REPORT-URL','sessionSummGW');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('HIDDEN-COLS','3, 11');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('REPORT-TITLE','Interface Monitor Report - Gateway');
Insert into T_DMP_INTERFACE_DETAILS (COL_IDENTIFIER,COL_METADATA) values ('SQL-CLAUSE','WHERE use_case_category = ?');

COMMIT;