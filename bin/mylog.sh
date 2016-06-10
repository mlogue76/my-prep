#!/bin/sh

function usage(){
    echo "Usage: $0 [-v] [-u <username>] [-d <n>] [-h]"
    echo "  -v    svn log의 v 옵션을 켠다"
    echo "  -u    username을 명시한다. default는 whoami 결과"
    echo "  -d    n weeks 전부터 지금(HEAD)까지의 결과를 출력한다. default는 1"
    echo "  -h    이 도움말을 표시하고 끝낸다"
    exit 1
}

d='1'
o=
u=`whoami`

while getopts u:d:vh OPTION
do
  case ${OPTION} in
  d) d=${OPTARG};;
  v) o="-v";;
  u) u=${OPTARG};;
  h) usage;;
  esac
done

begin="date +{%Y-%m-%d} -d '"$d" weeks ago'"
svn log ${o} -r`eval $begin`:HEAD http://svn/tibero |\
awk 'BEGIN {
    out = 0
}
{
    if (out == 0 && /\| '"$u"' \|/) {
        print $0
        out = 1;
    }
    else if (out == 1 && /-----------------------------------/) {
        print $0
        out = 0;
    }
    else if (out == 1) {
        print $0
    }
}'
