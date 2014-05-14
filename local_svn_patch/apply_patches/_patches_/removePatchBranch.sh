#!/bin/bash

__doCMD(){
	sh git_cmd.sh "$@" 2>&1 | tee -a $logFile
	echo -e "\n\n ---------------------------------------------------------------------\n"  | tee -a $logFile
}

workRootPath=$(cd $(dirname $0); pwd)
cd $workRootPath

logFile="$workRootPath/${0##*/}.log"
if [ -d $logFile ]; then
	rm -f $logFile
fi

__doCMD checkout master
__doCMD reset --hard HEAD
for branch in 5.3.1 5.3.2 5.4.1
do
	__doCMD branch -D patch/v$branch
done
__doCMD st


