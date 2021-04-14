package com.microgen.quality.ut;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.IDataComparisonOperator;
import com.microgen.quality.tlf.database.OracleDataComparisonOperator;

public class DataComparisonOperatorFactory
{
    public static IDataComparisonOperator getDataComparisonOperator ( final IDatabaseConnector pIDatabaseConnector )
    {
        return new OracleDataComparisonOperator ( pIDatabaseConnector );
    }
}