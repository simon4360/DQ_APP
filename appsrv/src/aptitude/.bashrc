# set Oracle home
#export ORACLE_HOME=/opt/oclient/default
export ORACLE_HOME=/opt/oclient/12.2.0.1/client_1

# set LD_LIBRARY path
if [ -z "$LD_LIBRARY_PATH" ] ; then
   export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib64
else
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib:/usr/lib64
fi

umask u+xr,g+x,o=

unset JAVA_ROOT
export JAVA_HOME=/opt/java/default
export JAVA_BINDIR=/opt/java/default/bin
export ODBCINI=@pathToInstance@odbc/.odbc.ini

# Set Aptitude environment variables
export BATCH_SCRIPTS=${HOME}/batchScripts
export APT_SCRIPTS=${HOME}/scripts
export APT_PROFILE=${APT_SCRIPTS}/profile.sh

export PATH=${PATH}:/bin:/usr/bin:/usr/local/bin:${JAVA_BINDIR}:${ORACLE_HOME}/bin:/usr/bin:${APT_SCRIPTS}:${BATCH_SCRIPTS}

# Load Aptitude environment
if [[ -x ${APT_PROFILE} ]]
then
 . ${APT_PROFILE}
fi
