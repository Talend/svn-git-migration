#! /bin/bash

clone () {
#  echo clone $1
#  cd
#  rm -rf $1
#  git svn clone --stdlayout --username smallet@talend.com http://talendforge.org/svn/$1 $1
#  cp $1_orig $1 -r
#  cd $1
#  java -Dfile.encoding=utf-8 -jar ../svn-migration-scripts.jar clean-git --force
#  for branch in branch-2_1 branch-2_2 branch-2_3 branch-2_4 branch-3_0 branch-3_1 branch-3_2 branch-4_0 branch-4_1 branch-4_1_metadata branch-splitmodel branch-tempbuild-5_4_0 jobserver-karaf branch-3_2_mdm;
#  do
#    git branch -D $branch
#  done 

  to_remove=`ls | grep -f ~/motif_$1 -xv`
  echo  'Folders to remove: '$to_remove
  git filter-branch --tag-name-filter cat --index-filter 'git rm --cached --quiet --ignore-unmatch -r "$to_remove"' -- --all --tags

#  for branch in master branch-5_4 branch-5_3 branch-5_2 branch-5_1 branch-5_0 branch-4_2;
#  do
#    git checkout $branch
#    ls | grep -f ../motif_$1 -xv | xargs -i rm -rf  {}
#    git commit -am "GIT admin: Remove non TAC projects"
#  done
#  for tag in `git tag`;
#  do
#    git checkout $tag
#    ls | grep -f ../motif_$1 -xv | xargs -i rm -rf  {}
#    git commit -am "GIT admin: Remove non TAC projects"
#  done
}

merge () {
  git remote add $1 ../$1
  git fetch $1
  for branch in master branch-5_4 branch-5_3 branch-5_2 branch-5_1 branch-5_0 branch-4_2;
  do
    git checkout $branch
    git merge $1/$branch -m "GIT admin: merge $1/$branch projects in TAC"
  done
  git remote add $1 ../$1 --tags
}

prepare_merge () {
  cd
  rm -rf merge
  mkdir merge
  cd merge
  git init
  touch .gitignore
  git add .gitignore
  git commit -am "GIT admin: TAC initial commit"
  git branch branch-5_4
  git branch branch-5_3
  git branch branch-5_2
  git branch branch-5_1
  git branch branch-5_0
  git branch branch-4_2
}

#clone tis_private
clone tis_shared
#prepare_merge
#merge tis_shared
#merge tis_private

#git remote add origin ssh://git@bitbucket.org/talend/tac.git
#git push origin --all
