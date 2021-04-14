# set Oracle home
#export ORACLE_HOME=/opt/oclient/default
export ORACLE_HOME=/opt/oclient/12.2.0.1/client_1

# set LD_LIBRARY path
if [ -z "$LD_LIBRARY_PATH" ] ; then
   export LD_LIBRARY_PATH=$ORACLE_HOME/lib
else
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
fi

unset JAVA_ROOT
export JAVA_HOME=/opt/java/default
export JAVA_BINDIR=/opt/java/default/bin
export PATH=${JAVA_BINDIR}:$PATH:$ORACLE_HOME/bin

umask u+xr,g+r,o=


