#!/bin/bash

gitRootPath=$1
gitTagBaseName=$2
patchBranchName=$3

#gitTagBaseName="release-5_4_1"
#patchBranchName="patch/v5.4.1"

__createBranch(){
	rep=$1
	addition=$2
	
	repFolder="${gitRootPath}/$rep"
	if [ ! -d $repFolder ]; then
		return 1 #not existed
	fi
	
	cd $repFolder
	echo -e "\n ----> $(pwd)"
	
	git checkout -b ${patchBranchName} ${gitTagBaseName}${addition}
	
	return 0

}

__createBranch tamc-ee _tis_shared

__createBranch tbd-studio-ee _tis_shared

__createBranch tbd-studio-se _tos

__createBranch tcommon-studio-ee _tis_shared
if [ $? -eq 0 ]; then #existed
	git merge --no-commit ${gitTagBaseName}_tis_private
	git add .
	git commit -m "Merged ${gitTagBaseName}_tis_private and ${gitTagBaseName}_tis_shared"
	git merge --no-commit ${gitTagBaseName}_tos
	git add .
	git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tis_private"
fi

__createBranch tcommon-studio-se _tos
if [ $? -eq 0 ]; then #existed
	git merge --no-commit ${gitTagBaseName}_tis_shared
	git add .
	git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tos"
fi

__createBranch tdi-studio-ee _tis_shared

__createBranch tdi-studio-se _tos

__createBranch tdq-studio-ee _tdq
if [ $? -eq 0 ]; then #existed
	git merge --no-commit ${gitTagBaseName}_tis_shared
	git add .
	git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tdq"
	git merge --no-commit ${gitTagBaseName}_tos
	git add .
	git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tdq"
fi

__createBranch tdq-studio-se _top
if [ $? -eq 0 ]; then #existed
	git merge --no-commit ${gitTagBaseName}_tos
	git add .
	git commit -m "Merged ${gitTagBaseName}_tos and ${gitTagBaseName}_top"
fi

__createBranch tdsc _datastewardship

__createBranch tesb-studio-ee _tis_shared

__createBranch tesb-studio-se _tos

__createBranch tmdm-common _tom

__createBranch tmdm-server-ee _tem

__createBranch tmdm-server-se _tom

__createBranch tmdm-studio-ee _tem
if [ $? -eq 0 ]; then #existed 
	git merge --no-commit ${gitTagBaseName}_tis_shared
	git add .
	git commit -m "Merged ${gitTagBaseName}_tis_shared and ${gitTagBaseName}_tem"
fi

__createBranch tmdm-studio-se _tom
if [ $? -eq 0 ]; then #existed 
	git merge --no-commit ${gitTagBaseName}_tem
	git add .
	git commit -m "Merged ${gitTagBaseName}_tem and ${gitTagBaseName}_tom"
fi

__createBranch toem-studio-ee _tis_shared

__createBranch toem-studio-se _tos

