#!/bin/sh
workingPath="$1"

if [ "$#" -lt 1 ]; then
	echo "Please provide the branch root path, also must be absolute path."
	exit 1
fi

logFile=$workingPath/$0.log
if [ -e $logFile ]; then
	rm -rf $logFile
fi

for rep in $(ls)
do
	curPath=$workingPath/$rep
	if [ -f $curPath ]; then #must be dir
		continue
	fi
	if [ "$rep" = "-patches" ]; then #not patch path
		continue
	fi
	
	cd $curPath
	
	echo -e "\n" >>$logFile
	echo  ">>>>>>>$rep">>$logFile
	git hist >> $logFile
done
