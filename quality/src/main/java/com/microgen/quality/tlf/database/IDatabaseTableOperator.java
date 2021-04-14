package com.microgen.quality.tlf.database;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.string.ITokenReplacement;

public interface IDatabaseTableOperator
{
    public boolean checkIfExists ( final String pTableOwner , final String pTableName ) throws Exception;

    public void copyTable        ( final String pSourceTableOwner , final String pSourceTableName , final String pTargetTableOwner , final String pTargetTableName , final boolean pIncludeData ) throws Exception;

    public void insertToTable    ( final String pSourceTableOwner , final String pSourceTableName , final String pTargetTableOwner , final String pTargetTableName ) throws Exception;

    public void deleteData       ( final String pTableOwner , final String pTableName ) throws Exception;

    public void deleteData       ( final String pTableOwner , final String pTableName , final String pCondition , final String[] pBindArray , final ITokenReplacement pITokenReplacement ) throws Exception;
    
    public void dropIfExists     ( final String pTableOwner , final String pTableName ) throws Exception;
    
    public void alterTrigger  ( final String pTriggerOwner , final String pTriggerName, final String pAction ) throws Exception;


}