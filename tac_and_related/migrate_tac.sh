#! /bin/bash

clone () {
  cd ~/checkout/$1

  echo ' ---> Clean branches & tags with svn-migration-scripts.jar'
  time java -Dfile.encoding=utf-8 -jar ~/talend-svn-git-migration/svn-migration-scripts.jar clean-git --force

  echo ' ---> Delete some branches'
  for branch in branch-2_1 branch-2_2 branch-2_3 branch-2_4 branch-3_0 branch-3_1 branch-3_2 branch-4_0 branch-4_1 branch-4_1_metadata branch-splitmodel branch-tempbuild-5_4_0 jobserver-karaf branch-3_2_mdm;
  do
    git branch -D $branch
  done 

  to_remove=`ls ~/checkout/$1 --hide pom.xml | grep -f ~/talend-svn-git-migration/tac_and_related/motif_$1 -xv`
  for folder in $to_remove;
  do
    echo ------------------------------------
    echo '---> ' $folder
    echo ------------------------------------
    java -jar ~/talend-svn-git-migration/bfg-1.11.1.jar --no-blob-protection --delete-folders $folder
    rm -rf ../$1.bfg.report
    git reset --hard
    echo 'Reste ' `ls | wc -w`
    echo ------------------------------------
    echo ''
  done
#  filter-branch --commit-filter 'git_commit_non_empty_tree "$@"' -- --all
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

cd
echo ' ---> Delete old checkout'
time rm -rf checkout/
echo ' ---> Init new checkout from save'
time cp checkout-save/ checkout/ -r

clone tis_private
#clone tis_shared
#prepare_merge
#merge tis_shared
#merge tis_private

#git remote add origin ssh://git@bitbucket.org/talend/tac.git
#git push origin --all
