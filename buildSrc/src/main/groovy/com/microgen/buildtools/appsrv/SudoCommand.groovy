package com.microgen.buildtools.appsrv;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.attribute.PosixFilePermissions;
import java.nio.file.Path;
import java.util.Map;
import java.util.HashMap;
import org.gradle.api.GradleException;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;

public class SudoCommand {
private static String deployerUsername;
private static String aptitudeLinuxUsername;	

static def setUsernames(final String pDeployerUsername, final String pAptitudeLinuxUsername)
{
	deployerUsername = pDeployerUsername;
	aptitudeLinuxUsername = pAptitudeLinuxUsername;
}
private static def getUsername(){
	return System.getProperty("user.name");
}
private static def getUid(pUserName){
    return ["id", "-u", pUserName].execute().text.trim()
}
private static def getGid(pUserName){
    return ["id", "-g", pUserName].execute().text.trim()
}

static def execute ( final String pUsername , final String pCommand ) {
  
 // println "pUsername: " + pUsername  + ", UID: " + getUid( pUsername )+ ", GID: " + getGid( pUsername )
 // println "aptitudeLinuxUsername: " + aptitudeLinuxUsername + ", UID: " + getUid( aptitudeLinuxUsername )+ ", GID: " + getGid( aptitudeLinuxUsername )
 // println "deployerUsername: " + deployerUsername + ", UID: " + getUid( deployerUsername )+ ", GID: " + getGid( deployerUsername )
 // println "getUsername(): " + getUsername() + ", UID: " + getUid( getUsername() )+ ", GID: " + getGid( getUsername() )

    if ( !(pUsername && aptitudeLinuxUsername && deployerUsername))	
	{ throw new RuntimeException ( "The users have not been correctly initialised" ); }

    if ( getUsername() == pUsername )
        { executeBash (  pUsername , pCommand ); }
    else if (aptitudeLinuxUsername == pUsername)
        { executeSudo ( pUsername , pCommand );} 
    else
	{ executeSSH ( pUsername , pCommand ); }
}	
static def executeSudo ( final String pUsername , final String pCommand ) {
        CommandLine command = new CommandLine ( 'sudo' );
        command.addArgument ( '-iu' ).addArgument ( pUsername ).addArgument ( "bash" ).addArgument ( "-c " ).addArgument ( '${theCommand}' , false );
        Map m = new HashMap();
        m.put ('theCommand', pCommand );
        command.setSubstitutionMap ( m );
        DefaultExecutor executor = new DefaultExecutor ();
        int exitValue = executor.execute ( command );
        if ( exitValue != 0 ) {
            throw new RuntimeException ( "Exception: return code = ${exitValue}" );
        }        
    }
static def executeBash ( final String pUsername , final String pCommand ) {
        String cmd = "bash";
        CommandLine cmdLine = new CommandLine ( cmd );
        cmdLine.addArgument ( "-c " ).addArgument ( '${theCommand}' , false );

        Map m = new HashMap();
        m.put ('theCommand', pCommand );
        cmdLine.setSubstitutionMap ( m );
        DefaultExecutor executor = new DefaultExecutor ();
        
        ExecuteWatchdog watchdog = new ExecuteWatchdog(30000);
        executor.setWatchdog(watchdog);


        int exitValue = executor.execute ( cmdLine );
        if ( exitValue != 0 ) {
            throw new RuntimeException ( "Exception: return code = ${exitValue}" );
        }        
    }
static def executeSSH ( final String pUsername , final String pCommand ) {
        CommandLine command = new CommandLine ( 'ssh' );
        command.addArgument ("-o").addArgument("StrictHostKeyChecking=no").addArgument ( pUsername + "@localhost" ).addArgument ( '${theCommand}' , false );
        Map m = new HashMap();
        m.put ('theCommand', pCommand );
        command.setSubstitutionMap ( m );
        DefaultExecutor executor = new DefaultExecutor ();
	int exitValue = executor.execute ( command );
        if ( exitValue != 0 ) {
            throw new RuntimeException ( "Exception: return code = ${exitValue}" );
        }
    }
    
static def executeWithoutPrejudice ( final String pUsername , final String pCommand ) {
        CommandLine command = new CommandLine ( 'sudo' );
        command.addArgument ( '-iu' ).addArgument ( pUsername ).addArgument ( "bash" ).addArgument ( "-c " ).addArgument ( '${theCommand}' , false );
        Map m = new HashMap();
        m.put ('theCommand', pCommand );
        command.setSubstitutionMap ( m );
        DefaultExecutor executor = new DefaultExecutor ();
        try {
        int exitValue = executor.execute ( command );
        } catch (all) { assert true }
    }
    
static def deleteFolder ( final String pUsername , final Path pPathToFolder ) {
        this.execute ( pUsername , "rm -rf $pPathToFolder" );
    }

static def createFolder ( final String pUsername , final Path pPathToFolder ) {
        this.execute ( pUsername , "mkdir -p $pPathToFolder" );
    }

static def deployFile ( final String pUsername , final Path pPathToSource , final String pPathToTarget ) {
        assert ( Files.exists ( pPathToSource ) );
        final String ALL_PERMS                   = 'rwxrwxrwx';
        final Path   PATH_TO_INTERMEDIATE_FOLDER = Files.createTempDirectory ( 'ae_build_' + pUsername + '_' , PosixFilePermissions.asFileAttribute ( PosixFilePermissions.fromString ( ALL_PERMS ) ) );
        final Path   PATH_TO_INTERMEDIATE_FILE   = PATH_TO_INTERMEDIATE_FOLDER.resolve ( pPathToSource.getFileName().toString() );
        Files.setPosixFilePermissions ( PATH_TO_INTERMEDIATE_FOLDER , PosixFilePermissions.fromString ( ALL_PERMS ) );
        Files.copy ( pPathToSource , PATH_TO_INTERMEDIATE_FILE );
        Files.setPosixFilePermissions ( PATH_TO_INTERMEDIATE_FILE , PosixFilePermissions.fromString ( ALL_PERMS ) );
        this.execute ( pUsername , "cp $PATH_TO_INTERMEDIATE_FILE $pPathToTarget" );
        Files.delete ( PATH_TO_INTERMEDIATE_FILE );
        Files.delete ( PATH_TO_INTERMEDIATE_FOLDER );
    }

static def retrieveFile ( final String pUsername , final Path pPathToSourceFile , final Path pPathToTarget ) {
        final String ALL_PERMS                   = 'rwxrwxrwx';
        final Path   PATH_TO_INTERMEDIATE_FOLDER = Files.createTempDirectory ( 'ae_build_' + pUsername + '_' , PosixFilePermissions.asFileAttribute ( PosixFilePermissions.fromString ( ALL_PERMS ) ) );
        final Path   PATH_TO_INTERMEDIATE_FILE   = PATH_TO_INTERMEDIATE_FOLDER.resolve ( pPathToSourceFile.getFileName().toString() );
        Files.setPosixFilePermissions ( PATH_TO_INTERMEDIATE_FOLDER , PosixFilePermissions.fromString ( ALL_PERMS ) );
        this.execute ( pUsername , "cp $pPathToSourceFile $PATH_TO_INTERMEDIATE_FILE;chmod 777 $PATH_TO_INTERMEDIATE_FILE;" );        
        Files.copy ( PATH_TO_INTERMEDIATE_FILE , pPathToTarget );
        Files.delete ( PATH_TO_INTERMEDIATE_FILE );
        Files.delete ( PATH_TO_INTERMEDIATE_FOLDER );
    }
}
