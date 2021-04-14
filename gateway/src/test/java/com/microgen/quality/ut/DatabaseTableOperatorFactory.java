package com.microgen.quality.ut;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.IDatabaseTableOperator;
import com.microgen.quality.tlf.database.OracleDatabaseTableOperator;

public class DatabaseTableOperatorFactory
{
    public static IDatabaseTableOperator getDatabaseTableOperator ( final IDatabaseConnector pIDatabaseConnector )
    {
        return new OracleDatabaseTableOperator ( pIDatabaseConnector );
    }
}