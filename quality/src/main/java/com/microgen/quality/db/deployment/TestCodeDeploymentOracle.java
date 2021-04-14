package com.microgen.quality.db.deployment;

import com.microgen.quality.db.DBObjectUtils;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.Scanner;
import java.sql.Connection;
import java.sql.DriverManager;
import java.lang.ClassNotFoundException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.List;
import java.util.regex.Pattern;

public class TestCodeDeploymentOracle
{
    private static class ObjectDetails
    {
        private String dbName;
        private String objectName;

        public ObjectDetails ( final String pDbName , final String pObjectName )
        {
            dbName     = pDbName.toLowerCase();
            objectName = pObjectName.toLowerCase();
        }

        public String getDbName()
        {
            return dbName;
        }

        public String getObjectName()
        {
            return objectName;
        }

        @Override
        public boolean equals ( final Object pObjectDetails )
        {
            boolean isEqual = false;

            if ( pObjectDetails instanceof TestCodeDeploymentOracle.ObjectDetails )
            {
                final TestCodeDeploymentOracle.ObjectDetails temp = ( TestCodeDeploymentOracle.ObjectDetails ) pObjectDetails;

                if ( getDbName().equals ( temp.getDbName() ) && getObjectName().equals ( temp.getObjectName() ) )
                {
                    isEqual = true;
                }
            }

            return isEqual;
        }

        @Override
        public int hashCode()
        {
            return new HashCodeBuilder ( 21 , 13 ).append ( getDbName() ).append ( getObjectName() ).toHashCode();
        }
    }

    private static List<TestCodeDeploymentOracle.ObjectDetails> getObjectDetails ( final File pObjectFile , final Pattern pDbNameRegex , final Pattern pObjectNameRegex , final boolean pSingleObjectPerFile ) throws FileNotFoundException
    {
        final Scanner                                objectFileScanner  = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
        final List<TestCodeDeploymentOracle.ObjectDetails> objectNames        = new ArrayList<TestCodeDeploymentOracle.ObjectDetails>();

        while ( objectFileScanner.hasNextLine() )
        {
            String tempDbName     = objectFileScanner.findInLine ( pDbNameRegex );
            String tempObjectName = objectFileScanner.findInLine ( pObjectNameRegex );

            if ( tempDbName != null && tempObjectName != null )
            {
                objectNames.add ( new TestCodeDeploymentOracle.ObjectDetails ( tempDbName.toLowerCase() , tempObjectName.toLowerCase() ) );

                if ( pSingleObjectPerFile )
                {
                    break;
                }
            }

            objectFileScanner.nextLine();
        }

        return objectNames;
    }
    
    public static Set <TestCodeDeploymentOracle.ObjectDetails> getUserObjects ( Set <TestCodeDeploymentOracle.ObjectDetails> pRemainingSqlObjects, final String pCodeType, final String pJdbcUrl, final String pOracleHost, final String pAeLogonName, final String pAeLogonPassword ) throws SQLException , ClassNotFoundException
    {
        
        Connection        conn  = null;
        Connection        connection  = null;
        PreparedStatement pStmt = null;
        ResultSet         rs    = null;

        try
        {
            Class.forName ( "oracle.jdbc.driver.OracleDriver" );

            conn = DriverManager.getConnection ( pJdbcUrl , pAeLogonName , pAeLogonPassword );

            conn.setAutoCommit ( false );
            
            pStmt = conn.prepareStatement
                    (
                          " select "
                        +        " lower ( trim ( owner ) ) databasename "
                        +      " , lower ( trim ( object_name ) )    tablename "
                        + "   from "
                        +        " all_objects "
                        + "  where "
                        +        " status = 'VALID' and "       
                        +        " object_type = ? and "
                        +        " lower ( trim ( owner ) ) = ? "

                    );

            pStmt.setString ( 1 , pCodeType );
            pStmt.setString ( 2 , pAeLogonName );

            rs = pStmt.executeQuery();
            
            while ( rs.next () )
            {
                //System.out.println ( "Found following object in database " + rs.getString ( "databasename" ) + "." + rs.getString ( "tablename" )  );
                pRemainingSqlObjects.remove ( new TestCodeDeploymentOracle.ObjectDetails ( rs.getString ( "databasename" ) , rs.getString ( "tablename" ) ) );
            }
        }
        catch ( SQLException sqle )
        {
            sqle.printStackTrace();
            throw sqle;
        }
        finally
        {
            rs.close    ();

            pStmt.close ();

            conn.close  ();
        }
        
        return pRemainingSqlObjects;
    }

    public static boolean testCodeDeployment ( final File pCodeRoot , final String pHostDirectoryName , final String pCodeType , final Pattern pDbNameRegex , final Pattern pObjectNameRegex , final boolean pSingleObjectPerFile ) throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        boolean isPass = true;

        /* get details of objects from source code */

        Set  <TestCodeDeploymentOracle.ObjectDetails> allObjects  = new HashSet <TestCodeDeploymentOracle.ObjectDetails>();
        List <File>                             allSQLFiles = DBObjectUtils.populateListOfAllSQLFiles ( pCodeRoot );

        for ( File file : allSQLFiles )
        {
            if ( file.getName().indexOf("install.sql") < 0 && file.getName().indexOf("cleardown") < 0 && file.getName().indexOf("refresh_objects.sql") < 0 && file.getName().indexOf("register_install") < 0 && DBObjectUtils.getObjectTypeFolder ( file ).getName().equals ( pHostDirectoryName ) )
            {
                allObjects.addAll ( TestCodeDeploymentOracle.getObjectDetails ( file , pDbNameRegex , pObjectNameRegex , pSingleObjectPerFile ) );
            }
        }

        /* get details of deployed objects in valid status from data dictionary */
        System.out.println ( "" );
        System.out.println ( "'testCodeDeployment' conducted using: pCodeType = '" + pCodeType + "'" );
        System.out.println ( "******************************************************************" );
        
        String jdbcUrl         = System.getProperty ( "test.oracleJdbcUrl" );
        String oracleHost      = System.getProperty ( "test.oracleHost" );
  
        TestCodeDeploymentOracle.getUserObjects ( allObjects, pCodeType, jdbcUrl, oracleHost, System.getProperty ( "test.g77_cfgUsername" ), System.getProperty ( "test.g77_cfgPassword" ) );
        TestCodeDeploymentOracle.getUserObjects ( allObjects, pCodeType, jdbcUrl, oracleHost, System.getProperty ( "test.g77_cfg_arcUsername" ), System.getProperty ( "test.g77_cfg_arcPassword" ) );

        for ( TestCodeDeploymentOracle.ObjectDetails temp : allObjects )
        {
            System.out.println ( "Object " + temp.getDbName() + "." + temp.getObjectName() + "' is defined in source code but does not exist on the database or the status of object is invalid." );
            isPass = false;
        }

        return isPass;
    }
}
