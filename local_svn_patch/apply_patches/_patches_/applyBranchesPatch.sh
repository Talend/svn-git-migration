#!/bin/bash


curPath=$(cd $(dirname $0); pwd)
cd $curPath

logFile="$curPath/../LocalPatchMigration.log"
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

for branch in 5.3.1 5.4.1
do
	patchRootPath="$curPath/v$branch/"
	
	gitTagBaseName="release/$branch" #release/5.4.1
	patchBranchName="patch/$branch" #patch/5.4.1
	
	#Create patch branches
	__runCmd "$curPath/git_cmd.sh checkout -b $patchBranchName $gitTagBaseName"

	
	#Apply the patches
	applyPatchShFile="$patchRootPath/${branch//./}applyPatch.sh" #531applyPatch.sh
	if [ -f $applyPatchShFile ]; then # if have patches to do.
		__runCmd "$applyPatchShFile $gitRootPath $patchRootPath" "## apply patches on $patchBranchName"
	fi
	
	#push patch branches
	__runCmd "$curPath/git_cmd.sh push origin $patchBranchName" "$$ push patch branches for $patchBranchName" 

done

