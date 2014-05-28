#!/bin/bash

finalReposPath=$1

if [ $# -lt 1 ]; then
	#same as migrate testutils.sh to set the default
	finalReposPath=$(cd "../final_repos"; pwd) 
fi

#if exited, delete the old one
finalPathesPath="$finalReposPath/_patches_"
[ -d $finalPathesPath ] && rm -rf $finalPathesPath

#copy all patches file to final repository folder
cp -rf local_svn_patch/apply_patches/_patches_  $finalReposPath

cd "$finalReposPath"

/bin/bash $finalReposPath/_patches_/checkTags.sh $finalReposPath
/bin/bash $finalReposPath/_patches_/applyBranchesPatch.sh

#need delete the tmp patches files?
#rm -rf $finalReposPath


