package com.microgen.quality.ut.testing.database_tests.schema_compare;

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
import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;
import org.apache.log4j.Logger;

public class testCompareFullBuildToUpgrade {
	private static final Logger LOG = Logger.getLogger(testCompareFullBuildToUpgrade.class);

	/*
	 * Define paths to various folders and files Define various operator objects
	 * that will be reused by these tests
	 * 
	 */
  private IDatabaseConnector       CFG_CONN_OPS = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG () ;
	 
	private final IDatabaseTableOperator DB_TABLE_OPS_G77_CFG = DatabaseTableOperatorFactory.getDatabaseTableOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	private final IExcelOperator XL_OPS_G77_CFG = ExcelOperatorFactory.getExcelOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	private final IDataComparisonOperator DATA_COMP_OPS = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
	private final TokenReplacement TOKEN_OPS = new TokenReplacement();
	private final Path PATH_TO_RESOURCES = Resources.getPathToResource("testing/schema_compare");
    

	@BeforeClass
	private void cleardownBeforeEachTest() throws Exception {
	}

	@AfterClass
	private void cleardownAfterEachTest() throws Exception {
	}

 private void copyCatalogView (  final String pInstallType, final String pCopySQL) throws Exception
    {

        Connection        connCFG = null;

        PreparedStatement pStmtCFG = null;
           
        LOG.debug ( "Copying catalog view from G77_CFG Schema to G77_CFG .<catalog_view>_compare with install_type " + pInstallType + " using sql " + TOKEN_OPS.replaceTokensInString ( pCopySQL ) );

        try
        {
            connCFG = CFG_CONN_OPS.getConnection ();
            LOG.debug ( "A connection to the database was successfully retrieved" );
            pStmtCFG = connCFG.prepareStatement ( TOKEN_OPS.replaceTokensInString ( pCopySQL ) );
            LOG.debug ( "The insert statement was successfully prepared" );
            pStmtCFG.execute ();
            LOG.debug ( "The insert statement was successfully executed" );
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

    private void copyCatalogViews (  final String pInstallType ) throws Exception
    {
    	
        String COPY_SQL 
             = "insert into g77_cfg.user_objects_compare "
             + "select '" +pInstallType+ "' as install_type, '@versionTo@' as release, user as owner, object_type, object_name, status, temporary, generated, secondary "
             + "from user_objects where object_name not like 'SYS%' and object_type not in ('JAVA RESOURCE', 'LOB', 'JAVA CLASS', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'TABLE PARTITION', 'TABLE SUBPARTITION' ) "
             ;
             
        copyCatalogView ( pInstallType, COPY_SQL );
        
        COPY_SQL 
             = "insert into g77_cfg.user_source_compare "
             + "select '" +pInstallType+ "' as install_type, '@versionTo@' as release, user as owner, name, type, line, text "
             + "from user_source "
             ;

        copyCatalogView ( pInstallType, COPY_SQL );
        
        COPY_SQL 
             = "insert into g77_cfg.user_tab_columns_compare "
             + "select '" +pInstallType+ "' as install_type, '@versionTo@' as release, user as owner, table_name, column_name, data_type, data_length, data_precision, data_scale, nullable, identity_column "
             + "from user_tab_columns "
             ;

        copyCatalogView ( pInstallType, COPY_SQL );
        
        
        COPY_SQL 
             = "insert into g77_cfg.user_ind_columns_compare "
             + "select '" +pInstallType+ "' as install_type, '@versionTo@' as release, user as owner, index_name, table_name, column_name, column_position, column_length, char_length, descend "
             + "from user_ind_columns "
             ;

        copyCatalogView ( pInstallType, COPY_SQL );
        
        COPY_SQL 
             = "insert into g77_cfg.user_tab_privs_compare "
             + "select '" +pInstallType+ "' as install_type, '@versionTo@' as release, grantee, owner, table_name, grantor, privilege, grantable, hierarchy, common, type "
             + "from user_tab_privs "
             ;

        copyCatalogView ( pInstallType, COPY_SQL );

        COPY_SQL 
             = "insert into g77_cfg.user_role_privs_compare "
             + "select '" +pInstallType+ "' as install_type, '@versionTo@' as release, username, granted_role, admin_option, delegate_option, default_role, os_granted, common "
             + "from user_role_privs "
             ;

        copyCatalogView ( pInstallType, COPY_SQL );
        
        COPY_SQL 
             = "insert into g77_cfg.user_role_tab_privs_compare "
             + "select '" +pInstallType+ "' as install_type, '@versionTo@' as release, role, owner, table_name, column_name, privilege, grantable, common "
             + "from role_tab_privs "
             ;

        copyCatalogView ( pInstallType, COPY_SQL );
        
    }

@Test  (groups = { "load_comparison_data" })
    public void TestSchemaCompareLoadComparisonData () throws Exception
    {
        final Path   PATH_TO_TEST_DATA_FILE  = PATH_TO_RESOURCES.resolve ( "schema_compare.xlsx" );

        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_TEST_DATA_FILE )      && Files.isRegularFile ( PATH_TO_TEST_DATA_FILE ) );

        final String            tableOwner   = "g77_cfg";
        final String            tableName    = "user_objects_compare";
              String            install_type = "full or upgrade";
        
        if ( DB_TABLE_OPS_G77_CFG.checkIfExists ( tableOwner, tableName ) )
        {
        	// schema comparison tables exist, populate them with catalog details of fully installed system
        	install_type = "upgrade";
        	 
        	 copyCatalogViews ( install_type );
        	 
        } else 
        { 
        	// schema comparison tables do not exist, create them, grant insert to schema users and insert with user_* catalog details
          install_type = "full";
           
          CommonTestOperations.createDatabaseTableFromExcelTab (   TablenameConstants.USER_OBJECTS_COMPARE , PATH_TO_TEST_DATA_FILE ) ;
          CommonTestOperations.createDatabaseTableFromExcelTab (   TablenameConstants.USER_SOURCE_COMPARE , PATH_TO_TEST_DATA_FILE ) ;
          CommonTestOperations.createDatabaseTableFromExcelTab (   TablenameConstants.USER_TAB_COLUMNS_COMPARE , PATH_TO_TEST_DATA_FILE ) ;
          CommonTestOperations.createDatabaseTableFromExcelTab (   TablenameConstants.USER_IND_COLUMNS_COMPARE , PATH_TO_TEST_DATA_FILE ) ;
          CommonTestOperations.createDatabaseTableFromExcelTab (   TablenameConstants.USER_TAB_PRIVS_COMPARE , PATH_TO_TEST_DATA_FILE ) ;
          CommonTestOperations.createDatabaseTableFromExcelTab (   TablenameConstants.USER_ROLE_PRIVS_COMPARE , PATH_TO_TEST_DATA_FILE ) ;
          CommonTestOperations.createDatabaseTableFromExcelTab (   TablenameConstants.USER_ROLE_TAB_PRIVS_COMPARE , PATH_TO_TEST_DATA_FILE ) ;
                
          copyCatalogViews ( install_type );
        } 
    }
    
    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareUserObjects () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_objects_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_objects_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
        
    }
    
    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareUserSource () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_source_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_source_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
        
    }
    
    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareUserTabColumns () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_tab_columns_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_tab_columns_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
        
    }
    
    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareUserViewColumns () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_view_columns_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_view_columns_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
        
    }    
    
    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareUserIndColumns () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_ind_columns_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_ind_columns_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
        
    }
    
    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareUserTabPrivs () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_tab_privs_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_tab_privs_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
    }

    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareRoleTabPrivs () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_role_tab_privs_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_role_tab_privs_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
    }
    
    @Test  (dependsOnGroups = { "load_comparison_data" })
    public void TestSchemaCompareUserRolePrivs () throws Exception
    {
    	
        final Path   PATH_TO_FULLINSTALL_RESULTS    = PATH_TO_RESOURCES.resolve ( "user_role_privs_compare_full.sql" );
        final Path   PATH_TO_UPGRADE_RESULTS        = PATH_TO_RESOURCES.resolve ( "user_role_privs_compare_upgrade.sql" );
        
        assert ( Files.exists ( PATH_TO_RESOURCES )           && Files.isDirectory   ( PATH_TO_RESOURCES ) );
        assert ( Files.exists ( PATH_TO_FULLINSTALL_RESULTS ) && Files.isRegularFile ( PATH_TO_FULLINSTALL_RESULTS ) );
        assert ( Files.exists ( PATH_TO_UPGRADE_RESULTS )     && Files.isRegularFile ( PATH_TO_UPGRADE_RESULTS ) );       
        
        Assert.assertEquals
        (
            0
        ,   DATA_COMP_OPS.countMinusQueryResults
            (
                PATH_TO_FULLINSTALL_RESULTS
            ,   PATH_TO_UPGRADE_RESULTS
            ,   new String[0]
            ,   TOKEN_OPS
            )
        ); 
    }
}
