#/bin/sh

if [ -z "$TB_HOME" ]; then
    echo '$TB_HOME not defined.\n'
    exit 1;
fi

ant -f $TB_HOME/src/client/tbgw/java/build.xml export
unzip -o $TB_HOME/client/bin/tbgateway.zip -d ~/bin
cp -f $TB_HOME/src/client/tbgw/java/lib/sqljdbc.jar ~/bin/tbJavaGW/lib
chmod +x ~/bin/tbJavaGW/tbgw
CWD=`pwd`
cd $TB_HOME/
svn revert src/client/tbgw/java/build.properties client/bin/tbgateway.zip
cd ~/bin/tbJavaGW/
./tbgw
cd $CWD
