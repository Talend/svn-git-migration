#!/bin/bash

finalReposPath=$1

if [ $# -lt 1 ]; then
	echo "Must provide the final repositories path (absolute)."
	exit 1
fi

cd "$(dirname $0)"

#if exited, delete the old one
finalPathesPath="$finalReposPath/_patches_"
[ -d $finalPathesPath ] && rm -rf $finalPathesPath

#copy all patches file to final repository folder
cp -rf apply_patches/_patches_  $finalReposPath

cd "$finalReposPath"
/bin/bash $finalReposPath/_patches_/checkTags.sh $finalReposPath
/bin/bash $finalReposPath/_patches_/applyBranchesPatch.sh

