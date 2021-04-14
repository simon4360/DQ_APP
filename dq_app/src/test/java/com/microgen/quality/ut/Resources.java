package com.microgen.quality.ut;

import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.log4j.Logger;

public class Resources
{
    private static final Logger LOG = Logger.getLogger ( Resources.class );

    public static Path getPathToResource ( final String pPathToResource )
    {
        LOG.debug ( "Obtaining a path to the resource '" + pPathToResource + "'" );

        Path p = null;

        try
        {
            p = Paths.get ( Resources.class.getClassLoader ().getResource ( pPathToResource ).toURI () );

            LOG.debug ( "Path '" + p + "' obtained. The path does " + ( Files.exists ( p ) ? "" : " ***NOT*** " ) + " refer to a real resource" );

            assert ( Files.exists ( p ) );
        }
        catch ( URISyntaxException use )
        {
            LOG.debug ( "URISyntaxException + '" + use + "'" );

            assert ( false );
        }

        return p;
    }
}