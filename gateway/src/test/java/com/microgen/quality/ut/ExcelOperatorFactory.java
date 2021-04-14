package com.microgen.quality.ut;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.excel.IExcelOperator;
import com.microgen.quality.tlf.excel.OracleExcelOperator;

public class ExcelOperatorFactory
{
    public static IExcelOperator getExcelOperator ( final IDatabaseConnector pIDatabaseConnector  )
    {
        return new OracleExcelOperator ( pIDatabaseConnector );
    }
}