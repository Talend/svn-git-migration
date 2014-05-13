#!/bin/sh

patchName=$1
if [[ $# < 1 ]]; then
	echo "Need patch branch Name."
	exit 1
fi



__doCMD(){
	sh git_cmd.sh "$@" 2>&1 | tee -a $logFile
	echo -e "\n\n ---------------------------------------------------------------------\n"  | tee -a $logFile
}
workRootPath=$(cd $(dirname $0); pwd)
cd $workRootPath

logFile="$workRootPath/$0.log"

if [ -d $logFile ]; then
	rm -f $logFile
fi

__doCMD co master
__doCMD reset --hard HEAD
__doCMD br -D $patchName
__doCMD st
