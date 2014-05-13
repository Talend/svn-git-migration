#!/bin/sh
gitRootPath=$1

if [ $# -lt 1 ]; then
	echo "need provide the Git root path."
	exit 1
fi

binaryReport="binary_files.log"
find . -type f -name "*.patch" | xargs grep "Binary files a/" | awk '{printf("%s %s\n",$1,$3)}' >$binaryReport

uniqBinaryReport="uniq-${binaryReport}"
find . -type f -name "*.patch" | xargs grep "Binary files a/" | awk '{printf("%s\n",$3)}' |  sort | uniq >$uniqBinaryReport

patches4gitReposReportFile="patches_gitRepos.log"

for patchFile in $(find . -type f -name "*.patch");
do
	projectNames=$(cat $patchFile | grep "diff --git a/" | awk '{printf("%s\n",$3)}' | awk -F '/' '{printf("%s\n",$2)}' | sort | uniq)
	
	echo -e "\n>>>$patchFile" | tee -a $patches4gitReposReportFile
	for p in $projectNames 
	do
		gitRepo=$(find $gitRootPath -type d -name "$p" | awk -F '/' '{printf("%s\n",$5)}')
		echo -e " $p   ---> $gitRepo"  | tee -a $patches4gitReposReportFile
	done

done
