package com.microgen.quality.ut;

import org.testng.Assert;
import org.apache.log4j.Logger;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.sql.*;


import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.ut.DatabaseConnectorFactory;
import com.microgen.quality.tlf.database.OracleDatabaseConnector;

public class Execution
{

    private static final Logger LOG = Logger.getLogger ( Execution.class );
    
    private static final IDatabaseConnector   DB_G77_CFG_CONN_OPS  = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG ();

    // Clean a given directory as target user - without force so that we give it a chance to fail
    //
    public static boolean clearDirectory ( final String pAppServerName , final String pAppServerOsUsername , final String directory )
    {
        Boolean result = true;
        
        final StringBuffer batchStepCommand = new StringBuffer ( "sudo -iu ").append ( pAppServerOsUsername ).append(" bash -c '")
                                                       .append ( " rm -f " )
                                                       .append ( directory ).append ( "/* '");
      
        try
        {
          ServerOperatorFactory.getSSHServerOperator ().issueCommandOnServer 
            (pAppServerName , EnvironmentConstants.APP_DEPLOYER_OS_USERNAME , batchStepCommand.toString ());
        }
        catch ( Exception e )
        {
            result = false;
        }

        return result;
    }
    
        private static Integer generateRunID() throws Exception{
            Connection conn = null;
            PreparedStatement pStmt = null;
            String SYNDDL = "select SQ_T_BATCH_TASK_PROCESS_ID.NEXTVAL from dual";

            LOG.debug("Generating RunID: ");

            try {
                conn = DB_G77_CFG_CONN_OPS.getConnection();
                LOG.debug("A connection to the database was successfully retrieved");
                pStmt = conn.prepareStatement(SYNDDL);
                LOG.debug("The SQL to be used has been successfully prepared");
                ResultSet rs = pStmt.executeQuery();
                Integer RunID = null;
                if(rs.next())
                {
                RunID = rs.getInt(1);
                }
                LOG.debug("RunID generated");
                return(RunID);
                } 
            catch (Exception sqle) {
                LOG.fatal("SQL Exception: " + sqle);
                throw sqle;
               } 
              finally 
              {
                pStmt.close();
                conn.close();
              }
    }

    // Copy file as target user
    //
    public static boolean copyFile ( final String pAppServerName , final String pAppServerOsUsername , final String sourceFile, final String destination )
    {
        Boolean result = true;
             
        try
        {
          ServerOperatorFactory.getSSHServerOperator ().sendFileToServer
            (pAppServerName , pAppServerOsUsername , destination.replace("\\","/") + "/" +  Paths.get(sourceFile).getFileName(), Paths.get(sourceFile) );   
        }
        catch ( Exception e )
        {
            result = false;
        }

        return result;
    }

    public static boolean copyFileSudo ( final String pAppServerName , final String pAppServerOsUsername , final String sourceFile, final String destination )
    {
        Boolean result = true;
        
        final StringBuffer batchStepCommand = new StringBuffer ( "sudo -iu ").append ( pAppServerOsUsername ).append(" bash -c \"")
                                                       .append ( " cp " )
                                                       .append ( sourceFile ).append ( " ").append ( destination ).append(" \"");
      
        try
        {
          ServerOperatorFactory.getSSHServerOperator ().issueCommandOnServer 
            (pAppServerName , EnvironmentConstants.APP_DEPLOYER_OS_USERNAME , batchStepCommand.toString ());  
        }
        catch ( Exception e )
        {
            result = false;
        }

        return result;
    }    
	  
    public static boolean executeMF ( final String pAppServerName , final String pAppServerOsUsername , final String pAptitudeProject , final String pAptitudeMicroflow , final String pSessionId, final String pSourceId )
    {  
    	  String  aptitudeLinuxUsername   =  EnvironmentConstants.APP_SERVER_OS_USERNAME; 
        Boolean result = true;
        String wrapper = "StartTask.sh ";       
        Integer RunID = null;
        try{
        RunID = generateRunID();
           }
           catch( Exception e)
           {
              result = false;
           }

        final StringBuffer executeMFCommand = new StringBuffer ( "sudo -iu ").append ( aptitudeLinuxUsername ).append(" bash -c \'")
                                                       .append ( ". /home/").append (aptitudeLinuxUsername).append("/.bashrc;")
                                                       .append ( "${BATCH_SCRIPTS}/" )
                                                       .append ( wrapper )
                                                       .append ( "-p" ).append ( pAptitudeProject   ).append ( " " )
                                                       .append ( "-m" ).append ( pAptitudeMicroflow ).append ( " " )
                                                       .append ( "-s" ).append ("'").append( pSessionId ).append ("'").append ( " " )
                                                       .append ( "-a" ).append ( pSourceId ).append ( " " )
                                                       .append ( "-r" ).append ( RunID ).append ( "\'") ;
                                                       ;
     
        try
        { 
        	ServerOperatorFactory.getSSHServerOperator ().issueCommandOnServer ( pAppServerName , EnvironmentConstants.APP_DEPLOYER_OS_USERNAME , executeMFCommand.toString () );           
        }
        catch ( Exception e )
        {
            result = false;
            LOG.fatal("Failed to execute Microflow",e);
        }

        return result;
    }
	  
    public static boolean runMF ( final String pAptitudeProject , final String pAptitudeMicroflow , final String pSessionId, final String pSourceId ) 
    {
        return executeMF
                (
                    EnvironmentConstants.APP_SERVER_NAME
                ,   EnvironmentConstants.APP_SERVER_OS_USERNAME
                ,   pAptitudeProject
                ,   pAptitudeMicroflow
                ,   pSessionId
                ,   pSourceId          
                );        
    }

    public static boolean StopStartAptitude (  final String pExecutionFolderName, final String pProjectName, final String pStopStart) throws Exception
    {   
    	  Boolean result = true;
    	  String  env                     =  EnvironmentConstants.ENVIRONMENT;
        String  aptitudeHost            =  EnvironmentConstants.APP_SERVER_NAME;
        String  aptitudeLinuxUsername   =  EnvironmentConstants.APP_SERVER_OS_USERNAME; 
        Integer aptitudeServerPort      =  Integer.valueOf(EnvironmentConstants.APT_SRV_PORT);
        Integer aptitudeServerBusPort   =  Integer.valueOf(EnvironmentConstants.APT_BUS_PORT);
        String  aptitudeServerUsername  =  EnvironmentConstants.ADMIN_USERNAME;
        String  aptitudeServerPassword  =  EnvironmentConstants.ADMIN_PASSWORD;
        
        assert ( pStopStart == "stop" || pStopStart == "start" ); 
        
        final StringBuffer aptitudeCommand = new StringBuffer ( "sudo -iu ").append ( aptitudeLinuxUsername ).append( " bash -c '" )
                                                       .append ( "/home/").append(aptitudeLinuxUsername).append("/aptitude/" ).append ( "bin/" )
                                                       .append ( "aptcmd " ) 
                                                       .append (  " -" ).append( pStopStart ).append ( " ")
                                                       .append ( "-project " ).append("'").append ( pExecutionFolderName ).append( "/" ).append( pProjectName ).append ( "\' " )
                                                       .append ( "-host " ).append("'").append( aptitudeHost ).append ( "' " )
                                                       .append ( "-port " ).append("'").append( aptitudeServerPort ).append ( "' " )
                                                       .append ( "-login " ).append("'").append( aptitudeServerUsername ).append ( "' " )
                                                       .append ( "-password " ).append("'").append( aptitudeServerPassword ).append ( "' '" );
                                                                                       
       try
        {
                // This will throw back server side exceptions - we should rethrow them (CFCFG-283)
                //
                //LOG.info("Server command = " + aptitudeCommand.toString());
        	ServerOperatorFactory.getSSHServerOperator ().issueCommandOnServer ( aptitudeHost , EnvironmentConstants.APP_DEPLOYER_OS_USERNAME , aptitudeCommand.toString () );           
        }
        catch ( Exception e )
        {
            result = false;
            LOG.info("Execution.java:StopStartAptitude - failed to stop/start aptitude");
            throw(e);
        }

        return result;
    }                                   
}
