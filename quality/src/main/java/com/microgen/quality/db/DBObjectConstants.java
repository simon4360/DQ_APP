package com.microgen.quality.db;

import java.io.File;
import java.util.regex.Pattern;

public final class DBObjectConstants
{
    public static final File    DB_CODE_ROOT                            = new File ( System.getProperty ( "test.codeRoot" ) );

    public static final Pattern CONSTRAINT_NAME_REGEX                   = Pattern.compile ( "(?<=alter table [a-z0-9_]{1,30}\\.[a-z0-9_]{1,30} add constraint )[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );
    public static final Pattern CONSTRAINED_TABLE_DB_NAME_REGEX         = Pattern.compile ( "(?<=alter table )[a-z0-9_]*(?=\\.[a-z0-9_]* add constraint)"                  , Pattern.CASE_INSENSITIVE );
    public static final Pattern CONSTRAINED_TABLE_NAME_REGEX            = Pattern.compile ( "(?<=alter table [a-z0-9_]{1,30}\\.)[a-z0-9_]*(?= add constraint)"             , Pattern.CASE_INSENSITIVE );

    public static final Pattern DATA_DB_NAME_REGEX                      = Pattern.compile ( "(?<=(insert into|merge into|update|delete from) )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern DATA_TABLE_REGEX                        = Pattern.compile ( "(?<=(insert into|merge into|update|delete from) [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final Pattern INDEXED_TABLE_DB_NAME_REGEX             = Pattern.compile ( "(?<=create index [a-z0-9_]{1,30} on )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern INDEXED_TABLE_NAME_REGEX                = Pattern.compile ( "(?<=create index [a-z0-9_]{1,30} on [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final Pattern MACRO_DB_NAME_REGEX                     = Pattern.compile ( "(?<=replace macro )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern MACRO_NAME_REGEX                        = Pattern.compile ( "(?<=replace macro [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );
    public static final String  MACRO_FOLDER_NAME                       = "macros";
    public static final String  MACRO_FLAG                              = "M";

    public static final Pattern PROCEDURE_DB_NAME_REGEX                 = Pattern.compile ( "(?<=replace procedure )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern PROCEDURE_NAME_REGEX                    = Pattern.compile ( "(?<=replace procedure [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );
    public static final Pattern PROCEDURE_DB_NAME_REGEX_ORA             = Pattern.compile ( "(?<=create or replace procedure )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern PROCEDURE_NAME_REGEX_ORA                = Pattern.compile ( "(?<=create or replace procedure [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final String  PROCEDURE_FOLDER_NAME                   = "procedures";
    public static final String  PROCEDURE_FLAG                          = "PROCEDURE";

    public static final Pattern FUNCTION_DB_NAME_REGEX                  = Pattern.compile ( "(?<=create or replace function )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern FUNCTION_NAME_REGEX                     = Pattern.compile ( "(?<=create or replace function [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final String  FUNCTION_FOLDER_NAME                    = "functions";
    public static final String  FUNCTION_FLAG                           = "FUNCTION";

    public static final Pattern PACKAGE_DB_NAME_REGEX                   = Pattern.compile ( "(?<=create or replace package )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern PACKAGE_NAME_REGEX                      = Pattern.compile ( "(?<=create or replace package [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final String  PACKAGE_FOLDER_NAME                     = "packages_spec";
    public static final String  PACKAGE_FLAG                            = "PACKAGE";

    public static final Pattern PACKAGE_BODY_DB_NAME_REGEX              = Pattern.compile ( "(?<=create or replace package body )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern PACKAGE_BODY_NAME_REGEX                 = Pattern.compile ( "(?<=create or replace package body [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final String  PACKAGE_BODY_FOLDER_NAME                = "packages_body";
    public static final String  PACKAGE_BODY_FLAG                       = "PACKAGE BODY";

    
    public static final Pattern SEQUENCE_DB_NAME_REGEX                  = Pattern.compile ( "(?<=(create sequence )|(alter sequence ))[a-z0-9_]*(?=\\.)"                              , Pattern.CASE_INSENSITIVE );
    public static final Pattern SEQUENCE_NAME_REGEX                     = Pattern.compile ( "(?<=(create sequence [a-z0-9_]{1,30}\\.)|(alter sequence [a-z0-9_]{1,30}\\.))[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final String  SEQUENCE_FOLDER_NAME                    = "sequences";
    public static final String  SEQUENCE_FLAG                           = "SEQUENCE";

    public static final Pattern SQLUDF_DB_NAME_REGEX                    = Pattern.compile ( "(?<=replace function )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern SQLUDF_NAME_REGEX                       = Pattern.compile ( "(?<=replace function [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );
    public static final String  SQLUDF_FOLDER_NAME                      = "sql_udf";
    public static final String  SQLUDF_FLAG                             = "F";

    public static final Pattern STATISTICS_DB_NAME_REGEX                = Pattern.compile ( "(?<=collect statistics (on)?(\\s)?(using sample)?(\\s)?(on)?(\\s)?(temporary)?(\\s)?)[a-z0-9_]*(?=\\.[a-z0-9_]{1,30})" , Pattern.CASE_INSENSITIVE );
    public static final Pattern STATISTICS_TABLE_NAME_REGEX             = Pattern.compile ( "(?<=collect statistics (on)?(\\s)?(using sample)?(\\s)?(on)?(\\s)?(temporary)?(\\s)?[a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final Pattern TABLE_DB_NAME_REGEX                     = Pattern.compile ( "(?<=(create (global temporary )?table )|(alter table ))[a-z0-9_]*(?=\\.)"                              , Pattern.CASE_INSENSITIVE );
    public static final Pattern TABLE_NAME_REGEX                        = Pattern.compile ( "(?<=(create (global temporary )?table [a-z0-9_]{1,30}\\.)|(alter table [a-z0-9_]{1,30}\\.))[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );
    public static final String  TABLE_FOLDER_NAME                       = "tables";
    public static final String  TABLE_FLAG                              = "TABLE";

    public static final String  A38_TABLE_FOLDER_NAME                   = "tables_a38";
    public static final String  ADY_TABLE_FOLDER_NAME                   = "tables_ady";
    public static final String  CRR_TABLE_FOLDER_NAME                   = "tables_crr";
    public static final String  ERS_TABLE_FOLDER_NAME                   = "tables_ers";
    public static final String  FA0_TABLE_FOLDER_NAME                   = "tables_fa0";
    public static final String  G24_TABLE_FOLDER_NAME                   = "tables_g24";
    public static final String  G32_TABLE_FOLDER_NAME                   = "tables_g32";
    public static final String  G51_TABLE_FOLDER_NAME                   = "tables_g51";
    public static final String  G61_TABLE_FOLDER_NAME                   = "tables_g61";
    public static final String  G71_TABLE_FOLDER_NAME                   = "tables_g71";
    public static final String  G72_TABLE_FOLDER_NAME                   = "tables_g72";
    public static final String  G73_TABLE_FOLDER_NAME                   = "tables_g73";
    public static final String  G74_TABLE_FOLDER_NAME                   = "tables_g74";
    public static final String  G76_TABLE_FOLDER_NAME                   = "tables_g76";
    public static final String  G77_TABLE_FOLDER_NAME                   = "tables_g77";
    public static final String  G77_CORDL_TABLE_FOLDER_NAME             = "tables_g77_cordl";
    public static final String  G77_META_TABLE_FOLDER_NAME              = "tables_g77_meta";
    public static final String  G77_REF_TABLE_FOLDER_NAME               = "tables_g77_ref";
    public static final String  G79_TABLE_FOLDER_NAME                   = "tables_g79";
    public static final String  G7C_TABLE_FOLDER_NAME                   = "tables_g7c";
    public static final String  G7M_TABLE_FOLDER_NAME                   = "tables_g7m";
    public static final String  MDM_TABLE_FOLDER_NAME                   = "tables_mdm";
    public static final String  PHO_TABLE_FOLDER_NAME                   = "tables_pho";
    public static final String  PIL_TABLE_FOLDER_NAME                   = "tables_pil";
    public static final String  Q0T_TABLE_FOLDER_NAME                   = "tables_q0t";
    public static final String  RVL_TABLE_FOLDER_NAME                   = "tables_rvl";
    public static final String  VMS_TABLE_FOLDER_NAME                   = "tables_vms";
    
    public static final String  DMP_TABLE_FOLDER_NAME                   = "dmp_tables";
    public static final String  DMP_VIEW_FOLDER_NAME                    = "dmp_views";
    public static final String  DMP_FUNCTION_FOLDER_NAME                = "dmp_functions";

    
    public static final Pattern TABLE_GRANT_DB_NAME_REGEX               = Pattern.compile ( "(?<=grant [a-zA-Z0-9_,\\s]{1,500} on )[a-z0-9_]*"                   , Pattern.CASE_INSENSITIVE );
    public static final Pattern TABLE_GRANT_TABLE_NAME_REGEX            = Pattern.compile ( "(?<=grant [a-zA-Z0-9_,\\s]{1,500} on [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final Pattern FUNCTION_GRANT_DB_NAME_REGEX            = Pattern.compile ( "(?<=grant execute on )[a-z0-9_]{1,30}"              , Pattern.CASE_INSENSITIVE );
    public static final Pattern FUNCTION_GRANT_PROCEDURE_NAME_REGEX     = Pattern.compile ( "(?<=grant execute on [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final Pattern PROCEDURE_GRANT_DB_NAME_REGEX           = Pattern.compile ( "(?<=grant execute on )[a-z0-9_]{1,30}"              , Pattern.CASE_INSENSITIVE );
    public static final Pattern PROCEDURE_GRANT_PROCEDURE_NAME_REGEX    = Pattern.compile ( "(?<=grant execute on [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final Pattern VIEW_GRANT_DB_NAME_REGEX                = Pattern.compile ( "(?<=grant [a-zA-Z0-9_,\\s]{1,500} on )[a-z0-9_]*"                   , Pattern.CASE_INSENSITIVE );
    public static final Pattern VIEW_GRANT_VIEW_NAME_REGEX              = Pattern.compile ( "(?<=grant [a-zA-Z0-9_,\\s]{1,500} on [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );

    public static final Pattern TRIGGER_DB_NAME_REGEX                   = Pattern.compile ( "(?<=replace trigger )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern TRIGGER_NAME_REGEX                      = Pattern.compile ( "(?<=replace trigger [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );
    public static final String  TRIGGER_FOLDER_NAME                     = "triggers";
    public static final String  TRIGGER_FLAG                            = "TRIGGER";

    public static final Pattern VIEW_DB_NAME_REGEX                      = Pattern.compile ( "(?<=replace (force )?view )[a-z0-9_]*(?=\\.)"            , Pattern.CASE_INSENSITIVE );
    public static final Pattern VIEW_NAME_REGEX                         = Pattern.compile ( "(?<=replace (force )?view [a-z0-9_]{1,30}\\.)[a-z0-9_]*" , Pattern.CASE_INSENSITIVE );
    public static final String  VIEW_FOLDER_NAME                        = "views";
    public static final String  VIEW_FLAG                               = "VIEW";
}