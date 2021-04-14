package com.microgen.quality.tlf.database;

import com.microgen.quality.tlf.database.IDatabaseConnector;

import java.sql.Connection;
import java.sql.DriverManager;

import org.apache.log4j.Logger;

public class OracleDatabaseConnector implements IDatabaseConnector
{
    private static final Logger LOG = Logger.getLogger ( OracleDatabaseConnector.class );

    private final String DRIVER_CLASS = "oracle.jdbc.driver.OracleDriver";

    private String jdbcUrl  = "";
    private String username = "";
    private String password = "";

    public OracleDatabaseConnector ( final String pJdbcURL , final String pUsername , final String pPassword , final String pDefaultDB , final boolean pFastLoad )
    {
        jdbcUrl  = pJdbcURL;

        LOG.debug ( "The Oracle jdbc URL was set to '" + jdbcUrl + "'" );

        username = pUsername;

        LOG.debug ( "The Oracle username was set to '" + username + "'" );

        password = pPassword;
    }

    public Connection getConnection () throws Exception
    {
        LOG.debug ( "A connection to the database will be retrieved based on the URL '" + jdbcUrl + "'" );

        Class.forName ( DRIVER_CLASS );

        LOG.debug ( "The driver class has been set to '" + DRIVER_CLASS + "'" );

        Connection conn = DriverManager.getConnection ( jdbcUrl , username , password );

        LOG.debug ( "A database connection has been successfully retrieved using the jdbc URL '" + jdbcUrl + "' and username '" + username + "'" );

        conn.setAutoCommit ( false );

        LOG.debug ( "Autocommit has been set on the database connection" );

        LOG.debug ( "A connection to the database has been successfully retrieved and set up" );

        return conn;
    }
}