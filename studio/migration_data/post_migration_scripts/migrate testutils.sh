#!/bin/bash
#this script copies the test utils bundle into the tcommon-studio.se repository, this is not done during the main migration script because
#these test utils projects do not folow the same life cycle, meaning do not have the same branches. 

cd ../final_repos/tcommon-studio-se
for branch in master maintenance/5.4 maintenance/5.3 maintenance/5.2 maintenance/5.1 maintenance/5.0;
do
  git checkout $branch
  cp -r ../../svn_git_repos/commons_dev/org.talend.testutils ./test/plugins/
  cp -r ../../svn_git_repos/commons_dev/test.all.test.suite ./test/plugins/
  git add --all
  git commit -m "[GIT Migration] adding org.talend.testutils and test.all.test.suite to $branch"
done
git push --all