package com.microgen.quality.ut.testing.database_tests.tlf.excel;

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

import org.apache.commons.lang3.StringUtils;

import java.util.Calendar;

import org.testng.annotations.Test;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.AfterMethod;
import org.apache.log4j.Logger;

public class TestExcelLibraryFunctions
{
    private static final Logger LOG = Logger.getLogger(TestExcelLibraryFunctions.class);
    
	  private final IDatabaseTableOperator  DB_TABLE_OPS_G77_CFG = DatabaseTableOperatorFactory.getDatabaseTableOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	  private final IExcelOperator          XL_OPS_G77_CFG       = ExcelOperatorFactory.getExcelOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	  private final IDataComparisonOperator DATA_COMP_OPS        = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	  private final TokenReplacement        TOKEN_OPS            = new TokenReplacement(); 
    private final Path                    PATH_TO_REF_DATA     = Resources.getPathToResource("testing/reference_data");
    private final Path                    PATH_TO_RESOURCES    = Resources.getPathToResource("testing/testlibrary/TestExcelTableMethods");

    final TablenameConstants targetTable = TablenameConstants.T_TARGET_CONFIG;

	  private void clearDown() throws Exception {                 
	  	CommonTestOperations.dropERIfExists ( targetTable );
	  }

    @BeforeMethod
    private void cleardownBeforeEachTest () throws Exception {
        clearDown();
    }
    
    @AfterMethod
    private void cleardownAfterEachTest () throws Exception {
        clearDown();
    }

    @Test
    public void TestCreateTableFromExcelTab () throws Exception
    {                     
      final Path PATH_TO_TEST_DATA_FILE      = PATH_TO_RESOURCES.resolve("example.xlsx");
        
      assert (Files.exists(PATH_TO_RESOURCES)           && Files.isDirectory(PATH_TO_RESOURCES));
      assert (Files.exists(PATH_TO_TEST_DATA_FILE)      && Files.isRegularFile(PATH_TO_TEST_DATA_FILE));
      
    	CommonTestOperations.createERTableFromExcelTab   ( targetTable , PATH_TO_TEST_DATA_FILE );

    }  
    
    @Test
    public void TestLoadDataFromExcelTab () throws Exception
    {
      final Path PATH_TO_TEST_DATA_FILE      = PATH_TO_RESOURCES.resolve("example.xlsx");
        
      assert (Files.exists(PATH_TO_RESOURCES)           && Files.isDirectory(PATH_TO_RESOURCES));
      assert (Files.exists(PATH_TO_TEST_DATA_FILE)      && Files.isRegularFile(PATH_TO_TEST_DATA_FILE));
      
    	CommonTestOperations.createERTableFromExcelTab   ( targetTable , PATH_TO_TEST_DATA_FILE );
	  	CommonTestOperations.loadERDataToDatabase        ( targetTable , PATH_TO_TEST_DATA_FILE , TOKEN_OPS );

    }  
}
