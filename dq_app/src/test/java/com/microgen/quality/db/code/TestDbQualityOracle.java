package com.microgen.quality.db.code;

import com.microgen.quality.db.DBObjectConstants;
import com.microgen.quality.db.code.TestCodeQuality;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.junit.Assert;
import org.junit.Test;

public class TestDbQualityOracle
{
    private static final File CODE_ROOT    = new File ( System.getProperty ( "test.codeRoot" ) );
    private static final File INSTALL_FULL_FILE = new File ( CODE_ROOT , "full_install.sql" );
    private static final File INSTALL_UPG_FILE = new File ( CODE_ROOT , "upgrade_install.sql" );

    @Test
    public void testDataQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "data"
            ,   true
            ,   DBObjectConstants.DATA_DB_NAME_REGEX
            ,   DBObjectConstants.DATA_TABLE_REGEX
            ,   true
            ,   true
            )
        );
    }

    @Test
    public void testTableGrantsQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "grants/tables"
            ,   false
            ,   DBObjectConstants.TABLE_GRANT_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_GRANT_TABLE_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }

    @Test
    public void testProcedureGrantsQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "grants/procedures"
            ,   false
            ,   DBObjectConstants.PROCEDURE_GRANT_DB_NAME_REGEX
            ,   DBObjectConstants.PROCEDURE_GRANT_PROCEDURE_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }

    @Test
    public void testFunctionGrantsQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "grants/sql_udf"
            ,   false
            ,   DBObjectConstants.FUNCTION_GRANT_DB_NAME_REGEX
            ,   DBObjectConstants.FUNCTION_GRANT_PROCEDURE_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }

    @Test
    public void testViewGrantsQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "grants/views"
            ,   false
            ,   DBObjectConstants.VIEW_GRANT_DB_NAME_REGEX
            ,   DBObjectConstants.VIEW_GRANT_VIEW_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }

    @Test
    public void testIndicesQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "indices"
            ,   false
            ,   DBObjectConstants.INDEXED_TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.INDEXED_TABLE_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }

    @Test
    public void testMacroQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "macros"
            ,   false
            ,   DBObjectConstants.MACRO_DB_NAME_REGEX
            ,   DBObjectConstants.MACRO_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testProcedureQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "procedures"
            ,   false
            ,   DBObjectConstants.PROCEDURE_DB_NAME_REGEX
            ,   DBObjectConstants.PROCEDURE_NAME_REGEX
            ,   true
            ,   false
            ,   true  //fileEndsWithForwardSlash
            )
        );
    }

    @Test
    public void testFunctionQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "functions"
            ,   false
            ,   DBObjectConstants.FUNCTION_DB_NAME_REGEX
            ,   DBObjectConstants.FUNCTION_NAME_REGEX
            ,   true
            ,   false
            ,   true  //fileEndsWithForwardSlash
            )
        );
    }

    @Test
    public void testPackageQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "packages_spec"
            ,   false
            ,   DBObjectConstants.PACKAGE_DB_NAME_REGEX
            ,   DBObjectConstants.PACKAGE_NAME_REGEX
            ,   true
            ,   false
            ,   true  //fileEndsWithForwardSlash
            )
        );
    }
    
    @Test
    public void testPackageBodyQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "packages_body"
            ,   false
            ,   DBObjectConstants.PACKAGE_BODY_DB_NAME_REGEX
            ,   DBObjectConstants.PACKAGE_BODY_NAME_REGEX
            ,   true
            ,   false
            ,   true  //fileEndsWithForwardSlash
            )
        );
    }

    @Test
    public void testRIConstraintQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "ri_constraints"
            ,   false
            ,   DBObjectConstants.CONSTRAINED_TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.CONSTRAINED_TABLE_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }

    @Test
    public void testSqlUdfQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "sql_udf"
            ,   false
            ,   DBObjectConstants.SQLUDF_DB_NAME_REGEX
            ,   DBObjectConstants.SQLUDF_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testStatisticsQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "statistics"
            ,   false
            ,   DBObjectConstants.STATISTICS_DB_NAME_REGEX
            ,   DBObjectConstants.STATISTICS_TABLE_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }

    
    @Test
    public void testA38TableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_a38"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testAdyTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_ady"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }    
    
    @Test
    public void testCrrTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_crr"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testDmpTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "dmp/tables"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testDmpViewQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "dmp/views"
            ,   false
            ,   DBObjectConstants.VIEW_DB_NAME_REGEX
            ,   DBObjectConstants.VIEW_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testDmpFunctionQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "dmp/functions"
            ,   false
            ,   DBObjectConstants.FUNCTION_GRANT_DB_NAME_REGEX
            ,   DBObjectConstants.FUNCTION_GRANT_PROCEDURE_NAME_REGEX
            ,   true
            ,   true
            )
        );
    }
    
    @Test
    public void testErsTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_ers"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testFa0TableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_fa0"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testG7cInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g7c"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    @Test
    public void testG7mInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g7m"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    @Test
    public void testG24InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g24"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    @Test
    public void testG32InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g32"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    
    @Test
    public void testG61InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g61"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    @Test
    public void testG71InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g71"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    @Test
    public void testG72InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g72"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    
    @Test
    public void testG73InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g73"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    
    @Test
    public void testG74InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g74"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testG76InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g76"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    
    
    @Test
    public void testG77InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g77"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testG77CorDlTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g77_cordl"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testG77MetaModelTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g77_meta"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testG77RefTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g77_ref"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

   @Test
   public void testArchiveTableQuality ()
   {
       Assert.assertTrue
       (
           TestCodeQuality.testFileSetQuality
           (
               CODE_ROOT
           ,   "tables_archive"
           ,   false
           ,   DBObjectConstants.TABLE_DB_NAME_REGEX
           ,   DBObjectConstants.TABLE_NAME_REGEX
           ,   true
           ,   false
           )
       );
   }
    
    @Test
    public void testG79InterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_g79"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    
    @Test
    public void testMdmInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_mdm"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }


    @Test
    public void testPhoInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_pho"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    
    @Test
    public void testPilInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_pil"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    
    @Test
    public void testQ0tInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_q0t"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    
    @Test
    public void testRvlInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_rvl"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    
    @Test
    public void testVmsInterfaceTableQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "tables_vms"
            ,   false
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }
    
    @Test
    public void testSequenceQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "sequences"
            ,   false
            ,   DBObjectConstants.SEQUENCE_DB_NAME_REGEX
            ,   DBObjectConstants.SEQUENCE_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testTriggerQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "triggers"
            ,   false
            ,   DBObjectConstants.TRIGGER_DB_NAME_REGEX
            ,   DBObjectConstants.TRIGGER_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testViewQuality ()
    {
        Assert.assertTrue
        (
            TestCodeQuality.testFileSetQuality
            (
                CODE_ROOT
            ,   "views"
            ,   false
            ,   DBObjectConstants.VIEW_DB_NAME_REGEX
            ,   DBObjectConstants.VIEW_NAME_REGEX
            ,   true
            ,   false
            )
        );
    }

    @Test
    public void testAllFilesAreUsedByInstallScript () throws FileNotFoundException
    {
        Assert.assertTrue ( TestCodeQuality.testAllFilesAreUsedByInstallScript ( INSTALL_FULL_FILE ) );
        Assert.assertTrue ( TestCodeQuality.testAllFilesAreUsedByInstallScript ( INSTALL_UPG_FILE ) );
    }

    @Test
    public void testAllFilesReferredToByInstallScriptsExist () throws FileNotFoundException
    {
        Assert.assertTrue ( TestCodeQuality.testAllFilesReferredToByInstallScriptsExist ( INSTALL_FULL_FILE ) );
        Assert.assertTrue ( TestCodeQuality.testAllFilesReferredToByInstallScriptsExist ( INSTALL_UPG_FILE ) );
    }

    @Test
    public void testQualityOfFiles ()
    {
        Assert.assertTrue ( TestCodeQuality.testQualityOfFiles ( CODE_ROOT ) );
    }

    @Test
    public void testForBadEOL () throws FileNotFoundException , IOException
    {
        Assert.assertTrue ( TestCodeQuality.testForBadEOL ( CODE_ROOT ) );
    }
}
