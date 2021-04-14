package com.microgen.buildtools.appsrv.aptitude;

public class AptitudeServerConstants {

    /*
     Following functions define the application server install and runtime structure
    */
    
    static def String getPathToBase () {
        return "/opt/aptitude/";
    }
    
    static def String getRuntimePath () {
        return "~/aptitude/";
    }   

    static def String getPathToApmId ( final String pApmId ) {
        return AptitudeServerConstants.getPathToBase () + pApmId  + '/'
    }
    
    static def String getPathToInstance        ( final String pApmId , final String pLinuxUserName ) {
        return AptitudeServerConstants.getPathToBase () + pApmId  + '/' + pLinuxUserName + '/'
    }

    static def String getPathToBaseCopy ( final String pAptitudeVersion ) {
        return AptitudeServerConstants.getPathToBase () + 'aptitude-' + pAptitudeVersion + '/'
    }
  
    static def String getPathToBackup          ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'backup/'
    }
 
    static def String getPathToBackupEngine    ( final String pEnv ) {
        return AptitudeServerConstants.getPathToBackup()          + 'engine/'
    }

    static def String getPathToBackupServer    ( final String pEnv ) {
        return AptitudeServerConstants.getPathToBackup()          + 'server/'
    }
 
    /* Link to Base */
    static def String getPathToBin             ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'bin/'
    }
    static def String getPathToAptCmd          ( final String pEnv ) {
        return AptitudeServerConstants.getPathToBin()             + 'aptcmd'
    }

    static def String getPathToAptsrv          ( final String pEnv ) {
        return AptitudeServerConstants.getPathToBin()             + 'aptsrv'
    }
    
    static def String getPathToDbDir           ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath ( )         + 'db/'
    }

    static def String getPathToDbBusDir        ( final String pEnv ) {
        return AptitudeServerConstants.getPathToDbDir ( pEnv )    + 'bus/'
    }
    
    static def String getPathToDbServerDir     ( final String pEnv ) {
        return AptitudeServerConstants.getPathToDbDir ( pEnv )    + 'server/'
    }

    static def String getPathToSqliteDir       ( final String pEnv ) {
        return AptitudeServerConstants.getPathToDbDir ( pEnv )    + 'server_sqlite/'
    }

    static def String getPathToIni             ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'ini/'
    }
    
    static def String getPathToLib             ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'lib/'
    }
    
    static def String getPathToLibexecDir      ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'libexec/'
    }

    static def String getPathToLockDir         ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'lock/'
    }
    
    static def String getPathToLogDir          ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'log/'
    }

    static def String getPathToRecordingDir    ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'recording/'
    }

    static def String getPathToShareDir        ( final String pEnv ) {
        return AptitudeServerConstants.getRuntimePath()           + 'share/'
    }    
    
    static def String getPathToData            ( final String pApmId ) {
        return AptitudeServerConstants.getPathToBase() + pApmId + '_data_in/'
    }

    static def String getPathToDataArc         ( final String pApmId ) {
        return AptitudeServerConstants.getPathToBase() + pApmId + '_data_arc/'
    }

    static def String getPathToLogs            ( final String pEnv ) {
        return  '~/logs/'
    }
    static def String getPathToScripts         ( final String pEnv ) {
        return  '~/scripts/'
    }
    static def String getPathToTempUploadDir   ( final String pEnv ) {
        return  '~/tmp/'
    }
    
    static def String getPathToFileBeatInstance   ( final String pApmId  ) {
        return '/opt/filebeat/'+ pApmId  + '/etc/'
    }
}
