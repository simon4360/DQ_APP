package com.microgen.quality.ut.testing.database_tests.tlf.server;

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

public class TestServerLibraryFunctions
{
    private static final Logger LOG = Logger.getLogger(TestServerLibraryFunctions.class);
    
	  private final IDatabaseTableOperator  DB_TABLE_OPS_G77_CFG = DatabaseTableOperatorFactory.getDatabaseTableOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	  private final IExcelOperator          XL_OPS_G77_CFG       = ExcelOperatorFactory.getExcelOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	  private final IDataComparisonOperator DATA_COMP_OPS        = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	  private final TokenReplacement        TOKEN_OPS            = new TokenReplacement(); 

    @BeforeClass
    private void cleardownBeforeEachTest () throws Exception
    {
    }
    @AfterClass
    private void cleardownAfterClass () throws Exception
    {
    }

}