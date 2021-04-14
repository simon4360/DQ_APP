package com.microgen.quality.ut;

import com.microgen.quality.ut.DataComparisonOperatorFactory;
import com.microgen.quality.ut.DatabaseConnectorFactory;
import com.microgen.quality.ut.DatabaseTableOperatorFactory;
import com.microgen.quality.ut.ExcelOperatorFactory;
import com.microgen.quality.ut.CSVFileOperatorFactory;
import com.microgen.quality.ut.EnvironmentConstants;
import com.microgen.quality.ut.Execution;
import com.microgen.quality.ut.ResourceConstants;
import com.microgen.quality.ut.Resources;
import com.microgen.quality.ut.TablenameConstants;
import com.microgen.quality.ut.TokenReplacement;
import com.microgen.quality.ut.ServerOperatorFactory;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.IDatabaseTableOperator;
import com.microgen.quality.tlf.database.IDataComparisonOperator;
import com.microgen.quality.tlf.excel.IExcelOperator;
import com.microgen.quality.tlf.csv.ICSVOperator;
import com.microgen.quality.tlf.server.IServerOperator;
import com.microgen.quality.tlf.string.ITokenReplacement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.DirectoryStream;

import org.testng.annotations.Test;
import org.testng.Assert;

import org.apache.log4j.Logger;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;

public class CommonTestOperations {
    private static final Logger LOG = Logger.getLogger(CommonTestOperations.class);
    private static final TokenReplacement TOKEN_OPS = new TokenReplacement();
    private static final IDatabaseConnector DB_G77_CFG_CONN_OPS = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG();
    private static final IDatabaseConnector DB_G77_CFG_TEC_CONN_OPS = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG_TEC();
    private static final IExcelOperator XL_OPS_G77_CFG = ExcelOperatorFactory.getExcelOperator(DB_G77_CFG_CONN_OPS);
    private static final ICSVOperator CSV_OPS_G77_CFG = CSVFileOperatorFactory.getCsvFileOperator(DB_G77_CFG_CONN_OPS);
    

    private static final IDataComparisonOperator DATA_COMP_OPS = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
    private static final IDatabaseTableOperator DB_G77_CFG_OPS = DatabaseTableOperatorFactory.getDatabaseTableOperator(DB_G77_CFG_CONN_OPS);

    private static final String dev_flag = System.getenv("DISABLE_CLEARDOWN_AFTER_TEST");
    

    public static void deleteData(TablenameConstants pTableName) throws Exception {
        DB_G77_CFG_OPS.deleteData(pTableName.getTableOwner(), pTableName.getTableName());
    }

    public static void startAptitudeProject(String aptitudeProject) {
        try {
            CommonTestOperations.aptitudeProjectCommand(aptitudeProject, "start");
        } catch (Exception e) {
            LOG.info("Start failed but this is probably because it was running already");
            LOG.info("But here's the message just in case: " + e.getMessage());
        }
    }

    public static void backupActualsVersusExpected(final TablenameConstants pActual, final String pTestPrefix) throws Exception {

        String expectedBackup = StringUtils.substring(pTestPrefix + "_" + pActual.getERTableName(), 0, 30);
        String actualsBackup = StringUtils.substring(pTestPrefix + "_" + pActual.getTableName(), 0, 30);

        DB_G77_CFG_OPS.dropIfExists(pActual.getTableOwner(), expectedBackup);
        DB_G77_CFG_OPS.copyTable(pActual.getTableOwner(), pActual.getERTableName(), pActual.getTableOwner(), expectedBackup, true);

        DB_G77_CFG_OPS.dropIfExists(pActual.getTableOwner(), actualsBackup);
        DB_G77_CFG_OPS.copyTable(pActual.getTableOwner(), pActual.getTableName(), pActual.getTableOwner(), actualsBackup, true);

        LOG.info("Test results backed up:");
        LOG.info("select 'expected' resultset, expected.* from " + expectedBackup + " expected;");
        LOG.info("select 'actual' resultset, actuals.* from " + actualsBackup + " actuals;");

    }

    public static void backupTableWithData(final TablenameConstants pTableName, final String pTestPrefix) throws Exception {

        String testPrefix = pTestPrefix;
        if (pTestPrefix == null || pTestPrefix.length() == 0)
            testPrefix = "TST_";
        String expectedTableName = StringUtils.substring(testPrefix + "_" + pTableName.getTableName(), 0, 30);

        DB_G77_CFG_OPS.dropIfExists(pTableName.getTableOwner(), expectedTableName);
        DB_G77_CFG_OPS.copyTable(pTableName.getTableOwner(), pTableName.getTableName(), pTableName.getTableOwner(), expectedTableName, true);

        LOG.info("select * from " + pTableName + ";");
        LOG.info("select * from " + expectedTableName + ";");

    }

    public static void backupTableWithData(final TablenameConstants pTableName) throws Exception {
        backupTableWithData(pTableName, null);
    }

    public static void dropIfExists(TablenameConstants pTableName) throws Exception {
        DB_G77_CFG_OPS.dropIfExists(pTableName.getTableOwner(), pTableName.getTableName());
    }

    public static void dropERIfExists(TablenameConstants pTableName) throws Exception {
        DB_G77_CFG_OPS.dropIfExists(pTableName.getTableOwner(), pTableName.getERTableName());
    }

    public static void createDatabaseTableFromExcelTab(final TablenameConstants pTableName, final Path pPathToExcelFile) throws Exception {
        XL_OPS_G77_CFG.createDatabaseTableFromExcelTab(pTableName.getTableOwner(), pPathToExcelFile, pTableName.getTableName());
    }

    public static void createERTableFromExcelTab(final TablenameConstants pTableName, final Path pPathToExcelFile) throws Exception {
        XL_OPS_G77_CFG.createDatabaseTableFromExcelTab(pTableName.getTableOwner(), pPathToExcelFile, pTableName.getERTableName());
    }

    public static void loadExcelTabToDatabaseTable(final TablenameConstants pTableName, final Path pPathToExcelFile, final ITokenReplacement pITokenReplacement) throws Exception {
        XL_OPS_G77_CFG.loadExcelTabToDatabaseTable(pTableName.getTableOwner(), pPathToExcelFile, pTableName.getTableName(), pITokenReplacement);
    }

    public static void loadERDataToDatabase(final TablenameConstants pTableName, final Path pPathToExcelFile, final ITokenReplacement pITokenReplacement) throws Exception {
        XL_OPS_G77_CFG.loadExcelTabToDatabaseTable(pTableName.getTableOwner(), pPathToExcelFile, pTableName.getERTableName(), pITokenReplacement);
    }
    
    public static void createDatabaseTableFromCsvFile(final TablenameConstants pTableName, final Path pPathToTestResources) throws Exception {
        
        assert (Files.exists( pPathToTestResources.resolve(pTableName.getCsvFileName())) && Files.isRegularFile(pPathToTestResources.resolve(pTableName.getCsvFileName())));
        
        CSV_OPS_G77_CFG.createDatabaseTableFromCsvFile(pTableName.getTableOwner(), pTableName.getTableName(), pPathToTestResources.resolve(pTableName.getCsvFileName()));
    }
    
    public static void createExpectedResultsTableFromCsvFile(final TablenameConstants pTableName, final Path pPathToTestResources) throws Exception {
        
        assert (Files.exists( pPathToTestResources.resolve(pTableName.getCsvFileName())) && Files.isRegularFile(pPathToTestResources.resolve(pTableName.getCsvFileName())));
        
        CSV_OPS_G77_CFG.createDatabaseTableFromCsvFile(pTableName.getTableOwner(), pTableName.getERTableName(), pPathToTestResources.resolve(pTableName.getCsvFileName()));
    }
    
    public static void loadInputDataToDatabase(final TablenameConstants pTableName, final Path pPathToTestResources, final ITokenReplacement pITokenReplacement) throws Exception {
        
        assert (Files.exists( pPathToTestResources.resolve(pTableName.getCsvFileName())) && Files.isRegularFile(pPathToTestResources.resolve(pTableName.getCsvFileName())));
        
        DB_G77_CFG_OPS.deleteData(pTableName.getTableOwner(), pTableName.getTableName());
        CSV_OPS_G77_CFG.loadCsvFileToDatabaseTable(pTableName.getTableOwner(), pTableName.getTableName(), pPathToTestResources.resolve(pTableName.getCsvFileName()), pITokenReplacement);
    }

    public static void loadCSVERDataToDatabase(final TablenameConstants pTableName, final Path pPathToTestResources, final ITokenReplacement pITokenReplacement) throws Exception {
        
        assert (Files.exists( pPathToTestResources.resolve(pTableName.getCsvFileName())) && Files.isRegularFile(pPathToTestResources.resolve(pTableName.getCsvFileName())));
        
        DB_G77_CFG_OPS.dropIfExists(pTableName.getTableOwner(), pTableName.getERTableName());
        CSV_OPS_G77_CFG.createDatabaseTableFromCsvFile(pTableName.getTableOwner(), pTableName.getERTableName(), pPathToTestResources.resolve(pTableName.getCsvFileName()));
        CSV_OPS_G77_CFG.loadCsvFileToDatabaseTable(pTableName.getTableOwner(), pTableName.getERTableName(), pPathToTestResources.resolve(pTableName.getCsvFileName()), pITokenReplacement);
    }
    
    
    public static void backupGeneralMappings() throws Exception {
          backupTableWithData ( TablenameConstants.T_GENERAL_MAPPINGS, "BKP" ); 
    }

    public static void resetGeneralMappings() throws Exception {
        Connection conn = null;
        PreparedStatement pStmt = null;
        
        DB_G77_CFG_OPS.alterTrigger ( TablenameConstants.TR_T_GENERAL_MAPPINGS_GMT.getTableOwner () , TablenameConstants.TR_T_GENERAL_MAPPINGS_GMT.getTableName (), "disable" );
        DB_G77_CFG_OPS.alterTrigger ( TablenameConstants.TR_T_GENERAL_MAPPINGS_AUD.getTableOwner () , TablenameConstants.TR_T_GENERAL_MAPPINGS_AUD.getTableName (), "disable" );
        
        deleteData ( TablenameConstants.T_GENERAL_MAPPINGS ) ;
    final String RESET_SQL = " insert into @g77_cfgUsername@.t_general_mappings (mapping_type_id,mapping_type_group,source_system_code,match_key_1,match_key_1_desc,match_key_2,match_key_2_desc,match_key_3,match_key_3_desc,match_key_4,match_key_4_desc, " +
"match_key_5,match_key_5_desc,match_key_6,match_key_6_desc,match_key_7,match_key_7_desc,match_key_8,match_key_8_desc,match_key_9,match_key_9_desc,match_key_10,match_key_10_desc,match_key_11,match_key_11_desc, " +
"match_key_12,match_key_12_desc,match_key_13,match_key_13_desc,match_key_14,match_key_14_desc,match_key_15,match_key_15_desc,match_key_16,match_key_16_desc,match_key_17,match_key_17_desc,match_key_18,match_key_18_desc," +
"match_key_19,match_key_19_desc,match_key_20,match_key_20_desc,match_key_21,match_key_21_desc,match_key_22,match_key_22_desc,match_key_23,match_key_23_desc,match_key_24,match_key_24_desc,match_key_25,match_key_25_desc," +
"match_key_26,match_key_26_desc,match_key_27,match_key_27_desc,match_key_28,match_key_28_desc,match_key_29,match_key_29_desc,match_key_30,match_key_30_desc,lookup_value_1,lookup_value_1_desc,lookup_value_2,lookup_value_2_desc," +
"lookup_value_3,lookup_value_3_desc,lookup_value_4,lookup_value_4_desc,lookup_value_5,lookup_value_5_desc,lookup_value_6,lookup_value_6_desc,lookup_value_7,lookup_value_7_desc,lookup_value_8,lookup_value_8_desc,lookup_value_9,lookup_value_9_desc," +
"lookup_value_10,lookup_value_10_desc,lookup_value_11,lookup_value_11_desc,lookup_value_12,lookup_value_12_desc,lookup_value_13,lookup_value_13_desc,lookup_value_14,lookup_value_14_desc,lookup_value_15,lookup_value_15_desc,lookup_value_16," +
"lookup_value_16_desc,lookup_value_17,lookup_value_17_desc,lookup_value_18,lookup_value_18_desc,lookup_value_19,lookup_value_19_desc,lookup_value_20,lookup_value_20_desc,lookup_value_21,lookup_value_21_desc,lookup_value_22,lookup_value_22_desc,lookup_value_23," +
"lookup_value_23_desc,lookup_value_24,lookup_value_24_desc,lookup_value_25,lookup_value_25_desc,lookup_value_26,lookup_value_26_desc,lookup_value_27,lookup_value_27_desc,lookup_value_28,lookup_value_28_desc,lookup_value_29,lookup_value_29_desc,lookup_value_30," +
"lookup_value_30_desc,active_indicator,input_by,input_time,input_time_gmt,approved_by,auth_by,auth_status,effective_from,effective_to,unique_hash) " +
"select mapping_type_id,mapping_type_group,source_system_code,match_key_1,match_key_1_desc,match_key_2,match_key_2_desc,match_key_3,match_key_3_desc,match_key_4,match_key_4_desc," +
"match_key_5,match_key_5_desc,match_key_6,match_key_6_desc,match_key_7,match_key_7_desc,match_key_8,match_key_8_desc,match_key_9,match_key_9_desc,match_key_10,match_key_10_desc,match_key_11,match_key_11_desc," +
"match_key_12,match_key_12_desc,match_key_13,match_key_13_desc,match_key_14,match_key_14_desc,match_key_15,match_key_15_desc,match_key_16,match_key_16_desc,match_key_17,match_key_17_desc,match_key_18,match_key_18_desc," +
"match_key_19,match_key_19_desc,match_key_20,match_key_20_desc,match_key_21,match_key_21_desc,match_key_22,match_key_22_desc,match_key_23,match_key_23_desc,match_key_24,match_key_24_desc,match_key_25,match_key_25_desc," +
"match_key_26,match_key_26_desc,match_key_27,match_key_27_desc,match_key_28,match_key_28_desc,match_key_29,match_key_29_desc,match_key_30,match_key_30_desc,lookup_value_1,lookup_value_1_desc,lookup_value_2,lookup_value_2_desc," +
"lookup_value_3,lookup_value_3_desc,lookup_value_4,lookup_value_4_desc,lookup_value_5,lookup_value_5_desc,lookup_value_6,lookup_value_6_desc,lookup_value_7,lookup_value_7_desc,lookup_value_8,lookup_value_8_desc,lookup_value_9,lookup_value_9_desc," +
"lookup_value_10,lookup_value_10_desc,lookup_value_11,lookup_value_11_desc,lookup_value_12,lookup_value_12_desc,lookup_value_13,lookup_value_13_desc,lookup_value_14,lookup_value_14_desc,lookup_value_15,lookup_value_15_desc,lookup_value_16," +
"lookup_value_16_desc,lookup_value_17,lookup_value_17_desc,lookup_value_18,lookup_value_18_desc,lookup_value_19,lookup_value_19_desc,lookup_value_20,lookup_value_20_desc,lookup_value_21,lookup_value_21_desc,lookup_value_22,lookup_value_22_desc,lookup_value_23," +
"lookup_value_23_desc,lookup_value_24,lookup_value_24_desc,lookup_value_25,lookup_value_25_desc,lookup_value_26,lookup_value_26_desc,lookup_value_27,lookup_value_27_desc,lookup_value_28,lookup_value_28_desc,lookup_value_29,lookup_value_29_desc,lookup_value_30," +
"lookup_value_30_desc,active_indicator,input_by,input_time,input_time_gmt,approved_by,auth_by,auth_status,effective_from,effective_to,unique_hash " +
"from @g77_cfgUsername@.bkp_t_general_mappings";
        try {
            conn = DB_G77_CFG_CONN_OPS.getConnection();

            LOG.debug("A connection to the database was successfully retrieved");

            pStmt = conn.prepareStatement(TOKEN_OPS.replaceTokensInString(RESET_SQL));

            LOG.debug("The reset statements were successfully prepared");

            pStmt.execute();

            LOG.debug("The delete statements were successfully executed");

            conn.commit();

            LOG.debug("The changes were committed to the database");
        } catch (SQLException sqle) {
            LOG.error("SQLException : " + sqle);

            throw sqle;
        } finally {
            pStmt.close();

            conn.close();
        }


        DB_G77_CFG_OPS.alterTrigger ( TablenameConstants.TR_T_GENERAL_MAPPINGS_GMT.getTableOwner () , TablenameConstants.TR_T_GENERAL_MAPPINGS_GMT.getTableName (), "enable" );
        DB_G77_CFG_OPS.alterTrigger ( TablenameConstants.TR_T_GENERAL_MAPPINGS_AUD.getTableOwner () , TablenameConstants.TR_T_GENERAL_MAPPINGS_AUD.getTableName (), "enable" );

    }

    public static void cleardownG77_CFG() throws Exception {
        Connection conn = null;
        PreparedStatement pStmt = null;

        LOG.debug("Deleting all test data from the G77_CFG database.");

        // example disable trigger DB_G77_CFG_OPS.alterTrigger (
        // TablenameConstants.FRTR_SLR_ENTITIES_AD.getTableOwner () ,
        // TablenameConstants.FRTR_SLR_ENTITIES_AD.getTableName (), "disabled"
        // );

        final String CLEARDOWN_SQL = " truncate table @g77_cfgUsername@.t_info_log ;" + " truncate table @g77_cfgUsername@.t_error_log ;" + " truncate table @g77_cfgUsername@.t_legal_entity;" + " truncate table @g77_cfgUsername@.t_cost_centre;" + " truncate table @g77_cfgUsername@.t_bus_partic_type;" + " truncate table @g77_cfgUsername@.t_currency;"
                + " truncate table @g77_cfgUsername@.t_exchange_rate;" + " truncate table @g77_cfgUsername@.t_line_of_business;" + " truncate table @g77_cfgUsername@.t_partner;" + " truncate table @g77_cfgUsername@.t_roll_forward;" + " truncate table @g77_cfgUsername@.t_g71_contract_in_arc;" + " truncate table @g77_cfgUsername@.t_g71_contract_in;"
                + " truncate table @g77_cfgUsername@.t_g71_financial_trans_in_arc;" + " truncate table @g77_cfgUsername@.t_g71_financial_transaction_in;" + " truncate table @g77_cfgUsername@.t_g24_ticdl_out;" + " truncate table @g77_cfgUsername@.t_mdm_bus_partic_typ_in;" + " truncate table @g77_cfgUsername@.t_mdm_cost_centre_in;"
                + " truncate table @g77_cfgUsername@.t_mdm_contract_in;" + " truncate table @g77_cfgUsername@.t_mdm_currency_in;" + " truncate table @g77_cfgUsername@.t_mdm_exchange_rate_in;" + " truncate table @g77_cfgUsername@.t_mdm_legal_entity_in;" + " truncate table @g77_cfgUsername@.t_mdm_line_of_business_in;"
                + " truncate table @g77_cfgUsername@.t_mdm_partner_in;" + " truncate table @g77_cfgUsername@.t_mdm_roll_forward_in;" + " truncate table @g77_cfgUsername@.t_g74_insurance_policy_out;" + " truncate table @g77_cfgUsername@.t_g74_insurance_policy_out_arc;" + " truncate table @g77_cfgUsername@.t_g74_acc_event_out;"
                + " truncate table @g77_cfgUsername@.t_g74_acc_event_out_arc;" + " truncate table @g77_cfgUsername@.t_g77_contract_out;" + " truncate table @g77_cfgUsername@.t_g77_contract_out_arc;" + " truncate table @g77_cfgUsername@.t_g77_currency_out;" + " truncate table @g77_cfgUsername@.ref_currency;"
                + " truncate table @g77_cfgUsername@.ref_contract_arc;" + " truncate table @g77_cfgUsername@.ref_contract;" + " truncate table @g77_cfgUsername@.t_key_combinations;" + " truncate table @g77_cfgUsername@.t_roll_forward_arc;" + " truncate table @g77_cfgUsername@.t_partner_arc;" + " truncate table @g77_cfgUsername@.t_line_of_business_arc;"
                + " truncate table @g77_cfgUsername@.t_exchange_rate_arc;" + " truncate table @g77_cfgUsername@.t_currency_arc;" + " truncate table @g77_cfgUsername@.t_bus_partic_type_arc;" + " truncate table @g77_cfgUsername@.t_cost_centre_arc;" + " truncate table @g77_cfgUsername@.t_legal_entity_arc;"
                + " truncate table @g77_cfgUsername@.t_financial_transaction_arc;" + " truncate table @g77_cfgUsername@.t_financial_transaction;" + " truncate table @g77_cfgUsername@.t_contract;" + " truncate table @g77_cfgUsername@.t_contract_arc;"
                // Delete from mock tables as they are synonyms
                + " delete from @g77_cfgUsername@.t_g77_contract;" + " delete from @g77_cfgUsername@.t_g77_financial_transaction;" + " delete from @g77_cfgUsername@.fr_stan_raw_acc_event;" + " delete from @g77_cfgUsername@.fr_stan_raw_insurance_policy;";
        try {
            conn = DB_G77_CFG_CONN_OPS.getConnection();

            LOG.debug("A connection to the database was successfully retrieved");

            pStmt = conn.prepareStatement(TOKEN_OPS.replaceTokensInString(CLEARDOWN_SQL));

            LOG.debug("The delete statements were successfully prepared");

            pStmt.execute();

            LOG.debug("The delete statements were successfully executed");

            conn.commit();

            LOG.debug("The changes were committed to the database");
        } catch (SQLException sqle) {
            LOG.error("SQLException : " + sqle);

            throw sqle;
        } finally {
            pStmt.close();

            conn.close();
        }

        // example enable trigger DB_SLR_OPS.alterTrigger (
        // TablenameConstants.FRTR_SLR_ENTITIES_AD.getTableOwner () ,
        // TablenameConstants.FRTR_SLR_ENTITIES_AD.getTableName (), "enabled" );
    }

    public static void grantTableAccess(final TablenameConstants pTableName) throws Exception {

        if ((dev_flag != null && dev_flag.equals("false"))) {

            Connection conn = null;
            PreparedStatement pStmt = null;
            String SYNDDL = "grant SELECT, UPDATE, INSERT, DELETE on @g77_cfgUsername@." + pTableName.getTableName() + " to @g77_cfg_tecUsername@";

            LOG.debug("Granting: " + TOKEN_OPS.replaceTokensInString(SYNDDL));

            try {
                conn = DB_G77_CFG_CONN_OPS.getConnection();
                LOG.debug("A connection to the database was successfully retrieved");
                pStmt = conn.prepareStatement(TOKEN_OPS.replaceTokensInString(SYNDDL));
                LOG.debug("The DDL to be used to grant table access has been successfully prepared");
                pStmt.executeUpdate();
                LOG.debug("Grant granted");
                conn.commit();
            } catch (SQLException sqle) {
                LOG.fatal("SQL Exception: " + sqle);
                throw sqle;
            } finally {
                pStmt.close();
                conn.close();
            }
        } else {
            LOG.info("No granting off rights allowed on this environment.");
        }

    }

    public static void replaceTableSynonym(final TablenameConstants pTableName) throws Exception {
        Connection conn = null;
        PreparedStatement pStmt = null;
        String SYNDDL = "create or replace synonym @g77_cfg_tecUsername@." + pTableName.getSynonymName() + " FOR @g77_cfgUsername@." + pTableName.getTableName();

        LOG.debug("The Synonym '@g77_cfg_tecUsername@." + pTableName.getSynonymName() + "' will be re-pointed to mock table @g77_cfg_tecUsername@." + pTableName.getTableName() + " using the following DDL '" + TOKEN_OPS.replaceTokensInString(SYNDDL) + "'");

        try {
            conn = DB_G77_CFG_TEC_CONN_OPS.getConnection();
            LOG.debug("A connection to the database was successfully retrieved");
            pStmt = conn.prepareStatement(TOKEN_OPS.replaceTokensInString(SYNDDL));
            LOG.debug("The DDL to be used to re-point a synonym has been successfully prepared");
            pStmt.executeUpdate();
            LOG.debug("Synonym Created");
            conn.commit();
        } catch (SQLException sqle) {
            LOG.fatal("SQL Exception: " + sqle);
            throw sqle;
        } finally {
            pStmt.close();
            conn.close();
        }

        SYNDDL = "create or replace synonym @g77_cfgUsername@." + pTableName.getSynonymName() + " FOR " + pTableName.toString();

        if (pTableName.getTableName() == pTableName.getSynonymName()) {
            LOG.info("Skipping creation of Synonym '@g77_cfgUsername@." + pTableName.getSynonymName() + "' for table " + pTableName.toString() + " as the database rightfully so thinks it's not needed.");
        } else {
            LOG.info("The Synonym '@g77_cfgUsername@." + pTableName.getSynonymName() + "' will be re-pointed to mock table " + pTableName.toString() + " using the following DDL '" + TOKEN_OPS.replaceTokensInString(SYNDDL) + "'");
            try {
                conn = DB_G77_CFG_CONN_OPS.getConnection();
                LOG.debug("A connection to the database was successfully retrieved");
                pStmt = conn.prepareStatement(TOKEN_OPS.replaceTokensInString(SYNDDL));
                LOG.debug("The DDL to be used to re-point a synonym has been successfully prepared");
                pStmt.executeUpdate();
                LOG.debug("Synonym Created");
                conn.commit();
            } catch (SQLException sqle) {
                LOG.fatal("SQL Exception: " + sqle);
                throw sqle;
            } finally {
                pStmt.close();
                conn.close();
            }
        }
    }

    public static void aptitudeProjectCommand(final String pAptitudeProject, final String pAptitudeCommand) throws Exception {
        Path PATH_TO_APTITUDE_SRC_DIR = Paths.get(System.getProperty("user.dir")).resolve("src").resolve("main").resolve("aptitude");
        if (Files.isDirectory(PATH_TO_APTITUDE_SRC_DIR)) {
            try {
                DirectoryStream<Path> aptitudeSrcDirStream = Files.newDirectoryStream(PATH_TO_APTITUDE_SRC_DIR);
                for (Path executionFolder : aptitudeSrcDirStream) {
                    if (pAptitudeProject == "all") {
                        if (Files.isDirectory(executionFolder) && !Files.isHidden(executionFolder)) {
                            DirectoryStream<Path> aptitudeProjectStream = Files.newDirectoryStream(executionFolder, "*.{brd}");

                            for (Path aptitudeProject : aptitudeProjectStream) {
                                try {
                                    Execution.StopStartAptitude(executionFolder.getFileName().toString(), FilenameUtils.getBaseName(aptitudeProject.toString()), pAptitudeCommand);
                                } catch (Exception e) {
                                    throw e;
                                }
                            }
                            aptitudeProjectStream.close();
                        }

                    } else {
                        Execution.StopStartAptitude(executionFolder.getFileName().toString(), pAptitudeProject, pAptitudeCommand);
                    }
                }
                aptitudeSrcDirStream.close();
            } catch (Exception e) {
                throw e;
            }
        }
    }
}
