package com.microgen.quality.ut;

import com.microgen.quality.ut.EnvironmentConstants;
import com.microgen.quality.tlf.string.ITokenReplacement;

public class TokenReplacement implements ITokenReplacement
{
    public String replaceTokensInString ( final String pString )
    {
        return pString.replaceAll ( "@g77_cfgUsername@" , EnvironmentConstants.G77_CFG_DB )
                      .replaceAll ( "@g77_cfg_tecUsername@", EnvironmentConstants.G77_CFG_TEC_DB )
                      .replaceAll ( "@versionTo@"   , EnvironmentConstants.VERSION_TO )
        ;

    }
}
