#!/bin/bash

finalReposPath=$(cd "../final_repos"; pwd)


#if exited, delete the old one
finalPathesPath="$finalReposPath/_patches_"
[ -d $finalPathesPath ] && rm -rf $finalPathesPath

#copy all patches file to final repository folder
cp -rf mdm_migration_data/post_migration_scripts/local_svn_patch/apply_patches/_patches_  $finalReposPath

#reuse the shells from studio.
studioFilesPath="studio/migration_data/post_migration_scripts/local_svn_patch/apply_patches/_patches_"
cp $studioFilesPath/*.sh $finalReposPath/_patches_
cp $studioFilesPath/git_cmd.exclude $finalReposPath/_patches_

cd "$finalReposPath"

/bin/bash $finalReposPath/_patches_/checkTags.sh $finalReposPath
/bin/bash $finalReposPath/_patches_/applyBranchesPatch.sh

#need delete the tmp patches files?
#rm -rf $finalReposPath


