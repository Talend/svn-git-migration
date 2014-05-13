#!/bin/sh

curPath=$(cd $(dirname $0); pwd)


gitRootPath="$curPath/../../"
patchRootPath="$curPath"

logFile="$curPath/$0.log"
if [ -e $logFile ]; then
	rm -f $logFile
fi


__logLine(){
	echo -e "\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++"  | tee -a $logFile
}

__logLine
sh $curPath/../createPatchBranch.sh  "$gitRootPath" "release-5_4_1" "patch/v5.4.1" 2>&1 | tee -a $logFile
__logLine
sh 541applyPatch.sh "$gitRootPath" "$patchRootPath"  2>&1  | tee -a $logFile
