package com.microgen.quality.ut;

import com.microgen.quality.tlf.server.IServerOperator;
import com.microgen.quality.tlf.server.SUDOServerOperator;
import com.microgen.quality.tlf.server.SSHServerOperator;

public class ServerOperatorFactory
{
    public static IServerOperator getServerOperator ()
    {
        return new SUDOServerOperator ();
    }
    
    public static IServerOperator getSSHServerOperator ()
    {
        return new SSHServerOperator ();
    }
}