package com.microgen.quality.db.code;

import com.microgen.quality.db.DBObjectConstants;
import com.microgen.quality.db.code.TestCodeQuality;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.junit.Assert;
import org.junit.Test;

public class TestConfigurations
{
    private static final File CODE_ROOT = new File ( System.getProperty ( "test.codeRoot" ) );

    @Test
    public void testDataQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "data"
                             ,   true
                             ,   DBObjectConstants.DATA_DB_NAME_REGEX
                             ,   DBObjectConstants.DATA_TABLE_REGEX
                             ,   false // allow multiple schema definitions per file
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }
    
    @Test
    public void testUpgradeDataQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "upgrade"
                             ,   true
                             ,   DBObjectConstants.DATA_DB_NAME_REGEX
                             ,   DBObjectConstants.DATA_TABLE_REGEX
                             ,   false
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }
    
    @Test
    public void testTableGrantsQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "grants/tables"
                             ,   true
                             ,   DBObjectConstants.TABLE_GRANT_DB_NAME_REGEX
                             ,   DBObjectConstants.TABLE_GRANT_TABLE_NAME_REGEX
                             ,   true
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testProcedureGrantsQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "grants/procedures"
                             ,   true
                             ,   DBObjectConstants.PROCEDURE_GRANT_DB_NAME_REGEX
                             ,   DBObjectConstants.PROCEDURE_GRANT_PROCEDURE_NAME_REGEX
                             ,   true
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testFunctionGrantsQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "grants/sql_udf"
                             ,   true
                             ,   DBObjectConstants.FUNCTION_GRANT_DB_NAME_REGEX
                             ,   DBObjectConstants.FUNCTION_GRANT_PROCEDURE_NAME_REGEX
                             ,   true
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testViewGrantsQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "grants/views"
                             ,   true
                             ,   DBObjectConstants.VIEW_GRANT_DB_NAME_REGEX
                             ,   DBObjectConstants.VIEW_GRANT_VIEW_NAME_REGEX
                             ,   true
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testIndicesQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "indices"
                             ,   true
                             ,   DBObjectConstants.INDEXED_TABLE_DB_NAME_REGEX
                             ,   DBObjectConstants.INDEXED_TABLE_NAME_REGEX
                             ,   true
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testProcedureQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "procedures"
                             ,   false
                             ,   DBObjectConstants.PROCEDURE_DB_NAME_REGEX
                             ,   DBObjectConstants.PROCEDURE_NAME_REGEX
                             ,   true
                             ,   false
                             ,   true 
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }
    
    @Test
    public void testPackageQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "packages"
                             ,   false
                             ,   DBObjectConstants.PROCEDURE_DB_NAME_REGEX
                             ,   DBObjectConstants.PROCEDURE_NAME_REGEX
                             ,   true
                             ,   false
                             ,   true 
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testRIConstraintQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "ri_constraints"
                             ,   true
                             ,   DBObjectConstants.CONSTRAINED_TABLE_DB_NAME_REGEX
                             ,   DBObjectConstants.CONSTRAINED_TABLE_NAME_REGEX
                             ,   true
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testSqlUdfQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "sql_udf"
                             ,   true
                             ,   DBObjectConstants.SQLUDF_DB_NAME_REGEX
                             ,   DBObjectConstants.SQLUDF_NAME_REGEX
                             ,   true
                             ,   false
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testStatisticsQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "statistics"
                             ,   true
                             ,   DBObjectConstants.STATISTICS_DB_NAME_REGEX
                             ,   DBObjectConstants.STATISTICS_TABLE_NAME_REGEX
                             ,   true
                             ,   true
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testTableQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "tables"
                             ,   false
                             ,   DBObjectConstants.TABLE_DB_NAME_REGEX
                             ,   DBObjectConstants.TABLE_NAME_REGEX
                             ,   true
                             ,   false
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testTriggerQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "triggers"
                             ,   false
                             ,   DBObjectConstants.TRIGGER_DB_NAME_REGEX
                             ,   DBObjectConstants.TRIGGER_NAME_REGEX
                             ,   true
                             ,   false
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

    @Test
    public void testViewQuality ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = (
                             TestCodeQuality.testFileSetQuality
                             (
                                 testSetDbFolder
                             ,   "views"
                             ,   false
                             ,   DBObjectConstants.VIEW_DB_NAME_REGEX
                             ,   DBObjectConstants.VIEW_NAME_REGEX
                             ,   true
                             ,   false
                             )
                             && isPass
                         );
            }
        }

        assert ( isPass );
    }

     @Test
    public void testAllFilesAreUsedByInstallScript () throws FileNotFoundException
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetConfigInstallFile = new File ( testSetFolder , "install.sql" );
            File testSetConfigFullInstallFile = new File ( testSetFolder , "full_install.sql" );
            File testSetConfigUpgradeInstallFile = new File ( testSetFolder , "upgrade_install.sql" );

            if ( testSetConfigInstallFile.exists () )
            {
                isPass = TestCodeQuality.testAllFilesAreUsedByInstallScript ( testSetConfigInstallFile  ) && isPass;
            }
            
            if ( testSetConfigFullInstallFile.exists () )
            {
                isPass = TestCodeQuality.testAllFilesAreUsedByInstallScript ( testSetConfigFullInstallFile  ) && isPass;
            }
            
            if ( testSetConfigUpgradeInstallFile.exists () )
            {
                isPass = TestCodeQuality.testAllFilesAreUsedByInstallScript ( testSetConfigUpgradeInstallFile  ) && isPass;
            }

        }

        assert ( isPass );
    }

    @Test
    public void testAllFilesReferredToByInstallScriptsExist () throws FileNotFoundException
    {
        boolean isPass = true;
     
        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetConfigInstallFile = new File ( testSetFolder , "install.sql" );
            File testSetConfigFullInstallFile = new File ( testSetFolder , "full_install.sql" );
            File testSetConfigUpgradeInstallFile = new File ( testSetFolder , "upgrade_install.sql" );

   
            if ( testSetConfigInstallFile.exists () )
            {
               isPass = TestCodeQuality.testAllFilesReferredToByInstallScriptsExist ( testSetConfigInstallFile  ) && isPass;
            }
            
            if ( testSetConfigFullInstallFile.exists () )
            {
               isPass = TestCodeQuality.testAllFilesReferredToByInstallScriptsExist ( testSetConfigFullInstallFile  ) && isPass;
            }
            
            if ( testSetConfigUpgradeInstallFile.exists () )
            {
               isPass = TestCodeQuality.testAllFilesReferredToByInstallScriptsExist ( testSetConfigUpgradeInstallFile  ) && isPass;
            }
            
        }

        assert ( isPass );

    }

    @Test
    public void testQualityOfFiles ()
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            File testSetDbFolder = new File ( testSetFolder , "db" );

            if ( testSetDbFolder.exists () )
            {
                isPass = TestCodeQuality.testQualityOfFiles ( testSetDbFolder ) && isPass;
            }
        }

        assert ( isPass );
    }

    @Test
    public void testForBadEOL () throws FileNotFoundException , IOException
    {
        boolean isPass = true;

        for ( File testSetFolder : CODE_ROOT.listFiles () )
        {
            isPass = TestCodeQuality.testForBadEOL ( new File ( testSetFolder , "db" ) ) && isPass;
        }
    }
}
