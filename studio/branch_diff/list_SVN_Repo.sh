#!/bin/sh
svnUser=$1
svnPass=$2

#Check the input arguments
if [ $# -lt 2 ] ;then
cat<<EOF
============================ Usage: ============================ 
=                                                              =
=  ./list_SVN_Repo.sh <svnUser> <svnPass>                      =
=                                                              =
================================================================ 
EOF
    exit
fi

baseFolder="../migration_data/branches"
for branches in 5_0 5_1 5_2 5_3 5_4 5_5
do
	branchFolder="$baseFolder/branch-$branches/svn"
	mkdir -p $branchFolder
	for repo in tos top tom tis_shared tis_private tdq tem 
	do 
		echo "$branches $repo" 
		repoFile=$branchFolder/$repo.$branches
		svn list --depth immediates http://talendforge.org/svn/$repo/branches/branch-$branches/ --username $svnUser --password $svnPass > $repoFile
		sort $repoFile > $repoFile.sorted
		rm -rf $repoFile
	done
done

#trunk(master)
branchFolder="$baseFolder/master/svn"
mkdir -p $branchFolder
for repo in tos top tom tis_shared tis_private tdq tem 
do 
	echo "trunk $repo" 
	repoFile=$branchFolder/$repo.trunk
	svn list --depth immediates http://talendforge.org/svn/$repo/trunk/  --username $svnUser --password $svnPass >  $repoFile
	sort $repoFile > $repoFile.sorted
	rm -rf $repoFile
done
