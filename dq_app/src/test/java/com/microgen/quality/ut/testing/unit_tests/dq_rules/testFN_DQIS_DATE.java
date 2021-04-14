package com.microgen.quality.ut.testing.unit_tests.dq_rules;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.IDatabaseTableOperator;
import com.microgen.quality.tlf.database.IDataComparisonOperator;
import com.microgen.quality.tlf.server.IServerOperator;
import com.microgen.quality.tlf.excel.IExcelOperator;

import com.microgen.quality.ut.EnvironmentConstants;
import com.microgen.quality.ut.DatabaseConnectorFactory;
import com.microgen.quality.ut.DatabaseTableOperatorFactory;
import com.microgen.quality.ut.ExcelOperatorFactory;
import com.microgen.quality.ut.ServerOperatorFactory;
import com.microgen.quality.ut.DataComparisonOperatorFactory;

import com.microgen.quality.ut.Execution;
import com.microgen.quality.ut.CommonTestOperations;

import com.microgen.quality.ut.ResourceConstants;
import com.microgen.quality.ut.Resources;
import com.microgen.quality.ut.TablenameConstants;
import com.microgen.quality.ut.TokenReplacement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.SQLException;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.util.Calendar;

import org.testng.annotations.Test;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;
import org.apache.log4j.Logger;

public class testFN_DQIS_DATE {
        private static final Logger LOG = Logger.getLogger(testFN_DQIS_DATE.class);

        private final IDatabaseTableOperator  DB_TABLE_OPS_G77_CFG = DatabaseTableOperatorFactory.getDatabaseTableOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
        private final IExcelOperator          XL_OPS_G77_CFG       = ExcelOperatorFactory.getExcelOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
        private final IDataComparisonOperator DATA_COMP_OPS        = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
        private final TokenReplacement        TOKEN_OPS            = new TokenReplacement();
        private       IDatabaseConnector      CFG_CONN_OPS         = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG () ;
        private final Path PATH_TO_REF_DATA  = Resources.getPathToResource("testing/reference_data");
        private final Path PATH_TO_RESOURCES = Resources.getPathToResource("testing/dq_rules/FN_DQIS_DATE");

        final String TestPrefix = "FID5";
        final String aptitudeProject = "g77_src_ady";
        final String aptitudeUtils = "g77_utils";
        final String sessionId = "DQ_FUNCTION5";
        final String use_case_id = "UCN1043";
        final String publishMicroflow = "payroll_publish";

        final TablenameConstants fileControl  = TablenameConstants.T_FILE_CONTROL;
        final TablenameConstants targetTable  = TablenameConstants.T_ADY_PAYROLL_IN;
        final TablenameConstants refTableCost = TablenameConstants.REF_COST_CENTRE;
        final TablenameConstants refTableCurr = TablenameConstants.REF_CURRENCY;
        final TablenameConstants refGLAccount = TablenameConstants.REF_GL_ACCOUNT;

        private void clearDown() throws Exception {

                CommonTestOperations.deleteData     ( fileControl );
                CommonTestOperations.deleteData     ( targetTable );
                CommonTestOperations.dropERIfExists ( targetTable );
                
                CommonTestOperations.deleteData     ( refTableCost );
                CommonTestOperations.deleteData     ( refTableCurr );
                CommonTestOperations.deleteData     ( refGLAccount );
        }

        private void updateConfigData( String pUpdateSQL ) throws Exception
        {
         Connection        connCFG = null;
         PreparedStatement pStmtCFG = null;
        
         LOG.debug ( "Updating active config in t_meta_table_dq so only function 5 is run during this test " + TOKEN_OPS.replaceTokensInString ( pUpdateSQL ) );
             try
             {
                 connCFG = CFG_CONN_OPS.getConnection ();
                 LOG.debug ( "A connection to the database was successfully retrieved" );
                 pStmtCFG = connCFG.prepareStatement ( TOKEN_OPS.replaceTokensInString ( pUpdateSQL ) );
                 LOG.debug ( "The update statement was successfully prepared" );
                 pStmtCFG.execute ();
                 LOG.debug ( "The update statement was successfully executed" );
                 connCFG.commit ();
                 LOG.debug ( "The changes were committed to the database" );
             }
             catch ( SQLException sqle )
             {
                 LOG.error ( "SQLException : " + sqle );
                 throw sqle;
             }
             finally
             {
                 pStmtCFG.close ();
                 connCFG.close ();
             } 
        }

        @BeforeClass
        private void cleardownBeforeEachTest() throws Exception {
                clearDown();

                String pUpdateSQL = "update t_meta_table_dq set DQ_ACTIVE_INDICATOR = 'X' where dq_config_id in (select distinct mdq.dq_config_id from t_meta_table_dq mdq inner join v_meta_batch_task_dq dq on dq.dq_config_id = mdq.dq_config_id where dq.dq_aptitude_project = 'g77_src_ady' and mdq.dq_function_id != '5')";
                updateConfigData(pUpdateSQL);
        }

        @AfterClass
        private void cleardownAfterEachTest() throws Exception {
                clearDown();

                String pUpdateSQL = "update t_meta_table_dq set DQ_ACTIVE_INDICATOR = 'A' where dq_active_indicator='X'";
                updateConfigData(pUpdateSQL);
        }

        @Test
        public void runTest() throws Exception {

                // Load data in staging and ER tables
                final Path PATH_TO_REF_DATA_FILE = PATH_TO_REF_DATA.resolve("reference_data_input.xlsx");
                final Path PATH_TO_TEST_DATA_FILE = PATH_TO_RESOURCES.resolve("WT_LUPAY_20170531_XXXX_01_01.enc");
                final Path PATH_TO_EXPCTD_RESULTS_FILE = PATH_TO_RESOURCES.resolve("data_expected_results.xlsx");
                final Path PATH_TO_EXPCTD_RESULTS = PATH_TO_RESOURCES.resolve("expected_results.sql");
                final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("actual_results.sql");
                final Path PATH_TO_TARGET_DIRECTORY = Paths.get("/opt/aptitude/g77_data_in/ADY");

                assert (Files.exists(PATH_TO_TEST_DATA_FILE) && Files.isRegularFile(PATH_TO_TEST_DATA_FILE));
                assert (Files.exists(PATH_TO_EXPCTD_RESULTS_FILE) && Files.isRegularFile(PATH_TO_EXPCTD_RESULTS_FILE));
                assert (Files.exists(PATH_TO_EXPCTD_RESULTS) && Files.isRegularFile(PATH_TO_EXPCTD_RESULTS));
                assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));
                assert (Files.exists(PATH_TO_REF_DATA_FILE) && Files.isRegularFile(PATH_TO_REF_DATA_FILE));

                Execution.copyFile(EnvironmentConstants.APP_SERVER_NAME.toString(), EnvironmentConstants.APP_SERVER_OS_USERNAME.toString(), PATH_TO_TEST_DATA_FILE.toString(), PATH_TO_TARGET_DIRECTORY.toString());
                // Prepare Inputs
                
                CommonTestOperations.loadExcelTabToDatabaseTable ( refTableCost  , PATH_TO_REF_DATA_FILE, TOKEN_OPS);
                CommonTestOperations.loadExcelTabToDatabaseTable ( refTableCurr  , PATH_TO_REF_DATA_FILE, TOKEN_OPS);
                CommonTestOperations.loadExcelTabToDatabaseTable ( refGLAccount  , PATH_TO_REF_DATA_FILE, TOKEN_OPS);

                // Prepare Expected Results
                CommonTestOperations.createERTableFromExcelTab   ( targetTable , PATH_TO_EXPCTD_RESULTS_FILE );
                CommonTestOperations.loadERDataToDatabase        ( targetTable , PATH_TO_EXPCTD_RESULTS_FILE , TOKEN_OPS );

                // Start Aptitude project
                try {
                        CommonTestOperations.aptitudeProjectCommand(aptitudeProject, "start");
                } catch (Exception e) {
                        LOG.info("Start failed but this is probably because it was running already");
                }
                try {
                        CommonTestOperations.aptitudeProjectCommand(aptitudeUtils, "start");
                } catch (Exception e) {
                        LOG.info("Start failed but this is probably because it was running already");
                }

                Assert.assertTrue(Execution.runMF(aptitudeUtils,   "run_file_control", sessionId, use_case_id));
                Assert.assertFalse(Execution.runMF(aptitudeProject, "payroll_publish",  sessionId, use_case_id));

                try {
                        Assert.assertEquals ( 0, DATA_COMP_OPS.countMinusQueryResults ( PATH_TO_EXPCTD_RESULTS , PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS )
                          );
                } catch ( AssertionError e_no_results ) {
                        CommonTestOperations.backupActualsVersusExpected ( targetTable , TestPrefix );
                        throw e_no_results;
                }
        }
}
