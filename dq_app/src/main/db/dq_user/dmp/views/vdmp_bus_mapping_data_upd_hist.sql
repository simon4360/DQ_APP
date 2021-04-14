CREATE OR REPLACE FORCE VIEW DQ_USER.VDMP_BUS_MAPPING_DATA_UPD_HIST
(REC_ID, METADATA_ID, UPDATE_COUNT, MODIFIED_BY, MODIFIED_ON, APPROVED_BY, SOURCE_DATA_1, SOURCE_DATA_1_DESC, SOURCE_DATA_2, SOURCE_DATA_2_DESC, SOURCE_DATA_3, SOURCE_DATA_3_DESC, SOURCE_DATA_4, 
 SOURCE_DATA_4_DESC, SOURCE_DATA_5, SOURCE_DATA_5_DESC, SOURCE_DATA_6, SOURCE_DATA_6_DESC, SOURCE_DATA_7, SOURCE_DATA_7_DESC, SOURCE_DATA_8, SOURCE_DATA_8_DESC, SOURCE_DATA_9, SOURCE_DATA_9_DESC, 
 SOURCE_DATA_10, SOURCE_DATA_10_DESC, SOURCE_DATA_11, SOURCE_DATA_11_DESC, SOURCE_DATA_12, SOURCE_DATA_12_DESC, SOURCE_DATA_13, SOURCE_DATA_13_DESC, SOURCE_DATA_14, SOURCE_DATA_14_DESC, 
 SOURCE_DATA_15, SOURCE_DATA_15_DESC, SOURCE_DATA_16, SOURCE_DATA_16_DESC, SOURCE_DATA_17, SOURCE_DATA_17_DESC, SOURCE_DATA_18, SOURCE_DATA_18_DESC, SOURCE_DATA_19, SOURCE_DATA_19_DESC, 
 SOURCE_DATA_20, SOURCE_DATA_20_DESC, SOURCE_DATA_21, SOURCE_DATA_21_DESC, SOURCE_DATA_22, SOURCE_DATA_22_DESC, SOURCE_DATA_23, SOURCE_DATA_23_DESC, SOURCE_DATA_24, SOURCE_DATA_24_DESC, 
 SOURCE_DATA_25, SOURCE_DATA_25_DESC, SOURCE_DATA_26, SOURCE_DATA_26_DESC, SOURCE_DATA_27, SOURCE_DATA_27_DESC, SOURCE_DATA_28, SOURCE_DATA_28_DESC, SOURCE_DATA_29, SOURCE_DATA_29_DESC, 
 SOURCE_DATA_30, SOURCE_DATA_30_DESC, TARGET_DATA_1, TARGET_DATA_1_DESC, TARGET_DATA_2, TARGET_DATA_2_DESC, TARGET_DATA_3, TARGET_DATA_3_DESC, TARGET_DATA_4, TARGET_DATA_4_DESC, TARGET_DATA_5, 
 TARGET_DATA_5_DESC, TARGET_DATA_6, TARGET_DATA_6_DESC, TARGET_DATA_7, TARGET_DATA_7_DESC, TARGET_DATA_8, TARGET_DATA_8_DESC, TARGET_DATA_9, TARGET_DATA_9_DESC, TARGET_DATA_10, TARGET_DATA_10_DESC, 
 TARGET_DATA_11, TARGET_DATA_11_DESC, TARGET_DATA_12, TARGET_DATA_12_DESC, TARGET_DATA_13, TARGET_DATA_13_DESC, TARGET_DATA_14, TARGET_DATA_14_DESC, TARGET_DATA_15, TARGET_DATA_15_DESC, 
 TARGET_DATA_16, TARGET_DATA_16_DESC, TARGET_DATA_17, TARGET_DATA_17_DESC, TARGET_DATA_18, TARGET_DATA_18_DESC, TARGET_DATA_19, TARGET_DATA_19_DESC, TARGET_DATA_20, TARGET_DATA_20_DESC, 
 TARGET_DATA_21, TARGET_DATA_21_DESC, TARGET_DATA_22, TARGET_DATA_22_DESC, TARGET_DATA_23, TARGET_DATA_23_DESC, TARGET_DATA_24, TARGET_DATA_24_DESC, TARGET_DATA_25, TARGET_DATA_25_DESC, 
 TARGET_DATA_26, TARGET_DATA_26_DESC, TARGET_DATA_27, TARGET_DATA_27_DESC, TARGET_DATA_28, TARGET_DATA_28_DESC, TARGET_DATA_29, TARGET_DATA_29_DESC, TARGET_DATA_30, TARGET_DATA_30_DESC,
 REQUEST_TYPE, REQUEST_COUNT)
BEQUEATH DEFINER
AS
SELECT dmp_row_id rec_id,
       metadata_id,
       update_count,
       modified_by,
       modified_time MODIFIED_ON,
       approved_by,
       source_system_value1 SOURCE_DATA_1,
       source_system_value1_desc SOURCE_DATA_1_DESC,
       source_system_value2 SOURCE_DATA_2,
       source_system_value2_desc SOURCE_DATA_2_DESC,
       source_system_value3 SOURCE_DATA_3,
       source_system_value3_desc SOURCE_DATA_3_DESC,
       source_system_value4 SOURCE_DATA_4,
       source_system_value4_desc SOURCE_DATA_4_DESC,
       source_system_value5 SOURCE_DATA_5,
       source_system_value5_desc SOURCE_DATA_5_DESC,
       source_system_value6 SOURCE_DATA_6,
       source_system_value6_desc SOURCE_DATA_6_DESC,
       source_system_value7 SOURCE_DATA_7,
       source_system_value7_desc SOURCE_DATA_7_DESC,
       source_system_value8 SOURCE_DATA_8,
       source_system_value8_desc SOURCE_DATA_8_DESC,
       source_system_value9 SOURCE_DATA_9,
       source_system_value9_desc SOURCE_DATA_9_DESC,
       source_system_value10 SOURCE_DATA_10,
       source_system_value10_desc SOURCE_DATA_10_DESC,
       source_system_value11 SOURCE_DATA_11,
       source_system_value11_desc SOURCE_DATA_11_DESC,
       source_system_value12 SOURCE_DATA_12,
       source_system_value12_desc SOURCE_DATA_12_DESC,
       source_system_value13 SOURCE_DATA_13,
       source_system_value13_desc SOURCE_DATA_13_DESC,
       source_system_value14 SOURCE_DATA_14,
       source_system_value14_desc SOURCE_DATA_14_DESC,
       source_system_value15 SOURCE_DATA_15,
       source_system_value15_desc SOURCE_DATA_15_DESC,
       source_system_value16 SOURCE_DATA_16,
       source_system_value16_desc SOURCE_DATA_16_DESC,
       source_system_value17 SOURCE_DATA_17,
       source_system_value17_desc SOURCE_DATA_17_DESC,
       source_system_value18 SOURCE_DATA_18,
       source_system_value18_desc SOURCE_DATA_18_DESC,
       source_system_value19 SOURCE_DATA_19,
       source_system_value19_desc SOURCE_DATA_19_DESC,
       source_system_value20 SOURCE_DATA_20,
       source_system_value20_desc SOURCE_DATA_20_DESC,
       source_system_value21 SOURCE_DATA_21,
       source_system_value21_desc SOURCE_DATA_21_DESC,
       source_system_value22 SOURCE_DATA_22,
       source_system_value22_desc SOURCE_DATA_22_DESC,
       source_system_value23 SOURCE_DATA_23,
       source_system_value23_desc SOURCE_DATA_23_DESC,
       source_system_value24 SOURCE_DATA_24,
       source_system_value24_desc SOURCE_DATA_24_DESC,
       source_system_value25 SOURCE_DATA_25,
       source_system_value25_desc SOURCE_DATA_25_DESC,
       source_system_value26 SOURCE_DATA_26,
       source_system_value26_desc SOURCE_DATA_26_DESC,
       source_system_value27 SOURCE_DATA_27,
       source_system_value27_desc SOURCE_DATA_27_DESC,
       source_system_value28 SOURCE_DATA_28,
       source_system_value28_desc SOURCE_DATA_28_DESC,
       source_system_value29 SOURCE_DATA_29,
       source_system_value29_desc SOURCE_DATA_29_DESC,
       source_system_value30 SOURCE_DATA_30,
       source_system_value30_desc SOURCE_DATA_30_DESC,
       target_system_value1 TARGET_DATA_1,
       target_system_value1_desc TARGET_DATA_1_DESC,
       target_system_value2 TARGET_DATA_2,
       target_system_value2_desc TARGET_DATA_2_DESC,
       target_system_value3 TARGET_DATA_3,
       target_system_value3_desc TARGET_DATA_3_DESC,
       target_system_value4 TARGET_DATA_4,
       target_system_value4_desc TARGET_DATA_4_DESC,
       target_system_value5 TARGET_DATA_5,
       target_system_value5_desc TARGET_DATA_5_DESC,
       target_system_value6 TARGET_DATA_6,
       target_system_value6_desc TARGET_DATA_6_DESC,
       target_system_value7 TARGET_DATA_7,
       target_system_value7_desc TARGET_DATA_7_DESC,
       target_system_value8 TARGET_DATA_8,
       target_system_value8_desc TARGET_DATA_8_DESC,
       target_system_value9 TARGET_DATA_9,
       target_system_value9_desc TARGET_DATA_9_DESC,
       target_system_value10 TARGET_DATA_10,
       target_system_value10_desc TARGET_DATA_10_DESC,
       target_system_value11 TARGET_DATA_11,
       target_system_value11_desc TARGET_DATA_11_DESC,
       target_system_value12 TARGET_DATA_12,
       target_system_value12_desc TARGET_DATA_12_DESC,
       target_system_value13 TARGET_DATA_13,
       target_system_value13_desc TARGET_DATA_13_DESC,
       target_system_value14 TARGET_DATA_14,
       target_system_value14_desc TARGET_DATA_14_DESC,
       target_system_value15 TARGET_DATA_15,
       target_system_value15_desc TARGET_DATA_15_DESC,
       target_system_value16 TARGET_DATA_16,
       target_system_value16_desc TARGET_DATA_16_DESC,
       target_system_value17 TARGET_DATA_17,
       target_system_value17_desc TARGET_DATA_17_DESC,
       target_system_value18 TARGET_DATA_18,
       target_system_value18_desc TARGET_DATA_18_DESC,
       target_system_value19 TARGET_DATA_19,
       target_system_value19_desc TARGET_DATA_19_DESC,
       target_system_value20 TARGET_DATA_20,
       target_system_value20_desc TARGET_DATA_20_DESC,
       target_system_value21 TARGET_DATA_21,
       target_system_value21_desc TARGET_DATA_21_DESC,
       target_system_value22 TARGET_DATA_22,
       target_system_value22_desc TARGET_DATA_22_DESC,
       target_system_value23 TARGET_DATA_23,
       target_system_value23_desc TARGET_DATA_23_DESC,
       target_system_value24 TARGET_DATA_24,
       target_system_value24_desc TARGET_DATA_24_DESC,
       target_system_value25 TARGET_DATA_25,
       target_system_value25_desc TARGET_DATA_25_DESC,
       target_system_value26 TARGET_DATA_26,
       target_system_value26_desc TARGET_DATA_26_DESC,
       target_system_value27 TARGET_DATA_27,
       target_system_value27_desc TARGET_DATA_27_DESC,
       target_system_value28 TARGET_DATA_28,
       target_system_value28_desc TARGET_DATA_28_DESC,
       target_system_value29 TARGET_DATA_29,
       target_system_value29_desc TARGET_DATA_29_DESC,
       target_system_value30 TARGET_DATA_30,
       target_system_value30_desc TARGET_DATA_30_DESC,
       REQUEST_TYPE,
       REQUEST_COUNT
FROM T_MAP_SRC_TRG_UPD_HIST;