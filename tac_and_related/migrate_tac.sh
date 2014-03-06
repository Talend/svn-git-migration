#! /bin/bash

clone () {
  cd
  echo ' ---> Init checkout folder '$1
  cd checkout
  rm -rf $1
  cp ../checkout-save/$1 . -r
  cd $1

  echo ' ---> Clean branches & tags with svn-migration-scripts.jar'
  time java -Dfile.encoding=utf-8 -jar ~/talend-svn-git-migration/svn-migration-scripts.jar clean-git --force

  for branch in master branch-5_4 branch-5_3 branch-5_2 branch-5_1 branch-5_0 branch-4_2;
  do
    git checkout $branch
    to_remove=`ls ~/checkout/$1 --hide pom.xml | grep -f ~/talend-svn-git-migration/tac_and_related/$1To$2 -xv`
    for folder in $to_remove;
    do
      echo ------------------------------------
      echo '---> ' $branch - $folder
      echo ------------------------------------
      java -jar ~/talend-svn-git-migration/bfg-1.11.1.jar --no-blob-protection --delete-folders $folder
      rm -rf ../$1.bfg-report
      git reset --hard
      echo 'Reste ' `ls | wc -w`
      echo ------------------------------------
      echo ''
    done
  done
  git filter-branch --commit-filter 'git_commit_non_empty_tree "$@"' -- --all
}

merge () {
 S cd ~/checkout/merge/
  git remote add $1 ../$1
  git fetch $1
  for branch in master branch-5_4 branch-5_3 branch-5_2 branch-5_1 branch-5_0 branch-4_2;
  do
    git checkout $branch
    git merge $1/$branch -m "GIT admin: merge $1/$branch projects in $2"

    status=`git status --short`
    if [ -n "$status"  ]; then
      git rm pom.xml
      git commit -m "GIT admin: merge $1/$branch projects in $2"
    fi
  done
  git fetch $1 --tags
  git remote rm $1
}

prepare_merge () {
  cd ~/checkout/
  rm -rf merge
  mkdir merge
  cd merge
  git init
  touch .gitignore
  git add .gitignore
  git commit -am "GIT admin: initial commit"
  git branch branch-5_4
  git branch branch-5_3
  git branch branch-5_2
  git branch branch-5_1
  git branch branch-5_0
  git branch branch-4_2
}

#clone tis_private JobServer
#clone tis_shared JobServer
prepare_merge
merge tis_private JobServer
#merge tis_shared JobServer

#git remote add origin ssh://git@bitbucket.org/talend/tac.git
#git push origin --all
