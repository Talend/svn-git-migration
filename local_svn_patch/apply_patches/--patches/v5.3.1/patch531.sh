#!/bin/sh

curPath=$(pwd)
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
sh $curPath/../createPatchBranch.sh  "$gitRootPath" "release-5_3_1" "patch/v5.3.1"  2>&1  | tee -a $logFile
__logLine
sh 531applyPatch.sh "$gitRootPath" "$patchRootPath"   2>&1  | tee -a $logFile
