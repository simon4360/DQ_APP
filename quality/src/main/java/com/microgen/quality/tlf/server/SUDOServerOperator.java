package com.microgen.quality.tlf.server;

import java.nio.file.attribute.PosixFilePermissions;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;

import org.apache.log4j.Logger;

public class SUDOServerOperator implements IServerOperator
{
    private static final Logger LOG = Logger.getLogger ( SUDOServerOperator.class );

    private static void executeCommand ( final String pUsername , final String pCommand ) throws Exception
    {
        CommandLine command = new CommandLine ( "sudo" );

        command.addArgument ( "-iu" ).addArgument ( pUsername ).addArgument ( "bash" ).addArgument ( "-c " ).addArgument ( "${theCommand}" , false );

        Map<String,String> m = new HashMap<String,String>();

        m.put ( "theCommand" , pCommand );

        command.setSubstitutionMap ( m );

        DefaultExecutor executor  = new DefaultExecutor ();

        //LOG.info("Command = " + command.toString());

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

    public void deleteContentsOfFolder ( final String pServerName , final String pUsername , final String pPathToFolder ) throws Exception
    {
        Path PATH_TO_FOLDER = Paths.get ( pPathToFolder );

        SUDOServerOperator.executeCommand ( pUsername , "rm -rf " + PATH_TO_FOLDER.toString () + "/*" );
    }

    public void retrieveFileFromServer ( final String pServerName , final String pUsername , final String pPassword , final String pPathToSourceFileOnServer , final Path pPathToLocalTargetFolder )
    {

    }

    public void retrieveFileFromServer ( final String pServerName , final String pUsername , final String pPathToSourceFileOnServer , final Path pPathToLocalTargetFolder )
    {

    }

    public void sendFileToServer       ( final String pServerName , final String pUsername , final String pPassword , final String pPathToTargetFolderOnServer , final Path pPathToLocalFile )
    {

    }

    public void sendFileToServer       ( final String pServerName , final String pUsername , final String pPathToTargetFolderOnServer , final Path pPathToLocalFile ) throws Exception
    {
        LOG.debug ( "Sending '" + pPathToLocalFile + "' to '" + pPathToTargetFolderOnServer + "'" );

        final Path PATH_TO_INTERMEDIATE_FOLDER = Files.createTempDirectory ( "corfah_build_" + pUsername + "_" );

        final Path PATH_TO_INTERMEDIATE_FILE   = PATH_TO_INTERMEDIATE_FOLDER.resolve ( pPathToLocalFile .getFileName().toString() );

        Files.setPosixFilePermissions ( PATH_TO_INTERMEDIATE_FOLDER , PosixFilePermissions.fromString ( "rwxrwxrwx" ) );

        Files.copy ( pPathToLocalFile , PATH_TO_INTERMEDIATE_FILE );

        Files.setPosixFilePermissions ( PATH_TO_INTERMEDIATE_FILE , PosixFilePermissions.fromString ( "rwxrwxrwx" ) );

        SUDOServerOperator.executeCommand ( pUsername , "cp " + PATH_TO_INTERMEDIATE_FILE + " " + pPathToTargetFolderOnServer  + ";" );

        Files.delete ( PATH_TO_INTERMEDIATE_FILE );

        Files.delete ( PATH_TO_INTERMEDIATE_FOLDER );

        LOG.info ( "" + pPathToLocalFile + "' was successfully sent to '" + pPathToTargetFolderOnServer + "'" );
    }

    public void issueCommandOnServer   ( final String pServerName , final String pUsername , final String pPassword , final String pCommand )
    {

    }

    public void issueCommandOnServer   ( final String pServerName , final String pUsername , final String pCommand ) throws Exception
    {
        SUDOServerOperator.executeCommand ( pUsername , pCommand );
    }
}
