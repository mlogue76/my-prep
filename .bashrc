# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Terminal
export TERM=xterm-color

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=yes'
    alias dir='ls --color=auto --format=vertical'
    alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias h='history'
alias cp='cp -i'
alias mv='mv -i'
alias emacs='emacs -nw'
alias nw='ls -lt | head -5'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Less
export PAGER="less -R"
#export LESSCHARSET=latin1
export JLESSCHARSET=euc

# User specific aliases and functions
ulimit -c unlimited

alias dir="ls -al --color=tty"
alias tiberoshare='smbclient //192.1.1.115/tibero smbuser_6 -U smbuser_f'

# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

function set_prompt ()
{
    PS1=$"[$1] ${Green}\u@\h ${Yellow}\w${Color_Off}\n$ "
    export PS1
    export PROMPT_COMMAND=""
}

# Tibero Development Enviroments
tb ()
{
    if [ $# -eq 2 ]
    then
        local sid=$2
    else
        local sid=$1
    fi

    local base=~/tibero/$1

    echo $base

    if [ -d $base ]; then
        source $base/tbenv $base $sid \
            && set_prompt `echo $sid | tr '[:lower:]' '[:upper:]'`
    fi
}

tb sp1 # default

EDITOR=vim
export EDITOR

# splint
LARCH_PATH=.:/usr/local/share/splint/lib
LCLIMPORTDIR=/usr/local/share/splint/imports

# java
JDK6_HOME=/usr/lib/jvm/java-6-openjdk-amd64
JAVA_HOME=$JDK6_HOME
#JAVA_HOME=~/jdk1.8.0_65
PATH=$JAVA_HOME/bin:$PATH
export JDK6_HOME JAVA_HOME PATH

# user bin dir
PATH=/home/ktlee/bin:$PATH
export PATH

# Developers Command Aliases

# callgrind
alias callgrind='callgrind --collect-jumps=yes --trace-children=yes --simulate-cache=yes'
alias valgrind='valgrind -v --suppressions=$TB_HOME/src/scripts/tbsvr-valgrind.supp --trace-children=yes --log-file=VGLOG --leak-check=full --show-reachable=yes'

if [ -f "$TB_HOME"/dev-util/bashrc ]; then
    . "$TB_HOME"/dev-util/bashrc
fi

# Tibero-src-independent Command Aliases

alias ver='strings $TB_HOME/bin/tbboot | grep Build'
alias si='echo $TB_SID'
alias sd='svn diff --diff-cmd=svndiff'
alias tn='tb_newmount.sh'

stty erase ^H

# ANT
export ANT_HOME=/usr/share/ant

LS_COLORS="no=00:fi=00:di=36:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:*.c=02;33:*.h=02;36:*.o=02;35"
export LS_COLORS

set -o ignoreeof

#export ALTIBASE_HOME=/home/altibase
#export PATH=$PATH:$ALTIBASE_HOME/bin
#
#export SAMPLER_HOME=/bighome/sampler
#
#export DIST_HOME=~/dist

export SVN_EDITOR=$TB_HOME/dev-util/svn-log-format.sh

#export ORACLE_HOME=/home/oracle/BASE/product/11.1.0/db_1
#export ORACLE_SID=orcl
#export PATH=$PATH:$ORACLE_HOME/bin
#export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$TB_HOME/lib:$TB_HOME/client/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH_64=$ORACLE_HOME/lib:$TB_HOME/lib:$TB_HOME/client/lib:$LD_LIBRARY_PATH_64
#export ORAINCDIR=$ORACLE_HOME/rdbms/public
#export ORALIBDIR=$ORACLE_HOME/lib
#source ~/bin/oraenv.sh

export TB_MSGW_HOME=$HOME/bin/tbJavaGW

# Language and Locale
export LANG=ko_KR.euckr
#export TB_NLS_LANG=MSWIN949

function jc()
{
    local i=0
    local start=${1:-0}

    shift
    local end=${1:-0}

    shift
    local ch=0
    local org=`pwd`

    #tbdown abnormal

    # for d in `find $TB_HOME/src ! \( -type d -name "nbsvr" -prune \) -a -type d -name "tests" | xargs -L 1 dirname | sort`; do

    for d in `find $TB_HOME/src ! \( -type d -name "nbsvr" -prune \) \
                   -a -type f -name "Jamfile"                        \
              | xargs grep -l "^ *\<Fit\|^ *\<ScriptTest\>"          \
              | xargs -L 1 dirname | sort | uniq`
    do
        i=$(($i+1))
        name=`echo $d | sed -e "s,$TB_HOME/src/,,g"`
        [ $start = "0" ] && echo "$i. $name" && continue
        if [ "$i" = "$start" ] || expr $name : ".*/$start/.*" >/dev/null 2>&1
        then
            ch=1;
        fi

        [ $ch -eq 0 ] && continue

        cd $d

        echo "-----------------------------------------------------------------"
        echo "$i. check started. $name"

        jam -sCHECK_OPT=-s check

        if [ $? -ne 0 ]; then
            echo "$i ($name) FAIL. "
            return
        fi

        echo "checked successfully. $name"
        echo "-----------------------------------------------------------------"
        echo ""

        if [ "$i" = "$end" ] || expr $name : ".*/$end/.*" >/dev/null 2>&1
        then
            return;
        fi
    done

    if [ $ch -eq 0 ]; then
        echo ""
        echo "Usage: jc start_module [end module] "
        echo "Example:"
        echo " \$jc 1           : check all module"
        echo " \$jc 3           : check all module after 3th"
        echo " \$jc opt tc      : check from opt to tc"
        echo " \$jc 3 4         : check from 3th to 5th"
    fi

    cd $org
}

function irm()
{
    for m in `ipcs -m | awk '/'$USER'/ {print $2}'`
    do
        ipcrm -m $m
    done
    for m in `ipcs -s | awk '/'$USER'/ {print $2}'`
    do
        ipcrm -s $m
    done
}

# Python
export PYTHONSTARTUP=$HOME/.pythonrc
export KIT_DIR=/home/ktlee/tibero/tpch/dev-util/tpch

alias rb='tbdown abort; tbboot'
alias ab='tbdown abnormal'

export TBGW=HOME=$TB_HOME/client/bin

## Solidbase (Fasoo)
#export FSB_LIB_PATH=/home/fasoo/solidbase/platformlib/linux/x64
##/bighome/tibero/fasoo/tools/lib
#export FCW_CRYPTO_BASE=/home/fasoo/solidbase/platformlib/linux/x64
#export FCW_CRYPTO_PATH=$FSB_LIB_PATH/libfcw_crypto2.so
#export PATH=$FCW_CRYPTO_BASE:$PATH
#export LD_LIBRARY_PATH=$FSB_LIB_PATH:$LD_LIBRARY_PATH

#export VALGRIND_OPTS='-v --num-callers=10 --trace-children=yes --log-file=VGLOG --error-limit=no --leak-check=yes --suppressions=/tmp/tibero-valgrind.supp'
