#!/bin/bash

rep=$1
baseSHA=$2

workRootPath="$(pwd)/../"
	
patchPath="${workRootPath}/--patches/${rep}"
if [ ! -e $patchPath ]; then
	mkdir -p $patchPath
fi

cd "${workRootPath}/${rep}"

index=1

for shaId in $(git log --pretty=format:'%h' ${baseSHA}.. | sed -e '1!G;h;$!d')
do
	indexStr="${index}"
	if [ ${index} -lt 10 ]; then
		indexStr="0${index}" #make sure two bits
	fi
	
	resultFileName="${patchPath}/${indexStr}_${shaId}"
	
	git diff ${shaId}^..${shaId} > ${resultFileName}.patch	
	git log --pretty=format:'%h|%ad|%s' --graph --date=short | grep ${shaId} | awk -F '|' '{print $3}' > ${resultFileName}.comment
	
	index=$((${index}+1))

done
    



     


