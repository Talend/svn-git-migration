#!/bin/bash

# will do the diff for between preSHA and curSHA 
__gitDiff4SHA(){
	preSHA=$1
	curSHA=$2
	
	curPath="${workingPath}/${rep}"
	cd $curPath
	
	
	
	indexStr="${index}"
	if [ ${index} -lt 10 ]; then
		indexStr="0${index}" #make sure two bits
	fi
	
	patchPath="${workingPath}/-patches/${rep}"
	if [ ! -e $patchPath ]; then
		mkdir -p $patchPath
	fi
	
	resultFileName="${patchPath}/${indexStr}_${curSHA}"
	
	git diff ${preSHA}..${curSHA} > ${resultFileName}.patch	
	git log --pretty=format:'%h|%ad|%s' --graph --date=short | grep ${curSHA} | awk -F '|' '{print $3}' > ${resultFileName}.comment
	
	index=$((${index}+1))
}
# will do the diff for curSHA
__gitDiff4PreSHA(){
	curSHA=$1
	__gitDiff4SHA ${curSHA}^ ${curSHA}
}

# will do the diff from startSHA to HEAD
__gitDiffStartSHA(){
	startSHA=$1
	endSHA=$2
	if [ "X$endSHA" = "X" ]; then
		endSHA="HEAD"
	fi
	#do for current start SHA
	__gitDiff4PreSHA ${startSHA}
	
	for sha in $(git log --pretty=format:'%h' ${startSHA}..${endSHA}  | sed -e '1!G;h;$!d') ;
	do
		__gitDiff4PreSHA $sha
	done
}

#----------------------------------------------------------
workingPath=$(cd $(dirname $0); pwd)
cd $workingPath

#----------------------------------------------------------
rep="datastewardship"
index=1 # reset index
__gitDiffStartSHA "ce4dc51"  

#----------------------------------------------------------
rep="tdq"
index=1 # reset index
__gitDiff4PreSHA "a3294c9"
__gitDiff4SHA "a3294c9"  "8c9eb4a"
__gitDiffStartSHA "b488342"  "152ae30"
__gitDiff4SHA "152ae30"  "318580d"
__gitDiffStartSHA "91601b9"

#----------------------------------------------------------
rep="tem"
index=1 # reset index
__gitDiffStartSHA "7afe572"  

#----------------------------------------------------------
rep="tis_private"
index=1 # reset index
__gitDiffStartSHA "517258f"  

#----------------------------------------------------------
rep="tis_shared"
index=1 # reset index
__gitDiffStartSHA "1934523" 

#----------------------------------------------------------
rep="tom"
index=1 # reset index
__gitDiffStartSHA "5c7ffad" 

#----------------------------------------------------------
rep="top"
index=1 # reset index
__gitDiffStartSHA "53acfc1"  "0fab819"
__gitDiff4SHA "0fab819"  "fe3e5b9"
__gitDiffStartSHA "b173342" 

#----------------------------------------------------------
rep="tos"
index=1 # reset index
__gitDiffStartSHA "dffa571"  "6c08a07"
__gitDiff4SHA "6c08a07"  "7ef6a0a"
__gitDiffStartSHA "322d032" "1fbd3a4"
__gitDiff4SHA "1fbd3a4"  "98f5792"
__gitDiffStartSHA "465341c"
