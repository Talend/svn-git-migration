#!/bin/sh

workingPath=$(cd $(dirname $0); pwd)
cd $workingPath

ignoreArray=(d3e6bfa 6a64abf 470f527 ab2ba84 b1b17a2 f9839e7 d188a16 08b29df 50f6a4d)
	

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
	
	if [ "$debug" ]; then
		echo
		echo ">>>>" $curPath
	fi
	
	
	index=1
	
	for shaId in $(git log --pretty=format:'%h'  | sed -e '1!G;h;$!d' )
	do 
		#ignore some
		ignore=false
		for ((i=0;i<${#ignoreArray[@]};i++))
		do
			if [ "$shaId" = "${ignoreArray[$i]}" ]; then
				ignore=true
			fi
		done	
		
		if [ "$ignore" = "true" ]; then
			continue
		fi
	

		patchPath="${workingPath}/-patches/${rep}"
		if [ ! -e $patchPath ]; then
			mkdir -p $patchPath
		fi
		
		indexStr="${index}"
		if [ ${index} -lt 10 ]; then
			indexStr="0${index}" #make sure two bits
		fi
	
		resultFileName="$patchPath/${indexStr}_${shaId}"
		
		if [ "$debug" ]; then
			echo "git diff ${shaId}^..${shaId} > ${resultFileName}.patch"	
			echo "git log ... > ${resultFileName}.comment"
		else
			git diff ${shaId}^..${shaId} > ${resultFileName}.patch	
			git log --pretty=format:'%h|%ad|%s' --graph --date=short | grep ${shaId} | awk -F '|' '{print $3}' > ${resultFileName}.comment
		fi
	
		index=$((${index}+1))
	done
	

done








