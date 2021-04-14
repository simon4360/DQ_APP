package com.microgen.quality.tlf.server;

import java.nio.file.attribute.PosixFilePermissions;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;

import org.apache.log4j.Logger;

public class SSHServerOperator implements IServerOperator
{
	
	  private static final Logger LOG = Logger.getLogger ( SSHServerOperator.class );

    private static void executeCommand ( final String pUsername , final String pServername , final String pCommand ) throws Exception
    {
        CommandLine command = new CommandLine ( "ssh" );

        command.addArgument("-o")
               .addArgument("UserKnownHostsFile=/dev/null")
               .addArgument("-o")
               .addArgument("StrictHostKeyChecking=no")
               .addArgument ( pUsername + "@" + pServername ).addArgument ( "${theCommand}" , false );

        Map<String,String> m = new HashMap<String,String>();

        m.put ( "theCommand" , pCommand );

        command.setSubstitutionMap ( m );

        DefaultExecutor executor  = new DefaultExecutor ();
        
        int exitValue = executor.execute ( command );

        if ( exitValue != 0 )
        {
            throw new Exception ( "The attempt to execute the command '" + command + "' was unsuccessful - it returned with the value '" + exitValue + "'" );
        }
        else
        {
            LOG.debug ( "The command '" + command + "' was executed successfully" );
        }
    }
	
    public void retrieveFileFromServer  ( final String pServerName , final String pUsername , final String pPassword , final String pPathToSourceFileOnServer , final Path pPathToLocalTargetFolder )
    {

    }

    public void deleteContentsOfFolder ( final String pServerName , final String pUsername , final String pPathToFolder ) throws Exception
    {

    }

    public void retrieveFileFromServer  ( final String pServerName , final String pUsername , final String pPathToSourceFileOnServer , final Path pPathToLocalTargetFolder )
    {

    }

    public void sendFileToServer        ( final String pServerName , final String pUsername , final String pPassword , final String pPathToTargetFolderOnServer , final Path pPathToLocalFile )
    {

    }

    public void sendFileToServer        ( final String pServerName , final String pUsername , final String pPathToTargetFolderOnServer , final Path pPathToLocalFile ) throws Exception
    {
    	CommandLine command = new CommandLine ( "scp");

        command.addArgument("-o")
        .addArgument("UserKnownHostsFile=/dev/null")
        .addArgument("-o")
        .addArgument("StrictHostKeyChecking=no")
        .addArgument(pPathToLocalFile.toString() , false)
        .addArgument("${theCommand}", false);

        Map<String,String> m = new HashMap<String,String>();

        m.put ( "theCommand" , pUsername + "@" + pServerName + ":" + pPathToTargetFolderOnServer );

        command.setSubstitutionMap ( m );

        DefaultExecutor executor  = new DefaultExecutor ();

        int exitValue = executor.execute ( command );

        if ( exitValue != 0 )
        {
            throw new Exception ( "The attempt to execute the command '" + command + "' was unsuccessful - it returned with the value '" + exitValue + "'" );
        }
        else
        {
            LOG.debug ( "The command '" + command + "' was executed successfully" );
        }
    	
    }

    public void issueCommandOnServer    ( final String pServerName , final String pUsername , final String pPassword , final String pCommand )
    {

    }

    public void issueCommandOnServer    ( final String pServerName , final String pUsername , final String pCommand ) throws Exception
    {   
    	   SSHServerOperator.executeCommand ( pUsername ,pServerName, pCommand );
    }
}
