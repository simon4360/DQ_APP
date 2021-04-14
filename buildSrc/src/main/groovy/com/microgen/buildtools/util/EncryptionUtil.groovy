package com.microgen.buildtools.util;

import uk.co.microgen.tomcat.EncryptedDataSourceFactory;

import com.microgen.buildtools.util.TwoWayEncryption;


public class EncryptionUtil {

    private static final TwoWayEncryption config = new TwoWayEncryption ();

    static String getEncryptedString ( final String pStringToEncrypt ) {
        return EncryptedDataSourceFactory.encode ( pStringToEncrypt );
    }

    static String getEncryptedPassword ( final String pStringToEncrypt ,  final String pMasterPassword ) {
        return config.encryptString ( pStringToEncrypt, pMasterPassword );
    }

    static String getDecryptedPassword ( final String pStringToDecrypt ,  final String pMasterPassword ) {
        return config.decryptString ( pStringToDecrypt , pMasterPassword );
    }
}
