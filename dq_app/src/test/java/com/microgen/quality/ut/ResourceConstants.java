package com.microgen.quality.ut;

import com.microgen.quality.ut.Resources;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public enum ResourceConstants
{
   //   e.g. SLR_ENTITIES_INITIALIZED                   ( Resources.getPathToResource ( "testing/general/init/slr_entities_exist.sql" ) ) 
    
    ;

    private Path pathToResource;

    ResourceConstants ( final Path pPathToResource )
    {
        this.pathToResource  = pPathToResource;
    }

    public Path getPathToResource ()
    {
        return pathToResource;
    }
}