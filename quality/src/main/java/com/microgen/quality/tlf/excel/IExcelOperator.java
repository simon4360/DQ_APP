package com.microgen.quality.tlf.excel;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.string.ITokenReplacement;

import java.nio.file.Path;

public interface IExcelOperator
{
    public void createDatabaseTableFromExcelTab ( final String pTableOwner , final Path pPathToExcelFile , final String pExcelTab ) throws Exception;

    public void loadExcelTabToDatabaseTable     ( final String pTableOwner , final Path pPathToExcelFile , final String pExcelTab , final ITokenReplacement pITokenReplacement ) throws Exception;
    
 
    
}
