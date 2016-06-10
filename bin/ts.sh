#!/bin/sh

pushd `pwd`
cd $TB_HOME/src/autoconf
touch *
jam
cd $TB_HOME/src
cat > Jamrules.local <<EOF
DEFS_ADD += [ FDefines _DONT_CHECK_LICENSE ] ;
SKIP_ANT_CHECK = true ;
SKIP_ANT_GEN_CHECK = true ;
EOF
echo "CXXFLAGS += -fno-tree-sink ;" >> JamConfig
cd $TB_HOME/tools
ln -f -s /home/hyunsoo_chang/workspace/prebuilt
cd $TB_HOME/src
jam tool
popd
