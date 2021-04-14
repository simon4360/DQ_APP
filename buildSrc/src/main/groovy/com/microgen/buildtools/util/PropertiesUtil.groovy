package com.microgen.buildtools.util;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;
import java.nio.charset.Charset;
import java.util.Properties;

public class PropertiesUtil {
    static Properties getProperties ( final Path pPathToPropertiesFile ) {
        assert ( Files.exists ( pPathToPropertiesFile ) );
        Properties props = new Properties();
        props.load ( Files.newInputStream ( pPathToPropertiesFile ) );
        return props;
    }
    
    static void setProperty ( final Path pPathToPropertiesFile, final String pProperty, final String pOldValue, final String pNewValue ) {
        
        Charset charset = StandardCharsets.UTF_8;

        String content = new String ( Files.readAllBytes ( pPathToPropertiesFile ), charset );
        content = content.replaceAll ( pProperty + "=" + pOldValue, pProperty + "=" + pNewValue );
        Files.write ( pPathToPropertiesFile, content.getBytes ( charset ) )
    }
}