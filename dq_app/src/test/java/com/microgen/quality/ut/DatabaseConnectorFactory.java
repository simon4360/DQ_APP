package com.microgen.quality.ut;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.OracleDatabaseConnector;

public class DatabaseConnectorFactory
{
    public static IDatabaseConnector getDatabaseConnectorG77_CFG ()
    {
        return new OracleDatabaseConnector
                   (
                       EnvironmentConstants.DB_CONNECTOR_STING
                   ,   EnvironmentConstants.G77_CFG_DB
                   ,   EnvironmentConstants.G77_CFG_PASSWORD
                   ,   EnvironmentConstants.G77_CFG_DB
                   ,   false
                   );
    }

    public static IDatabaseConnector getDatabaseConnectorG77_CFG_TEC ()
    {
        return new OracleDatabaseConnector
                   (
                       EnvironmentConstants.DB_CONNECTOR_STING
                   ,   EnvironmentConstants.G77_CFG_TEC_DB
                   ,   EnvironmentConstants.G77_CFG_TEC_PASSWORD
                   ,   EnvironmentConstants.G77_CFG_TEC_DB
                   ,   false
                   );
    }

    public static IDatabaseConnector getDatabaseConnectorG77_CFG_ARC ()
    {
        return new OracleDatabaseConnector
                (
                        EnvironmentConstants.DB_CONNECTOR_STING
                        ,   EnvironmentConstants.G77_CFG_ARC_DB
                        ,   EnvironmentConstants.G77_CFG_ARC_PASSWORD
                        ,   EnvironmentConstants.G77_CFG_ARC_DB
                        ,   false
                );
    }
}