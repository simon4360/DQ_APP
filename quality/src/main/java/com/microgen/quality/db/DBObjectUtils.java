package com.microgen.quality.db;

import com.microgen.quality.db.MultipleObjectNamesException;
import com.microgen.quality.db.NoObjectNameFoundException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Scanner;
import java.util.regex.Pattern;

public final class DBObjectUtils
{
    public static List<String> getMatchesFromFile ( File pFile , Pattern pObjectNameRegex , boolean pAllowOnlyOneObjectName , boolean pAllowMultipleObjectNameMatches ) throws FileNotFoundException , MultipleObjectNamesException , NoObjectNameFoundException
    {
        final Scanner objectFileScanner = new Scanner ( new BufferedReader ( new FileReader ( pFile ) ) );
        List<String>  objectNames       = new ArrayList<String>();

        while ( objectFileScanner.hasNextLine() )
        {
            String temp = objectFileScanner.findInLine ( pObjectNameRegex );

            if ( temp != null )
            {
                if ( objectNames.isEmpty() )
                {
                    objectNames.add ( temp );
                }
                else
                {
                    if ( pAllowOnlyOneObjectName && pAllowMultipleObjectNameMatches )
                    {
                        if ( objectNames.contains ( temp ) )
                        {
                            objectNames.add ( temp );
                        }
                        else
                        {
                            throw new MultipleObjectNamesException();
                        }
                    }

                    if ( pAllowOnlyOneObjectName && ! pAllowMultipleObjectNameMatches )
                    {
                        throw new MultipleObjectNamesException();
                    }

                    if ( ! pAllowOnlyOneObjectName && ! pAllowMultipleObjectNameMatches )
                    {
                        if ( ! objectNames.contains ( temp ) )
                        {
                            objectNames.add ( temp );
                        }
                        else
                        {
                            throw new MultipleObjectNamesException();
                        }
                    }

                    if ( ! pAllowOnlyOneObjectName && pAllowMultipleObjectNameMatches )
                    {
                        objectNames.add ( temp );
                    }
                }
            }

            try
            {
                objectFileScanner.nextLine();
            }
            catch ( NoSuchElementException nsele )
            {

            }
        }

        if ( objectNames.isEmpty() )
        {
            throw new NoObjectNameFoundException();
        }

        return objectNames;
    }

    public static String getMatchFromFile ( File pFile , Pattern pObjectNameRegex , boolean pAllowOnlyOneObjectName , boolean pAllowMultipleObjectNameMatches ) throws FileNotFoundException , MultipleObjectNamesException , NoObjectNameFoundException
    {
        return DBObjectUtils.getMatchesFromFile ( pFile , pObjectNameRegex , pAllowOnlyOneObjectName , pAllowMultipleObjectNameMatches ).get ( 0 );
    }

    public static List<File> populateListOfAllSQLFiles ( File pSearchRoot )
    {
        List<File> allSQLFiles = new ArrayList<File>();

        final File[] sqlFiles = pSearchRoot.listFiles();

        for ( File sqlFile : sqlFiles )
        {
            if ( sqlFile.isDirectory() )
            {
                allSQLFiles.addAll ( DBObjectUtils.populateListOfAllSQLFiles ( sqlFile ) );
            }
            else
            {
                if ( sqlFile.getName().endsWith ( ".sql" ) )
                {
                    allSQLFiles.add ( sqlFile );
                }
            }
        }

        return allSQLFiles;
    }

    public static File getDbFolder ( final File pSqlFile )
    {
        File dbFolder = new File ( pSqlFile.getPath() );

        while ( ! dbFolder.getParentFile().getName().equals ( "db" ) )
        {
            dbFolder = dbFolder.getParentFile();
        }

        if ( dbFolder.getParentFile().getName().equals ( "grants" ) )
        {
            dbFolder = new File ( pSqlFile.getPath() );

            while ( ! dbFolder.getParentFile().getParentFile().getName().equals ( "db" ) )
            {
                dbFolder = dbFolder.getParentFile();
            }            
        }
        return dbFolder;
    }

    public static File getObjectTypeFolder ( final File pSqlFile )
    {
        File objectTypeFolder = new File ( pSqlFile.getPath() ).getParentFile();
        File dbRootFolder = new File ( pSqlFile.getPath() ).getParentFile();
        String grantObjectType = new String();
        
        while ( ! objectTypeFolder.getParentFile().getName().equals ( "db" ) )
        {
            if ( objectTypeFolder.getParentFile().getName().equals ( "grants" ) ) 
            {
                grantObjectType = objectTypeFolder.getParentFile().getName();
            }
            
            dbRootFolder = objectTypeFolder.getParentFile().getParentFile();
            objectTypeFolder = objectTypeFolder.getParentFile();
        }

        objectTypeFolder = new File ( dbRootFolder, grantObjectType ) ;

        return  new File ( objectTypeFolder ,  pSqlFile.getParentFile().getName() ) ;
        
    }
    
    public static String getActualDbName ( final File pDbFolder )
    {
        String dbFolderName = pDbFolder.getName();
        String actualDbName = null;

        if ( dbFolderName.equals ( "g77_cfg" ) )
        {
            actualDbName = System.getProperty ( "test.g77_cfgUsername" );
        }      

        if ( dbFolderName.equals ( "g77_cfg_arc" ) )
        {
            actualDbName = System.getProperty ( "test.g77_cfg_arcUsername" );
        }

        return actualDbName;
    }
}
