package com.microgen.quality.ut;

public class EnvironmentConstants
{
    public static final String  ENVIRONMENT              = System.getProperty ( "test.env" );
    public static final String  DB_CONNECTOR_STING       = System.getProperty ( "test.oracleJdbcUrl" );
    public static final String  APP_SERVER_NAME          = System.getProperty ( "test.aptitudeHost" );
    public static final String  APP_SERVER_OS_USERNAME   = System.getProperty ( "test.aptitudeLinuxUsername" );
    public static final String  APP_DEPLOYER_OS_USERNAME = System.getProperty ( "test.deployerUsername" );
    public static final String  ADMIN_USERNAME           = System.getProperty ( "test.aptitudeAdminUsername" );
    public static final String  ADMIN_PASSWORD           = System.getProperty ( "test.aptitudeAdminPassword" );  
    public static final String  APT_SRV_PORT             = System.getProperty ( "test.aptitudeServerPort");
    public static final String  APT_BUS_PORT             = System.getProperty ( "test.aptitudeBusPort");
    public static final String  G77_CFG_DB               = System.getProperty ( "test.g77_cfgUsername" );
    public static final String  G77_CFG_PASSWORD         = System.getProperty ( "test.g77_cfgPassword" );
	public static final String  G77_CFG_ARC_DB           = System.getProperty ( "test.g77_cfg_arcUsername" );
    public static final String  G77_CFG_ARC_PASSWORD     = System.getProperty ( "test.g77_cfg_arcPassword" );
    public static final String  G77_CFG_TEC_DB           = System.getProperty ( "test.g77_cfg_tecUsername" );
    public static final String  G77_CFG_TEC_PASSWORD     = System.getProperty ( "test.g77_cfg_tecPassword" ); 
    public static final String  VERSION_TO               = System.getProperty ( "test.versionTo" ); 
}