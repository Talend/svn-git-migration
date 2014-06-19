cd ~
rm -rf test_tac_size
mkdir test_tac_size
cd test_tac_size/
git clone git@bitbucket.org:talend/tac.git
cp tac/ tac_orig -r
cd tac

echo ----------------------------------------------------
echo Rename tags
echo ----------------------------------------------------
for tag in release-5_0_0 release-5_0_1 release-5_0_2 release-5_0_3 release-5_1_0 release-5_1_1 release-5_1_2 release-5_1_3 release-5_2_0 release-5_2_1 release-5_2_2 release-5_2_3 release-5_3_0 release-5_3_1 release-5_3_2 release-5_4_0 release-5_4_1;
do
  git checkout $tag
  git tag -d $tag
  new_tag=`echo $tag | sed -e 's/_/./g' | sed -e 's/-/\//g'`
  git tag -a $new_tag -m "$new_tag"
done

echo
echo ----------------------------------------------------
echo Remove some tags
echo ----------------------------------------------------
git checkout master
for tag in `git tag -l release-*`;
do
  git tag -d $tag
done

echo
echo ----------------------------------------------------
echo Rename maintenance branches
echo ----------------------------------------------------
for branch in branch-5_5 branch-5_4 branch-5_3 branch-5_2 branch-5_1 branch-5_0;
do
  git checkout $branch
  new_branch=`echo $branch | sed -e 's/_/./g' | sed -e 's/branch-/maintenance\//g'`
  git branch -M $branch $new_branch
done

echo
echo ----------------------------------------------------
echo Checkout branches we like to keep
echo ----------------------------------------------------
for branch in `git branch --list origin/bugfix/* origin/feature/* -r`;
do
  git checkout $branch
done

echo
echo ----------------------------------------------------
echo Remove a branch
echo ----------------------------------------------------
git branch -D branch-4_2
git checkout master

echo
echo ----------------------------------------------------
echo Remove some big files
echo ----------------------------------------------------
java -jar ~/talend-svn-git-migration/bfg-1.11.2.jar --delete-folders '{org.talend.selenium.tac.test,org.talend.designer.components.*,org.talend.gwttoolkit}'
rm -rf ../tac.bfg-report/
git reset --hard
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo
echo ----------------------------------------------------
echo Change remote from bitbucket to github
echo ----------------------------------------------------
git remote rm origin
git remote add origin git@github.com:Talend/tac.git

git push -u origin master --all --tags
