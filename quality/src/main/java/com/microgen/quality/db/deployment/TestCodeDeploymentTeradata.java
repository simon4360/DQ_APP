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

public class TestCodeDeploymentTeradata
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

            if ( pObjectDetails instanceof TestCodeDeploymentTeradata.ObjectDetails )
            {
                final TestCodeDeploymentTeradata.ObjectDetails temp = ( TestCodeDeploymentTeradata.ObjectDetails ) pObjectDetails;

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

    private static List<TestCodeDeploymentTeradata.ObjectDetails> getObjectDetails ( final File pObjectFile , final Pattern pDbNameRegex , final Pattern pObjectNameRegex , final boolean pSingleObjectPerFile ) throws FileNotFoundException
    {
        final Scanner                                objectFileScanner  = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
        final List<TestCodeDeploymentTeradata.ObjectDetails> objectNames        = new ArrayList<TestCodeDeploymentTeradata.ObjectDetails>();

        while ( objectFileScanner.hasNextLine() )
        {
            String tempDbName     = objectFileScanner.findInLine ( pDbNameRegex );
            String tempObjectName = objectFileScanner.findInLine ( pObjectNameRegex );

            if ( tempDbName != null && tempObjectName != null )
            {
                objectNames.add ( new TestCodeDeploymentTeradata.ObjectDetails ( tempDbName.toLowerCase() , tempObjectName.toLowerCase() ) );

                if ( pSingleObjectPerFile )
                {
                    break;
                }
            }

            objectFileScanner.nextLine();
        }

        return objectNames;
    }

    public static boolean TestCodeDeploymentTeradata ( final File pCodeRoot , final String pHostDirectoryName , final String pCodeType , final Pattern pDbNameRegex , final Pattern pObjectNameRegex , final boolean pSingleObjectPerFile ) throws FileNotFoundException , SQLException , ClassNotFoundException
    {
        boolean isPass = true;

        /* get details of objects from source code */

        Set  <TestCodeDeploymentTeradata.ObjectDetails> allObjects  = new HashSet <TestCodeDeploymentTeradata.ObjectDetails>();
        List <File>                             allSQLFiles = DBObjectUtils.populateListOfAllSQLFiles ( pCodeRoot );

        for ( File file : allSQLFiles )
        {
            if ( DBObjectUtils.getObjectTypeFolder ( file ).getName().equals ( pHostDirectoryName ) )
            {
                allObjects.addAll ( TestCodeDeploymentTeradata.getObjectDetails ( file , pDbNameRegex , pObjectNameRegex , pSingleObjectPerFile ) );
            }
        }

        /* get details of objects from data dictionary */

        final String teradataHost    = System.getProperty ( "test.teradataHost" );
        final String aeLogonName     = System.getProperty ( "test.mahadminUsername" );
        final String aeLogonPassword = System.getProperty ( "test.mahadminPassword" );
        final String csaLogonName    = System.getProperty ( "test.csaAdminUsername" );
        final String jdbcUrl         = "jdbc:teradata://" + teradataHost + "/DATABASE=" + aeLogonName;

        Connection        conn  = null;
        PreparedStatement pStmt = null;
        ResultSet         rs    = null;

        try
        {
            Class.forName ( "com.teradata.jdbc.TeraDriver" );

            conn = DriverManager.getConnection ( jdbcUrl , aeLogonName , aeLogonPassword );

            conn.setAutoCommit ( false );

            pStmt = conn.prepareStatement
                    (
                          " select "
                        +        " lower ( trim ( databasename ) ) databasename "
                        +      " , lower ( trim ( tablename ) )    tablename "
                        + "   from "
                        +        " dbc.tables "
                        + "  where "
                        +        " case "
                        +            " when tablekind in ( 'T' , 'O' ) "
                        +            " then 'T' "
                        +            " else tablekind "
                        +        " end "
                        +        "  = ? "
                        +    " and lower ( databasename ) = any ( "
                        +                                       " select "
                        +                                              " databasename "
                        +                                         " from "
                        +                                              " dbc.databases "
                        +                                        " where "
                        +                                              " lower ( ownername ) =  lower ( ? ) "
                        +                                        " union "
                        +                                       " select "
                        +                                              " databasename "
                        +                                         " from "
                        +                                              " dbc.databases "
                        +                                        " where "
                        +                                              " lower ( databasename ) = lower ( ? ) "
                        +                                        " union "
                        +                                       " select "
                        +                                              " databasename "
                        +                                         " from "
                        +                                              " dbc.databases "
                        +                                        " where "
                        +                                              " lower ( ownername ) =  lower ( ? ) "
                        +                                     " ) "
                    );

            pStmt.setString ( 1 , pCodeType );
            pStmt.setString ( 2 , aeLogonName );
            pStmt.setString ( 3 , aeLogonName );
            pStmt.setString ( 4 , csaLogonName );

            rs = pStmt.executeQuery();

            while ( rs.next () )
            {
                allObjects.remove ( new TestCodeDeploymentTeradata.ObjectDetails ( rs.getString ( "databasename" ) , rs.getString ( "tablename" ) ) );
            }
        }
        catch ( SQLException sqle )
        {
            throw sqle;
        }
        finally
        {
            rs.close    ();

            pStmt.close ();

            conn.close  ();
        }

        System.out.println ( "'TestCodeDeploymentTeradata' conducted using: pCodeType = '" + pCodeType + "' and aeLogonName = '" + aeLogonName + "'" );

        for ( TestCodeDeploymentTeradata.ObjectDetails temp : allObjects )
        {
            System.out.println ( "Object " + temp.getDbName() + "." + temp.getObjectName() + "' is defined in source code but does not exist on the database." );
            isPass = false;
        }

        return isPass;
    }
}