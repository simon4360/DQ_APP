package com.microgen.quality.db.code;

import com.microgen.quality.db.DBObjectConstants;
import com.microgen.quality.db.DBObjectUtils;
import com.microgen.quality.db.DuplicateFileReferencesException;
import com.microgen.quality.db.MultipleObjectNamesException;
import com.microgen.quality.db.NoObjectNameFoundException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;
import java.util.regex.Pattern;

import org.apache.commons.io.FilenameUtils;

public class TestCodeQuality
{
  //  private static final String  INSTALL_FILE_NAME   = "install.sql";
    private static final Pattern BTEQ_RUN_FILE_REGEX = Pattern.compile ( "(?<=\\.(run|compile) file = )[a-z0-9/_]*\\.sql" );
    private static final Pattern SQLPLUS_RUN_FILE_REGEX = Pattern.compile ( "[a-z0-9/_]*\\.sql" );
    

    private static List<File> getFilesReferencedByScript ( File pInstallFile ) throws DuplicateFileReferencesException , FileNotFoundException
    {
        List<File> referencedFiles = new ArrayList<File>();

        Scanner installFileScanner = new Scanner ( pInstallFile );

        while ( installFileScanner.hasNextLine() )
        {
            String temp = installFileScanner.findInLine ( TestCodeQuality.SQLPLUS_RUN_FILE_REGEX );
            
            if ( temp != null )
            {
                File sqlFile = new File ( pInstallFile.getParentFile() , temp );

                if ( referencedFiles.contains ( sqlFile ) )
                {
                    System.out.println ( "'" + pInstallFile + " contains multiple references to '" + sqlFile + "'." );

                    throw new DuplicateFileReferencesException();
                }

                referencedFiles.add ( sqlFile );
            }

            try
            {
                installFileScanner.nextLine();
            }
            catch ( NoSuchElementException nsele )
            {

            }
        }

        return referencedFiles;
    }
    
    private static List<File> getFilesReferencedByScript ( File pInstallFile, String pChild ) throws DuplicateFileReferencesException , FileNotFoundException
    {
        List<File> referencedFiles = new ArrayList<File>();

        Scanner installFileScanner = new Scanner ( pInstallFile );

        while ( installFileScanner.hasNextLine() )
        {
            String temp = installFileScanner.findInLine ( TestCodeQuality.SQLPLUS_RUN_FILE_REGEX );

            if ( temp != null &&  temp.indexOf("/") == -1 )
            {
                File sqlFile = new File ( pInstallFile.getParentFile() , temp );

                if ( referencedFiles.contains ( sqlFile ) )
                {
                    System.out.println ( "'" + pInstallFile + " contains multiple references to '" + sqlFile + "'." );

                    throw new DuplicateFileReferencesException();
                }
                         referencedFiles.add ( sqlFile );

            }

            try
            {
                installFileScanner.nextLine();
            }
            catch ( NoSuchElementException nsele )
            {

            }
        }

        return referencedFiles;
    }

    private static boolean isFileEmpty ( File pObjectFile ) throws FileNotFoundException , IOException
    {
        boolean isEmpty = true;

        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
              String  lastTextInFile    = null;

        objectFileScanner.useDelimiter("\\n");


        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.nextLine();

            if ( temp != null )
            {
                temp = temp.toLowerCase().trim();
            }

            if ( ! temp.equals ( "" ) )
            {
                isEmpty = false;
            }
        }

        return isEmpty;
    }

    private static boolean isFileEndedWithCommit ( File pObjectFile ) throws FileNotFoundException , IOException
    {
        boolean isPass = false;

        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
              String  lastTextInFile    = null;

        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.nextLine().toLowerCase().trim();

            if ( ! temp.equals ( "" ) )
            {
                lastTextInFile = temp;
            }
        }

        if ( lastTextInFile.equals ( "commit;" ) )
        {
            isPass = true;
        }

        return isPass;
    }
    
    private static boolean isFileEndedWithForwardSlash ( File pObjectFile ) throws FileNotFoundException , IOException
    {
        boolean isPass = false;

        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
              String  lastTextInFile    = null;

        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.nextLine().toLowerCase().trim();

            if ( ! temp.equals ( "" ) )
            {
                lastTextInFile = temp;
            }
        }

        if ( lastTextInFile.equals ( "/" ) )
        {
            isPass = true;
        }

        return isPass;
    }
    
    private static boolean hasPrimaryIndexDeclaration ( File pObjectFile ) throws FileNotFoundException , IOException
    {
        boolean isPass = false;

        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
              String  primaryIndexMatch = null;

        final Pattern primaryIndexPattern = Pattern.compile ( "primary(\\s)*index" , Pattern.CASE_INSENSITIVE );

        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.findInLine ( primaryIndexPattern );

            if ( temp != null )
            {
                isPass = true;
                break;
            }

            objectFileScanner.nextLine();
        }

        return isPass;
    }

    private static boolean hasPrimaryKeyDeclaration ( File pObjectFile ) throws FileNotFoundException , IOException
    {
        boolean isPass = false;

        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
              String  primaryIndexMatch = null;

        final Pattern primaryIndexPattern = Pattern.compile ( "primary(\\s)*key" , Pattern.CASE_INSENSITIVE );

        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.findInLine ( primaryIndexPattern );

            if ( temp != null )
            {
                isPass = true;
                break;
            }

            objectFileScanner.nextLine();
        }

        return isPass;
    }
    
    private static boolean hasTableSpaceDeclaration ( File pObjectFile ) throws FileNotFoundException , IOException
    {
        boolean isPass = false;

        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
              String  tableSpaceMatch = null;

        final Pattern tableSpacePattern = Pattern.compile ( "(TABLESPACE) [0-9]*[A-Za-z]*[0-9]*" , Pattern.CASE_INSENSITIVE );

        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.findInLine ( tableSpacePattern );

            if ( temp != null )
            {
                isPass = true;
                break;
            }

            objectFileScanner.nextLine();
        }

        return isPass;
    }

    private static boolean hasRIConstraintDeclarations ( File pObjectFile ) throws FileNotFoundException , IOException
    {
        boolean isPass = false;

        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pObjectFile ) ) );
              String  primaryIndexMatch = null;

        final Pattern primaryIndexPattern = Pattern.compile ( "foreign(\\s)*key" , Pattern.CASE_INSENSITIVE );

        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.findInLine ( primaryIndexPattern );

            if ( temp != null )
            {
                isPass = true;
                break;
            }

            objectFileScanner.nextLine();
        }

        return isPass;
    }

    public static final boolean testFileSetQuality ( final File pCodeRoot , final String pHostDirectoryName , final boolean pEndFilesWithCommit , final Pattern pDbNameRegex , final Pattern pObjectNameRegex , final boolean pAllowOneObjectNamePerFile , final boolean pAllowMultiStatementsPerFile )
    {
        boolean isPass = true;

        List<File> allSQLFiles = DBObjectUtils.populateListOfAllSQLFiles ( pCodeRoot );

        allSQLFiles.remove ( new File ( pCodeRoot , "full_install.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "upgrade_install.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "uninstall.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "cleardown.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "schema_comp_uninstall.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "refresh_objects.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "register_install_db_history.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "register_install_version.sql" ) );

        for ( File sqlFile : allSQLFiles )
        {
            File dbFolder         = DBObjectUtils.getDbFolder         ( sqlFile );
            File objectTypeFolder = DBObjectUtils.getObjectTypeFolder ( sqlFile );
            
            File blaa = new File ( pCodeRoot , pHostDirectoryName );
           
            if ( ( new File ( pCodeRoot , pHostDirectoryName ).equals ( objectTypeFolder ) ) )
            {
            	
            	  if ( FilenameUtils.removeExtension ( sqlFile.getName() ).replaceAll("cfcfg\\d*\\_", "").replaceAll("_cfcfg\\d*","").replaceAll("cfres\\d*\\_", "").length() > 30 ) {
                     System.out.println ( "The object name " + FilenameUtils.removeExtension ( sqlFile.getName() ) + " exceeds the maximum length allowed (" + FilenameUtils.removeExtension ( sqlFile.getName() ).length() + " > 30 char) "  );
                     isPass = false;
                }
                
                try
                {
                    if ( ! TestCodeQuality.isFileEmpty ( sqlFile ) && ! (sqlFile.getName().indexOf("install.sql") >=0) )
                    {
                        boolean isFileEndedWithCommit = TestCodeQuality.isFileEndedWithCommit ( sqlFile );

                        if ( ! isFileEndedWithCommit && pEndFilesWithCommit )
                        {
                            System.out.println ( "File " + sqlFile.getAbsolutePath() + " must end with a 'commit;' statement" );
                            isPass = false;
                        }
                        else
                        if ( isFileEndedWithCommit && ! pEndFilesWithCommit )
                        {
                            System.out.println ( "File " + sqlFile.getAbsolutePath() + " must not end with a 'commit;' statement" );
                            isPass = false;
                        }

                        try
                        {
                            String dbName         = DBObjectUtils.getMatchFromFile ( sqlFile , pDbNameRegex , pAllowOneObjectNamePerFile , pAllowMultiStatementsPerFile );
                            String expectedDbName = DBObjectUtils.getActualDbName ( dbFolder );

                            if ( ! expectedDbName.toUpperCase().equals ( dbName.toUpperCase() ) )
                            {
                                System.out.println ( "File " + sqlFile.getAbsolutePath() + " contains statements pertaining to the '" + dbName + "' database. It was expected that the statements would pertain to the '" + expectedDbName + "' database." );
                                isPass = false;
                            }
                        }
                        catch ( NoObjectNameFoundException nonf )
                        {
                            System.out.println ( "No database name was matched in file '" + sqlFile.getAbsolutePath() + "' using the regex: '" + pDbNameRegex + "'." );
                            isPass = false;
                        }
                        catch ( MultipleObjectNamesException mone )
                        {
                            System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' contains > 1 match for the regex used to find the database name: '" + pDbNameRegex + "'.");
                            isPass = false;
                        }

                        try
                        {
                            String objectName         = DBObjectUtils.getMatchFromFile ( sqlFile , pObjectNameRegex , pAllowOneObjectNamePerFile , pAllowMultiStatementsPerFile );
                            String expectedObjectName = FilenameUtils.removeExtension ( sqlFile.getName() ).replaceAll("cfcfg\\d*\\_", "").replaceAll("_cfcfg\\d*","").replaceAll("cfres\\d*\\_", "");

                            if ( ! objectName.toUpperCase().equals ( expectedObjectName.toUpperCase() ) )
                            {
                                System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' refers to the object '" + objectName + "'. '" + expectedObjectName + "' was the object's expected name." );
                                isPass = false;
                            }
                        }
                        catch ( NoObjectNameFoundException nonf )
                        {
                            System.out.println ( "No object name was matched in file '" + sqlFile.getAbsolutePath() + "' using the regex '" + pObjectNameRegex + "'." );
                            isPass = false;
                        }
                        catch ( MultipleObjectNamesException mone )
                        {
                            System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' contains > 1 match for the regex used to find the object name: '" + pObjectNameRegex + "'.");
                            isPass = false;
                        }

                        if ( pHostDirectoryName.equals ( "tables" ) )
                        {
                            if ( ! TestCodeQuality.hasPrimaryKeyDeclaration ( sqlFile ) )
                            {
                                System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' must be altered to explicitly declare a primary key." );
                                isPass = false;
                            }

                            if ( TestCodeQuality.hasRIConstraintDeclarations ( sqlFile ) )
                            {
                                System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' must be altered to remove the foreign key declarations. Place them in the 'ri_constraints' folder instead." );
                                isPass = false;
                            }
                            
                            if ( TestCodeQuality.hasTableSpaceDeclaration ( sqlFile ) && ! (sqlFile.getName().indexOf("arc.sql") >=0) )
                            {
                                System.out.println ( "Tablespace declaration must be removed from file '" + sqlFile.getAbsolutePath() + ". Currently only default tablespaces are used.");
                                isPass = false;
                            }
                        }
                        
                        if ( pHostDirectoryName.equals ( "indices" ) )
                        {                            
                            if ( TestCodeQuality.hasTableSpaceDeclaration ( sqlFile ) )
                            {
                                System.out.println ( "Tablespace declaration must be removed from file '" + sqlFile.getAbsolutePath() + ". Currently only default tablespaces are used.");
                                isPass = false;
                            }
                        }
                    }
                    else 
                    {
                    	  if ( ! (sqlFile.getName().indexOf("install.sql") >=0 ) ) {
                        System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' is empty. Either remove the file or add some content to it." );
                        isPass = false;
                      }
                    }
                }
                catch ( FileNotFoundException fnfe )
                {
                    System.out.println ( "FileNotFoundException: "+ fnfe + "." );
                    isPass = false;
                }
                catch ( IOException ioe )
                {
                    System.out.println ( "IOException : " + ioe + "." );
                    isPass = false;
                }
            }
        }

        return isPass;
    }


    public static final boolean testFileSetQuality ( final File pCodeRoot , final String pHostDirectoryName , final boolean pEndFilesWithCommit , final Pattern pDbNameRegex , final Pattern pObjectNameRegex , final boolean pAllowOneObjectNamePerFile , final boolean pAllowMultiStatementsPerFile, final boolean pEndFilesWithForwardSlash )
    {
        boolean isPass = true;

        List<File> allSQLFiles = DBObjectUtils.populateListOfAllSQLFiles ( pCodeRoot );

        allSQLFiles.remove ( new File ( pCodeRoot , "full_install.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "upgrade_install.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "uninstall.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "cleardown.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "schema_comp_uninstall.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "refresh_objects.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "register_install_db_history.sql" ) );
        allSQLFiles.remove ( new File ( pCodeRoot , "register_install_version.sql" ) );

        for ( File sqlFile : allSQLFiles )
        {
            File dbFolder         = DBObjectUtils.getDbFolder         ( sqlFile );
            File objectTypeFolder = DBObjectUtils.getObjectTypeFolder ( sqlFile );
            
            File blaa = new File ( pCodeRoot , pHostDirectoryName );
           
            if ( ( new File ( pCodeRoot , pHostDirectoryName ).equals ( objectTypeFolder ) ) )
            {
            	
            	  if ( FilenameUtils.removeExtension ( sqlFile.getName() ).length() > 30 ) {
                     System.out.println ( "The object name " + FilenameUtils.removeExtension ( sqlFile.getName() ) + " exceeds the maximum length allowed (" + FilenameUtils.removeExtension ( sqlFile.getName() ).length() + " > 30 char) "  );
                     isPass = false;
                }

                try
                {
                    if ( ! TestCodeQuality.isFileEmpty ( sqlFile ) && ! (sqlFile.getName().indexOf("install.sql") >=0) )
                    {
                        boolean isFileEndedWithCommit = TestCodeQuality.isFileEndedWithCommit ( sqlFile );

                        if ( ! isFileEndedWithCommit && pEndFilesWithCommit )
                        {
                            System.out.println ( "File " + sqlFile.getAbsolutePath() + " must end with a 'commit;' statement" );
                            isPass = false;
                        }
                        else
                        if ( isFileEndedWithCommit && ! pEndFilesWithCommit )
                        {
                            System.out.println ( "File " + sqlFile.getAbsolutePath() + " must not end with a 'commit;' statement" );
                            isPass = false;
                        }

                        boolean isFileEndedWithForwardSlash = TestCodeQuality.isFileEndedWithForwardSlash ( sqlFile );

                        if ( ! isFileEndedWithForwardSlash && pEndFilesWithForwardSlash )
                        {
                            System.out.println ( "File " + sqlFile.getAbsolutePath() + " must end with a '/' statement" );
                            isPass = false;
                        }
                        else
                        if ( isFileEndedWithForwardSlash && ! pEndFilesWithForwardSlash )
                        {
                            System.out.println ( "File " + sqlFile.getAbsolutePath() + " must not end with a '/' statement" );
                            isPass = false;
                        }

                        try
                        {
                            String dbName         = DBObjectUtils.getMatchFromFile ( sqlFile , pDbNameRegex , pAllowOneObjectNamePerFile , pAllowMultiStatementsPerFile );
                            String expectedDbName = DBObjectUtils.getActualDbName ( dbFolder );

                            if ( ! expectedDbName.toUpperCase().equals ( dbName.toUpperCase() ) )
                            {
                                System.out.println ( "File " + sqlFile.getAbsolutePath() + " contains statements pertaining to the '" + dbName + "' database. It was expected that the statements would pertain to the '" + expectedDbName + "' database." );
                                isPass = false;
                            }
                        }
                        catch ( NoObjectNameFoundException nonf )
                        {
                            System.out.println ( "No database name was matched in file '" + sqlFile.getAbsolutePath() + "' using the regex: '" + pDbNameRegex + "'." );
                            isPass = false;
                        }
                        catch ( MultipleObjectNamesException mone )
                        {
                            System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' contains > 1 match for the regex used to find the database name: '" + pDbNameRegex + "'." );
                            isPass = false;
                        }

                        try
                        {
                            String objectName         = DBObjectUtils.getMatchFromFile ( sqlFile , pObjectNameRegex , pAllowOneObjectNamePerFile , pAllowMultiStatementsPerFile );
                            String expectedObjectName = FilenameUtils.removeExtension ( sqlFile.getName() );

                            if ( ! objectName.toUpperCase().equals ( expectedObjectName.toUpperCase() ) )
                            {
                                System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' refers to the object '" + objectName + "'. '" + expectedObjectName + "' was the object's expected name." );
                                isPass = false;
                            }
                        }
                        catch ( NoObjectNameFoundException nonf )
                        {
                            System.out.println ( "No object name was matched in file '" + sqlFile.getAbsolutePath() + "' using the regex '" + pObjectNameRegex + "'." );
                            isPass = false;
                        }
                        catch ( MultipleObjectNamesException mone )
                        {
                            System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' contains > 1 match for the regex used to find the object name: '" + pObjectNameRegex + "'." );
                            isPass = false;
                        }

                        if ( pHostDirectoryName.equals ( "tables" ) )
                        {
                            if ( ! TestCodeQuality.hasPrimaryKeyDeclaration ( sqlFile ) )
                            {
                                System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' must be altered to explicitly declare a primary key." );
                                isPass = false;
                            }

                            if ( TestCodeQuality.hasRIConstraintDeclarations ( sqlFile ) )
                            {
                                System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' must be altered to remove the foreign key declarations. Place them in the 'ri_constraints' folder instead." );
                                isPass = false;
                            }
                        }
                    }
                    else 
                    {
                    	  if ( ! (sqlFile.getName().indexOf("install.sql") >=0 ) ) {
                        System.out.println ( "File '" + sqlFile.getAbsolutePath() + "' is empty. Either remove the file or add some content to it." );
                        isPass = false;
                      }
                    }
                }
                catch ( FileNotFoundException fnfe )
                {
                    System.out.println ( "FileNotFoundException: "+ fnfe + "." );
                    isPass = false;
                }
                catch ( IOException ioe )
                {
                    System.out.println ( "IOException : " + ioe + "." );
                    isPass = false;
                }
            }
        }

        return isPass;
    }

    public static final boolean testAllFilesAreUsedByInstallScript ( final File pInstallFile ) throws FileNotFoundException
    {
        boolean isPass = true;

        List<File> allSQLFiles = DBObjectUtils.populateListOfAllSQLFiles ( pInstallFile.getParentFile() );
        List<File> referencedFiles = new ArrayList<File>();
      
        try
        {
            referencedFiles.addAll ( TestCodeQuality.getFilesReferencedByScript ( pInstallFile ) );
            
            for ( File SqlFile : allSQLFiles )
            {
           
                if ( SqlFile.getName().indexOf("_install.sql") >= 0 ) 
                {
                    referencedFiles.addAll ( TestCodeQuality.getFilesReferencedByScript ( SqlFile ) );
                }
                     
            }

            for ( File referencedFile : referencedFiles )
            {
                if ( allSQLFiles.contains ( referencedFile ) )
                {
                    allSQLFiles.remove ( referencedFile );
                }
            }
        }
        catch ( DuplicateFileReferencesException dfre )
        {
            System.out.println ( "'" + pInstallFile + "' contains duplicate file references." );
            isPass = false;
        }

        if ( isPass )
        {
            allSQLFiles.remove ( pInstallFile );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "full_install.sql" ) );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "upgrade_install.sql" ) );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "uninstall.sql" ) );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "cleardown.sql" ) );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "schema_comp_uninstall.sql" ) );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "refresh_objects.sql" ) );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "register_install_db_history.sql" ) );
            allSQLFiles.remove ( new File ( pInstallFile.getParentFile() , "register_install_version.sql" ) );

            for ( File sqlFile : allSQLFiles )
            {
                if ( ! ( sqlFile.getName().indexOf("_uninstall.sql") >= 0 ) &&  ! ( sqlFile.getName().indexOf("00_install.sql") >= 0 ) )
                {
                    System.out.println ( "'" + sqlFile.getAbsolutePath() + "' is not referred to by the database installation scripts." );
                    isPass = false;
                }
            }
        }

        return isPass;
    }

    public static final boolean testAllFilesReferredToByInstallScriptsExist ( final File pInstallFile ) throws FileNotFoundException
    {
        boolean isPass = true;
        String isChildScript = "blaa";

        try
        {
            List<File> referencedFilesMain = TestCodeQuality.getFilesReferencedByScript ( pInstallFile );
            List<File> referencedFilesAll = TestCodeQuality.getFilesReferencedByScript ( pInstallFile );
            
            
            for ( File TopLevelReferencedFile : referencedFilesMain )
            {
                if ( TopLevelReferencedFile.getName().indexOf("_install.sql") >= 0 ) 
                {
                    referencedFilesAll.addAll ( TestCodeQuality.getFilesReferencedByScript ( TopLevelReferencedFile , isChildScript ) );
                }
            }

            for ( File referencedFile : referencedFilesAll )
            {
                if ( ! referencedFile.exists() )
                {
                    System.out.println ( "'" + pInstallFile.getAbsolutePath() + "' references non-existent file '" + referencedFile.getAbsolutePath() + "'." );
                    isPass = false;
                }
            }
        }
        catch ( DuplicateFileReferencesException dfre )
        {
            System.out.println ( "'" + pInstallFile + "' contains duplicate file references." );
            isPass = false;
        }

        return isPass;
    }
    
    public static boolean testQualityOfFiles ( final File pCodeRoot )
    {
        boolean isPass = true;

        List<File> allSQLFiles = DBObjectUtils.populateListOfAllSQLFiles ( pCodeRoot );

        for ( File sqlFile : allSQLFiles )
        {
            if ( ! sqlFile.getName().equals ( sqlFile.getName().toLowerCase() ) )
            {
                isPass = false;
                System.out.println ( "The name of file '" + sqlFile.getAbsolutePath() + "' must be in lowercase." );
            }
        }

        return isPass;
    }

    public static boolean testForBadEOL ( File pFile ) throws FileNotFoundException , IOException
    {
        boolean isPass = true;

        if ( pFile.isDirectory() )
        {
            final File[] sqlFiles = pFile.listFiles();

            for ( File sqlFile : sqlFiles )
            {
                isPass = ( testForBadEOL ( sqlFile ) && isPass );
            }
            return isPass;
        }
        else
        {

            if ( FilenameUtils.getExtension ( pFile.getCanonicalPath() ).toLowerCase().equals ( "sql" ) )
            {
                BufferedReader fileReader = new BufferedReader ( new FileReader ( pFile ) );

                int currentChar;

                while ( ( currentChar = fileReader.read() ) != -1 )
                {
                    if ( currentChar == '\r' )
                    {
                        currentChar = fileReader.read();

                        if ( ! ( currentChar == '\n' ) )
                        {
                            System.out.println ( "File \"" + pFile.getAbsolutePath() + "\" has some \"\\r\" end-of-line characters. Change these to \"\\r\\n\" or just \"\\n\"." );
                            isPass = false;
                            break;
                        }
                    }
                }

                fileReader.close();
            }
        }

        return isPass;
    }
}
