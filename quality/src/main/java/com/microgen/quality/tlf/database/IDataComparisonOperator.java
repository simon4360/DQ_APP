package com.microgen.quality.tlf.database;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.string.ITokenReplacement;

import java.nio.file.Path;

public interface IDataComparisonOperator
{
    public int countMinusQueryResults ( final Path pPathToQuery1 , final Path pPathToQuery2 , final String[] pBindArray , final ITokenReplacement pITokenReplacement ) throws Exception;

    public int countMinusQueryResultsNoLog ( final Path pPathToQuery1 , final Path pPathToQuery2 , final String[] pBindArray , final ITokenReplacement pITokenReplacement ) throws Exception;

    public int countMinusQueryResultsOneDirection ( final Path pPathToQuery1 , final Path pPathToQuery2 , final String [] pBindArray , final ITokenReplacement pITokenReplacement ) throws Exception;
}