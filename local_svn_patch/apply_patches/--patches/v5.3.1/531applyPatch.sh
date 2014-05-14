#!/bin/sh

if [ $# -lt 2 ]; then
	echo -e "For example: \n ./531applyPatch.sh /media/Work/Talend_git_test /media/Work/Talend_git_test/----patches/v5.3.1"
	exit 1
fi



__doApplyPatchFile(){
	patchFile=$1
	if [ -f ${patchFile} ]; then
		echo "git apply ${patchFile}"
		git apply ${patchFile}
	fi
	echo "git add ."
	git add . 

	commentFile="${patchFile/.patch/.comment}"
	if [ -f ${commentFile} ]; then
		commentContent=$(cat ${commentFile})
		git commit -m "${commentContent}"
		echo -e ">>> Apply ${patchFile} for \n   ${commentContent}\n"
	fi
}

__applyOnePatch(){
	patchBasePath=$1
	curPatchName=$2
	
	for patchFile in $(find "${patchBasePath}" -type f -name "${curPatchName}.patch");
	do
		__doApplyPatchFile "${patchFile}"
	done

}

__applyMultiPatches(){
	patchBasePath=$1
	startIndex=$2 # like 01 02 ... 10
	endIndex=$3
	
	if [ "X${startIndex}" = "X" ]; then
		startIndex=0 # set min
	fi
	
	if [ "X${endIndex}" = "X" ]; then
		endIndex=1000 # set max
	fi
	
	
	for patchFile in $(find "${patchBasePath}" -type f -name "*.patch" | sort ); #try to find all patch.
	do
		curIndex=$(echo "${patchFile##*/}" | awk -F '.' '{print $1}' | awk -F '_' '{print $1}')
		if [ ${curIndex} -ge ${startIndex} -a ${curIndex} -le ${endIndex} ]; then 
			__doApplyPatchFile "${patchFile}"
		fi
	
	done
	
}


__applyRep(){
	gitRoot=$1 # like /media/TOOLS/Talend_git_test
	patchRoot=$2 #like  /media/TOOLS/Talend_git_test/----patches/v5.4.1
	rep=$3
	startIndex=$4 # like 01 02 ... 10
	endIndex=$5
	
	echo -e "-------------------------------------------------\n Working for  ${rep}... "
	cd "${gitRoot}/${rep}"
	
	__applyMultiPatches "${patchRoot}/${rep}" ${startIndex} ${endIndex}
}

__copyFolderFiles(){
	src=$1
	dest=$2
	# If dest is not existed, will created.
	if [ ! -d $dest ]; then
		mkdir -p $dest
	fi
	
	if [ -f $src ]; then
		cp -f $src $dest
		
	elif [ -d $src ]; then
		#if not end with /, will add it.
		echo "$src" | grep "/$" >/dev/null
		if [ "$?" -eq 0 ]; then
			src="$src."
		else
			src="$src/."
		fi
		#copy all files to dest
		cp -af  $src $dest
		
	fi

}
#-------------------------------------------------------------------------------

gitRootPath=$1
patchRootPath=$2

# apply patches
__applyRep $gitRootPath $patchRootPath tcommon-studio-ee

__applyRep $gitRootPath $patchRootPath tcommon-studio-se

__applyRep $gitRootPath $patchRootPath tdi-studio-ee

__applyRep $gitRootPath $patchRootPath tdi-studio-se

#
repo="tdq-studio-ee"
__applyRep $gitRootPath $patchRootPath ${repo} 1 6
#binary 07_318580d
__copyFolderFiles "${patchRootPath}/${repo}/07_318580d.files/" "${gitRootPath}/${repo}/org.talend.dataquality.reporting/reports/subreports/"
__applyOnePatch "${patchRootPath}/${repo}" "07_318580d"
#do one special jars commit 07_jars
__copyFolderFiles "${patchRootPath}/${repo}/01_02_05_07.files/" "${gitRootPath}/${repo}/org.talend.designer.components.tdqprovider/components/tDqReportRun/"
__doApplyPatchFile "${patchRootPath}/${repo}/07_jars.patch"
__applyRep ${gitRootPath} ${patchRootPath} ${repo} 8

repo="tdq-studio-se"
__applyRep $gitRootPath $patchRootPath ${repo} 0 5
# there are some new files for 06_39a66d5 
#AddNetezzaExpressionInIndicatorsTask.java
__copyFolderFiles "${patchRootPath}/${repo}/06_39a66d5_java.files/" "${gitRootPath}/${repo}/org.talend.dataprofiler.core/src/org/talend/dataprofiler/core/migration/impl"
#Indicators
__copyFolderFiles "${patchRootPath}/${repo}/06_39a66d5_indicators.files/" "${gitRootPath}/${repo}/org.talend.dataprofiler.core/indicators/"
__applyOnePatch "${patchRootPath}/${repo}" "06_39a66d5"
#So far, there is no 7
#__applyRep ${gitRootPath} ${patchRootPath} ${repo} 7

__applyRep $gitRootPath $patchRootPath tesb-studio-ee

__applyRep $gitRootPath $patchRootPath tesb-studio-se

__applyRep $gitRootPath $patchRootPath tmdm-server-ee

__applyRep $gitRootPath $patchRootPath tmdm-server-se
