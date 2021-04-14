package com.microgen.quality.tlf.database;

import com.microgen.quality.tlf.database.IDatabaseTableOperator;
import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.string.ITokenReplacement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLWarning;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

public class OracleDatabaseTableOperator implements IDatabaseTableOperator
{
    private static final Logger LOG = Logger.getLogger ( OracleDatabaseTableOperator.class );

    private IDatabaseConnector databaseConnector;

    public OracleDatabaseTableOperator ( final IDatabaseConnector pDatabaseConnector )
    {
        databaseConnector = pDatabaseConnector;
    }

    public boolean checkIfExists ( final String pObjectOwner , final String pObjectName  ) throws Exception
    {
      final String            dbObjectType = "table";
     
      return checkIfExists ( pObjectOwner , pObjectName, dbObjectType );
    }
    
    public boolean checkIfExists ( final String pObjectOwner , final String pObjectName, final String pObjectType ) throws Exception
    {
        Connection        conn       = null;
        PreparedStatement pStmt      = null;
        ResultSet         rs         = null;
        boolean           doesExist  = false;
        
        String            objectType = "table";
        
        if ( pObjectType.length() > 0 ) { 
        	objectType = pObjectType; 
        }

        LOG.debug ( "The existence of the " + objectType + " " + pObjectOwner + "." + pObjectName + "' will be confirmed" );

        try
        {
            conn = databaseConnector.getConnection ();

            LOG.debug ( "A connection to the database was successfully retrieved" );

            pStmt = conn.prepareStatement ( " select count ( * ) cnt from all_objects where trim ( lower ( owner ) ) = trim ( lower ( ? ) ) and trim ( lower ( object_name ) ) = trim ( lower ( ? ) ) and trim ( lower ( object_type ) ) = trim ( lower ( ? ) )" );

            LOG.debug ( "The DML used to check whether the table exists has been successfully prepared" );

            pStmt.setString ( 1 , pObjectOwner );

            LOG.debug ( "The owner '" + pObjectOwner + "' has been bound" );

            pStmt.setString ( 2 , pObjectName );

            LOG.debug ( "The object name '" + pObjectName + "' has been bound" );
            
            pStmt.setString ( 3 , objectType );

            LOG.debug ( "The object type '" + objectType + "' has been bound" );

            rs = pStmt.executeQuery ();

            LOG.debug ( "The query has been successfully executed" );

            rs.next ();

            if ( rs.getDouble ( "cnt" ) == 1 )
            {
                LOG.debug ( "The table has been found to exist" );

                doesExist = true;
            }
        }
        catch ( SQLException sqle )
        {
            LOG.fatal ( "SQL Exception: " + sqle );

            throw sqle;
        }
        finally
        {
            rs.close    ();

            pStmt.close ();

            conn.close  ();
        }

        LOG.debug ( "The database " + objectType + " '" + pObjectOwner + "." + pObjectName + "' " + ( doesExist ? "exists" : "does not exist" ) );

        return doesExist;
    }

    public void copyTable ( final String pSourceTableOwner , final String pSourceTableName , final String pTargetTableOwner , final String pTargetTableName , final boolean pIncludeData ) throws Exception
    {
        Connection        conn    = null;
        PreparedStatement pStmt   = null;

        final String DDL = "create table " + pTargetTableOwner + "." + pTargetTableName + " as ( select a.* from ( select b.* from " + pSourceTableOwner + "." + pSourceTableName + " b ) a where " + ( pIncludeData ? "  1 = 1 " : " 1 = 0 " ) +   ")  ";

        LOG.debug ( "The database table '" + pSourceTableOwner + "." + pSourceTableName + "' will be copied to '" + pTargetTableOwner + "." + pTargetTableName + "' using the DDL '" + DDL + "'" );

        try
        {
            conn = databaseConnector.getConnection ();

            LOG.debug ( "A connection to the database was successfully retrieved" );

            pStmt = conn.prepareStatement ( DDL );

            LOG.debug ( "The DDL statement was successfully prepared" );

            pStmt.executeUpdate ();

            LOG.debug ( "The DDL statement was executed successfully" );

            conn.commit ();

            LOG.debug ( "The changes were committed to the database" );
        }
        catch ( SQLException sqle )
        {
            LOG.fatal ( "SQL Exception: " + sqle );

            throw sqle;
        }
        finally
        {
            pStmt.close ();

            conn.close  ();
        }

        LOG.debug ( "The database table '" + pSourceTableOwner + "." + pSourceTableName + "' has been successfully copied to '" + pTargetTableOwner + "." + pTargetTableName + "'" );
    }

    public void insertToTable ( final String pSourceTableOwner , final String pSourceTableName , final String pTargetTableOwner , final String pTargetTableName ) throws Exception
    {
        Connection        conn    = null;
        PreparedStatement pStmt   = null;

        final String DDL = "insert into " + pTargetTableOwner + "." + pTargetTableName + " select a.* from ( select b.* from " + pSourceTableOwner + "." + pSourceTableName + " b ) a ";

        LOG.debug ( "Contents of table '" + pSourceTableOwner + "." + pSourceTableName + "' will be copied to '" + pTargetTableOwner + "." + pTargetTableName + "' using the following DDL '" + DDL + "'" );

        try
        {
            conn = databaseConnector.getConnection ();

            LOG.debug ( "A connection to the database was successfully retrieved" );

            pStmt = conn.prepareStatement ( DDL );

            LOG.debug ( "The DDL statement was successfully prepared" );

            pStmt.executeUpdate ();

            LOG.debug ( "The DDL statement was executed successfully" );

            conn.commit ();

            LOG.debug ( "The changes were committed to the database" );
        }
        catch ( SQLException sqle )
        {
            throw sqle;
        }
        finally
        {
            pStmt.close ();
            conn.close  ();
        }
    }
    

    public void deleteData ( final String pTableOwner , final String pTableName ) throws Exception
    {
        Connection        conn    = null;
        PreparedStatement pStmt   = null;

        final String DML = "delete from " + pTableOwner + "." + pTableName;

        LOG.debug ( "Data will be deleted from '" + pTableOwner + "." + pTableName + "' using the following DML '" + DML + "'" );

        try
        {
            conn = databaseConnector.getConnection ();

            LOG.debug ( "A connection to the database was successfully retrieved" );

            pStmt = conn.prepareStatement ( DML );

            LOG.debug ( "The DML statement was successfully prepared" );

            pStmt.executeUpdate ();

            LOG.debug ( "The DML statement was executed successfully" );

            conn.commit ();

            LOG.debug ( "The changes were committed to the database" );
        }
        catch ( SQLException sqle )
        {
            LOG.fatal ( "SQL Exception: " + sqle );

            throw sqle;
        }
        finally
        {
            pStmt.close ();

            conn.close  ();
        }

        LOG.debug ( "Data has been successfully deleted from '" + pTableOwner + "." + pTableName + "'" );
    }

    public void deleteData ( final String pTableOwner , final String pTableName , final String pCondition , final String[] pBindArray , final ITokenReplacement pITokenReplacement ) throws Exception
    {
              Connection        conn    = null;
              PreparedStatement pStmt   = null;
        final String            DML     = pITokenReplacement.replaceTokensInString ( "delete from " + pTableOwner + "." + pTableName + " where " + pCondition );

        LOG.debug ( "Data will be deleted from '" + pTableOwner + "." + pTableName + "' using the following DML '" + DML + "'" );

        try
        {
            conn = databaseConnector.getConnection ();

            LOG.debug ( "A connection to the database was successfully retrieved" );

            pStmt = conn.prepareStatement ( DML );

            LOG.debug ( "The DML statement was successfully prepared" );

            for ( int i = 0 ; i < pBindArray.length ; i++ )
            {
                String val = pBindArray [ i ];

                int    pos = i + 1;

                LOG.debug ( "The value '" + val + "' is to be bound to the position '" + pos + "' in the DML statement" );

                pStmt.setString ( pos , val );

                LOG.debug ( "The value was bound successfully" );
            }
            
            LOG.debug ( "variables bound" );
            
            pStmt.executeUpdate ();

            LOG.debug ( "The DML statement was executed successfully" );

            conn.commit ();

            LOG.debug ( "The changes were committed to the database" );
        }
        catch ( SQLException sqle )
        {
            LOG.fatal ( "SQL Exception: " + sqle );

            throw sqle;
        }
        finally
        {
            pStmt.close ();

            conn.close  ();
        }

        LOG.debug ( "Data has been successfully deleted from '" + pTableOwner + "." + pTableName + "'" );
    }
    

   

    public void dropIfExists  ( final String pTableOwner , final String pTableName ) throws Exception
    {
              Connection        conn       = null;
              PreparedStatement pStmt      = null;
        final String            DROPDDL    = "drop table " + pTableOwner + "." + pTableName;

        LOG.debug ( "The database table '" + pTableOwner + "." + pTableName + "' will be dropped using the following DDL '" + DROPDDL + "'" );

        if ( checkIfExists ( pTableOwner , pTableName ) )
        {
            try
            {
                conn = databaseConnector.getConnection ();

                LOG.debug ( "A connection to the database was successfully retrieved" );

                pStmt = conn.prepareStatement ( DROPDDL );

                LOG.debug ( "The DDL to be used to drop the table has been successfully prepared" );

                pStmt.executeUpdate ();

                LOG.debug ( "The database table '" + pTableOwner + "." + pTableName + "' has been successfully dropped" );

                conn.commit ();
            }
            catch ( SQLException sqle )
            {
                LOG.fatal ( "SQL Exception: " + sqle );

                throw sqle;
            }
            finally
            {
                pStmt.close ();

                conn.close  ();
            }
        }
    }
    
        public void alterTrigger  ( final String pTriggerOwner , final String pTriggerName, final String pAction ) throws Exception
    {
              Connection        conn       = null;
              PreparedStatement pStmt      = null;
        final String            ALTERDDL    = "alter trigger " + pTriggerOwner + "." + pTriggerName + " " + pAction;
        final String            dbObjectType = "trigger";
        

        LOG.debug ( "A trigger will be " + pAction + "d using the following DDL '" + ALTERDDL + "'" );

        if ( checkIfExists ( pTriggerOwner , pTriggerName,  dbObjectType ) )
        {
            try
            {
                conn = databaseConnector.getConnection ();

                LOG.debug ( "A connection to the database was successfully retrieved" );

                pStmt = conn.prepareStatement ( ALTERDDL );

                LOG.debug ( "The DDL to be used to alter the trigger has been successfully prepared" );

                pStmt.executeUpdate ();

                LOG.debug ( "The trigger has been successfully " + pAction + "d");

                conn.commit ();
            }
            catch ( SQLException sqle )
            {
                throw sqle;
            }
            finally
            {
                pStmt.close ();
                conn.close  ();
            }
        }
    }
}