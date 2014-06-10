#! /bin/bash

cd ../migration_data/branches

#
declare -a branchesArray
i=1
branchesFolders=`ls | sort`
for bFolder in ${branchesFolders};
do
	if [ -d $bFolder ]; then
		branchesArray[i]=${bFolder}
		i=$(($i+1))	
	fi
done

#clean all diff files
find . -type f -name "*.diff" | xargs rm -rf

#
for((i=1;i<${#branchesArray[*]};i++));
do
	echo -e "\nCompare between ${branchesArray[i]} and ${branchesArray[i+1]}....\n"
	curVer=${branchesArray[i]##*-}
	nextVer=${branchesArray[i+1]##*-}
	
	#Special for master(trunk)
	if [ "${nextVer}" == "${branchesArray[i+1]}" ]; 
	then
		nextVer="trunk"
	fi
	
	
	for repo in tos top tom tis_shared tis_private tdq tem 
	do 
		curVerFile="${branchesArray[i]}/svn/${repo}.${curVer}.sorted"
		nextVerFile="${branchesArray[i+1]}/svn/${repo}.${nextVer}.sorted"
		curDiffFile="${branchesArray[i]}/svn/${repo}-${branchesArray[i+1]}-${branchesArray[i]}.diff"
		
		if [ -e ${curVerFile} -a -e ${nextVerFile} ];
		then 
			echo "comm -3 ${nextVerFile} ${curVerFile} > ${curDiffFile}"
			comm -3 ${nextVerFile} ${curVerFile} > ${curDiffFile}
		fi
	done
done
	

