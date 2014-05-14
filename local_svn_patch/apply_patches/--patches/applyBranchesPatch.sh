#!/bin/sh


curPath=$(cd $(dirname $0); pwd)
cd $curPath

logFile="$curPath/${0##*/}.log"
if [ -e $logFile ]; then
	rm -f $logFile
fi

__logLine(){
	echo -e "\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++"  | tee -a $logFile
}

gitRootPath="$curPath/../"

for branch in 5.3.1 5.3.2 5.4.1
do
	patchRootPath="$curPath/v$branch/"
	
	gitTagBaseName="release-${branch//./_}" #release-5_3_1
	patchBranchName="patch/v$branch"
	
	#Create patch branches
	__logLine
	echo -e ">>>>>>>@@ Create patch branch $patchBranchName based on $gitTagBaseName"  | tee -a $logFile
	echo -e "\$sh $curPath/createPatchBranch.sh  $gitRootPath $gitTagBaseName $patchBranchName\n" | tee -a $logFile
	sh $curPath/createPatchBranch.sh  $gitRootPath $gitTagBaseName $patchBranchName  2>&1  | tee -a $logFile
	
	#Apply the patches
	applyPatchShFile="$patchRootPath/${branch//./}applyPatch.sh" #531applyPatch.sh
	if [ -f $applyPatchShFile ]; then # if have patches to do.
		__logLine
		echo -e ">>>>>>>## apply patches on $patchBranchName"  | tee -a $logFile
		echo -e "\$sh $applyPatchShFile $gitRootPath $patchRootPath\n"  | tee -a $logFile
		sh $applyPatchShFile $gitRootPath $patchRootPath   2>&1  | tee -a $logFile
	fi
	
	#pull patch branches
	__logLine
	echo -e ">>>>>>>## pull patch branches for $patchBranchName"  | tee -a $logFile
	echo -e "\$sh $curPath/git_cmd.sh push origin $patchBranchName\n"  | tee -a $logFile
	sh $curPath/git_cmd.sh push origin $patchBranchName 2>&1 | tee -a $logFile
done

