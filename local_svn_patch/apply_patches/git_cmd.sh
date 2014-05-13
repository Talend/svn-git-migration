#!/bin/sh
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

workRootPath=$(pwd)

logFile=${workRootPath}/$0.log
if [ -f ${logFile} ]; then
	rm -rf ${logFile}
fi

echo -e ">>> Starting to git ${cmd} ...\n" | tee -a $logFile


for rep in $(ls)
do
    fullPath=$workRootPath/$rep

    #directory, ignore files in current path.
    if [ -d $fullPath ]; then
	cd $fullPath

	#check the git log
	testResult=$(git log -1 2>/dev/null)

	if [ "X${testResult}" != "X" ]; then #not empty, means in git 
	    echo "--'>$ git ${cmd}' for $rep" | tee -a $logFile
	    
            #TODO....start
            
	    git ${cmd} 2>&1 | tee -a $logFile

	    #TODO....end
	    
	    echo  #empty line
	    
	    echo  -e "\n"  | tee -a $logFile
	fi
    fi
     
done

echo -e "\nFinished to git ${cmd}. <<<<\n" | tee -a $logFile

