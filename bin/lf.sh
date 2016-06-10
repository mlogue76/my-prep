#!/bin/sh

pid=`tbdown pid | awk -F : '/MTHR/ {print $1}'`
exec tail -f ${TB_HOME:?}/instance/${TB_SID:?}/tbsvr\.out\.${pid:?}
