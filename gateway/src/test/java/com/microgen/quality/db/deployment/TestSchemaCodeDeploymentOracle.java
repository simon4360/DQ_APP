package com.microgen.quality.db.deployment;

import com.microgen.quality.db.DBObjectConstants;
import com.microgen.quality.db.deployment.TestCodeDeploymentOracle;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.SQLException;

import org.junit.Assert;
import org.junit.Test;

public class TestSchemaCodeDeploymentOracle
{
    @Test
    public void testTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }
    
    @Test
    public void testA38TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.A38_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testADYTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.ADY_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testCRRTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.CRR_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testDMPTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.DMP_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testDMPViewDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.DMP_VIEW_FOLDER_NAME
            ,   DBObjectConstants.VIEW_FLAG
            ,   DBObjectConstants.VIEW_DB_NAME_REGEX
            ,   DBObjectConstants.VIEW_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testDMPFunctionDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.DMP_FUNCTION_FOLDER_NAME
            ,   DBObjectConstants.FUNCTION_FLAG
            ,   DBObjectConstants.FUNCTION_DB_NAME_REGEX
            ,   DBObjectConstants.FUNCTION_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testERSTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.ERS_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testFA0TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.FA0_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG24TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G24_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG32TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G32_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG51TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G51_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG61TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G61_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG71TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G71_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG72TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G72_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG73TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G73_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG74TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G74_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG76TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G76_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG77TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G77_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG77_CORDLTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G77_CORDL_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG77_METATableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G77_META_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG77_REFTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G77_REF_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG79TableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G79_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG7CTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G7C_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testG7MTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.G7M_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testMDMTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.MDM_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testPHOTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.PHO_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testPILTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.PIL_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testQ0TTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.Q0T_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testRVLTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.RVL_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testVMSTableDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.VMS_TABLE_FOLDER_NAME
            ,   DBObjectConstants.TABLE_FLAG
            ,   DBObjectConstants.TABLE_DB_NAME_REGEX
            ,   DBObjectConstants.TABLE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testViewDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.VIEW_FOLDER_NAME
            ,   DBObjectConstants.VIEW_FLAG
            ,   DBObjectConstants.VIEW_DB_NAME_REGEX
            ,   DBObjectConstants.VIEW_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testProcedureDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.PROCEDURE_FOLDER_NAME
            ,   DBObjectConstants.PROCEDURE_FLAG
            ,   DBObjectConstants.PROCEDURE_DB_NAME_REGEX_ORA
            ,   DBObjectConstants.PROCEDURE_NAME_REGEX_ORA
            ,   true
            )
        );
    }

    @Test
    public void testPackageDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.PACKAGE_FOLDER_NAME
            ,   DBObjectConstants.PACKAGE_FLAG
            ,   DBObjectConstants.PACKAGE_DB_NAME_REGEX
            ,   DBObjectConstants.PACKAGE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testPackageBodyDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.PACKAGE_BODY_FOLDER_NAME
            ,   DBObjectConstants.PACKAGE_BODY_FLAG
            ,   DBObjectConstants.PACKAGE_BODY_DB_NAME_REGEX
            ,   DBObjectConstants.PACKAGE_BODY_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testSequenceDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.SEQUENCE_FOLDER_NAME
            ,   DBObjectConstants.SEQUENCE_FLAG
            ,   DBObjectConstants.SEQUENCE_DB_NAME_REGEX
            ,   DBObjectConstants.SEQUENCE_NAME_REGEX
            ,   true
            )
        );
    }

    @Test
    public void testTriggerDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.TRIGGER_FOLDER_NAME
            ,   DBObjectConstants.TRIGGER_FLAG
            ,   DBObjectConstants.TRIGGER_DB_NAME_REGEX
            ,   DBObjectConstants.TRIGGER_NAME_REGEX
            ,   true
            )
        );
    }
    
    @Test
    public void testFunctionDeployment () throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        Assert.assertTrue
        (
            TestCodeDeploymentOracle.testCodeDeployment
            (
                DBObjectConstants.DB_CODE_ROOT
            ,   DBObjectConstants.FUNCTION_FOLDER_NAME
            ,   DBObjectConstants.FUNCTION_FLAG
            ,   DBObjectConstants.FUNCTION_DB_NAME_REGEX
            ,   DBObjectConstants.FUNCTION_NAME_REGEX
            ,   true
            )
        );
    }
}