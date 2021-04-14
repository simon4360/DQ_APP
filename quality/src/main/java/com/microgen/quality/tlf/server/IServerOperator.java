package com.microgen.quality.tlf.server;

import java.nio.file.Path;

public interface IServerOperator
{
    public void deleteContentsOfFolder ( final String pServerName , final String pUsername , final String pPathToFolder ) throws Exception;

    public void retrieveFileFromServer  ( final String pServerName , final String pUsername , final String pPassword , final String pPathToSourceFileOnServer , final Path pPathToLocalTargetFolder );

    public void retrieveFileFromServer  ( final String pServerName , final String pUsername , final String pPathToSourceFileOnServer , final Path pPathToLocalTargetFolder );

    public void sendFileToServer        ( final String pServerName , final String pUsername , final String pPassword , final String pPathToTargetFolderOnServer , final Path pPathToLocalFile );

    public void sendFileToServer        ( final String pServerName , final String pUsername , final String pPathToTargetFolderOnServer , final Path pPathToLocalFile ) throws Exception;

    public void issueCommandOnServer    ( final String pServerName , final String pUsername , final String pPassword , final String pCommand );

    public void issueCommandOnServer    ( final String pServerName , final String pUsername , final String pCommand ) throws Exception;
}