package com.microgen.quality.ut.testing.database_tests.tlf.database;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.IDatabaseTableOperator;
import com.microgen.quality.tlf.database.IDataComparisonOperator;
import com.microgen.quality.tlf.server.IServerOperator;
import com.microgen.quality.tlf.excel.IExcelOperator;

import com.microgen.quality.ut.EnvironmentConstants;
import com.microgen.quality.ut.DatabaseConnectorFactory;
import com.microgen.quality.ut.DatabaseTableOperatorFactory;
import com.microgen.quality.ut.DataComparisonOperatorFactory;
import com.microgen.quality.ut.ExcelOperatorFactory;
import com.microgen.quality.ut.ServerOperatorFactory;

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

import org.testng.Assert;
import org.testng.annotations.Test;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.AfterClass;

public class TestDatabaseLibraryFunctions
{

    /* 
     * Define paths to various folders and files
     */
    private final Path PATH_TO_TEST_RESOURCES = Resources.getPathToResource ( "testing/testlibrary/" );

    /*
     * Define various operator objects that will be reused by these tests
     */

    
    private static final IDatabaseConnector  DB_CONN_OPS      = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG ();
    private final IDatabaseTableOperator     DB_TABLE_OPS     = DatabaseTableOperatorFactory.getDatabaseTableOperator ( DB_CONN_OPS );
    
    private final IDatabaseTableOperator     DB_TABLE_OPS_G77_CFG = DatabaseTableOperatorFactory.getDatabaseTableOperator ( DatabaseConnectorFactory.getDatabaseConnectorG77_CFG () );
    private final IDataComparisonOperator    DATA_COMP_OPS        = DataComparisonOperatorFactory.getDataComparisonOperator ( DatabaseConnectorFactory.getDatabaseConnectorG77_CFG () );

    
    private final TokenReplacement        TOKEN_OPS        = new TokenReplacement ();

    @BeforeMethod
    private void cleardownBeforeEachTest () throws Exception
    {
        //@BeforeMethod => run before any test method, @BeforeClass => run before any test Class
        DB_TABLE_OPS.dropIfExists (   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName () );
    }

    @AfterClass
    private void cleardownAfterClass () throws Exception
    {
        DB_TABLE_OPS.dropIfExists (   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName () );
    }
    
    @Test
    public void TestCheckTableExistsMethod () throws Exception
    {
        DB_TABLE_OPS.copyTable (   TablenameConstants.T_PROJECT_CONFIG.getTableOwner () ,   TablenameConstants.T_PROJECT_CONFIG.getTableName () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName (), true );
        DB_TABLE_OPS.checkIfExists (   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName () );
    }



    @Test
    public void TestCheckTableExistsMethodFailsCorrectly () throws Exception
    {
        Assert.assertFalse (DB_TABLE_OPS.checkIfExists (   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName () ) );
    }
   
   
    
    @Test
    public void TestInsertToTableMethod () throws Exception
    {
        DB_TABLE_OPS.copyTable (   TablenameConstants.T_PROJECT_CONFIG.getTableOwner () ,   TablenameConstants.T_PROJECT_CONFIG.getTableName () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName (), false );
        
        DB_TABLE_OPS.insertToTable (    TablenameConstants.T_PROJECT_CONFIG.getTableOwner () ,   TablenameConstants.T_PROJECT_CONFIG.getTableName () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName () );
    }
    
    
    
    @Test
    public void TestCheckDeleteWithConditionMethod () throws Exception
    {
        String deleteCondition = " aptitude_project = 'g77_src_g71' ";
        String[] testBindArray = new String [0]; 
        
        DB_TABLE_OPS.copyTable (   TablenameConstants.T_PROJECT_CONFIG.getTableOwner () ,   TablenameConstants.T_PROJECT_CONFIG.getTableName () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName (), true );
        
        DB_TABLE_OPS.deleteData (   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName (), deleteCondition, testBindArray, TOKEN_OPS );
    }
    
    
    
    @Test
    public void TestCopyTableMethod () throws Exception
    {
        DB_TABLE_OPS.copyTable (   TablenameConstants.T_PROJECT_CONFIG.getTableOwner () ,   TablenameConstants.T_PROJECT_CONFIG.getTableName () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName (), true );
    }
    
    @Test
    public void TestGenericUpdateStatement () throws Exception
    {

        final String ER_TLF_DATABASE_TEST  = "update g77_cfg.er_tlf_database_test set is_active = 'I' ";
        Connection        conn                   = null;
        PreparedStatement updateTestTable  = null;
      
        DB_TABLE_OPS.copyTable (   TablenameConstants.T_PROJECT_CONFIG.getTableOwner () ,   TablenameConstants.T_PROJECT_CONFIG.getTableName () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableOwner () ,   TablenameConstants.ER_TLF_DATABASE_TEST.getTableName (), true );
        
        try
        {
            conn = DB_CONN_OPS.getConnection ();

            updateTestTable  = conn.prepareStatement ( ER_TLF_DATABASE_TEST );

            updateTestTable.executeUpdate ();

            conn.commit ();

        }
        catch ( SQLException sqle )
        {
            throw sqle;
        }
        finally
        {
            if ( updateTestTable != null) { updateTestTable.close (); }

            conn.close ();
        } 
    }
}
