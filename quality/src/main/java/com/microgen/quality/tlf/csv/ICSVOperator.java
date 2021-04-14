package com.microgen.quality.tlf.csv;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.string.ITokenReplacement;

import java.nio.file.Path;

public interface ICSVOperator
{
    public void createDatabaseTableFromCsvFile ( final String pTableOwner ,final String pTableName , final Path pPathToCsvFile ) throws Exception;

    public void loadCsvFileToDatabaseTable     ( final String pTableOwner , final String pTableName , final Path pPathToCsvFile , final ITokenReplacement pITokenReplacement ) throws Exception;
    
//    public void createCsvFileFromDatabaseTable ( final String pTableOwner ,final String pTableName , final Path pPathToCsvFile ) throws Exception;


}
