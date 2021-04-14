package test;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;

import org.apache.commons.codec.binary.Base64;

public class TwoWayEncryption {

    private static String PWDSTRING = "g77MasterPassword";
    private static final byte[] SALT = {
        (byte) 0xde, (byte) 0x33, (byte) 0x10, (byte) 0x12,
        (byte) 0xde, (byte) 0x33, (byte) 0x10, (byte) 0x12,
    };
    
    public TwoWayEncryption (String masterPassword) {
    	TwoWayEncryption.PWDSTRING = masterPassword;
    }

    public static void main(String[] args) throws Exception {
    	System.out.println(decryptString("sN3JfbkTtvVw34fS2gSluw=="));
        
    }

	private static void runPassword(String Password) throws GeneralSecurityException, UnsupportedEncodingException, IOException {
		String originalPassword = Password;
        System.out.println("Original password: " + originalPassword);
        String encryptedPassword = encryptString (originalPassword , PWDSTRING );
        System.out.println("Encrypted password: encrypted:" + encryptedPassword);
//        String decryptedPassword = decryptString (encryptedPassword , PWDSTRING );
//        System.out.println("Decrypted password: " + decryptedPassword);
	}
    
    public static String encryptString ( String property ) throws Exception {
    	return encryptString (property, PWDSTRING) ;
    }

    public static String encryptString ( String property, String encryptionKey ) throws GeneralSecurityException, UnsupportedEncodingException {
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance( "PBEWithMD5AndDES" );
        SecretKey key = keyFactory.generateSecret(new PBEKeySpec( encryptionKey.toCharArray() ));
        Cipher pbeCipher = Cipher.getInstance( "PBEWithMD5AndDES" );
        pbeCipher.init(Cipher.ENCRYPT_MODE, key, new PBEParameterSpec( SALT, 20 ));
        return encodeBase64(pbeCipher.doFinal(property.getBytes( "UTF-8" )));
    }

	private static String encodeBase64(byte[] bytes) {
        new Base64();
		return Base64.encodeBase64String(bytes);
    }
    
    public static String decryptString ( String property ) throws Exception {
    	return decryptString (property, PWDSTRING) ;
    }

    public static String decryptString( String property, String encryptionKey  ) throws GeneralSecurityException, IOException {
        SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("PBEWithMD5AndDES");
        SecretKey key = keyFactory.generateSecret(new PBEKeySpec( encryptionKey.toCharArray() ));
        Cipher pbeCipher = Cipher.getInstance("PBEWithMD5AndDES");
        pbeCipher.init(Cipher.DECRYPT_MODE, key, new PBEParameterSpec(SALT, 20));
        return new String(pbeCipher.doFinal(base64Decode(property)), "UTF-8");
    }

	private static byte[] base64Decode(String property) throws IOException {
    	new Base64();
        return Base64.decodeBase64(property);
    }
}
