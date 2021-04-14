package com.microgen.quality.ut.testing.${projectName};

import com.microgen.quality.tlf.database.IDataComparisonOperator;
import com.microgen.quality.ut.DatabaseConnectorFactory;
import com.microgen.quality.ut.DataComparisonOperatorFactory;
import com.microgen.quality.ut.Execution;
import com.microgen.quality.ut.AptitudeProjectWorkflow;
import com.microgen.quality.ut.CommonTestOperations;
import com.microgen.quality.ut.Resources;
import com.microgen.quality.ut.TablenameConstants;
import com.microgen.quality.ut.TokenReplacement;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.LinkedList;

import org.testng.annotations.Test;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;
import org.apache.log4j.Logger;

public class ${className} {
	private static final Logger LOG = Logger.getLogger(${className}.class);
	
	final String packageName = "${projectName}";
	
	// Set the test prefix
	final String TestPrefix = "${TestPrefix}";
	final String aptitudeUtils = "${aptitudeUtils}";
	final String sessionId =   "${TestPrefix}${className}";
	final String use_case_id = "${TestPrefix}${className}";
	
	final String testResourcesFolderName = "testing/${projectName}/${functionalName}";
	final Path PATH_TO_REF_DATA = Resources.getPathToResource("testing/reference_data");
	
	//Sequence in which the aptitude project are run
	LinkedList<AptitudeProjectWorkflow> aptitudeProjectsToRun = new LinkedList<AptitudeProjectWorkflow>(Arrays.asList(
			 ${l_aptitudeProjectsToRun}
			));

	//Standard table definitions
	LinkedList<TablenameConstants> sourceDataTables = new LinkedList<TablenameConstants>(Arrays.asList(
		      ${l_sourceTableName}
			));
	
	//Standard table definitions
	LinkedList<TablenameConstants> intermediateDataTables = new LinkedList<TablenameConstants>(Arrays.asList(
		      ${l_intermediateDataTables}
			));
	
	LinkedList<TablenameConstants> resultsTables = new LinkedList<TablenameConstants>(Arrays.asList(
		      ${l_targetTableName}
			));
			
	LinkedList<TablenameConstants> resourceDataTables = new LinkedList<TablenameConstants>(Arrays.asList(
		      ${l_resourceDataTables}
			));			
		
	/*
	 * Define paths to various folders and files Define various operator objects that will be reused by these tests
	 */
	private final IDataComparisonOperator DATA_COMP_OPS = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	private final TokenReplacement TOKEN_OPS = new TokenReplacement();
	private final Path PATH_TO_RESOURCES = Resources.getPathToResource(testResourcesFolderName);

	@BeforeClass
	private void cleardownBeforeEachTest() throws Exception {
		LOG.info("SessionID" +sessionId + ", UseCaseID:" + use_case_id + ", TestResourcesFolderName:" + testResourcesFolderName);
		cleardown();
		synonyms();
	}

	@AfterClass
	private void cleardownAfterEachTest() throws Exception {
		if (CommonTestOperations.isCleardownRequired())
			cleardown();
	}

	@Test
	public void runTest() throws Exception {

		// Load data in staging and ER tables
		final Path PATH_TO_TEST_DATA_FILE = PATH_TO_RESOURCES.resolve("data_input.xlsx");
		final Path PATH_TO_EXPCTD_RESULTS_FILE = PATH_TO_RESOURCES.resolve("data_expected_results.xlsx");
		final Path PATH_TO_REF_DATA_FILE = PATH_TO_REF_DATA.resolve("reference_data_input.xlsx");
		

		assert (Files.exists(PATH_TO_RESOURCES) && Files.isDirectory(PATH_TO_RESOURCES));
		assert (Files.exists(PATH_TO_TEST_DATA_FILE) && Files.isRegularFile(PATH_TO_TEST_DATA_FILE));
		assert (Files.exists(PATH_TO_EXPCTD_RESULTS_FILE) && Files.isRegularFile(PATH_TO_EXPCTD_RESULTS_FILE));

		//Load source data
		for(TablenameConstants tables : sourceDataTables) {
			CommonTestOperations.loadExcelTabToDatabaseTable(tables, PATH_TO_TEST_DATA_FILE, TOKEN_OPS);
		}
		
    // Load ref data
		for (TablenameConstants tables : resourceDataTables) {
			LOG.info("Clearing reference table as we're going to reload it: " + tables.getTableName());
			CommonTestOperations.deleteData(tables);
			CommonTestOperations.loadExcelTabToDatabaseTable(tables, PATH_TO_REF_DATA_FILE, TOKEN_OPS);
		}
		
		//Create and load Expected Results tables
		for(TablenameConstants tables : resultsTables) {
			CommonTestOperations.createERTableFromExcelTab(tables, PATH_TO_EXPCTD_RESULTS_FILE);
			CommonTestOperations.loadERDataToDatabase(tables, PATH_TO_EXPCTD_RESULTS_FILE, TOKEN_OPS);
		}


		// Start Aptitude project
		CommonTestOperations.startAptitudeProject(aptitudeUtils);

		//Run Aptitude Project
		for (AptitudeProjectWorkflow aptitudeWorkflow : aptitudeProjectsToRun) {
			// Start Aptitude project
			CommonTestOperations.startAptitudeProject(aptitudeWorkflow.getProjectName());
			LOG.info("Running Project: "+ aptitudeWorkflow.getProjectName() +", workflow: " + aptitudeWorkflow.getWorkflowName());
			Assert.assertTrue(Execution.runMF(aptitudeWorkflow.getProjectName(), aptitudeWorkflow.getWorkflowName(), sessionId, use_case_id));	
		}
		
		String tableName = "";

		try {
			for(TablenameConstants table : resultsTables) {
			// Compare results
				tableName = table.getTableName();
				final Path PATH_TO_EXPCTD_RESULTS = PATH_TO_RESOURCES.resolve(table.getTableName().toUpperCase() + "_expected.sql");
				final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve(table.getTableName().toUpperCase() + "_actual.sql");
	
				assert (Files.exists(PATH_TO_EXPCTD_RESULTS) && Files.isRegularFile(PATH_TO_EXPCTD_RESULTS));
				assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));
				
				Assert.assertEquals(0, DATA_COMP_OPS.countMinusQueryResults(PATH_TO_EXPCTD_RESULTS, PATH_TO_ACTUAL_RESULTS, new String[0], TOKEN_OPS));
			}
		} catch (AssertionError e_no_results) {
			// Back-up actuals and expected results for investigation
			for(TablenameConstants tables : resultsTables) {
				CommonTestOperations.backupActualsVersusExpected(tables, TestPrefix);
			}
			LOG.error("Failed on: " + tableName);

			throw e_no_results;
		}
	}
	
	private void cleardown() throws Exception {
		LOG.info("Clearing down tables.");
		// Clear the staging and target tables
		for (TablenameConstants tables : sourceDataTables) {
			LOG.info("Clearing: " + tables.getTableName());
			CommonTestOperations.deleteData(tables);
		}


		for (TablenameConstants tables : intermediateDataTables) {
			LOG.info("Clearing: " + tables.getTableName());
			CommonTestOperations.deleteData(tables);
		}
		for (TablenameConstants tables : resultsTables) {
			LOG.info("Clearing: " + tables.getTableName());
			CommonTestOperations.deleteData(tables);

			// Drop any ER tables
			CommonTestOperations.dropERIfExists(tables);
		}
	}

	
	private void synonyms() throws Exception {
		for(TablenameConstants tables : sourceDataTables) {
			CommonTestOperations.replaceTableSynonym( tables );		
		}	
		
		for(TablenameConstants tables : intermediateDataTables) {
			CommonTestOperations.replaceTableSynonym( tables );		
		}
		
		for(TablenameConstants tables : resultsTables) {
			CommonTestOperations.replaceTableSynonym( tables );		
		}	
	}
}
