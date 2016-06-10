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
