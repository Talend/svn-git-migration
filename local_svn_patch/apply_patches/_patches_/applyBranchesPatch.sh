#!/bin/bash


curPath=$(cd $(dirname $0); pwd)
cd $curPath

logFile="$curPath/${0##*/}.log"
if [ -e $logFile ]; then
	rm -f $logFile
fi

__runCmd(){
	cmd=$1
	message=$2

	if [ "X$cmd" = "X" ]; then
		return 1
	fi

	echo -e "\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++"  | tee -a $logFile
	echo -e ">>>>>>>${message}\n\$sh ${cmd}\n"  | tee -a $logFile
	/bin/bash $cmd  2>&1  | tee -a $logFile
}

gitRootPath="$curPath/../"

for branch in 5.3.1 5.3.2 5.4.1
do
	patchRootPath="$curPath/v$branch/"
	
	gitTagBaseName="release-${branch//./_}" #release-5_3_1
	patchBranchName="patch/v$branch"
	
	#Create patch branches
	__runCmd "$curPath/createPatchBranch.sh  $gitRootPath $gitTagBaseName $patchBranchName" "@@ Create patch branch $patchBranchName based on $gitTagBaseName"

	
	#Apply the patches
	applyPatchShFile="$patchRootPath/${branch//./}applyPatch.sh" #531applyPatch.sh
	if [ -f $applyPatchShFile ]; then # if have patches to do.
		__runCmd "$applyPatchShFile $gitRootPath $patchRootPath" "## apply patches on $patchBranchName"
	fi
	
	#push patch branches
	__runCmd "$curPath/git_cmd.sh push origin $patchBranchName" "$$ push patch branches for $patchBranchName" 

done

