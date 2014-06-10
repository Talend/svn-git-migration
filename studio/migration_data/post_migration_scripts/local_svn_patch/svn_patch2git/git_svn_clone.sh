#!/bin/bash

workPath="$1"
branchName="$2"

if [ "$#" -lt 2 ]; then
	echo "Please provide the branch root path and branch name."
	exit 1
fi

cd "$workPath"



svnBaseURL="http://patchsvn.talend.lan/svn/${branchName}/"


for rep in tos tis_shared tis_private top tdq tom tem datastewardship
do
	git svn clone ${svnBaseURL}/${rep} --username talend
done
