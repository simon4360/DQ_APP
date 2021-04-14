package com.microgen.quality.ut.testing.database_tests.g77_configuration;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.IDataComparisonOperator;

import com.microgen.quality.ut.EnvironmentConstants;
import com.microgen.quality.ut.DatabaseConnectorFactory;
import com.microgen.quality.ut.DatabaseTableOperatorFactory;
import com.microgen.quality.ut.ExcelOperatorFactory;
import com.microgen.quality.ut.ServerOperatorFactory;
import com.microgen.quality.ut.DataComparisonOperatorFactory;
import com.microgen.quality.ut.CommonTestOperations;

import com.microgen.quality.ut.Execution;

import com.microgen.quality.ut.ResourceConstants;
import com.microgen.quality.ut.Resources;
import com.microgen.quality.ut.TablenameConstants;
import com.microgen.quality.ut.TokenReplacement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

import java.util.ArrayList;
import java.util.Properties;
import java.util.stream.Stream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.UncheckedIOException;
import java.io.IOException;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.io.FilenameUtils;

import java.util.Calendar;

import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;
import org.apache.log4j.Logger;

public class testG77Configuration {
    Connection conn = null;
    CallableStatement cStmt = null;
    ResultSet rs = null;
    Statement eStmt = null;
    PreparedStatement pStmt = null;
    String SQL_CODE;
    String TASK;
    private static final Logger LOG = Logger.getLogger(testG77Configuration.class);

    private static final IDatabaseConnector DB_CONN_OPS = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG();
    private static final IDatabaseConnector DB_CONN_OPS_ARC = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG_ARC();
    private static final IDatabaseConnector DB_CONN_OPS_TEC = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG_TEC();

    private final IDataComparisonOperator DATA_COMP_OPS = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
    private final TokenReplacement TOKEN_OPS = new TokenReplacement();
    private final Path PATH_TO_RESOURCES = Resources.getPathToResource("testing/g77_configuration/");

    @Test
    public void testValidTechnicalUsersForRestartabilityConfig() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("TechnicalUsersCanHaveRestartConfig_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("TechnicalUsersCanHaveRestartConfig_actual.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }
    
    @Test
    public void testOperationalTablesShouldHaveBatchTaskConfig() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_actual_operational.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }

    @Test
    public void testInterfaceTablesShouldHaveBatchTaskConfig() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_actual_interface.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }
    
    @Test
    public void testReferenceTablesShouldHaveBatchTaskConfig() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_actual_reference.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }
    
    @Test
    public void testExternalTablesShouldHaveBatchTaskConfig() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("TablesShouldHaveBatchTask_actual_synonym.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }
    
    @Test
    public void testBatchTasksHaveInputAndOutputConfig() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("BatchTaskShouldHaveInputOutputTables_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("BatchTaskShouldHaveInputOutputTables_actual.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }
    
    @Test
    public void testMicroflowShouldBeLowerCase() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("MicroflowsMustBeLowerCase_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("MicroflowsMustBeLowerCase_actual.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }
	
    @Test
    public void testDeltaViewAttributeCoverage() throws Exception {

        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("DeltaViewShouldPopulateMiddleTableInFull_expected.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("DeltaViewShouldPopulateMiddleTableInFull_actual.sql");
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPECTED_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
    }
}
