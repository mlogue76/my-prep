# Set ORACLE_HOME to the directory where the bin and lib directories are located for the oracle client
export ORACLE_HOME=/usr/lib/oracle/10.2.0.4/client64
 
# No need to add ORACLE_HOME to the linker search path. oracle-instant-client.conf in
# /etc/ld.so.conf.d should already contain /usr/lib/oracle/11.2/client64.
# Alternately, you can set it here by uncommenting the following line:
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
 
# Define the default location where Oracle should look for the server
export TWO_TASK=//192.1.1.111:1521/listener
 
# Define where to find the tnsnames.ora file
export TNS_ADMIN=/etc/oracle
