#!/bin/bash
#set -o nounset
#set -o errexit



#help
if [[ "$@" = "--help" || $# -eq 0 ]]; then 
    cat <<EOF
============================ Usage: ============================ 
=  For example:                                                =
=   1) ./git_cmd.sh "log -1"                                   =
=      Display the log of HEAD.                                =
=                                                              =
=   2) ./git_cmd.sh "co master"                                =
=      Switch to branch "master"                               =
=                                                              =
=   3) ./git_cmd.sh "br -v"                                    =
=      Display the branches for each repositoroes.             =
================================================================ 
EOF
    exit 0  
fi

#
cmd="$@"

workRootPath=$(cd $(dirname $0); pwd)
gitRootPath="$workRootPath/../"
cd $gitRootPath

echo -e ">>> Starting to git ${cmd} ...\n"


for rep in $(ls)
do
    excludeRepFile=$workRootPath/git_cmd.exclude
    if [ -f $excludeRepFile ]; then
    	foundRep=$(cat $excludeRepFile | grep "^${rep}$")
    	if [ ! "X$foundRep" = "X" ]; then
	    	echo -e "\n----->> Skip to check the $rep \n"
		continue   
	fi 
    fi
    
    fullPath=$gitRootPath/$rep

    #directory, ignore files in current path.
    if [ -d $fullPath ]; then
	cd $fullPath

	#check the git log
	testResult=$(git log -1 2>/dev/null)

	if [ "X${testResult}" != "X" ]; then #not empty, means in git 
	    echo "--'>$ git ${cmd}' for $rep"
	    
            #TODO....start
            
	    git ${cmd} 2>&1

	    #TODO....end
	    
	    echo  #empty line
	    
	    echo  -e "\n" 
	fi
    fi
     
done

echo -e "\nFinished to git ${cmd}. <<<<\n"

