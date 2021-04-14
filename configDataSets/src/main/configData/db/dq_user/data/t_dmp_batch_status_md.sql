Delete from DQ_USER.T_DMP_BATCH_STATUS_MD;

SET DEFINE OFF;
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-HEADER','Aptitude Project');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL2-HEADER','Aptitude Microflow');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-HEADER','Table Name');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-HEADER','Batch Process ID');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL5-HEADER','Use Case ID');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL6-HEADER','Session ID');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-HEADER','Batch Status');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-TYPE','ICON');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL7-TYPE-RES-MAP','{
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
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL8-HEADER','Start Time');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL9-HEADER','End Time');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('COL10-HEADER','Error Active Ind');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-TITLE','Gateway Failed Jobs');
Insert into T_DMP_BATCH_STATUS_MD (COL_IDENTIFIER,COL_METADATA) values ('HIDDEN-COLS','4, 10');

COMMIT;