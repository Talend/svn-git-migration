#!/bin/bash

finalReposPath=$1

if [ $# -lt 1 ]; then
	echo "Must provide the final repositories path (absolute)."
	exit 1
fi

cd "$(dirname $0)"

#copy all patches file to final repository folder
cp -rf apply_patches/--patches  $finalReposPath

cd "$finalReposPath"
sh $finalReposPath/--patches/applyBranchesPatch.sh

