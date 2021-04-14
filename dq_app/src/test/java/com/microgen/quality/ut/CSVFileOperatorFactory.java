package com.microgen.quality.ut;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.csv.ICSVOperator;
import com.microgen.quality.tlf.csv.OracleCsvOperator;

public class CSVFileOperatorFactory
{
    public static ICSVOperator getCsvFileOperator ( final IDatabaseConnector pIDatabaseConnector  )
    {
        return new OracleCsvOperator ( pIDatabaseConnector );
    }
}