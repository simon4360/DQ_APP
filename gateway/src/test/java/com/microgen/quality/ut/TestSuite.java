package com.microgen.quality.ut;

import org.testng.annotations.AfterSuite;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.BeforeTest;
//import com.microgen.quality.ut.TestDbOperations;
import com.microgen.quality.ut.Resources;
import java.nio.file.Path;
import com.microgen.quality.ut.TablenameConstants;
import com.microgen.quality.ut.CommonTestOperations;
import com.microgen.quality.ut.TokenReplacement;
import org.apache.log4j.Logger;


//show the use of @BeforeSuite and @BeforeTest
public class TestSuite {
    private static final Logger LOG = Logger.getLogger ( TestSuite.class );

    @BeforeSuite(groups = {"cleardown"})
    public void testBeforeSuite() throws Exception {

        LOG.debug ( "testBeforeSuite()" );

        LOG.debug (System.getProperty("os.name"));
        
        if (System.getProperty("os.name").startsWith("Windows")) { 
                 System.setProperty("java.io.tmpdir", System.getenv("HOMEDRIVE")+System.getenv("HOMEPATH") + "\\" +".utTmpDir" );
        } else {
                 System.setProperty("java.io.tmpdir", System.getenv("HOME") + "/.utTmpDir" );
        }
        
        final Path PATH_TO_REF_DATA_FILE = Resources.getPathToResource("testing/reference_data/reference_data_input.xlsx");
        final TokenReplacement TOKEN_OPS = new TokenReplacement();

        CommonTestOperations.deleteData     ( TablenameConstants.REF_COMBINED_ACCORDION );
        CommonTestOperations.loadExcelTabToDatabaseTable ( TablenameConstants.REF_COMBINED_ACCORDION, PATH_TO_REF_DATA_FILE , TOKEN_OPS);

        // try {             
       //      TestDbOperations.initializeAE();
       //      }
       // catch ( Exception e ) 
       //     { 
       //     LOG.fatal ( "initializeAE failed" + e ) ;
       //     }
    }
 
    @AfterSuite
    public void testAfterSuite() {
        LOG.debug ( "testAfterSuite()" );
    }
 
    @BeforeTest
    public void testBeforeTest() {
        LOG.debug ( "testBeforeTest()" );
    }
 
    @AfterTest
    public void testAfterTest() {
        LOG.debug ( "testAfterTest()" );
    }

}
