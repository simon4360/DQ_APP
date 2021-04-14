package com.microgen.buildtools.appsrv.aptitude;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import com.microgen.buildtools.appsrv.aptitude.AptitudeServerConstants;
import com.microgen.buildtools.appsrv.SudoCommand;
import com.microgen.buildtools.appsrv.ShellCommand;

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class AptitudeServerController {
  
    private String env                    = ""
    private String aptitudeHost           = ""
    private String aptitudeLinuxUsername  = ""
    private int    aptitudeServerPort     = 0
    private int    aptitudeServerBusPort  = 0
    private String aptitudeServerUsername = ""
    private String aptitudeServerPassword = ""  

    AptitudeServerController ( final String pEnv , final String pAptitudeHost , final String pAptitudeLinuxUsername , final int pAptitudeServerPort , final int pAptitudeServerBusPort , final String pAptitudeServerUsername , final String pAptitudeServerPassword ) {
        env                    = pEnv
        aptitudeHost           = pAptitudeHost
        aptitudeLinuxUsername  = pAptitudeLinuxUsername
        aptitudeServerPort     = pAptitudeServerPort
        aptitudeServerBusPort  = pAptitudeServerBusPort
        aptitudeServerUsername = pAptitudeServerUsername
        aptitudeServerPassword = pAptitudeServerPassword
    }

    def deployProjectToAptitude ( final String pExecutionFolderName , final String pPathToProject ) {
        println "Deploying ... $pPathToProject to $pExecutionFolderName"

        SudoCommand.execute (   aptitudeLinuxUsername
                            ,       AptitudeServerConstants.getPathToAptCmd ( env ) + ' -deploy '
                                + ' -project_file_path '                            + pPathToProject         + ''
                                + ' -config_file_path  '                            + pPathToProject         + '.config'
                                + ' -redeployment_type                                "full" '
                                + ' -folder            "'                           + pExecutionFolderName   + '"'
                                + ' -host              "'                           + aptitudeHost           + '"'
                                + ' -port              "'                           + aptitudeServerPort     + '"'
                                + ' -login             "'                           + aptitudeServerUsername + '"'
                                + ' -password          "'                           + aptitudeServerPassword + '";'
                            )
    }

    def startAptitudeProject ( final String pExecutionFolderName , final String pProjectName ) {
        println "Starting ... $pExecutionFolderName/$pProjectName"

        SudoCommand.execute (   aptitudeLinuxUsername
                            ,       AptitudeServerConstants.getPathToAptCmd ( env ) + ' -start '
                                + ' -project           "'                         + pExecutionFolderName + '/' + pProjectName    + '"'
                                + ' -host              "'                         + aptitudeHost                                 + '"'
                                + ' -port              "'                         + aptitudeServerPort                           + '"'
                                + ' -login             "'                         + aptitudeServerUsername                       + '"'
                                + ' -password          "'                         + aptitudeServerPassword                       + '";'
                            )
    }

    def stopAptitudeProject ( final String pExecutionFolderName , final String pProjectName ) {
        println "Stopping ... $pExecutionFolderName/$pProjectName"
	
        SudoCommand.execute (   aptitudeLinuxUsername
                            ,     AptitudeServerConstants.getPathToAptCmd ( env ) + ' -stop '
                                + ' -project           "'                         + pExecutionFolderName + '/' + pProjectName + '"'
                                + ' -host              "'                         + aptitudeHost                              + '"'
                                + ' -port              "'                         + aptitudeServerPort                        + '"'
                                + ' -login             "'                         + aptitudeServerUsername                    + '"'
                                + ' -password          "'                         + aptitudeServerPassword                    + '" || true ;'
                            )
    }

    def addBusServer ( pBusServerName , pBusServerDescription ) {
        println "Adding bus server ... "

        SudoCommand.execute (   aptitudeLinuxUsername
                            ,     AptitudeServerConstants.getPathToAptCmd ( env ) + ' -add_bus_server '
                                + ' -bus_server_name        "'                    + pBusServerName         + '"'
                                + ' -bus_server_host        "'                    + aptitudeHost           + '"'
                                + ' -bus_server_port        "'                    + aptitudeServerBusPort  + '"'
                                + ' -bus_server_description "'                    + pBusServerDescription  + '"'
                                + ' -host                   "'                    + aptitudeHost           + '"'
                                + ' -port                   "'                    + aptitudeServerPort     + '"'
                                + ' -login                  "'                    + aptitudeServerUsername + '"'
                                + ' -password               "'                    + aptitudeServerPassword + '";'
                            )
    }

    def deleteBusServer ( pBusServerName ) {
        println "Deleting bus server ... "

        SudoCommand.executeWithoutPrejudice (   aptitudeLinuxUsername
                            ,     AptitudeServerConstants.getPathToAptCmd ( env ) + ' -remove_bus_server '
                                + ' -bus_server_name  "' + pBusServerName         + '"'
                                + ' -host             "' + aptitudeHost           + '"'
                                + ' -port             "' + aptitudeServerPort     + '"'
                                + ' -login            "' + aptitudeServerUsername + '"'
                                + ' -password         "' + aptitudeServerPassword + '";'
                            )
    }

    def addExecutionFolder ( final String pExecutionFolderName ) {
        println "Creating execution folder  ... $pExecutionFolderName"

        try {
            SudoCommand.execute (   aptitudeLinuxUsername
                                ,     AptitudeServerConstants.getPathToAptCmd ( env ) + ' -add_folder '
                                    + ' -folder   "'                                  + pExecutionFolderName   + '"'
                                    + ' -host     "'                                  + aptitudeHost           + '"'
                                    + ' -port     "'                                  + aptitudeServerPort     + '"'
                                    + ' -login    "'                                  + aptitudeServerUsername + '"'
                                    + ' -password "'                                  + aptitudeServerPassword + '";'
                                )
        }
        catch ( Exception e ) {

        }
    }

    def deleteExecutionFolder ( final String pExecutionFolderName ) {
        println "Deleting execution folder  ... $pExecutionFolderName"

        SudoCommand.execute (   aptitudeLinuxUsername
                            ,     AptitudeServerConstants.getPathToAptCmd ( env ) + ' -delete_folder '
                                + ' -folder   "'                                  + pExecutionFolderName   + '"'
                                + ' -host     "'                                  + aptitudeHost           + '"'
                                + ' -port     "'                                  + aptitudeServerPort     + '"'
                                + ' -login    "'                                  + aptitudeServerUsername + '"'
                                + ' -password "'                                  + aptitudeServerPassword + '";'
                            )
    }

    def deployGlobalLevelConfigDef ( final Path pConfigDefinitionFilePath ) {
        assert ( Files.exists ( pConfigDefinitionFilePath ) )

        println "Deploying the configuration definition '$pConfigDefinitionFilePath'"

        SudoCommand.createFolder  (   aptitudeLinuxUsername
                                  ,   Paths.get ( AptitudeServerConstants.getPathToTempUploadDir ( env ) )
                                  );

        SudoCommand.deployFile    (   aptitudeLinuxUsername
                                  ,   pConfigDefinitionFilePath
                                  ,   AptitudeServerConstants.getPathToTempUploadDir ( env )
                                  );

        SudoCommand.execute       (   aptitudeLinuxUsername
                                  ,     AptitudeServerConstants.getPathToAptCmd ( env )                                                                                  + ' -load_config_definition '
                                      + ' -config_file_path ' + AptitudeServerConstants.getPathToTempUploadDir ( env )  + pConfigDefinitionFilePath.fileName.toString() + ''
                                      + ' -overwrite             "true"'
                                      + ' -host             "' + aptitudeHost                                                                                            + '"'
                                      + ' -port             "' + aptitudeServerPort                                                                                      + '"'
                                      + ' -login            "' + aptitudeServerUsername                                                                                  + '"'
                                      + ' -password         "' + aptitudeServerPassword                                                                                  + '";'
                                  );

        SudoCommand.deleteFolder  (   aptitudeLinuxUsername
                                  ,   Paths.get ( AptitudeServerConstants.getPathToTempUploadDir ( env ) )
                                  );

    }

    def deleteGlobalLevelConfigDef ( final String pConfigDefinitionName ) {
        println "Deleting the configuration definition '$pConfigDefinitionName'"

        SudoCommand.execute (   aptitudeLinuxUsername
                            ,     AptitudeServerConstants.getPathToAptCmd ( env ) + ' -delete_config_definition '
                                + ' -global_only      "true"'
                                + ' -definition       "'                          + pConfigDefinitionName  + '"'
                                + ' -host             "'                          + aptitudeHost           + '"'
                                + ' -port             "'                          + aptitudeServerPort     + '"'
                                + ' -login            "'                          + aptitudeServerUsername + '"'
                                + ' -password         "'                          + aptitudeServerPassword + '";'
                            );
    }

    def deployFolderLevelConfigDef ( final Path pConfigDefinitionFilePath , final String pExecutionFolderName ) {
        assert ( Files.exists ( pConfigDefinitionFilePath ) )

        println "Deploying the configuration definition at '$pConfigDefinitionFilePath' to execution folder '$pExecutionFolderName'"

        addExecutionFolder        ( pExecutionFolderName );

        SudoCommand.createFolder  (   aptitudeLinuxUsername
                                  ,   Paths.get ( AptitudeServerConstants.getPathToTempUploadDir ( env ) )
                                  );

        SudoCommand.deployFile    (   aptitudeLinuxUsername
                                  ,   pConfigDefinitionFilePath
                                  ,   AptitudeServerConstants.getPathToTempUploadDir ( env )
                                  );

        SudoCommand.execute       (   aptitudeLinuxUsername
                                  ,     AptitudeServerConstants.getPathToAptCmd ( env )                                                                                 + ' -load_config_definition '
                                      + ' -config_file_path ' + AptitudeServerConstants.getPathToTempUploadDir ( env ) + pConfigDefinitionFilePath.fileName.toString() + ''
                                      + ' -overwrite             "true"'
                                      + ' -folder           "' + pExecutionFolderName                                                                                   + '"'
                                      + ' -host             "' + aptitudeHost                                                                                           + '"'
                                      + ' -port             "' + aptitudeServerPort                                                                                     + '"'
                                      + ' -login            "' + aptitudeServerUsername                                                                                 + '"'
                                      + ' -password         "' + aptitudeServerPassword                                                                                 + '";'
                                  );

        SudoCommand.deleteFolder  (   aptitudeLinuxUsername
                                  ,   Paths.get ( AptitudeServerConstants.getPathToTempUploadDir ( env ) )
                                  );
    }

    def deleteFolderLevelConfigDef ( final String pExecutionFolderName , final String pConfigDefinitionName ) {
        println "Deleting the configuration definition '$pConfigDefinitionName' from the execution folder '$pExecutionFolderName'"

        SudoCommand.execute (   aptitudeLinuxUsername
                            ,     AptitudeServerConstants.getPathToAptCmd ( env ) + ' -delete_config_definition '
                                + ' -folder           "'                          + pExecutionFolderName       + '"'
                                + ' -definition       "'                          + pConfigDefinitionName      + '"'
                                + ' -host             "'                          + aptitudeHost               + '"'
                                + ' -port             "'                          + aptitudeServerPort         + '"'
                                + ' -login            "'                          + aptitudeServerUsername     + '"'
                                + ' -password         "'                          + aptitudeServerPassword     + '";'
                            );
    }

    def String pkcs7EncodeString ( final String pStringToEncode , final Path pPathToLocalTmpFile ) {

        final String PKCS7_FILE_NAME       = 'pkcs7.encrypt';
        final Path   PKCS7_REMOTE_LOCATION = Paths.get ( AptitudeServerConstants.getPathToTempUploadDir ( env ) + PKCS7_FILE_NAME );
              String encodedString         = "";

        SudoCommand.createFolder  (   aptitudeLinuxUsername
                                  ,   Paths.get ( AptitudeServerConstants.getPathToTempUploadDir ( env ) )
                                  );

        SudoCommand.execute       (   aptitudeLinuxUsername
                                  ,     AptitudeServerConstants.getPathToAptCmd ( env )  
                                      + ' -pkcs7_encode '
                                      + ' -text              '                     + "'" + pStringToEncode            + "'"
                                      + ' -host             "'                           + aptitudeHost               + '"'
                                      + ' -port             "'                           + aptitudeServerPort         + '"'
                                      + ' -login            "'                           + aptitudeServerUsername     + '"'
                                      + ' -password         "'                           + aptitudeServerPassword     + '" > ' + "$PKCS7_REMOTE_LOCATION"
                                  );

        SudoCommand.retrieveFile  (   aptitudeLinuxUsername
                                  ,   PKCS7_REMOTE_LOCATION
                                  ,   pPathToLocalTmpFile
                                  );

        SudoCommand.deleteFolder  (   aptitudeLinuxUsername
                                  ,   Paths.get ( AptitudeServerConstants.getPathToTempUploadDir ( env ) )
                                  );

        encodedString = Files.newInputStream ( pPathToLocalTmpFile ).text.trim();

        Files.delete ( pPathToLocalTmpFile );

        return encodedString;
    }
    
    def pingProject ( final String pProjectName ) {
        println "Pinging project ... '$pProjectName'"

        try {
          SudoCommand.execute (   aptitudeLinuxUsername
                              ,   'aptProjectController.sh -c ping -p ' + pProjectName
                              );
        }
        catch ( Exception e ) {
          println "Error: Failed to ping project '$pProjectName'. Project probably not deployed due to compilation error."
          throw e;
        }
    }
    
    def modifyXMLConfigfiles ( final String pAptitudeConfigFile , final String pSchedulerMode , final String pPollingInterval , final String pNumberOfUnprocessedRows ) {
      try {
      
      // For t_project_config set mode to run only once (in ci this will be triggered by stop/start the project)
      String schedulerModeProjectConfig = 0;
    	String filepathConfigFile = pAptitudeConfigFile;
    	DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
    	DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
    	Document configFileDoc = docBuilder.parse( filepathConfigFile );          
       
      NodeList nlConfigElement = configFileDoc.getElementsByTagName( "ConfigElement" ); // Get ConfigElement nodes from xml file
      if ( nlConfigElement != null ) {
          for ( int i = 0; i < nlConfigElement.getLength(); i++ ) {
          	
              if ( nlConfigElement.item(i).getNodeType() == Node.ELEMENT_NODE ) {
                  Element elConfigElement = ( Element ) nlConfigElement.item(i);         
                  NamedNodeMap atrrConfigElement = elConfigElement.getAttributes();
                  Node nodeAttrConfigElement = atrrConfigElement.getNamedItem( "Type" );

                  // Only process Source Objects
                  if ( nodeAttrConfigElement.getTextContent().contains( "SOURCE_OBJECT_DB" ) ) {
                  	
                  	// Get the source object name to filter out t_project_config_reset_events and t_project_config_stop_project
                  	// as these sources do not select source data
                  	Node nodeSourceObjectName = elConfigElement.getElementsByTagName( "Name" ).item(0);              	 	    	
                  	if ( ! (nodeSourceObjectName.getTextContent().toLowerCase().contains( "t_project_config_reset_events" ) 
                  	           ||  nodeSourceObjectName.getTextContent().toLowerCase().contains( "t_project_config_stop_project" ) )) {        
                  	  Node nodeSourceScheduler = elConfigElement.getElementsByTagName( "SourceDBSchedulerComplex" ).item(0);                	 	      
                  	  NodeList nlSourceScheduler = nodeSourceScheduler.getChildNodes();
                  	  // Loop through the source scheduler child nodes and set the correct scheduler values
                  	  for ( int j = 0; j < nlSourceScheduler.getLength(); j++ ) {                	 	      	
                  	    if ( nlSourceScheduler.item(j).getNodeType() == Node.ELEMENT_NODE ) {                	 	        	
                 	       Node nodeSourceSchedulerChild = nlSourceScheduler.item(j);
                 	       // Change the Scheduler mode only if set to interval
                         if ( "Mode".equals(nodeSourceSchedulerChild.getNodeName() ) 
                                    && nodeSourceSchedulerChild.getTextContent().equals( "1" )) {
                         	if ( nodeSourceObjectName.getTextContent().toLowerCase().contains( "t_project_config" ) ) {
                         		nodeSourceSchedulerChild.setTextContent( schedulerModeProjectConfig );
                         	}
                         	else {
                         		nodeSourceSchedulerChild.setTextContent( pSchedulerMode );
                         	}
                         	}
                         // Set the number of rows
                         if ( "Rows".equals( nodeSourceSchedulerChild.getNodeName() ) ) {
                         	 nodeSourceSchedulerChild.setTextContent( pNumberOfUnprocessedRows );
                         	}
                         // Set the interval to check if there are n number of unprocessed rows
                         if ( "PollingInterval".equals( nodeSourceSchedulerChild.getNodeName() ) ) {
                         	 nodeSourceSchedulerChild.setTextContent( pPollingInterval );
                         	}                         	
                        }         
                 	    }      	         
     	              } 	                 
     	            }
     	        }
     	    }
     	}
     
    	// write the content into the config file
    	TransformerFactory transformerFactory = TransformerFactory.newInstance();
    	Transformer transformer = transformerFactory.newTransformer();
    	DOMSource source = new DOMSource( configFileDoc );
    	StreamResult result = new StreamResult( new File( filepathConfigFile ) );
    	transformer.transform( source , result );         
    } 
    catch ( Exception e ) {
    throw e;
	  }
	}
}