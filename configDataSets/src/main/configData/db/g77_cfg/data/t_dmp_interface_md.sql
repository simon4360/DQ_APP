DELETE FROM G77_CFG.T_DMP_INTERFACE_MD;

SET DEFINE OFF;
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-HEADER','Use Case Groups');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL1-WIDTH','10%');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL2-HEADER','Last Start Time');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL2-WIDTH','10%');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-HEADER','Status');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-TYPE','ICON');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-TYPE-RES-MAP','{
    "C": {
        "iconName": "check_circle",
        "iconColor": "green",
        "tooltipText": "Succeeded"
    },
    "X": {
        "iconName": "report_problem",
        "iconColor": "grey",
        "tooltipText": "Not Yet Run"
    },
    "E": {
        "iconName": "info",
        "iconColor": "red",
        "tooltipText": "Failed"
    }
}');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL3-WIDTH','10%');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-HEADER','Group');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('COL4-WIDTH','10%');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('DD-REPORT-PARAM-COLS','4');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('DD-REPORT-URL','interfaceReportDetailsGw');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('HIDDEN-COLS','4');
Insert into T_DMP_INTERFACE_MD (COL_IDENTIFIER,COL_METADATA) values ('REPORT-TITLE','Gateway Use Case Categories');

COMMIT;