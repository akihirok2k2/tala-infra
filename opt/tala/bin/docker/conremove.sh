#!/bin/bash
# FileName: vmcreate.sh

#set -e

logme () {
    exec </dev/null
    exec >$LOGDIR/$CMDNAME.$(date +%Y%m%d-%H%M%S).$$.log
    exec 2>&1
renice +20 -p $$
}

set -x 
CMDNAME=$(basename "$0")
CMDOPT=$*


FLG_H=
FLG_N=

if [ "$(id -u)" -ne 0 ];then
	echo 'This script is supposed to run under root.'
	exit 1
fi


PRINT_USAGE () {
    echo "usage: bash $CMDNAME [-H HostID]  [-n guest_machine_name] 
          -H: HostID
	  -n: container name"
    exit 1
}


TALADIR="/opt/tala"
LOGDIR="${TALADIR}/log/"
DOCKER="/usr/bin/docker"

#logme



## オプション値の確認
## 必要なオプションが空の場合、および不正なオプションがあった場合はスクリプトを終了

[ "$#" -ge 1 ] || PRINT_USAGE


while getopts H:n: OPT
do
	case ${OPT} in
		"H" ) FLG_H="TRUE" ; readonly CON_NUM="${OPTARG}" ;;
		"n" ) FLG_N="TRUE" ; readonly CON_NAME="${OPTARG}" ;;
		\? ) PRINT_USAGE ;; 
	esac
done




set +x
echo -------------------------------------
echo Container NAME $CON_NAME
echo -------------------------------------
set -x

if ${DOCKER} ps | grep -q ${CON_NAME} ;then 
    ${DOCKER} kill ${CON_NAME}
fi

${DOCKER} rm ${CON_NAME}

exit 0

